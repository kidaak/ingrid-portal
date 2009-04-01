<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html xmlns="http://www.w3.org/1999/xhtml" lang="de">
<head>

<style type="text/css">
/* If the select box (AND/OR select) is opened for the first time a scrollbar is shown for the main tab.
   to prevent this behaviour, the overflow is made invisible */
div.dojoTabPaneWrapper { overflow:visible; }
</style>


<script type="text/javascript">
var scriptScope = this;

var resultsPerPage = 10;
//var pageNav = new PageNavigation({ resultsPerPage: resultsPerPage, infoSpan:dojo.byId("objSearchExtResultsInfo"), pagingSpan:dojo.byId("objSearchExtResultsPaging") });
var pageNav = new PageNavigation({ resultsPerPage: resultsPerPage, infoSpan:dojo.byId("objSearchResultsInfo"), pagingSpan:dojo.byId("objSearchResultsPaging") });

var currentQuery = {	// Map of strings defining the query. See 'ObjectExtSearchParamsBean.java' for more details.
	queryTerm: null,			// search query
	relation: null,				// relation that should be used to analyze the query (AND / OR)
	searchType: null,			// search whole word or substring (exact/like)
	objClasses: null,			// array of ints that represent the object classes that should be included in the search
	thesaurusTerms: null,		// array of topicIds - descriptors and non-descriptors
	thesaurusRelation: null,	// relation that should be used to combine the thesaurus terms (AND / OR)
	geoThesaurusTerms: null,	// array of areaIds - locations
	geoThesaurusRelation: null,	// relation that should be used to combine the location topics (AND / OR)
	customLocation: null,		// custom location id from the catalog
	timeBegin: null,			// Time reference. Date object begin.
	timeEnd: null,				// Time reference. Date object end.
	timeAt: null,				// Time reference. Date object.
	timeIntersects: null,		// Flag signaling if the entered interval should be cut by the result 
	timeContains: null			// Flag signaling if the entered interval should be included in the result
}


_container_.addOnLoad(function() {
	// Initially select the first tabs on load
	scriptScope.navInnerTab('objTopic', 0, 3);
	scriptScope.navInnerTab('objSpace', 0, 3);
	scriptScope.navInnerTab('objTime', 0, 1);

	// Initialize select boxes
	dojo.widget.byId("objTopicInputBool").setValue(0);
	dojo.widget.byId("thesaurusTermsRelation").setValue(0);
	dojo.widget.byId("geoThesaurusTermsRelation").setValue(0);

	// Init the 'custom location' select box 
//           listId="1100" id="objSpaceGeoUnit"
	var languageCode = UtilCatalog.getCatalogLanguage();

	CatalogService.getSysLists([1100], languageCode, {
		callback: function(res) {
			dojo.widget.byId("objSpaceGeoUnit").dataProvider.setData(res[1100]);
		},
		errorHandler: function(mes) {
			dojo.debug("Error: "+mes);
		}
	});

    // Pressing 'enter' on the thesaurus input field is equal to a button click
    dojo.event.connect(dojo.widget.byId("objTopicThesaurus").domNode, "onkeypress",
        function(event) {
            if (event.keyCode == event.KEY_ENTER) {
                scriptScope.findTopics();
            }
	});

    // Pressing 'enter' on the thesaurus input field is equal to a button click
    dojo.event.connect(dojo.widget.byId("objLocationTopic").domNode, "onkeypress",
        function(event) {
            if (event.keyCode == event.KEY_ENTER) {
                scriptScope.findLocationTopics();
            }
	});

    // Pressing 'enter' on the date fields is equal to a new search
    dojo.event.connect(dojo.widget.byId("objTimeRef1From").domNode, "onkeypress",
        function(event) {
            if (event.keyCode == event.KEY_ENTER) {
                scriptScope.startNewSearch();
            }
	});
    dojo.event.connect(dojo.widget.byId("objTimeRef1To").domNode, "onkeypress",
        function(event) {
            if (event.keyCode == event.KEY_ENTER) {
                scriptScope.startNewSearch();
            }
	});

    dojo.event.connect(dojo.widget.byId("objTimeRef1From"), "onInvalidInput",
        function(input) {
/*
			dojo.debug("valueNode: "+dojo.widget.byId("objTimeRef1From").valueNode.value);
			dojo.debug("inputNode: "+dojo.widget.byId("objTimeRef1From").inputNode.value);
			dojo.debug("input: "+input);
*/
			dojo.widget.byId("objTimeRef1From").clearValue();
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.research.ext.obj.invalidDate"), input), dialog.WARNING);

	});
    dojo.event.connect(dojo.widget.byId("objTimeRef1To"), "onInvalidInput",
        function(input) {
/*
			dojo.debug("valueNode: "+dojo.widget.byId("objTimeRef1To").valueNode.value);
			dojo.debug("inputNode: "+dojo.widget.byId("objTimeRef1To").inputNode.value);
			dojo.debug("input: "+input);
*/
			dojo.widget.byId("objTimeRef1To").clearValue();
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.research.ext.obj.invalidDate"), input), dialog.WARNING);
	});


	dojo.event.connect(dojo.widget.byId("objTimeRef1"), "onValueChanged", function(value) {displayTimeToInput(value);});
	dojo.widget.byId("objTimeRef1").setValue("am");

	dojo.event.connect("after", pageNav, "onPageSelected", function() { startSearch(); });
});

// ************************** General Search functions **************************

// Starts a search with the current parameters stored in 'currentQuery' and 'pageNav'
function startSearch() {
	QueryService.queryObjectsExtended(currentQuery, pageNav.getStartHit(), resultsPerPage, {
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback: function(res) { updateResultTable(res); updatePageNavigation(res); },
		errorHandler: function(errMsg, err) {
			displayErrorMessage(err);
		}		
	});
}

