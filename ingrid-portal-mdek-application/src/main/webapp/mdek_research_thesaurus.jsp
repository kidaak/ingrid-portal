<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html xmlns="http://www.w3.org/1999/xhtml" lang="de">
<head>

<style>
a.notSelectable { margin-left:5px; text-decoration:none; color:#666666; }
a.resultText { margin-left:5px; text-decoration:none; color:#000; }
a.resultText:hover { text-decoration:underline; }
a.resultText.selected { color:#C21100; }
</style>

<script type="text/javascript">
var scriptScope = this;

// The currently selected textNode. Used for colorization
var selectedTextNode = null;
// Number of rows of the result table(s)
var resultsPerPage = 20;

// Result caching so the results don't have to be reloaded when the user switches tabs
var objResultsLoaded = false;
var adrResultsLoaded = false;

// The current topicId that was searched for
var currentQuery = null;

// Object and Address result navigation bars
var objPageNav = new PageNavigation({ resultsPerPage: resultsPerPage, infoSpan:dojo.byId("searchThesaurusObjResultsInfo"), pagingSpan:dojo.byId("searchThesaurusObjResultsPaging") });
var adrPageNav = new PageNavigation({ resultsPerPage: resultsPerPage, infoSpan:dojo.byId("searchThesaurusAdrResultsInfo"), pagingSpan:dojo.byId("searchThesaurusAdrResultsPaging") });


_container_.addOnLoad(function() {
	initTree();

    // Pressing 'enter' on the input field is equal to a button click
    dojo.event.connect(dojo.widget.byId("thesaurusSearch").domNode, "onkeypress",
        function(event) {
            if (event.keyCode == event.KEY_ENTER) {
                scriptScope.findTopic();
            }
	});

	dojo.event.connect("after", dojo.widget.byId("searchThesaurusNavResultContainer"), "onSelectChild", startSearch);
	dojo.event.connect("after", objPageNav, "onPageSelected", function() { objResultsLoaded = false; startSearch(); });
	dojo.event.connect("after", adrPageNav, "onPageSelected", function() { adrResultsLoaded = false; startSearch(); });
});

_container_.addOnUnload(function() {
	dojo.event.topic.unsubscribe(dojo.widget.byId("treeListenerSearchThesaurus").eventNames.select, scriptScope, "handleSelectNode");
});

// Initialize the tree view
function initTree() {
	// initially load data (first hierachy level) from server 
	SNSService.getRootTopics({
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback:function(res) { handleRootTopics(res); },
		timeout:0,
		errorHandler:function(msg) { dialog.show(message.get('general.error'), message.get('sns.connectionError'), dialog.WARNING); dojo.debug(msg); }
	});

	var treeController = dojo.widget.byId("treeControllerSearchThesaurus");
	treeController.loadRemote = function(node, sync) {

		var _this = this;
		var deferred = new dojo.Deferred();

		SNSService.getSubTopics(node.topicId, '2', 'down', {
			preHook: showLoadingZone,
			postHook: hideLoadingZone,
  			callback:function(res) { deferred.callback(res); },
			timeout:0,
			errorHandler:function(msg) { dojo.debug(msg); deferred.errback(new dojo.RpcError(msg, this));}
  		});

  		deferred.addCallback(function(res) {
			UtilList.addSNSTopicLabels(res);
  			for (i in res) {
  				res[i].title = res[i].label;
  				res[i].isFolder = (res[i].children.length > 0);
				res[i].nodeDocType = res[i].type;
  				res[i].children = [];
  			}
  			var resp = _this.loadProcessResponse(node,res);
  			// Make NODE_LABELs unselectable
  			dojo.lang.forEach(node.children, function(widget){
				if (widget.nodeDocType == "NODE_LABEL" || widget.nodeDocType == "NON_DESCRIPTOR") {
					dojo.html.addClass(widget.labelNode, "TreeNodeNotSelectable");
  					widget.viewMouseOver = function() {};
  				}
  			});
  			return resp;
  		});

		deferred.addErrback(function(res) { alert(res.message); });
		return deferred;
	};

	// Register the node click handler 
	var treeListener = dojo.widget.byId("treeListenerSearchThesaurus");
	dojo.event.topic.subscribe(treeListener.eventNames.select, scriptScope, "handleSelectNode");
}


function startNewQuery(topicId) {
	// build query
	currentQuery = topicId;
	objResultsLoaded = false;
	adrResultsLoaded = false;

	objPageNav.reset();
	adrPageNav.reset();

	startSearch();
}

function startSearch() {
//	dojo.debug("startSearch()");
	if (currentQuery == null)
		return;

	var selectedTab = dojo.widget.byId("searchThesaurusNavResultContainer").selectedChild;

	if (selectedTab == "searchThesaurusNavObjects" && !objResultsLoaded) {
//		dojo.debug("Starting object query for "+currentQuery);
//		dojo.debug("startHit: "+objPageNav.getStartHit());
		QueryService.queryObjectsThesaurusTerm(currentQuery, objPageNav.getStartHit(), resultsPerPage, {
			preHook: showLoadingZone,
			postHook: hideLoadingZone,
			callback: function(res){
				objResultsLoaded = true;
				updateObjectResults(res);
				updateObjectNavigation(res);
			},
			timeout:30000,
			errorHandler:function(message) {dojo.debug("Error in mdek_research_thesaurus.jsp: Error while searching for objects:"+message); }
		});
	} else if (selectedTab == "searchThesaurusNavAddresses" && !adrResultsLoaded){
//		dojo.debug("Starting address query for "+currentQuery);
//		dojo.debug("startHit: "+adrPageNav.getStartHit());
		QueryService.queryAddressesThesaurusTerm(currentQuery, adrPageNav.getStartHit(), resultsPerPage, {
			preHook: showLoadingZone,
			postHook: hideLoadingZone,
			callback: function(res){
				adrResultsLoaded = true;
				updateAddressResults(res);
				updateAddressNavigation(res);
			},
			timeout:30000,
			errorHandler:function(message) {dojo.debug("Error in mdek_research_thesaurus.jsp: Error while searching for addresses:"+message); }
		});		
	}
}

function updateObjectResults(res) {
	UtilList.addTableIndices(res.resultList);
	UtilList.addObjectLinkLabels(res.resultList);  
	UtilList.addIcons(res.resultList);

	dojo.widget.byId("searchThesaurusNavObjectsList").store.setData(res.resultList);
}

function updateAddressResults(res) {
	UtilList.addIcons(res.resultList);
	UtilList.addAddressTitles(res.resultList);
	UtilList.addAddressLinkLabels(res.resultList);
	UtilList.addTableIndices(res.resultList);

	dojo.widget.byId("searchThesaurusNavAddressesList").store.setData(res.resultList);
}

function updateObjectNavigation(res) {
	objPageNav.setTotalNumHits(res.totalNumHits);
	objPageNav.updateDomNodes();
}

function updateAddressNavigation(res) {
	adrPageNav.setTotalNumHits(res.totalNumHits);
	adrPageNav.updateDomNodes();
}


// Node click handler
this.handleSelectNode = function(treeNode) {
//	dojo.debug("node selected: "+treeNode.node.topicId);
	if (selectedTextNode) {
		dojo.html.removeClass(selectedTextNode, "selected");
	}
	startNewQuery(treeNode.node.topicId);
}

// Callback Handler for the root topics.
// This function gets called when the tree is initialized.
// @param topicList - List of Topics from the SNSService   
//
// The function adds the topics in 'topicList' as children to the tree 
function handleRootTopics(topicList) {
	for (i in topicList) {
		topicList[i].isFolder = true;
		topicList[i].nodeDocType = topicList[i].type;
	}

	var tree = dojo.widget.byId("treeSearchThesaurus");

	tree.setChildren(topicList);
}



// Displays the given topics in resultList in the second result tab
function displayAssociatedTopics(resultList) {
	var resultContainer = dojo.byId("thesaurusResultContainer");
	resultContainer.innerHTML = "";

	if (resultList.length == 0) {
		resultContainer.innerHTML = message.get("sns.noResultHint");
	}

	dojo.lang.forEach(resultList, function(term) {
		if (term.type != "NON_DESCRIPTOR") {
			var buttonLink = document.createElement("a"); 

			buttonLink.onclick = function() {
				scriptScope.topicButtonClicked(term.topicId);
			}
			buttonLink.setAttribute("href", "javascript:void(0);");

			buttonLink.setAttribute("title", "In Baumstruktur finden");
			buttonLink.innerHTML = "<img src=\"img/ic_jump_tree.gif\" style=\"position: relative; top: 3px;\"/>";

			var divElement = document.createElement("div");

			var linkElement = document.createElement("a"); 
			linkElement.innerHTML = term.label;

			if (term.type == "DESCRIPTOR") {
				dojo.html.addClass(linkElement, "resultText");
				linkElement.setAttribute("id", "_researchThesLabel_"+term.topicId);
				linkElement.onclick = function() {
					scriptScope.topicLabelClicked(term.topicId);
				}
				linkElement.setAttribute("href", "javascript:void(0);");

				linkElement.setAttribute("title", "Begriff auswaehlen");
				linkElement.topicId = term.topicId;
			} else {
				dojo.html.addClass(linkElement, "notSelectable");
			}
			
			resultContainer.appendChild(divElement);
			divElement.appendChild(buttonLink);
			divElement.appendChild(linkElement);
		}
	});
}

// Button onclick function for the associated topics. Switch the tab pane and
// expand the tree to the given topicId
this.topicButtonClicked = function(topicId) {
//	dojo.debug("clicked button: "+topicId);
	expandToTopicWithId(topicId);
}

// Start a search for objects/addresses with 'topicId'
this.topicLabelClicked = function(topicId) {
//	dojo.debug("clicked label: "+topicId);
	if (selectedTextNode) {
		dojo.html.removeClass(selectedTextNode, "selected");
	}

	selectedTextNode = dojo.byId("_researchThesLabel_"+topicId);
	dojo.html.addClass(selectedTextNode, "selected");

	startNewQuery(topicId);
}

// Search Button onClick function.
//
// This function reads the value of the TextBox 'thesSearch' and expands the tree from the root
// to the corresponding node
this.findTopic = function() {
	var queryTerm = dojo.string.trim(dojo.widget.byId("thesaurusSearch").getValue());

	if (queryTerm.length == 0) {
		return;
	}

	var resultPane = dojo.widget.byId("thesaurusResultPane");
	dojo.widget.byId("researchThesaurusTabContainer").selectChild(resultPane);

	SNSService.findTopics(queryTerm, {
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback:function(result) {
			if (result) {
				UtilList.addSNSTopicLabels(result);
				displayAssociatedTopics(result);
			}},
		timeout:0,
		errorHandler:function(msg) { dialog.show(message.get('general.error'), message.get('sns.connectionError'), dialog.WARNING); dojo.debug(msg); }
	});

};

// Expands the tree to the topic with id 'topicID'
// A valid topicID can be acquired by calling SNSService.findTopic()
function expandToTopicWithId(topicID) {
	var treePane = dojo.widget.byId("thesaurusTreeContainer");
	dojo.widget.byId("researchThesaurusTabContainer").selectChild(treePane);

	SNSService.getSubTopicsWithRoot(topicID, '0', 'up', {
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback:function(res) {
			var tree = dojo.widget.byId("treeSearchThesaurus");
			var topTerm = getTopTermNode(res[0]);
			expandPath(tree, topTerm, res[0]); },
		timeout:0,
		errorHandler:function(msg) { dialog.show(message.get('general.error'), message.get('sns.connectionError'), dialog.WARNING); dojo.debug(msg); }
	});	
}



// Expands the tree
// This is an internal function and should not be called. Call expandToTopicWithId(topicID) instead
// @param tree - Tree/TreeNode. Current position in the tree   
// @param currentNode - SNSTopic. The current node we are looking for to expand
// @param targetNode - SNSTopic. Last node in the tree. return when we found this node. 
//
// The function iterates over tree.children and locates a TreeNode with topicID == currentNode.topicID
// This node is then expanded and passed to expandPath recursively in a callback function.
function expandPath(tree, currentNode, targetNode) {
	
	// Break Condition
	if (currentNode.topicId == targetNode.topicId) {
		// Mark the target node as selected
		for(i in tree.children) {
			if (tree.children[i].topicId == currentNode.topicId) {
				dojo.widget.byId("treeSearchThesaurus").selectNode(tree.children[i]);
				// Scroll the contentPane to tree.children[i]
				if (!dojo.render.html.ie)				
					dojo.html.scrollIntoView(tree.children[i].domNode);

				// dojo.event.publish(dojo.widget.byId("treeListenerSearchThesaurus").eventNames.select, {node: tree.children[i]});
				scriptScope.handleSelectNode({ node: tree.children[i] });
				return;
			}
		}
		return;
	}

	// Iterate over tree.children and locate the node next node in the path
	for(i in tree.children) {
		var curTreeNode = tree.children[i];
		if (curTreeNode.topicId == currentNode.topicId)
		{
			// A node with the correct topicId was found. If the node is not expanded and
			// it's children have not been loaded yet, load the children via callback and
			// do the recursion afterwards.
			if (!curTreeNode.isExpanded && curTreeNode.children.length == 0) {
				var treeController = dojo.widget.byId("treeControllerSearchThesaurus");
//				dojo.debug('Passed the following node to callback: '+curTreeNode.topicId+' '+curTreeNode.widgetId);
				var widgetId = curTreeNode.widgetId;
				treeController.expand(curTreeNode).addCallback(function(res) {
//					dojo.debug('Callback got the following node: '+dojo.widget.byId(widgetId).topicId+' '+widgetId);
					expandPath(dojo.widget.byId(widgetId), currentNode.parents[0], targetNode);
				});
			}
			// If the children have been loaded, expand the node and continue with the recursion
			else {
				curTreeNode.expand();
				expandPath(curTreeNode, currentNode.parents[0], targetNode);
			}
		}
	}
}


// Walks through a 'SNSTopic' structure (from SNSService.getSubTopics()) and returns a TOP_TERM
function getTopTermNode(node) {
	if (node.type == 'TOP_TERM') {
		return node;
	}
	else {
		if (node.children != null && node.children.length != 0) {
			return getTopTermNode(node.children[0]);
		}
		else {
			dojo.debug('Error in getTopTermNode: No parent of type TOP_TERM found.');
			return node;
		}
	}
}


function showLoadingZone() {
    dojo.html.setVisibility(dojo.byId("thesaurusSearchLoadingZone"), "visible");
}

function hideLoadingZone() {
    dojo.html.setVisibility(dojo.byId("thesaurusSearchLoadingZone"), "hidden");
}


</script>



</head>

<body>

  <!-- CONTENT START -->
  <div dojoType="ContentPane" layoutAlign="client">
  
    <div id="researchThesaurusContentSection" class="contentBlockWhite top">
      <div id="winNavi">
		<a href="javascript:void(0);" onclick="javascript:dialog.showContextHelp(arguments[0], 7061)" title="Hilfe">[?]</a>
  	  </div>
  	  <div class="content">

        <!-- LEFT HAND SIDE CONTENT START -->
        <span class="label"><label for="thesaurusSearch" onclick="javascript:dialog.showContextHelp(arguments[0], 7062, 'Thesaurus-Hierarchie')"><fmt:message key="dialog.research.thes.title" /></label></span>
        <div class="inputContainer field grey noSpaceBelow">
          <span class="input"><input type="text" id="thesaurusSearch" class="w640" dojoType="ingrid:ValidationTextBox" /></span>
          <div class="spacerField"></div>
    	  </div>

        <div class="inputContainer full">
          <span class="button w644" style="height:20px !important;">
            <span style="float:right;">
              <button dojoType="ingrid:Button" title="In Thesaurus suchen" onClick="javascript:scriptScope.findTopic();"><fmt:message key="dialog.research.thes.search" /></button>
    		</span>
			<span id="thesaurusSearchLoadingZone" style="float:left; margin-top:1px; z-index: 100; visibility:hidden">
				<img src="img/ladekreis.gif" />
			</span>
    	  </span>
    	</div>


        <div class="inputContainer w684">
		<div id="researchThesaurusTabContainer" dojoType="ingrid:TabContainer" class="h500 tabContainerWithBorderTop" selectedChild="thesaurusTreeContainer">
		  <!-- first tab, tree view -->
		  <div class="grey" dojoType="ContentPane" id="thesaurusTreeContainer" label="<fmt:message key="dialog.research.thes.tree" />" style="padding-left:5px; padding-top:2px; width: 100%; overflow:auto;">
              <!-- tree components -->
              <div dojoType="ingrid:TreeController" widgetId="treeControllerSearchThesaurus"></div>
              <div dojoType="ingrid:TreeListener" widgetId="treeListenerSearchThesaurus"></div>	
              <div dojoType="ingrid:TreeDocIcons" widgetId="treeDocIconsSearchThesaurus"></div>	
              <div dojoType="ingrid:TreeDecorator" listener="treeListenerSearchThesaurus"></div>

              <!-- tree -->
                <div dojoType="ingrid:Tree" listeners="treeControllerSearchThesaurus;treeListenerSearchThesaurus;treeDocIconsSearchThesaurus" widgetId="treeSearchThesaurus">
                </div>
        	  </div>

		    <!-- second tab, associated topics -->
	        <div class="grey" dojoType="ContentPane" id="thesaurusResultPane" label="<fmt:message key="dialog.research.thes.list" />" style="padding-left:5px; width: 100%;">
			  <span id="thesaurusResultContainer"></span>
	        </div>
        </div>
        <!-- LEFT HAND SIDE CONTENT END -->
        
        <!-- RIGHT HAND SIDE CONTENT START -->
        <div id="resultsThesaurus" class="inputContainer">
          <span class="label"><label class="inActive" for="thesaurusDescList"><fmt:message key="dialog.research.thes.result" /></label></span>
        
         	<div id="searchThesaurusNavResultContainer" dojoType="ingrid:TabContainer" doLayout="false" class="w364" selectedChild="searchThesaurusNavObjects">

            <!-- TAB 1 START -->
        	<div id="searchThesaurusNavObjects" dojoType="ContentPane" class="blueTopBorder" label="<fmt:message key="dialog.research.thes.objects" />">
              <div class="listInfo w364">
                <span id="searchThesaurusObjResultsInfo" class="searchResultsInfo">&nbsp;</span>
                <span id="searchThesaurusObjResultsPaging" class="searchResultsPaging">&nbsp;</span>
            	<div class="fill"></div>
              </div>

				<div class="tableContainer rows22 w364">
          	      <table id="searchThesaurusNavObjectsList" dojoType="ingrid:FilteringTable" minRows="20" cellspacing="0" class="filteringTable nosort relativePos">
          	        <thead>
          		        <tr>
                		  <th field="icon" dataType="String" width="23" nosort="true"></th>
                		  <th field="linkLabel" dataType="String" width="323" nosort="true"><fmt:message key="dialog.research.thes.name" /></th>
          		        </tr>
          	        </thead>
				    <colgroup>
					  <col width="23">
					  <col width="323">
				    </colgroup>
          	        <tbody>
          	        </tbody>
          	      </table>
                </div>
          	</div>
            <!-- TAB 1 END -->

            <!-- TAB 2 START -->
       		<div id="searchThesaurusNavAddresses" dojoType="ContentPane" class="blueTopBorder" label="<fmt:message key="dialog.research.thes.addresses" />">
              <div class="listInfo w364">
                <span id="searchThesaurusAdrResultsInfo" class="searchResultsInfo">&nbsp;</span>
                <span id="searchThesaurusAdrResultsPaging" class="searchResultsPaging">&nbsp;</span>
            	  <div class="fill"></div>
              </div>

				<div class="tableContainer rows22 w364">
          	      <table id="searchThesaurusNavAddressesList" dojoType="ingrid:FilteringTable" minRows="20" cellspacing="0" class="filteringTable nosort relativePos">
          	        <thead>
          		        <tr>
                		  <th field="icon" dataType="String" width="23" nosort="true"></th>
                		  <th field="linkLabel" dataType="String" width="323" nosort="true"><fmt:message key="dialog.research.thes.name" /></th>
          		        </tr>
          	        </thead>
				    <colgroup>
					  <col width="23">
					  <col width="323">
				    </colgroup>
          	        <tbody>
          	        </tbody>
          	      </table>
                </div>
          	</div>
            <!-- TAB 2 END -->

          	</div>
          </div>
          
        </div>
        <!-- RIGHT HAND SIDE CONTENT END -->

      </div>
    </div>
  <!-- CONTENT END -->

</body>
</html>