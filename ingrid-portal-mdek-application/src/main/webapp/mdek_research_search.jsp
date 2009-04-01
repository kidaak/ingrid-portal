<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html xmlns="http://www.w3.org/1999/xhtml" lang="de">
<head>
<script type="text/javascript">
var scriptScope = this;

var resultsPerPage = 10;
var objPageNav = new PageNavigation({ resultsPerPage: resultsPerPage, infoSpan:dojo.byId("objSearchResultsInfo"), pagingSpan:dojo.byId("objSearchResultsPaging") });
var adrPageNav = new PageNavigation({ resultsPerPage: resultsPerPage, infoSpan:dojo.byId("adrSearchResultsInfo"), pagingSpan:dojo.byId("adrSearchResultsPaging") });

var curObjQuery = null;		// string representing the current object query
var curAdrQuery = null;		// string representing the current address query

_container_.addOnLoad(function() {
    // Pressing 'enter' on the address input field is equal to a button click.
    dojo.event.connect(dojo.widget.byId("adrSearchInput").domNode, "onkeypress",
        function(event) {
            if (event.keyCode == event.KEY_ENTER) {
                // Check if we have to do a normal or an extended search 
                if (isExtendedSearchActive("adr")) {
                	dojo.widget.byId("extContentAdr").scriptScope.startNewSearch();
                } else {
	                scriptScope.startNewAddressSearch();
                }
            }
	});
    
    // Pressing 'enter' on the object input field is equal to a button click.
    dojo.event.connect(dojo.widget.byId("objSearchInput").domNode, "onkeypress",
        function(event) {
            if (event.keyCode == event.KEY_ENTER) {
                // Check if we have to do a normal or an extended search 
                if (isExtendedSearchActive("obj")) {
                	dojo.widget.byId("extContentObj").scriptScope.startNewSearch();
                } else {
	                scriptScope.startNewObjectSearch();
                }
            }
	});

	// Synchronize address and object search input
	dojo.event.connect(dojo.widget.byId("objSearchInput"), "update",
		function() {
			var newVal = dojo.widget.byId("objSearchInput").getValue();
			if (dojo.widget.byId("adrSearchInput").getValue() != newVal) {
				dojo.widget.byId("adrSearchInput").setValue(newVal);
			}
	});
	dojo.event.connect(dojo.widget.byId("adrSearchInput"), "update",
		function() {
			var newVal = dojo.widget.byId("adrSearchInput").getValue();
			if (dojo.widget.byId("objSearchInput").getValue() != newVal) {
				dojo.widget.byId("objSearchInput").setValue(newVal);
			}
	});

	dojo.event.connect("after", objPageNav, "onPageSelected", function() { startObjectSearch(); });
	dojo.event.connect("after", adrPageNav, "onPageSelected", function() { startAddressSearch(); });
});


// Starts a search with the current parameters stored in 'curObjQuery' and 'objPageNav'
function startObjectSearch() {
	if (curObjQuery == null || dojo.string.trim(curObjQuery) == "") {
		return;
	}

	QueryService.queryObjectsFullText(curObjQuery, objPageNav.getStartHit(), resultsPerPage, {
		preHook: showObjectLoadingZone,
		postHook: hideObjectLoadingZone,
		callback: function(res) { updateObjectResultTable(res); updateObjectPageNavigation(res); },
		errorHandler: function(errMsg, err) {
			displayErrorMessage(err);
		}		
	});
}
// Starts a search with the current parameters stored in 'curAdrQuery' and 'adrPageNav'
function startAddressSearch() {
	if (curAdrQuery == null || dojo.string.trim(curAdrQuery) == "") {
		return;
	}

	QueryService.queryAddressesFullText(curAdrQuery, adrPageNav.getStartHit(), resultsPerPage, {
		preHook: showAddressLoadingZone,
		postHook: hideAddressLoadingZone,
		callback: function(res) { updateAddressResultTable(res); updateAddressPageNavigation(res); },
		errorHandler: function(errMsg, err) {
			displayErrorMessage(err);
		}		
	});
}

function updateObjectResultTable(res) {
//	dojo.debugShallow(res);
	var resultList = res.resultList;
	UtilList.addObjectLinkLabels(resultList);  
	UtilList.addTableIndices(resultList);
	UtilList.addIcons(resultList);

	dojo.widget.byId("objectSearchResults").store.setData(resultList);
}
function updateAddressResultTable(res) {
//	dojo.debugShallow(res);
	var resultList = res.resultList;
	UtilList.addAddressTitles(resultList);
	UtilList.addAddressLinkLabels(resultList);  
	UtilList.addTableIndices(resultList);
	UtilList.addIcons(resultList);

	dojo.widget.byId("addressSearchResults").store.setData(resultList);
}