function updateResultTable(res) {
//	dojo.debugShallow(res);
	var resultList = res.resultList;
	UtilList.addObjectLinkLabels(resultList);  
	UtilList.addTableIndices(resultList);
	UtilList.addIcons(resultList);

//	dojo.widget.byId("objectSearchExtResults").store.setData(resultList);
	dojo.widget.byId("objectSearchResults").store.setData(resultList);
}

function updatePageNavigation(res) {
	pageNav.setTotalNumHits(res.totalNumHits);
	pageNav.updateDomNodes();
}


// Search button function. Creates a new query and starts a new search
this.startNewSearch = function() {
	readQueryFromInput();
	pageNav.reset();
	startSearch();
}

// Subnavigation. 'subSectionIndex' specifies the index of the tab that should be selected
scriptScope.navInnerTab = function(sectionName, subSectionIndex, numSubSections){
	for (var i = 0; i < numSubSections; i++) {
		if (i == subSectionIndex) {
			dojo.html.show(dojo.byId(sectionName + i));

		} else {
			dojo.html.hide(dojo.byId(sectionName + i));
		}
	}
}

// Read the input fields and write the query to 'currentQuery'
function readQueryFromInput() {
	currentQuery.queryTerm = dojo.string.trim(dojo.widget.byId("objSearchInput").getValue());
	currentQuery.relation = dojo.widget.byId("objTopicInputBool").getValue();
	currentQuery.searchType = dojo.byId("objMode1").checked ? 0 : 1;	// Convert to int
	
	// Read obj class checkboxes
	currentQuery.objClasses = [];
	for (var i = 0; i < 6; ++i) {
		if (dojo.widget.byId("objTopicObjectClass" + i).checked)
			currentQuery.objClasses.push(i);
	}

	// Read the Descriptors from the thesaurus table
	var descStore = dojo.widget.byId("objExtSearchThesaurusTerms").store;
	currentQuery.thesaurusTerms = [];
	dojo.lang.forEach(descStore.getData(), function(item){
		currentQuery.thesaurusTerms.push(item.topicId);
	});
	currentQuery.thesaurusRelation = dojo.widget.byId("thesaurusTermsRelation").getValue();

	// Read the Location topics from the thesaurus table
	var geoThesStore = dojo.widget.byId("objExtSearchLocationTerms").store;
	currentQuery.geoThesaurusTerms = [];
	dojo.lang.forEach(geoThesStore.getData(), function(item){
		currentQuery.geoThesaurusTerms.push(item.topicId);
	});
	currentQuery.geoThesaurusRelation = dojo.widget.byId("geoThesaurusTermsRelation").getValue();

	currentQuery.customLocation = dojo.widget.byId("objSpaceGeoUnit").getValue();

	// Time ref
	currentQuery.timeBegin = null;
	currentQuery.timeEnd = null;
	currentQuery.timeAt = null;

	var timeType = dojo.widget.byId("objTimeRef1").getValue();
	var timeFrom = dojo.widget.byId("objTimeRef1From").getValue();
	var timeTo = dojo.widget.byId("objTimeRef1To").getValue();
	if (timeFrom == "") { timeFrom = null; }
	if (timeTo == "") { timeTo = null; }

	if (timeType == "am") {
		currentQuery.timeAt = timeFrom;

	} else if (timeType == "seit") {
		currentQuery.timeBegin = timeFrom;

	} else if (timeType == "bis") {
		currentQuery.timeEnd = timeFrom;

	} else if (timeType == "von") {
		currentQuery.timeBegin = timeFrom;
		currentQuery.timeEnd = timeTo;
	}

	currentQuery.timeIntersects = dojo.widget.byId("objTimeRefExtend1").checked;
	currentQuery.timeContains = dojo.widget.byId("objTimeRefExtend2").checked;

	dojo.debugShallow(currentQuery);
}

// Reset-Button function. Reset all the input fields to their initial values and reset 'currentQuery'
this.resetInput = function() {
	dojo.byId("objMode1").checked = true;
	dojo.widget.byId("objSearchInput").setValue("");
	dojo.widget.byId("objTopicInputBool").setValue(0);
	scriptScope.selectAllObjectClasses();
	dojo.widget.byId("objTopicThesaurus").setValue("");
	dojo.widget.byId("objExtSearchThesaurusTerms").store.clearData();
	dojo.widget.byId("thesaurusTermsRelation").setValue(0);
	dojo.widget.byId("objLocationTopic").setValue("");
	dojo.widget.byId("objExtSearchLocationTerms").store.clearData();
	dojo.widget.byId("geoThesaurusTermsRelation").setValue(0);
	dojo.widget.byId("objSpaceGeoUnit").setValue("");
//	dojo.byId("objTimeRef1").checked = false;
//	dojo.byId("objTimeRef2").checked = false;
//	dojo.byId("objTimeRef3").checked = true;

	dojo.widget.byId("objTimeRef1").setValue("am");
	dojo.widget.byId("objTimeRef1From").clearValue();
	dojo.widget.byId("objTimeRef1To").clearValue();
//	dojo.widget.byId("objTimeRef2On").clearValue();

/*
	// Text input fields 
	dojo.widget.byId("objTimeRef1From").setValue("");
	dojo.widget.byId("objTimeRef1To").setValue("");
	dojo.widget.byId("objTimeRef2On").setValue("");
*/
	dojo.widget.byId("objTimeRefExtend1").setValue(false);
	dojo.widget.byId("objTimeRefExtend2").setValue(false);

	readQueryFromInput();
}

