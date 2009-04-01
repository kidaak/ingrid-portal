<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html xmlns="http://www.w3.org/1999/xhtml" lang="de">
<head>
<script type="text/javascript">
var scriptScope = this;

_container_.addOnLoad(function() {
	initDuplicatesTable();
	initTree();
	// Load duplicates info on startup
	scriptScope.startDuplicatesJob();
});

function initDuplicatesTable() {
	var duplicatesTable = dojo.widget.byId("duplicatesListTable");
	dojo.event.connect(duplicatesTable, "onSelect", function() {
		var selection = duplicatesTable.getSelectedData();
		dojo.widget.byId("duplicatesObjectName").setValue(selection.title);
		dojo.widget.byId("duplicatesObjectDescription").setValue(selection.generalDescription);
		dojo.widget.byId("duplicatesObjectClass").setValue(message.get("ui.obj.type"+selection.objectClass+".name"));
	});

    var contextMenu = dojo.widget.createWidget("ingrid:TableContextMenu");
    contextMenu.addItemObject( { caption:'Im Hierarchiebaum anzeigen', method:selectObjectInTree } );
    duplicatesTable.setContextMenu(contextMenu);
}

// Switch to the tree view and select the node referenced by the menu action
function selectObjectInTree(menuItem) {
	dojo.widget.byId("duplicatesLists").selectChild("duplicatesList2");
	var menu = menuItem.parent;
	var rowData = menu.getRowData();
	var objUuid = rowData.uuid;

	selectObjectInTreeByUuid(objUuid);
}

// Select the node with uuid in the tree
function selectObjectInTreeByUuid(uuid) {
	ObjectService.getPathToObject(uuid, {
		callback: function(path){
			var def = expandPathDef(path);
			def.addCallback(selectNode);
		},
		errorHandler: function(msg, err) {
			dojo.debug("Error: "+msg);
			dojo.debugShallow(err);
			def.errback();
		}
	});
}

// Expand all nodes along the given path and select the target node
function expandPathDef(path) {
	var tree = dojo.widget.byId("duplicatesTree");

	// Start with the root object node and expand the correct children to the target
	var def = new dojo.Deferred();
	def.callback(tree.children[0]);

	// Expand nodes along the path
	for (var index = 0; index < path.length; ++index) {
		def.addCallback(function(res) { return expandNodeDef(res); });
		def.addCallback( dojo.lang.curry(scriptScope, scriptScope.getChildFromNode, path[index]) );
	}

	return def;
}

// Expand a node in the tree and return it via a deferred obj on completion
function expandNodeDef(node) {
	var treeController = dojo.widget.byId("treeDuplicatesController");
	var def = treeController.expand(node);
	def.addCallback(function() { return node; });
	return def;
}

// Get a child from a node in the tree for the given uuid 
scriptScope.getChildFromNode = function(childUuid, node) {
	for (var i = 0; i < node.children.length; ++i) {
		if (node.children[i].uuid == childUuid) {
			return node.children[i];
		}
	}
	return null;
}

function selectNode(node) {
	var tree = dojo.widget.byId("duplicatesTree");
	tree.selectNode(node);
	tree.selectedNode = node;
	dojo.html.scrollIntoView(node.domNode);
}

function initTree() {
	// Load initial first level of the tree from the server
	TreeService.getSubTree(null, null, 1, 
		function (rootNodeList) {
			var duplicatesTree = dojo.widget.byId("duplicatesTree");

			dojo.lang.forEach(rootNodeList, function(rootNode){
				rootNode.title = dojo.string.escape("html", rootNode.title);
				rootNode.uuid = rootNode.id;
				rootNode.id = null;
			});

			// Only display object root
			duplicatesTree.setChildren([rootNodeList[0]]);
	});

	// Function to load children of the node from server
	var loadRemote = function(node, sync){
		var _this = this;

		var params = {
			node: this.getInfo(node),
			tree: this.getInfo(node.tree)
		};

		var deferred = new dojo.Deferred();

		deferred.addCallback(function(res) {
			dojo.lang.forEach(res, function(obj){
				obj.title = dojo.string.escape("html", obj.title);
				obj.uuid = obj.id;
				obj.id = null;
			});
			return _this.loadProcessResponse(node,res);
		});
		deferred.addErrback(function(res) { dialog.show(message.get("general.error"), message.get("tree.loadError"), dialog.WARNING); dojo.debug(res); return res;});

		TreeService.getSubTree(node.uuid, node.nodeAppType, 1, {
  			callback:function(res) { deferred.callback(res); },
			errorHandler:function(message) { deferred.errback(new dojo.RpcError(message, this)); },
			exceptionHandler:function(message) { deferred.errback(new dojo.RpcError(message, this)); }
  		});

		return deferred;
	};

	// Attach load remote function to the tree controllers
	var duplicatesTreeController = dojo.widget.byId("treeDuplicatesController");
	duplicatesTreeController.loadRemote = loadRemote;
}