// Update the info and paging dom nodes after a search
function updateObjectPageNavigation(res) {
	objPageNav.setTotalNumHits(res.totalNumHits);
	objPageNav.updateDomNodes();
}
function updateAddressPageNavigation(res) {
	adrPageNav.setTotalNumHits(res.totalNumHits);
	adrPageNav.updateDomNodes();
}


// Object Search button function. Creates a new query and starts a new search
this.startNewObjectSearch = function() {
	curObjQuery = dojo.string.trim(dojo.widget.byId("objSearchInput").getValue());
	objPageNav.reset();
	startObjectSearch();
}
// Address Search button function. Creates a new query and starts a new search
this.startNewAddressSearch = function() {
	curAdrQuery = dojo.string.trim(dojo.widget.byId("adrSearchInput").getValue());
	adrPageNav.reset();
	startAddressSearch();
}



this.toggleContent = function(type){
	if (type == "obj") {
		var contentArea = "extContentObj";
		var contentURL = "mdek_research_ext_obj.jsp";

		var contentAreaNode = dojo.byId("extContentObj");
		var searchFieldWidget = dojo.widget.byId("objSearchInput");
		var searchButtonContainer = dojo.byId("objectSearchButtonContainer");
		var searchResultContainer = dojo.byId("objectSearchResultsContainer");

	} else if (type == "adr") {
		var contentArea = "extContentAdr";
		var contentURL = "mdek_research_ext_adr.jsp";

		var contentAreaNode = dojo.byId("extContentAdr");
		var searchFieldWidget = dojo.widget.byId("adrSearchInput");
		var searchButtonContainer = dojo.byId("addressSearchButtonContainer");
		var searchResultContainer = dojo.byId("addressSearchResultsContainer");
	}

	// expand arrow
	var arrow = dojo.byId(contentArea + "ToggleArrow");
	// toggle arrow and content
	if (arrow.src.indexOf("ic_info_expand.gif") != -1){
	    // load or toggle content for extended search
	    contentPane = dojo.widget.byId(contentArea);
	    if (contentPane.isLoaded == false){
			// load content
			contentPane.setUrl(contentURL);
		}
	    dojo.html.show(contentAreaNode);
	    arrow.src = "img/ic_info_deflate.gif";

		dojo.html.hide(searchButtonContainer);

	} else {
	    dojo.html.hide(contentAreaNode);
	    arrow.src = "img/ic_info_expand.gif";

	    dojo.html.show(searchButtonContainer);
	}
}


function isExtendedSearchActive(type) {
	if (type == "obj") {
		return (dojo.byId("extContentObjToggleArrow").src.indexOf("ic_info_expand.gif") == -1);
	} else if (type == "adr") {
		return (dojo.byId("extContentAdrToggleArrow").src.indexOf("ic_info_expand.gif") == -1);
	}
}

function showObjectLoadingZone() {
    dojo.html.setVisibility(dojo.byId("objectSearchLoadingZone"), "visible");
}
function hideObjectLoadingZone() {
    dojo.html.setVisibility(dojo.byId("objectSearchLoadingZone"), "hidden");
}

function showAddressLoadingZone() {
    dojo.html.setVisibility(dojo.byId("addressSearchLoadingZone"), "visible");
}
function hideAddressLoadingZone() {
    dojo.html.setVisibility(dojo.byId("addressSearchLoadingZone"), "hidden");
}

</script>