function displayTimeToInput(value) {
	var timeTo = dojo.byId("objTimeRef1ToEditor");

	value == "von" ? dojo.html.show(timeTo) : dojo.html.hide(timeTo); 
}

// ************************** Thesaurus Search functions (Thema/fachwoerterbuch) **************************

// Button function which searches for descriptors/nondescriptors from a given search query
// A list of checkboxes/labels is created and put into the div with id: 'objExtSearchThesaurusResults'
this.findTopics = function() {
	var term = dojo.string.trim(dojo.widget.byId("objTopicThesaurus").getValue());

	// Exit if we search for an empty string
	if (term.length == 0) {
		return;
	}

	clearThesaurusResults();

	SNSService.findTopics(term, {
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback:function(topics) {
			if (topics) {
				UtilList.addSNSTopicLabels(topics);
			}

			if (dojo.lang.some(topics, function(item) { return item.type == "DESCRIPTOR"} )) {
				addResultTextElement(message.get("dialog.research.ext.obj.similarTerms"));
				dojo.lang.forEach(topics, function(item){
	//				if (item.type == "DESCRIPTOR" || item.type == "NON_DESCRIPTOR") {
					if (item.type == "DESCRIPTOR") {
						addDescriptorCheckbox(item);
					}
				});
				dojo.html.show(dojo.byId("objExtSearchAddTopicButtonSpan"));

			} else {
				showNoThesaurusResults();
			}
		},
		timeout:20000,
		errorHandler:function(err) {
			hideLoadingZone();
			dojo.debug("Error while executing SNSService.findTopics");
		}
	});
}

this.addSelectedTopics = function() {
	var resultDiv = dojo.byId("objExtSearchThesaurusResults");
	var resultStore = dojo.widget.byId("objExtSearchThesaurusTerms").store;

	dojo.lang.forEach(resultDiv.childNodes, function(divElement) {
		var checkBoxDiv = divElement.firstChild;
		if (checkBoxDiv && checkBoxDiv.id) {
			var checkBox = dojo.widget.byId(checkBoxDiv.id);
		} else {
			return;
		}

		if (checkBox.checked) {
			// If the checked item is already contained in the result list then do nothing
			if (dojo.lang.some(resultStore.getData(), function(item){ return (checkBox.id == item.topicId); }))
				return;

			// Otherwise add the item to the result list
			resultStore.addData( {Id: UtilStore.getNewKey(resultStore), topicId: checkBox.id, label: checkBox.label} );
		}
	});
}

function addDescriptorCheckbox(descriptor, disableLink) {
	var resultDiv = dojo.byId("objExtSearchThesaurusResults");

	var checkBox = dojo.widget.createWidget("checkbox", {
			id: descriptor.topicId,
			label: descriptor.label
		});

	var divElement = document.createElement("div");

	if (disableLink) {
		var labelElement = document.createTextNode(descriptor.label);
		resultDiv.appendChild(divElement);
		divElement.appendChild(checkBox.domNode);
		divElement.appendChild(labelElement);
		return;
	}

	var linkElement = document.createElement("a"); 
	linkElement.setAttribute("href", "javascript:void(0);");
	linkElement.descriptor = descriptor;
	linkElement.onclick = function() {
		findAssociatedTopics(this.descriptor);
	}
	linkElement.innerHTML = descriptor.label;

	resultDiv.appendChild(divElement);
	divElement.appendChild(checkBox.domNode);
//	divElement.appendChild(labelElement);
	divElement.appendChild(linkElement);
}

function addResultTextElement(text) {
	var resultDiv = dojo.byId("objExtSearchThesaurusResults");
	var divElement = document.createElement("div");
	var labelElement = document.createElement("b");
	var labelText = document.createTextNode(text);
	resultDiv.appendChild(divElement);
	divElement.appendChild(labelElement);
	labelElement.appendChild(labelText);

	divElement.style['marginTop'] = "5px";
}


function findAssociatedTopics(descriptor) {
//	dojo.debug("findAssociatedTopics: "+descriptor.topicId);

	clearThesaurusResults();

	SNSService.getTopicsForTopic(descriptor.topicId, {
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback:function(topic) {
			if (topic) {
				UtilList.addSNSTopicLabels( [topic] );
				UtilList.addSNSTopicLabels( topic.synonyms );
				UtilList.addSNSTopicLabels( topic.parents );
				UtilList.addSNSTopicLabels( topic.children );
			}

			if (topic.topicId != descriptor.topicId) {
				addResultTextElement(message.get("dialog.research.ext.obj.synonym"));
				addDescriptorCheckbox(descriptor, true);
				addResultTextElement(message.get("dialog.research.ext.obj.userSynonyms"));
				addDescriptorCheckbox(topic);
			
			} else {
				addResultTextElement(message.get("dialog.research.ext.obj.descriptor"));
				addDescriptorCheckbox(descriptor, true);
	
				if (topic.synonyms.length > 0) {
					addResultTextElement(message.get("dialog.research.ext.obj.synonyms"));
					dojo.lang.forEach(topic.synonyms, function(item){
						addDescriptorCheckbox(item);
					});
				}
	
				if (topic.parents.length > 0) {
					addResultTextElement(message.get("dialog.research.ext.obj.parentTerms"));
					dojo.lang.forEach(topic.parents, function(item){
						addDescriptorCheckbox(item);
					});
				}
	
				if (topic.children.length > 0) {
					addResultTextElement(message.get("dialog.research.ext.obj.childTerms"));
					dojo.lang.forEach(topic.children, function(item){
						addDescriptorCheckbox(item);
					});
				}
			}
			
			dojo.html.show(dojo.byId("objExtSearchAddTopicButtonSpan"));
		},
		timeout:20000,
		errorHandler:function(err) {
			hideLoadingZone();
			dojo.debug("Error while executing SNSService.getTopicsForTopic");
		}
	});
}