function getDuplicatesDef() {
	var def = new dojo.Deferred();

	CatalogManagementService.getDuplicateObjects({
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback: function(duplicateList) {
			def.callback(duplicateList);
		},
		errorHandler: function(msg, err) {
			hideLoadingZone();
			dojo.debug("Error: "+msg);
			dojo.debugShallow(err);
			def.errback();
		}
	});

	return def;
}

scriptScope.startDuplicatesJob = function() {
	clearInputFields();
	var def = getDuplicatesDef();
	def.addCallback(function(duplicatesList) {
		for (var i = 0; i < duplicatesList.length; ++i) {
			duplicatesList[i].Id = i;
		}
		dojo.widget.byId("duplicatesListTable").store.setData(duplicatesList);
	});
}

function clearInputFields() {
	dojo.widget.byId("duplicatesObjectName").setValue("");
	dojo.widget.byId("duplicatesObjectDescription").setValue("");
	dojo.widget.byId("duplicatesObjectClass").setValue("");
}

scriptScope.saveChanges = function() {
	// Get the new name from the name input field
	// Store the new value in the backend
	// If an error occured -> abort
	// If it was successful update the table, refresh the tree and select the updated node in the tree
	var newObjectName = dojo.string.trim(dojo.widget.byId("duplicatesObjectName").getValue());
	var selectedObject = dojo.widget.byId("duplicatesListTable").getSelectedData();

	if (newObjectName && selectedObject) {
		var objectUuid = selectedObject.uuid;
		var def = storeNewObjectNameDef(objectUuid, newObjectName);
		def.addCallback(function() {
			dojo.widget.byId("duplicatesListTable").store.update(selectedObject, "title", newObjectName);
			var objectRootNode = dojo.widget.byId("duplicatesTree").children[0];
			var treeController = dojo.widget.byId("treeDuplicatesController");
			var refreshChildrenDef = treeController.refreshChildren(objectRootNode);
			refreshChildrenDef.addCallback(function() {
				selectObjectInTreeByUuid(objectUuid);
			});
			dialog.show(message.get("general.hint"), message.get("dialog.admin.management.duplicates.success"), dialog.INFO);
		});
		def.addErrback(function(err) {
			dojo.debug("Error: "+err);
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.generalError"), err+""), dialog.WARNING);
		});

	} else {
		dialog.show(message.get("general.error"), message.get("dialog.admin.invalidObjectNameError"), dialog.WARNING);
	}
}

function storeNewObjectNameDef(objUuid, objName) {
	var def = new dojo.Deferred();

	ObjectService.updateObjectTitle(objUuid, objName, {
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback: function() {
			def.callback();
		},
		errorHandler: function(msg, err) {
			hideLoadingZone();
			dojo.debug("Error: "+msg);
			dojo.debugShallow(err);
			def.errback();
		}
	});

	return def;
}

function showLoadingZone() {
    dojo.html.setVisibility(dojo.byId("duplicatesLoadingZone"), "visible");
}

function hideLoadingZone() {
    dojo.html.setVisibility(dojo.byId("duplicatesLoadingZone"), "hidden");
}

</script>
</head>

<body>