</head>
<body>

  <!-- CONTENT START -->
  <div dojoType="ContentPane" layoutAlign="client">
  
    <div id="researchSearchContentSection" class="contentBlockWhite top">
      <div id="winNavi">
		<a href="javascript:void(0);" onclick="javascript:dialog.showContextHelp(arguments[0], 7060)" title="Hilfe">[?]</a>
  	  </div>
  	  <div id="search" class="content">

        <!-- MAIN TAB CONTAINER START -->
        <div class="spacer"></div>
      	<div id="objects" dojoType="ingrid:TabContainer" doLayout="false" class="w845" selectedChild="objSearch">
          <!-- MAIN TAB 1 START -->
      		<div id="objSearch" dojoType="ContentPane" class="blueTopBorder" label="<fmt:message key="dialog.research.objects" />">
              <div class="inputContainer field grey noSpaceBelow w829">
              <span class="input"><input type="text" id="objSearchInput" name="objSearchInput" class="w800" dojoType="ingrid:ValidationTextBox" /></span>
              <span class="expandContent"><a href="javascript:void(0);" onclick="javascript:scriptScope.toggleContent('obj');" title="Erweiterte Suche"><img id="extContentObjToggleArrow" src="img/ic_info_expand.gif" width="8" height="8" alt="Pfeil" /><fmt:message key="dialog.research.extSearch" /></a></span>
              <div class="spacer"></div>
        	  </div>

	         <div id="objectSearchButtonContainer" class="inputContainer" style="display:block;">
	          <span class="button w805" style="height:20px !important;">
	            <span style="float:right;">
	              <button dojoType="ingrid:Button" title="Suchen" onClick="javascript:scriptScope.startNewObjectSearch();"><fmt:message key="dialog.research.search" /></button>
	    		</span>
				<span id="objectSearchLoadingZone" style="float:left; margin-top:1px; z-index: 100; visibility:hidden">
					<img src="img/ladekreis.gif" />
				</span>
	    	  </span>
	    	</div>

            <div dojoType="ContentPane" widgetId="extContentObj" id="extContentObj" style="margin-top:5px;" executeScripts="true" loadingMessage="Lade Daten ..."></div>

	        <!-- OBJECT SEARCH RESULT LIST START -->
	        <div class="spacer"></div>
	        <div id="objectSearchResultsContainer" class="inputContainer noSpaceBelow w845">
	          <span class="label"><fmt:message key="dialog.research.result" /></span>
	          <div class="listInfo w845">
	            <span id="objSearchResultsInfo" class="searchResultsInfo">&nbsp;</span>
	            <span id="objSearchResultsPaging" class="searchResultsPaging">&nbsp;</span>
	        	  <div class="fill"></div>
	          </div>
	
			  <div class="tableContainer rows10 w845">
	    	    <table id="objectSearchResults" dojoType="ingrid:FilteringTable" minRows="10" cellspacing="0" class="filteringTable nosort relativePos">
	    	      <thead>
	    		      <tr>
	          			<th nosort="true" field="icon" dataType="String" width="23"></th>
	          			<th nosort="true" field="linkLabel" dataType="String" width="804"><fmt:message key="dialog.research.name" /></th>
	    		      </tr>
	    	      </thead>
			        <colgroup>
				      <col width="23">
				      <col width="804">
			        </colgroup>
	    	      <tbody>
	    	      </tbody>
	    	    </table>
	    	   </div>
	    	  </div>
	        <!-- OBJECT SEARCH RESULT LIST END -->

      		</div>
          <!-- MAIN TAB 1 END -->
      		
          <!-- MAIN TAB 2 START -->
      		<div id="adrSearch" dojoType="ContentPane" class="blueTopBorder" label="<fmt:message key="dialog.research.addresses" />">
  
            <div class="inputContainer field grey noSpaceBelow w829">
              <span class="input"><input type="text" id="adrSearchInput" name="adrSearchInput" class="w800" dojoType="ingrid:ValidationTextBox" /></span>
              <span class="expandContent"><a href="javascript:void(0);" onclick="javascript:scriptScope.toggleContent('adr');" title="Erweiterte Suche"><img id="extContentAdrToggleArrow" src="img/ic_info_expand.gif" width="8" height="8" alt="Pfeil" />Erweiterte Suche</a></span>
              <div class="spacer"></div>
        	  </div>

	         <div id="addressSearchButtonContainer" class="inputContainer" style="display:block;">
	          <span class="button w805" style="height:20px !important;">
	            <span style="float:right;">
	              <button dojoType="ingrid:Button" title="Suchen" onClick="javascript:scriptScope.startNewAddressSearch();">Suchen</button>
	    		</span>
				<span id="addressSearchLoadingZone" style="float:left; margin-top:1px; z-index: 100; visibility:hidden">
					<img src="img/ladekreis.gif" />
				</span>
	    	  </span>
	    	</div>

            <div dojoType="ContentPane" widgetId="extContentAdr" id="extContentAdr" style="margin-top:5px;" executeScripts="true" loadingMessage="Lade Daten ..."></div>

	        <!-- ADDRESS SEARCH RESULT LIST START -->
	        <div class="spacer"></div>
	        <div id="addressSearchResultsContainer" class="inputContainer noSpaceBelow w845">
	          <span class="label"><fmt:message key="dialog.research.result" /></span>
	          <div class="listInfo w845">
	            <span id="adrSearchResultsInfo" class="searchResultsInfo">&nbsp;</span>
	            <span id="adrSearchResultsPaging" class="searchResultsPaging">&nbsp;</span>
	        	  <div class="fill"></div>
	          </div>
	
			  <div class="tableContainer rows10 w845">
	    	    <table id="addressSearchResults" dojoType="ingrid:FilteringTable" minRows="10" cellspacing="0" class="filteringTable nosort relativePos">
	    	      <thead>
	    		      <tr>
	          			<th nosort="true" field="icon" dataType="String" width="23"></th>
	          			<th nosort="true" field="linkLabel" dataType="String" width="804"><fmt:message key="dialog.research.name" /></th>
	    		      </tr>
	    	      </thead>
			        <colgroup>
				      <col width="23">
				      <col width="804">
			        </colgroup>
	    	      <tbody>
	    	      </tbody>
	    	    </table>
	    		</div>
	    	  </div>
	        <!-- ADDRESS SEARCH RESULT LIST END -->

      		</div>
          <!-- MAIN TAB 2 END -->
      	</div>
        <!-- MAIN TAB CONTAINER END -->  
      </div>
    </div>
  </div>
  <!-- CONTENT END -->

</body>
</html>