// Deletes the checkboxes contained in the div with id: 'objExtSearchThesaurusResults'
function clearThesaurusResults() {
	var resultDiv = dojo.byId("objExtSearchThesaurusResults");

	while (resultDiv.hasChildNodes()) {
		var divElement = resultDiv.removeChild(resultDiv.firstChild);
		var checkBox = divElement.firstChild;
		if (checkBox && checkBox.id) {
			dojo.widget.byId(checkBox.id).destroy();
		}
	}
}

function showNoThesaurusResults() {
	addResultTextElement(message.get("sns.noResultHint"));
	dojo.html.hide(dojo.byId("objExtSearchAddTopicButtonSpan"));
}

// ************************** Thesaurus location Search functions (Raum/Geothesaurus-Raumbezug) **************************
this.findLocationTopics = function() {
	var queryTerm = dojo.string.trim(dojo.widget.byId("objLocationTopic").getValue());

	if (queryTerm.length == 0)
		return;

	clearLocationResults();

	SNSService.getLocationTopics(queryTerm, "beginsWith", null, {
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback: setLocationResultList,
		timeout: 20000,
		errorHandler: function(err) {
			hideLoadingZone();
			dojo.debug("Error while executing SNSService.getLocationTopics");
		}
	});
}

function setLocationResultList(topicList) {
	if (topicList == null || topicList.length == 0) {
		showNoLocationResults();
		return;
	}

	dojo.html.show(dojo.byId("objExtSearchAddLocationTopicButtonSpan"));

	dojo.lang.forEach(topicList, function(topic) {
		addLocationTopicCheckbox(topic);
	});
}

function addLocationTopicCheckbox(topic) {
	var checkboxDiv = dojo.byId("objExtSearchLocationResults");

	var label = topic.name+", "+topic.type;
	var checkBox = dojo.widget.createWidget("checkbox", {
			id: topic.topicId,
			name: label,
			topic: topic
		});

	var divElement = document.createElement("div");

	var linkElement = document.createElement("a"); 
	linkElement.setAttribute("href", "javascript:void(0);");
	linkElement.topicId = topic.topicId;
	linkElement.onclick = function() {
		findAssociatedLocations(this.topicId);
	}
	linkElement.innerHTML = label;

	checkboxDiv.appendChild(divElement);
	divElement.appendChild(checkBox.domNode);
	divElement.appendChild(linkElement);
}

function findAssociatedLocations(topicId) {
	clearLocationResults();

	SNSService.getLocationTopicsById(topicId, {
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback: setLocationResultList,
		timeout: 20000,
		errorHandler: function(err) {
			hideLoadingZone();
			dojo.debug("Error while executing SNSService.getLocationTopics");
		}
	});	
}

this.addSelectedLocationTopics = function() {
	var resultDiv = dojo.byId("objExtSearchLocationResults");
	var resultStore = dojo.widget.byId("objExtSearchLocationTerms").store;

	dojo.lang.forEach(resultDiv.childNodes, function(divElement) {
		var checkBoxDiv = divElement.firstChild;
		if (checkBoxDiv && checkBoxDiv.id) {
			var checkBox = dojo.widget.byId(checkBoxDiv.id);
		} else {
			return;
		}

		if (checkBox.checked) {
			// If the checked item is already contained in the result list then do nothing
			if (dojo.lang.some(resultStore.getData(), function(item){ return (checkBox.id == item.topicId); }))
				return;

			// Otherwise add the item to the result list
			resultStore.addData( {Id: UtilStore.getNewKey(resultStore), topicId: checkBox.id, title: checkBox.name} );
		}
	});
}


function showNoLocationResults() {
	addLocationResultTextElement(message.get("sns.noResultHint"));
	dojo.html.hide(dojo.byId("objExtSearchAddLocationTopicButtonSpan"));
}

function clearLocationResults() {
	var resultDiv = dojo.byId("objExtSearchLocationResults");

	while (resultDiv.hasChildNodes()) {
		var divElement = resultDiv.removeChild(resultDiv.firstChild);
		var checkBox = divElement.firstChild;
		if (checkBox && checkBox.id) {
			dojo.widget.byId(checkBox.id).destroy();
		}
	}
}

function addLocationResultTextElement(text) {
	var resultDiv = dojo.byId("objExtSearchLocationResults");
	var divElement = document.createElement("div");
	var labelElement = document.createElement("b");
	var labelText = document.createTextNode(text);
	resultDiv.appendChild(divElement);
	divElement.appendChild(labelElement);
	labelElement.appendChild(labelText);

	divElement.style['marginTop'] = "5px";
}

// ************************** Object class functions (Thema/Objektklassen) **************************

// Button function to check all existing object class checkboxes
this.selectAllObjectClasses = function() {
	var checkBoxId = "objTopicObjectClass";

	for (var i = 0; i < 6; ++i) {
		dojo.widget.byId(checkBoxId + i).setValue(true);
	}
}

// Button function to uncheck all existing object class checkboxes
this.deselectAllObjectClasses = function() {
	var checkBoxId = "objTopicObjectClass";

	for (var i = 0; i < 6; ++i) {
		dojo.widget.byId(checkBoxId + i).setValue(false);
	}
}

// ************************** General functions **************************