<!-- CONTENT START -->
<div dojoType="ContentPane" layoutAlign="client">

	<div id="contentSection" class="contentBlockWhite top">
		<div id="winNavi">
			<a href="#" title="Hilfe">[?]</a>
		</div>
		<div id="duplicatesContent" class="content w964">

			<!-- INFO START -->
			<div class="spacer"></div>
			<div class="spacer"></div>

			<!-- LEFT HAND SIDE CONTENT START -->
			<div id="duplicatesListContainer" class="inputContainer">
				<span class="label"><fmt:message key="dialog.admin.catalog.management.duplicates.result" /></span>
				<div id="duplicatesLists" dojoType="ingrid:TabContainer" class="full w264 h349" selectedChild="duplicatesList1">
	
					<!-- TAB 1 START -->
					<div id="duplicatesList1" dojoType="ContentPane" class="blueTopBorder" label="<fmt:message key="dialog.admin.catalog.management.duplicates.list" />">
						<div class="inputContainer w264">
							<table id="duplicatesListTable" dojoType="ingrid:FilteringTable" minRows="14" multiple="false" headClass="fixedHeader hidden" tbodyClass="scrollContent rows14" cellspacing="0" class="filteringTable interactive readonly w264 relativePos">
								<thead class="hidden">
									<tr>
										<th field="title" dataType="String" width="264">Name</th>
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
					</div> <!-- TAB 1 END -->
	
	        		<!-- TAB 2 START -->
					<div id="duplicatesList2" dojoType="ContentPane" class="blueTopBorder grey xScroll" label="<fmt:message key="dialog.admin.catalog.management.duplicates.tree" />">
	
						<div class="inputContainer grey">
							<div dojoType="ContentPane" id="treeContainer">
								<!-- tree components -->
				                <div dojoType="ingrid:TreeController" widgetId="treeDuplicatesController" RpcUrl="server/treelistener.php"></div>
								<div dojoType="ingrid:TreeDocIcons" widgetId="treeDuplicatesDocIcons"></div>	

								<!-- tree -->
								<div dojoType="ingrid:Tree" listeners="treeDuplicatesController;treeDuplicatesDocIcons" widgetId="duplicatesTree">
								</div>
							</div>
	
							<div class="spacer"></div>
						</div>
					</div> <!-- TAB 2 END -->
	   
	        	</div>
			</div>
			<!-- LEFT HAND SIDE CONTENT END -->
	
			<!-- RIGHT HAND SIDE CONTENT START -->
			<div id="duplicatesData" class="inputContainer">
				<div class="inputContainer field grey noSpaceBelow h313">
					<span class="label"><label for="duplicatesObjectName" onclick="javascript:dialog.showContextHelp(arguments[0], 'Objektname')"><fmt:message key="dialog.admin.catalog.management.duplicates.objectName" /></label></span>
					<span class="input spaceBelow"><input type="text" id="duplicatesObjectName" name="duplicatesObjectName" class="w640" dojoType="ingrid:ValidationTextBox" /></span>
					<span class="label"><label for="duplicatesObjectClass" onclick="javascript:dialog.showContextHelp(arguments[0], 'Klasse')"><fmt:message key="dialog.admin.catalog.management.duplicates.objectClass" /></label></span>
					<span class="input spaceBelow"><input type="text" id="duplicatesObjectClass" name="duplicatesObjectClass" class="w640" disabled="true" dojoType="ingrid:ValidationTextBox" /></span>
					<span class="label"><label for="duplicatesObjectDescription" onclick="javascript:dialog.showContextHelp(arguments[0], 'Objektbeschreibung')"><fmt:message key="dialog.admin.catalog.management.duplicates.objectDescription" /></label></span>
   	           		<span class="input"><input type="text" mode="textarea" id="duplicatesObjectDescription" class="w640 h164" disabled="true" dojoType="ingrid:ValidationTextbox" /></span> 
					<div class="fill"></div>
				</div>
	
				<div class="inputContainer">
					<span class="button w644" style="height:20px !important;">
						<span style="float:right;">
							<button dojoType="ingrid:Button" title="Speichern" onClick="javascript:scriptScope.saveChanges();"><fmt:message key="dialog.admin.catalog.management.duplicates.saveChanges" /></button>
						</span>
						<span style="float:right;">
							<button dojoType="ingrid:Button" title="Pr&uuml;fung erneut ausf&uuml;hren" onClick="javascript:scriptScope.startDuplicatesJob();"><fmt:message key="dialog.admin.catalog.management.duplicates.refresh" /></button>
						</span>
						<span id="duplicatesLoadingZone" style="float:left; margin-top:1px; z-index: 100; visibility:hidden">
							<img src="img/ladekreis.gif" />
						</span>
					</span>
				</div>
			</div> <!-- RIGHT HAND SIDE CONTENT END -->
		</div>
	</div> <!-- CONTENT END -->
</div>
</body>
</html>