function showLoadingZone() {
    dojo.html.setVisibility(dojo.byId("objectSearchExtLoadingZone"), "visible");
}

function hideLoadingZone() {
    dojo.html.setVisibility(dojo.byId("objectSearchExtLoadingZone"), "hidden");
}

</script>
</head>

<body>
<!-- EXTENDED SEARCH START -->
<div id="extContentObjContent" class="inputContainer noSpaceBelow">

  <!-- EXTENDED SEARCH TAB CONTAINER START -->
	<div id="obj" dojoType="ingrid:TabContainer" doLayout="false" class="w845" selectedChild="objTopic">
    <!-- EXTENDED SEARCH TAB 1 START -->
		<div id="objTopic" dojoType="ContentPane" class="blueTopBorder grey" label="<fmt:message key="dialog.research.ext.obj.theme" />">
      <!-- EXTENDED SEARCH TAB 1 SUB 1 START -->
		<div id="objTopic0">
        <div class="tabContainerSubNavi">
    	    <ul>
    	      <li><a nohref="nohref" class="current" title="Suchmodus"><fmt:message key="dialog.research.ext.obj.mode" /></a></li>
    	      <li><a href="javascript:scriptScope.navInnerTab('objTopic', 1, 3);" title="Objektklassen"><fmt:message key="dialog.research.ext.obj.objClasses" /></a></li>
    	      <li><a href="javascript:scriptScope.navInnerTab('objTopic', 2, 3);" title="Fachw&ouml;rterbuch"><fmt:message key="dialog.research.ext.obj.thesaurus" /></a></li>
    	    </ul>
    	  </div>

        <div class="inputContainer field noSpaceBelow">
          <span class="note"><b><fmt:message key="dialog.research.ext.obj.description" /></b></span>
          <div class="spacer"></div>

          <span class="label noSpaceBelow"><label class="inActive" for="objTopicInputBool"><fmt:message key="dialog.research.ext.obj.contains" /></label>
            <select dojoType="ingrid:Select" style="width:174px;" id="objTopicInputBool">
              <!-- TODO: fill in jsp -->
            	<option value="0"><fmt:message key="dialog.research.ext.obj.contains.all" /></option>
            	<option value="1"><fmt:message key="dialog.research.ext.obj.contains.one" /></option>
            </select></span>

          <span class="label"><label onclick="javascript:dialog.showContextHelp(arguments[0], 7046, 'Suchmodus')"><fmt:message key="dialog.research.ext.obj.mode" /></label></span>
          <div class="checkboxContainer">
            <input type="radio" name="objMode" id="objMode1" class="radio entry first" checked />
            <label class="inActive entry closer w116" for="objMode1"><fmt:message key="dialog.research.ext.obj.full" /></label>
            <input type="radio" name="objMode" id="objMode2" class="radio entry" />
            <label class="inActive entry closer" for="objMode2"><fmt:message key="dialog.research.ext.obj.substring" /></label>
          </div>
	      <div class="fill"></div>
	      <div class="spacerField"></div>
   	     </div>
    	</div>
      <!-- EXTENDED SEARCH TAB 1 SUB 1 END -->
      
      <!-- EXTENDED SEARCH TAB 1 SUB 2 START -->
		  <div id="objTopic1">
        <div class="tabContainerSubNavi">
    	    <ul>
    	      <li><a href="javascript:scriptScope.navInnerTab('objTopic', 0, 3);" title="Suchmodus"><fmt:message key="dialog.research.ext.obj.mode" /></a></li>
    	      <li><a nohref="nohref" class="current" title="Objektklassen"><fmt:message key="dialog.research.ext.obj.objClasses" /></a></li>
    	      <li><a href="javascript:scriptScope.navInnerTab('objTopic', 2, 3);" title="Fachw&ouml;rterbuch"><fmt:message key="dialog.research.ext.obj.thesaurus" /></a></li>
    	    </ul>
    	  </div>
        <div class="inputContainer field noSpaceBelow">
          <div class="checkboxContainer half">
            <span class="input"><input type="checkbox" name="objTopicObjectClass0" id="objTopicObjectClass0" checked="true" dojoType="Checkbox" /><label class="inActive" for="objTopicObjectClass0"><fmt:message key="dialog.research.ext.obj.class0" /></label></span>
            <span class="input"><input type="checkbox" name="objTopicObjectClass1" id="objTopicObjectClass1" checked="true" dojoType="Checkbox" /><label class="inActive" for="objTopicObjectClass1"><fmt:message key="dialog.research.ext.obj.class1" /></label></span>
            <span class="input noSpaceBelow"><input type="checkbox" name="objTopicObjectClass2" id="objTopicObjectClass2" checked="true" dojoType="Checkbox" /><label class="inActive" for="objTopicObjectClass2"><fmt:message key="dialog.research.ext.obj.class2" /></label></span>
          </div>
          <div class="checkboxContainer">
            <span class="input"><input type="checkbox" name="objTopicObjectClass3" id="objTopicObjectClass3" checked="true" dojoType="Checkbox" /><label class="inActive" for="objTopicObjectClass3"><fmt:message key="dialog.research.ext.obj.class3" /></label></span>
            <span class="input"><input type="checkbox" name="objTopicObjectClass4" id="objTopicObjectClass4" checked="true" dojoType="Checkbox" /><label class="inActive" for="objTopicObjectClass4"><fmt:message key="dialog.research.ext.obj.class4" /></label></span>
            <span class="input noSpaceBelow"><input type="checkbox" name="objTopicObjectClass5" id="objTopicObjectClass5" checked="true" dojoType="Checkbox" /><label class="inActive" for="objTopicObjectClass5"><fmt:message key="dialog.research.ext.obj.class5" /></label></span>
          </div>
    	</div>
        <div class="spacerField" style="height:28px !important;">

          <span style="float:left;">
	        <button dojoType="ingrid:Button" title="Keine ausw&auml;hlen" onClick="javascript:scriptScope.deselectAllObjectClasses();"><fmt:message key="dialog.research.ext.obj.clearSelection" /></button>
	      </span>
          <span style="float:left;">
	        <button dojoType="ingrid:Button" title="Alle ausw&auml;hlen" onClick="javascript:scriptScope.selectAllObjectClasses();"><fmt:message key="dialog.research.ext.obj.selectAll" /></button>
	      </span>

        </div>
      </div>
      <!-- EXTENDED SEARCH TAB 1 SUB 2 END -->
      
      <!-- EXTENDED SEARCH TAB 1 SUB 3 START -->
	  <div id="objTopic2" style="display:none;">
        <div class="tabContainerSubNavi">
    	  <ul>
    	    <li><a href="javascript:scriptScope.navInnerTab('objTopic', 0, 3);" title="Suchmodus"><fmt:message key="dialog.research.ext.obj.mode" /></a></li>
    	    <li><a href="javascript:scriptScope.navInnerTab('objTopic', 1, 3);" title="Objektklassen"><fmt:message key="dialog.research.ext.obj.objClasses" /></a></li>
    	    <li><a nohref="nohref" class="current" title="Fachw&ouml;rterbuch"><fmt:message key="dialog.research.ext.obj.thesaurus" /></a></li>
    	  </ul>
    	</div>

        <div class="inputContainer field grey noSpaceBelow" style="width:808px;">
          <span class="label"><label for="objTopicThesaurus" onclick="javascript:dialog.showContextHelp(arguments[0], 7047, 'Thematischer Fachbegriff')"><fmt:message key="dialog.research.ext.obj.thesaurusText" /></label></span>
          <div class="input spaceBelow">
            <span style="float:left; width:659px;">
              <input type="text" id="objTopicThesaurus" name="objTopicThesaurus" class="w659" dojoType="ingrid:ValidationTextBox" />
			</span>

            <span style="float:right;">
              <button dojoType="ingrid:Button" title="In Thesaurus suchen" onClick="javascript:scriptScope.findTopics();"><fmt:message key="dialog.research.ext.obj.thesaurusSearch" /></button>
            </span>
          </div>
        </div>

        <div class="inputContainer field grey" style="width:800px; height:200px;">
		  <span class="half" style="float:left;">
		    <div id="objExtSearchThesaurusResults" class="h205 checkboxContainer" style="overflow: auto;">
			</div>
		  </span>

	      <span id="objExtSearchAddTopicButtonSpan" style="float:left; margin-top:95px; display:none;">
	        <button dojoType="ingrid:Button" title="&Uuml;bernehmen" onClick="javascript:scriptScope.addSelectedTopics();"><fmt:message key="dialog.research.ext.obj.apply" /> -&gt;</button>
		  </span>

		  <span style="float:right;">
              <span class="label"><label for="objExtSearchThesaurusTerms" onclick="javascript:dialog.showContextHelp(arguments[0], 7048, 'Thesaurus Suchbegriffe')"><fmt:message key="dialog.research.ext.obj.searchTerms" /></label></span>
	          <div class="tableContainer spaceBelow headHiddenRows8 w364">
	      	    <table id="objExtSearchThesaurusTerms" dojoType="ingrid:FilteringTable" minRows="8" headClass="hidden" cellspacing="0" class="filteringTable nosort interactive">
	      	      <thead>
	      		      <tr>
	            			<th nosort="true" field="label" dataType="String">Thesaurus Suchbegriffe</th>
	      		      </tr>
	      	      </thead>
	      	      <tbody>
	      	      </tbody>
	      	    </table>
	      	  </div>

            <span class="label">
              <label class="inActive" for="thesaurusTermsRelation"><fmt:message key="dialog.research.ext.obj.contains" /></label>
              <select dojoType="ingrid:Select" style="width:174px;" id="thesaurusTermsRelation">
              <!-- TODO: fill in jsp -->
                <option value="0"><fmt:message key="dialog.research.ext.obj.contains.all" /></option>
                <option value="1"><fmt:message key="dialog.research.ext.obj.contains.one" /></option>
              </select>
            </span>

		  </span>

		</div>
	    
	    <div class="spacer"></div>
   	  </div>
      <!-- EXTENDED SEARCH TAB 1 SUB 3 END -->
	</div>
    <!-- EXTENDED SEARCH TAB 1 END -->

    <!-- EXTENDED SEARCH TAB 2 START -->
		<div id="objSpace" dojoType="ContentPane" class="blueTopBorder grey" label="<fmt:message key="dialog.research.ext.obj.location" />">
      <!-- EXTENDED SEARCH TAB 2 SUB 1 START -->
		  <div id="objSpace0">
        <div class="tabContainerSubNavi">
    	    <ul>
    	      <li><a nohref="nohref" class="current" title="Geothesaurus-Raumbezug"><fmt:message key="dialog.research.ext.obj.snsLocation" /></a></li>
    	      <li><a href="javascript:scriptScope.navInnerTab('objSpace', 1, 3);" title="Freier Raumbezug"><fmt:message key="dialog.research.ext.obj.customLocation" /></a></li>
<!-- 
    	      <li><a href="javascript:scriptScope.navInnerTab('objSpace', 2, 3);" title="Raumeinschr&auml;nkung Karte">Raumeinschr&auml;nkung Karte</a></li>
 -->
    	    </ul>
    	  </div>


        <div class="inputContainer field grey noSpaceBelow" style="width:808px;">
          <span class="label"><label for="objLocationTopic" onclick="javascript:dialog.showContextHelp(arguments[0], 7049, 'Raumbezug')"><fmt:message key="dialog.research.ext.obj.thesaurusLocationText" /></label></span>
          <div class="input spaceBelow">
            <span style="float:left; width:636px;">
              <input type="text" id="objLocationTopic" class="w636" dojoType="ingrid:ValidationTextBox" />
			</span>

            <span style="float:right;">
              <button dojoType="ingrid:Button" title="In Geo-Thesaurus suchen" onClick="javascript:scriptScope.findLocationTopics();"><fmt:message key="dialog.research.ext.obj.thesaurusLocationSearch" /></button>
            </span>
          </div>
        </div>

        <div class="inputContainer field grey" style="width:800px; height:200px;">
		  <span class="half" style="float:left;">
		    <div id="objExtSearchLocationResults" class="h205 checkboxContainer" style="overflow: auto;">
			</div>
		  </span>

	      <span id="objExtSearchAddLocationTopicButtonSpan" style="float:left; margin-top:95px; display:none;">
	        <button dojoType="ingrid:Button" title="&Uuml;bernehmen" onClick="javascript:scriptScope.addSelectedLocationTopics();"><fmt:message key="dialog.research.ext.obj.apply" /> -&gt;</button>
		  </span>

		  <span style="float:right;">
              <span class="label"><label for="objExtSearchLocationTerms" onclick="javascript:dialog.showContextHelp(arguments[0], 7050, 'Geo-Thesaurus Suchbegriffe')"><fmt:message key="dialog.research.ext.obj.searchTerms" /></label></span>
	          <div class="tableContainer spaceBelow headHiddenRows8 w364">
	      	    <table id="objExtSearchLocationTerms" dojoType="ingrid:FilteringTable" minRows="8" headClass="hidden" cellspacing="0" class="filteringTable nosort interactive">
	      	      <thead>
	      		      <tr>
	            			<th nosort="true" field="title" dataType="String">Geo-Thesaurus Suchbegriffe</th>
	      		      </tr>
	      	      </thead>
	      	      <tbody>
	      	      </tbody>
	      	    </table>
	      	  </div>

            <span class="label">
              <label class="inActive" for="geoThesaurusTermsRelation"><fmt:message key="dialog.research.ext.obj.contains" /></label>
              <select dojoType="ingrid:Select" style="width:174px;" id="geoThesaurusTermsRelation">
              <!-- TODO: fill in jsp -->
                <option value="0"><fmt:message key="dialog.research.ext.obj.contains.all" /></option>
                <option value="1"><fmt:message key="dialog.research.ext.obj.contains.one" /></option>
              </select>
            </span>

		  </span>

		</div>

        <div class="spacer"></div>
    	</div>
      <!-- EXTENDED SEARCH TAB 2 SUB 1 END -->
      
      <!-- EXTENDED SEARCH TAB 2 SUB 2 START -->
		  <div id="objSpace1">
        <div class="tabContainerSubNavi">
    	    <ul>
    	      <li><a href="javascript:scriptScope.navInnerTab('objSpace', 0, 3);" title="Geothesaurus-Raumbezug"><fmt:message key="dialog.research.ext.obj.snsLocation" /></a></li>
    	      <li><a nohref="nohref" class="current" title="Freier Raumbezug"><fmt:message key="dialog.research.ext.obj.customLocation" /></a></li>
<!-- 
    	      <li><a href="javascript:scriptScope.navInnerTab('objSpace', 2, 3);" title="Raumeinschr&auml;nkung Karte">Raumeinschr&auml;nkung Karte</a></li>
 -->
    	    </ul>
    	  </div>
        <div class="inputContainer field noSpaceBelow">
          <span class="label"><label for="objSpaceGeoUnit" onclick="javascript:dialog.showContextHelp(arguments[0], 7051, 'Freier Raumbezug')"><fmt:message key="dialog.research.ext.obj.customLocation" />:</label></span>
          <span class="input"><input dojoType="ingrid:Select" listId="1100" style="width:782px;" id="objSpaceGeoUnit" /></span>
    	  </div>
        <div class="spacerField"></div>
    	</div>
      <!-- EXTENDED SEARCH TAB 2 SUB 2 END -->
      
      <!-- EXTENDED SEARCH TAB 2 SUB 3 START -->
		  <div id="objSpace2">
        <div class="tabContainerSubNavi">
    	    <ul>
    	      <li><a href="javascript:scriptScope.navInnerTab('objSpace', 0, 3);" title="Geothesaurus-Raumbezug"><fmt:message key="dialog.research.ext.obj.customLocation" /></a></li>
    	      <li><a href="javascript:scriptScope.navInnerTab('objSpace', 1, 3);" title="Freier Raumbezug"><fmt:message key="dialog.research.ext.obj.customLocation" /></a></li>
    	      <li><a nohref="nohref" class="current" title="Raumeinschr&auml;nkung Karte">Raumeinschr&auml;nkung Karte</a></li>
    	    </ul>
    	  </div>
        <div class="inputContainer field noSpaceBelow xScroll yNoScroll w829">
          <span><img src="img/map.gif" width="820" height="586" alt="Platzhalter Karte" /></span>
          <div class="spacer"></div>
          <span class="label">Selektiertes Gebiet <strong>Verwaltungseinheit</strong> oder <strong>geogr. Daten</strong></span>
          <div class="spacer"></div>
          <span class="label"><strong>Art der Einschr&auml;nkung</strong></span>
          <div class="checkboxContainer noSpaceBelow">
            <span class="input"><input type="checkbox" name="objSpaceMapConstraint0" widgetId="objSpaceMapConstraint0" dojoType="Checkbox" /><label class="inActive" for="objSpaceMapConstraint0">Der Raumbezug der Ergebnisse liegt innerhalb des gew&auml;hlten Kartenausschnittes</label></span>
            <span class="input"><input type="checkbox" name="objSpaceMapConstraint1" widgetId="objSpaceMapConstraint1" dojoType="Checkbox" /><label class="inActive" for="objSpaceMapConstraint1">Der Raumbezug der Ergebnisse schneidet den gew&auml;hlten Kartenausschnittes</label></span>
            <span class="input"><input type="checkbox" name="objSpaceMapConstraint2" widgetId="objSpaceMapConstraint2" dojoType="Checkbox" /><label class="inActive" for="objSpaceMapConstraint2">Der Raumbezug der Ergebnisse umschlie&szlig;t den gew&auml;hlten Kartenausschnittes</label></span>
          </div>
          <div class="spacerField"></div>
    	  </div>
    	</div>
      <!-- EXTENDED SEARCH TAB 2 SUB 3 END -->
		</div>
    <!-- EXTENDED SEARCH TAB 2 END -->

    <!-- EXTENDED SEARCH TAB 3 START -->
		<div id="objTime" dojoType="ContentPane" class="blueTopBorder grey" label="<fmt:message key="dialog.research.ext.obj.time" />">
      <!-- EXTENDED SEARCH TAB 3 SUB 1 START -->
		  <div id="objTime0">
        <div class="tabContainerSubNavi">
    	    <ul>
    	      <li><a nohref="nohref" class="current" title="Zeiteinschr&auml;nkung"><fmt:message key="dialog.research.ext.obj.timeLimit" /></a></li>
    	    </ul>
    	  </div>
        <div class="inputContainer field grey">
          <span class="label"><label onclick="javascript:dialog.showContextHelp(arguments[0], 7052, 'Zeitbezug')"><fmt:message key="dialog.research.ext.obj.timeRef" />:</label></span>
          <span class="note"><fmt:message key="dialog.research.ext.obj.timeIn" /></span>
          <div class="spacer"></div>
          <div class="inputContainer spaceBelow">

            <span class="entry first">
              <span class="label hidden"><label for="objTimeRef1">Typ</label></span>
    		  <span class="input">
    		  	<select dojoType="ingrid:Select" autoComplete="false" style="width:61px;" id="objTimeRef1">
    		  	<option value="am">am</option>
    		  	<option value="seit">seit</option>
    		  	<option value="bis">bis</option>
    		  	<option value="von">von - bis</option>
    		  	</select>
    		  </span>
   		    </span>
            <span class="entry">
              <span class="label hidden"><label for="objTimeRef1From">Datum 1 [TT.MM.JJJJ]</label></span>
              <span class="input"><div dojoType="ingrid:DropdownDatePicker" id="objTimeRef1From"  displayFormat="dd.MM.yyyy" name="timeRefDate1"></div><br />TT.MM.JJJJ</span>
            </span>
            <span class="entry last" id="objTimeRef1ToEditor" style="display:none;">
              <span class="label hidden"><label for="objTimeRef1To">Datum 2 [TT.MM.JJJJ]</label></span>
              <span class="input"><div dojoType="ingrid:DropdownDatePicker" id="objTimeRef1To" displayFormat="dd.MM.yyyy" name="timeRefDate2"></div><br />TT.MM.JJJJ</span>
            </span>

          </div>
          <div class="inputContainer">
          </div>

          <div class="inputContainer noSpaceBelow">
            <span class="label"><label onclick="javascript:dialog.showContextHelp(arguments[0], 7053, 'Erweiterung des Zeitbezuges')"><fmt:message key="dialog.research.ext.obj.timeExt" /></label></span>
            <div class="checkboxContainer">
              <span class="input"><input type="checkbox" name="objTimeRefExtend1" id="objTimeRefExtend1" dojoType="Checkbox" /><label class="inActive" for="objTimeRefExtend1"><fmt:message key="dialog.research.ext.obj.timeIntersect" /></label></span>
              <span class="input"><input type="checkbox" name="objTimeRefExtend2" id="objTimeRefExtend2" dojoType="Checkbox" /><label class="inActive" for="objTimeRefExtend2"><fmt:message key="dialog.research.ext.obj.timeContains" /></label></span>
            </div>
          </div>
    	  </div>
        <div class="spacer"></div>
      </div>
      <!-- EXTENDED SEARCH TAB 3 SUB 1 END -->
		</div>
    <!-- EXTENDED SEARCH TAB 3 END -->
	</div>
  <!-- EXTENDED SEARCH TAB CONTAINER END -->

  <div class="inputContainer">
    <span class="button w805" style="height:20px !important;">
      <span style="float:right;">
        <button dojoType="ingrid:Button" title="Suchen" onClick="javascript:scriptScope.startNewSearch();"><fmt:message key="dialog.research.ext.obj.search" /></button>
	  </span>
      <span style="float:right;">
        <button dojoType="ingrid:Button" title="Zur&uuml;cksetzen" onClick="javascript:scriptScope.resetInput();"><fmt:message key="dialog.research.ext.obj.reset" /></button>
	  </span>
	  <span id="objectSearchExtLoadingZone" style="float:left; margin-top:1px; z-index: 100; visibility:hidden">
		<img src="img/ladekreis.gif" />
	  </span>
    </span>
  </div>


<!-- EXTENDED SEARCH END -->
</body>