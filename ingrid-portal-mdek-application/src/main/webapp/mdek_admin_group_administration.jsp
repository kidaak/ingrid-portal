<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html xmlns="http://www.w3.org/1999/xhtml" lang="de">
<head>
<script type="text/javascript">
var scriptScope = this;

var currentUserGroupDetails = null;
var curSelectedGroupDetails = null;


_container_.addOnLoad(function() {
	showLoadingZone();

	if (currentUser.role == 1) {
		var def = new dojo.Deferred();
		def.callback(null);

	} else {
		var def = getGroupDetailsById(currentUser.groupId);
	}

	def.addCallback(function(groupDetails) {
		currentUserGroupDetails = groupDetails;

		initObjectTree();
		initAddressTree();
		initGroupList();
		resetAllInputData();
		hidePermissionLists();	
		hideLoadingZone();
	});
});


function deleteGroup(group) {
	var def = new dojo.Deferred();
	var deferred = new dojo.Deferred();
	
	var displayText = dojo.string.substituteParams(message.get("dialog.admin.groups.confirmDelete"), group.name);
	dialog.show(message.get("dialog.admin.users.deleteGroup"), displayText, dialog.INFO, [
		{ caption: message.get("general.no"),  action: function() { deferred.errback(); } },	
    	{ caption: message.get("general.ok"), action: function() { deferred.callback(); } }
	]);

	deferred.addCallback(function() {
		SecurityService.deleteGroup(group.id, {
			preHook: showLoadingZone,
			postHook: hideLoadingZone,
			callback: function() {
				def.callback();
			},
			errorHandler: function(errMsg, err) {
				hideLoadingZone();
				displayErrorMessage(err);
				dojo.debug(errMsg);
				displayDeleteGroupError(err);
				def.errback();
			}
		});
	});

	return def;
}

function reloadCurrentGroup() {
	var groupList = dojo.widget.byId("groups");
	var selectedGroups = groupList.getSelectedData();
	if (selectedGroups.length == 1) {
		updateAllInputData(selectedGroups[0]);
	}
}

function addObjectToPermissionTable(obj) {
	var objStore = dojo.widget.byId("groupDataRightsObjectsList").store;

	if (dojo.lang.every(objStore.getData(), function(item){ return (item.uuid != obj.id); })) {
		var permission = {}
		permission.Id = UtilStore.getNewKey(objStore);
		permission.title = obj.title;
		permission.uuid = obj.id;
		permission.single =  "<input type='radio' name='"+obj.id+"' id='"+obj.id+"_single' class='radio' />";
		permission.subtree = "<input type='radio' name='"+obj.id+"' id='"+obj.id+"_subtree' class='radio' checked='true' />";

		objStore.addData(permission);
	}
}


function addAddressToPermissionTable(adr) {
	var adrStore = dojo.widget.byId("groupDataRightsAddressesList").store;

	if (dojo.lang.every(adrStore.getData(), function(item){ return (item.uuid != adr.id); })) {
		var permission = {}
		permission.Id = UtilStore.getNewKey(adrStore);
		permission.title = adr.title;
		permission.uuid = adr.id;
		permission.single =  "<input type='radio' name='"+adr.id+"' id='"+adr.id+"_single' class='radio' />";
		permission.subtree = "<input type='radio' name='"+adr.id+"' id='"+adr.id+"_subtree' class='radio' checked='true' />";

		adrStore.addData(permission);
	}
}

function addFreeRootToPermissionTable(node) {
	var deferred = new dojo.Deferred();

	dojo.debug("Getting all free addresses");
    TreeService.getSubTree(node.id, node.nodeAppType, {
        callback:function(res) { deferred.callback(res); },
        errorHandler:function(message) {
            deferred.errback(new dojo.RpcError(message, this));
        }
    });

    deferred.addCallback(
    	function(res) {
    		dojo.debug("Adding free addresses to permission table"); 
    		dojo.lang.forEach(res, function(adr){
    		    addAddressToPermissionTable(adr);
    		});        	 
        }
    );
    deferred.addErrback(function(res) { dialog.show(message.get("general.error"), message.get("tree.loadError"), dialog.WARNING); dojo.debug(res); return res;});
    return deferred;
}

// 'Create new group' button function.
// If a group is selected, reset the input fields and deselect any selected groups
// Otherwise create a new group
scriptScope.newGroup = function() {
	var groupList = dojo.widget.byId("groups");
	var groupStore = groupList.store;
	var groupName = dojo.string.trim(dojo.widget.byId("groupDataName").getValue());

	if (groupList.getSelectedData().length != 1) {
		createNewGroup(groupName);

	} else {
		groupList.resetSelections();
		groupList.renderSelections();
	
		resetAllInputData();
		hidePermissionLists();
	}
}


// 'Save group' button function.
// If a group is selected update it with the new name.
// If zero or multiple groups are selected, create a new group.
scriptScope.saveGroup = function() {
	var groupList = dojo.widget.byId("groups");
	var groupStore = groupList.store;
	var groupName = dojo.string.trim(dojo.widget.byId("groupDataName").getValue());

	var selectedGroups = groupList.getSelectedData();
	if (selectedGroups.length == 1) {
		// exactly one group selected
//		var group = selectedGroups[0];
		var group = curSelectedGroupDetails;
		
		// update group name
		group.name = groupName;

		// update object permissions
		var objs = dojo.widget.byId("groupDataRightsObjectsList").store.getData();
		var objPermissionList = [];
	
		dojo.lang.forEach(objs, function(obj){
			var id = obj.uuid;
			var permissionType = dojo.byId(obj.uuid+"_subtree").checked ? "WRITE_TREE" : "WRITE_SINGLE";
			objPermissionList.push( { uuid:id, permission:permissionType } );
		});
		group.objectPermissions = objPermissionList;

		// update address permissions
		var adrs = dojo.widget.byId("groupDataRightsAddressesList").store.getData();
		var adrPermissionList = [];

		dojo.lang.forEach(adrs, function(adr){
			var id = adr.uuid;
			var permissionType = dojo.byId(adr.uuid+"_subtree").checked ? "WRITE_TREE" : "WRITE_SINGLE";
			adrPermissionList.push( { uuid:id, permission:permissionType } );
		});
		group.addressPermissions = adrPermissionList;

		// update group permissions
		group.groupPermissions = [];
		if (dojo.widget.byId("userDataCreate").checked) {
			group.groupPermissions.push("CREATE_ROOT");
		}
		if (dojo.widget.byId("userDataQS").checked) {
			group.groupPermissions.push("QUALITY_ASSURANCE");
		}


		var def = storeGroup(group, true);
		def.addCallback(function(storedGroup) {
			groupStore.update(selectedGroups[0], "name", storedGroup.name);
			curSelectedGroupDetails = storedGroup;

			dialog.show(message.get("dialog.storeGroupTitle"), message.get("dialog.storeGroupSuccess"), dialog.INFO, [
	        	{ caption: message.get("general.ok"),  action: function() {} }
			]);
		});

		def.addErrback(function(err) {
			dojo.debug("Error: "+err);
			if (err && err.message) {
				if (err.message.indexOf("NO_RIGHT_TO_REMOVE_USER_PERMISSION") != -1
				 || err.message.indexOf("NO_RIGHT_TO_ADD_USER_PERMISSION") != -1
				 || err.message.indexOf("NO_RIGHT_TO_REMOVE_OBJECT_PERMISSION") != -1
				 || err.message.indexOf("NO_RIGHT_TO_REMOVE_ADDRESS_PERMISSION") != -1) {
					reloadCurrentGroup();
				}
			}
		});

	} else {
		// zero or multiple groups selected
		createNewGroup(groupName);
	}
}


// 'Add Object' button function.
scriptScope.addObject = function() {
	var obj = dojo.widget.byId("treeObjects").selectedNode;

	if (obj == null || obj.id == "objectRoot") {
		return;
	
	} else {
		addObjectToPermissionTable(obj);
	}
}

// 'Add Address' button function.
scriptScope.addAddress = function() {
	var adr = dojo.widget.byId("treeAddresses").selectedNode;

	if (adr == null || adr.id == "addressRoot") {
		return;
	} else if (adr.id == "addressFreeRoot") {
		addFreeRootToPermissionTable(adr);
	} else {
		addAddressToPermissionTable(adr);
	}
}

// Creates a new group and returns a deferred obj which is called with the newly created group
function createNewGroup(groupName) {
	var deferred = new dojo.Deferred();

	if (groupName.length == 0) {
		return;
	}

	SecurityService.createGroup( { name: groupName }, true, {
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback: function(data) {
			var groupList = dojo.widget.byId("groups");
			var groupStore = groupList.store;
			data.Id = UtilStore.getNewKey(groupStore);
			groupStore.addData(data);
			deferred.callback(data);

			groupList.resetSelections();
			groupList.select(data);
			groupList.renderSelections();

		},
		errorHandler: function(errMsg, err) {
			hideLoadingZone();
			displayCreateGroupErrorMessage(err);
/*
			dojo.debug(errMsg);
			dojo.debugShallow(err);
*/
			deferred.errback(err);
		}
	});	

	return deferred;
}

function initObjectTree() {
	var tree = dojo.widget.byId("treeObjects");
	var treeController = dojo.widget.byId("treeControllerObjects");

	// initially load data (first hierarchy level) from server if the user is catAdmin
	if (currentUser.role == 1) {
		// catAdmin. Display all nodes starting from the rootNode
		TreeService.getSubTree(null, null, function (str) {
			tree.setChildren([str[0]]);
		});
	
	} else {
		// mdAdmin. Only display nodes from user's group
		var treeNodes = [];
		dojo.lang.forEach(currentUserGroupDetails.objectPermissions, function(p){
			treeNodes.push(convertObjectPermissionToTreeNode(p));
		});

		tree.setChildren(treeNodes);
	}
	
	
	treeController.loadRemote = function(node, sync) {
		var _this = this;

		var params = {
			node: this.getInfo(node),
			tree: this.getInfo(node.tree)
		};

		var deferred = new dojo.Deferred();

		TreeService.getSubTree(node.id, node.nodeAppType, {
//			preHook: UtilDWR.enterLoadingState,
//			postHook: UtilDWR.exitLoadingState,
  			callback:function(res) { deferred.callback(res); },
//			timeout:10000,
			errorHandler:function(message) {
//				UtilDWR.exitLoadingState();
				deferred.errback(new dojo.RpcError(message, this));
			}
  		});
		
		deferred.addCallback(function(res) { return _this.loadProcessResponse(node,res); });
		deferred.addErrback(function(res) { dialog.show(message.get("general.error"), message.get("tree.loadError"), dialog.WARNING); dojo.debug(res); return res;});
		return deferred;
	};
}

function initAddressTree() {
	var tree = dojo.widget.byId("treeAddresses");
	var treeController = dojo.widget.byId("treeControllerAddresses");

	// initially load data (first hierarchy level) from server if the user is catAdmin
	if (currentUser.role == 1) {
		// catAdmin. Display all nodes starting from the rootNode
		TreeService.getSubTree(null, null, function (str) {
			tree.setChildren([str[1]]);
		});
	
	} else {
		// mdAdmin. Only display nodes from user's group
		var treeNodes = [];
		dojo.lang.forEach(currentUserGroupDetails.addressPermissions, function(p){
			treeNodes.push(convertAddressPermissionToTreeNode(p));
		});

		tree.setChildren(treeNodes);
	}




	treeController.loadRemote = function(node, sync) {
		var _this = this;

		var params = {
			node: this.getInfo(node),
			tree: this.getInfo(node.tree)
		};

		var deferred = new dojo.Deferred();

		TreeService.getSubTree(node.id, node.nodeAppType, {
//			preHook: UtilDWR.enterLoadingState,
//			postHook: UtilDWR.exitLoadingState,
  			callback:function(res) { deferred.callback(res); },
//			timeout:10000,
			errorHandler:function(message) {
//				UtilDWR.exitLoadingState();
				deferred.errback(new dojo.RpcError(message, this));
			}
  		});
		
		deferred.addCallback(function(res) { return _this.loadProcessResponse(node,res); });
		deferred.addErrback(function(res) { dialog.show(message.get("general.error"), message.get("tree.loadError"), dialog.WARNING); dojo.debug(res); return res;});
		return deferred;
	};
}


// Initialize the group table
function initGroupList() {
	var def = getAllGroups();

	def.addCallback(function(groupList) {
		UtilList.addTableIndices(groupList);
		dojo.widget.byId("groups").store.setData(groupList);
	});

	var groupList = dojo.widget.byId("groups");
	var groupStore = groupList.store;

	dojo.event.connectOnce("around", groupList, "deleteRow", function(invocation) {
//		dojo.debug("delete row called on obj:");
//		dojo.debugShallow(invocation.args[0]);
		var def = deleteGroup(invocation.args[0]);
		def.addCallback(function() {
			var result = invocation.proceed();
			return result;		
		});
	});

/*
	dojo.event.connectOnce(groupStore, "onRemoveData", function(item) {
		deleteGroup(item.src);
	});
*/
	// If the user deletes a group that is currently selected, the input fields have to be reset
	dojo.event.connectOnce("after", groupStore, "onRemoveData", function(data) {
		if (dojo.lang.some(groupList.getSelectedData(), function(item){ return (item == data.src); })) {
			resetAllInputData();
			hidePermissionLists();
		}
	});

	// Selection of data via list.select() doesn't fire an 'onDataSelect' event.
	// Therefore we can't rely on the 'onSelect' event and have to update the input manually  
	dojo.event.connectOnce("after", groupList, "onDataSelect", function(item) {
		// Update the displayed data
		updateAllInputData(item);
		showPermissionLists();
	});

	dojo.event.connectOnce("after", groupList, "onSelect", function() {
		// Update the displayed data
		var selectedGroups = groupList.getSelectedData();
		if (selectedGroups.length == 1) {
			// one group selected, load and display it's group data
			updateAllInputData(selectedGroups[0]);
			showPermissionLists();

		} else {
			// zero or multiple groups selected
			resetAllInputData();
			hidePermissionLists();
		}
	});
}

// Fetch all groups from the backend. Returns a dojo.Deferred which is called with the groupList.
function getAllGroups() {
	var deferred = new dojo.Deferred();

	// Don't display the administrator group
	SecurityService.getGroups(false, {
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback: function(groupList) {
			deferred.callback(groupList);
		},
		errorHandler: function(errMsg, err) {
			hideLoadingZone();
			displayErrorMessage(err);
			dojo.debug(errMsg);
			dojo.debugShallow(err);
			deferred.errback(err);			
		}
	});

	return deferred;
}

// Store the group 'group'
function storeGroup(group, refetch) {
	var deferred = new dojo.Deferred();

	SecurityService.storeGroup(group, refetch, {
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback: function(group) {
			deferred.callback(group);
		},
		errorHandler: function(errMsg, err) {
			hideLoadingZone();
			displayStoreGroupErrorMessage(err);
/*
			dojo.debug(errMsg);
			dojo.debugShallow(err);
*/
			deferred.errback(errMsg);			
		}
	});

	return deferred;
}


function updateAllInputData(group) {
//	dojo.debugShallow(group);
	dojo.widget.byId("groupDataName").setValue(group.name);

	// Load the group details from the server
	var def = getGroupDetails(group.name);
	def.addCallback(function(groupDetails) {
//		dojo.debug("groupDetails: ");
//		dojo.debugShallow(groupDetails);
		curSelectedGroupDetails = groupDetails;

		setAddressPermissions(groupDetails.addressPermissions);
		setObjectPermissions(groupDetails.objectPermissions);
		setGroupPermissions(groupDetails.groupPermissions);
	});
}


function setAddressPermissions(permissionList) {
	var adrStore = dojo.widget.byId("groupDataRightsAddressesList").store;
	adrStore.clearData();

	dojo.lang.forEach(permissionList, function(p) {
		var adr = {}

		adr.Id = UtilStore.getNewKey(adrStore);
		adr.title = UtilAddress.createAddressTitle(p.address);
		adr.uuid = p.uuid;

		if (p.permission == "WRITE_SINGLE") {
			adr.single =  "<input type='radio' name='"+p.uuid+"' id='"+p.uuid+"_single' class='radio' checked='true' />";
			adr.subtree = "<input type='radio' name='"+p.uuid+"' id='"+p.uuid+"_subtree' class='radio' />";
		} else {
			adr.single =  "<input type='radio' name='"+p.uuid+"' id='"+p.uuid+"_single' class='radio' />";
			adr.subtree = "<input type='radio' name='"+p.uuid+"' id='"+p.uuid+"_subtree' class='radio' checked='true' />";
		}

		adrStore.addData(adr);
	});
}


function setObjectPermissions(permissionList) {
	var objStore = dojo.widget.byId("groupDataRightsObjectsList").store;
	objStore.clearData();

	dojo.lang.forEach(permissionList, function(p) {
		var obj = {}

		obj.Id = UtilStore.getNewKey(objStore);
		obj.title = p.object.title;
		obj.uuid = p.uuid;

		if (p.permission == "WRITE_SINGLE") {
			obj.single =  "<input type='radio' name='"+p.uuid+"' id='"+p.uuid+"_single' class='radio' checked='true' />";
			obj.subtree = "<input type='radio' name='"+p.uuid+"' id='"+p.uuid+"_subtree' class='radio' />";
		} else {
			obj.single =  "<input type='radio' name='"+p.uuid+"' id='"+p.uuid+"_single' class='radio' />";
			obj.subtree = "<input type='radio' name='"+p.uuid+"' id='"+p.uuid+"_subtree' class='radio' checked='true' />";
		}

		objStore.addData(obj);
	});
}

function setGroupPermissions(permissionList) {
	var canCreateRoot = false;
	var isQA = false;

	dojo.lang.forEach(permissionList, function(idcPermission){
		if (idcPermission == "CREATE_ROOT") {
			canCreateRoot = true;
		} else if (idcPermission == "QUALITY_ASSURANCE") {
			isQA = true;
		}
	});

	dojo.widget.byId("userDataCreate").setValue(canCreateRoot);
	dojo.widget.byId("userDataQS").setValue(isQA);
}


function resetAllInputData() {
	dojo.widget.byId("groupDataName").setValue("");

	dojo.widget.byId("groupDataRightsObjectsList").store.clearData();
	dojo.widget.byId("groupDataRightsAddressesList").store.clearData();

	dojo.widget.byId("userDataCreate").setValue(false);
	dojo.widget.byId("userDataQS").setValue(false);
}

function hidePermissionLists() {
	dojo.html.hide(dojo.byId("permissionCheckboxContainer"));
	dojo.html.hide(dojo.byId("permissionListObjects"));
	dojo.html.hide(dojo.byId("permissionListAddresses"));
}

function showPermissionLists() {
	dojo.html.show(dojo.byId("permissionCheckboxContainer"));
	dojo.html.show(dojo.byId("permissionListObjects"));
	dojo.html.show(dojo.byId("permissionListAddresses"));

	dojo.widget.byId("groupDataObjects").onResized();
	dojo.widget.byId("groupDataAddresses").onResized();
}

function getGroupDetails(groupName) {

	var deferred = new dojo.Deferred();

	SecurityService.getGroupDetails(groupName, {
		preHook: showLoadingZone,
		postHook: hideLoadingZone,
		callback: function(groupDetails) {
			deferred.callback(groupDetails);
		},
		errorHandler: function(errMsg, err) {
			hideLoadingZone();
			displayErrorMessage(err);
			dojo.debug(errMsg);
			dojo.debugShallow(err);
			deferred.errback(err);
		}
	});

	return deferred;
}

function getGroupDetailsById(groupId) {

	var def = getAllGroups();

	def.addCallback(function(groupList) {
		for (var i = 0; i < groupList.length; ++i) {
			if (groupList[i].id == groupId) {
				return groupList[i].name;
			}
		}
		return null;
	});

	return def.addCallback(getGroupDetails);
}

function convertObjectPermissionToTreeNode(p) {
	return {
		id: p.object.uuid,
		title: p.object.title,
		isFolder: p.object.hasChildren && p.permission == "WRITE_TREE",
		nodeDocType: p.object.nodeDocType,
		dojoType: "ingrid:TreeNode",
		nodeAppType: "O"
	}
}

function convertAddressPermissionToTreeNode(p) {
	return {
		id: p.address.uuid,
		title: UtilAddress.createAddressTitle(p.address),
		isFolder: p.address.hasChildren && p.permission == "WRITE_TREE",
		nodeDocType: p.address.nodeDocType,
		dojoType: "ingrid:TreeNode",
		nodeAppType: "A"
	}
}


// -- Error handling --
function displayCreateGroupErrorMessage(err) {
	if (err && err.message) {
		if (err.message.indexOf("ENTITY_ALREADY_EXISTS") != -1) {
//			dialog.show(message.get("general.error"), message.get("dialog.noPermissionError"), dialog.WARNING);
			dialog.show(message.get("general.error"), message.get("dialog.admin.groups.groupAlreadyExistsError"), dialog.WARNING);

		} else {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.generalError"), err.message), dialog.WARNING, null, 350, 350);				
		}

	} else {
		// Show general error message if we can't determine what went wrong
		dialog.show(message.get("general.error"), message.get("dialog.undefinedError"), dialog.WARNING);
	}
}

function displayStoreGroupErrorMessage(err) {
	if (err && err.message) {
		if (err.message.indexOf("SINGLE_BELOW_TREE_OBJECT_PERMISSION") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.object.singleBelowTreeError"), err.invalidObject.title, err.rootObject.title), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("TREE_BELOW_TREE_OBJECT_PERMISSION") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.object.treeBelowTreeError"), err.invalidObject.title, err.rootObject.title), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("SINGLE_BELOW_TREE_ADDRESS_PERMISSION") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.address.singleBelowTreeError"), UtilAddress.createAddressTitle(err.invalidAddress), UtilAddress.createAddressTitle(err.rootAddress)), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("TREE_BELOW_TREE_ADDRESS_PERMISSION") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.address.treeBelowTreeError"), UtilAddress.createAddressTitle(err.invalidAddress), UtilAddress.createAddressTitle(err.rootAddress)), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("USER_EDITING_OBJECT_PERMISSION_MISSING") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.object.userEditingError"), err.invalidObject.title, UtilAddress.createAddressTitle(err.rootAddress)), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("USER_RESPONSIBLE_FOR_OBJECT_PERMISSION_MISSING") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.object.userResponsibleError"), err.invalidObject.title, UtilAddress.createAddressTitle(err.rootAddress)), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("USER_EDITING_ADDRESS_PERMISSION_MISSING") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.address.userEditingError"), UtilAddress.createAddressTitle(err.invalidAddress), UtilAddress.createAddressTitle(err.rootAddress)), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("USER_RESPONSIBLE_FOR_ADDRESS_PERMISSION_MISSING") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.address.userResponsibleError"), UtilAddress.createAddressTitle(err.invalidAddress), UtilAddress.createAddressTitle(err.rootAddress)), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("NO_RIGHT_TO_REMOVE_OBJECT_PERMISSION") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.object.permissionError"), err.rootObject.title), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("NO_RIGHT_TO_REMOVE_ADDRESS_PERMISSION") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.address.permissionError"), UtilAddress.createAddressTitle(err.rootAddress)), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("NO_RIGHT_TO_REMOVE_USER_PERMISSION") != -1) {
			dialog.show(message.get("general.error"), message.get("dialog.admin.groups.removePermissionError"), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("NO_RIGHT_TO_ADD_USER_PERMISSION") != -1) {
			dialog.show(message.get("general.error"), message.get("dialog.admin.groups.addPermissionError"), dialog.WARNING, null, 350, 200);

		} else {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.generalError"), err.message), dialog.WARNING, null, 350, 350);				
		}

	} else {
		// Show general error message if we can't determine what went wrong
		dialog.show(message.get("general.error"), message.get("dialog.undefinedError"), dialog.WARNING);
	}
}

function displayDeleteGroupError(err) {
	if (err && err.message) {
		if (err.message.indexOf("GROUP_HAS_USERS") != -1) {
			var userList = "";
			dojo.lang.forEach(err.addresses, function(adr) {
				userList += UtilAddress.createAddressTitle(adr)+"\n";
			});
			userList = dojo.string.trim(userList);
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.groupHasUsersError"), userList), dialog.WARNING, null, 350, 200);
			
		} else if (err.message.indexOf("USER_EDITING_OBJECT_PERMISSION_MISSING") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.object.userEditingError"), err.invalidObject.title, UtilAddress.createAddressTitle(err.rootAddress)), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("USER_RESPONSIBLE_FOR_OBJECT_PERMISSION_MISSING") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.object.userResponsibleError"), err.invalidObject.title, UtilAddress.createAddressTitle(err.rootAddress)), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("USER_EDITING_ADDRESS_PERMISSION_MISSING") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.address.userEditingError"), UtilAddress.createAddressTitle(err.invalidAddress), UtilAddress.createAddressTitle(err.rootAddress)), dialog.WARNING, null, 350, 200);

		} else if (err.message.indexOf("USER_RESPONSIBLE_FOR_ADDRESS_PERMISSION_MISSING") != -1) {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.admin.groups.address.userResponsibleError"), UtilAddress.createAddressTitle(err.invalidAddress), UtilAddress.createAddressTitle(err.rootAddress)), dialog.WARNING, null, 350, 200);

		} else {
			dialog.show(message.get("general.error"), dojo.string.substituteParams(message.get("dialog.generalError"), err.message), dialog.WARNING, null, 350, 350);				
		}

	} else {
		// Show general error message if we can't determine what went wrong
		dialog.show(message.get("general.error"), message.get("dialog.undefinedError"), dialog.WARNING);
	}
}

function showLoadingZone() {
    dojo.html.setVisibility(dojo.byId("adminGroupLoadingZone"), "visible");
}

function hideLoadingZone() {
    dojo.html.setVisibility(dojo.byId("adminGroupLoadingZone"), "hidden");
}

</script>
</head>

<body>

<!-- CONTENT START -->
<div dojoType="ContentPane" layoutAlign="client">
  
	<div id="contentSection" class="contentBlockWhite top">
		<div id="winNavi">
			<a href="javascript:void(0);" onclick="javascript:window.open('mdek_help.jsp?hkey=user-administration-2#user-administration-2', 'Hilfe', 'width=750,height=550,resizable=yes,scrollbars=yes,locationbar=no');" title="Hilfe">[?]</a>
		</div>
		<div id="groupAdmin" class="content">

	        <!-- LEFT HAND SIDE CONTENT BLOCK 1 START -->
	        <div class="spacer"></div>
	        <div class="spacer"></div>

	        <div class="inputContainer noSpaceBelow">
				<div class="tableContainer w364 headHiddenRows9">
					<table id="groups" dojoType="ingrid:FilteringTable" minRows="9" headClass="hidden" cellspacing="0" class="filteringTable nosort interactive">
						<thead>
							<tr>
								<th nosort="true" field="name" dataType="String">Name</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
	        <!-- LEFT HAND SIDE CONTENT BLOCK 1 END -->
	
	        <!-- RIGHT HAND SIDE CONTENT BLOCK 1 START -->
	        <div id="groupData" class="inputContainer">
				<span class="label"><label onclick="javascript:dialog.showContextHelp(arguments[0], 8018)"><fmt:message key="dialog.admin.groups.data" /></label></span>
				<div class="inputContainer field grey noSpaceBelow">
	            	<span class="label"><label for="groupDataName" onclick="javascript:dialog.showContextHelp(arguments[0], 8019, 'Gruppenname')"><fmt:message key="dialog.admin.groups.name" /></label></span>
	            	<span class="input"><input type="text" maxlength="50" id="groupDataName" class="w550" dojoType="ingrid:ValidationTextBox" /></span>
	            	<div class="spacerField"></div>
	      	  	</div>

				<div class="inputContainer">
					<span class="button" style="width:556px; height:20px !important;">
						<span style="float:right;">
							<button dojoType="ingrid:Button" title="Speichern" onClick="javascript:scriptScope.saveGroup();"><fmt:message key="dialog.admin.groups.save" /></button>
						</span>
						<span style="float:right;">
							<button dojoType="ingrid:Button" title="Neue Gruppe anlegen" onClick="javascript:scriptScope.newGroup();"><fmt:message key="dialog.admin.groups.createGroup" /></button>
						</span>
						<span id="adminGroupLoadingZone" style="float:left; margin-top:1px; z-index: 100; visibility:hidden">
							<img src="img/ladekreis.gif" />
						</span>
					</span>
				</div>
				<div id="permissionCheckboxContainer" class="inputContainer grey field checkboxContainer" style="display:none;">
					<span class="input"><input type="checkbox" id="userDataCreate" dojoType="Checkbox" /><label onclick="javascript:dialog.showContextHelp(arguments[0], 8020, 'Root-Objekte und -Adressen anlegen')"><fmt:message key="dialog.admin.groups.createRoot" /></label></span>
					<span class="input"><input type="checkbox" id="userDataQS" dojoType="Checkbox" /><label onclick="javascript:dialog.showContextHelp(arguments[0], 8021, 'Qualit&auml;tssichernder')"><fmt:message key="dialog.admin.groups.qa" /></label></span>
		        </div>
			</div>
			<!-- RIGHT HAND SIDE CONTENT BLOCK 1 END -->
	
	        <!-- CONTENT BLOCK 2 START -->
	        <!-- SPLIT CONTAINER START -->
			<div id="permissionListObjects" style="display:none;">
				<div class="spacer"></div>
				<div class="spacer"></div>
				<span class="label"><label onclick="javascript:dialog.showContextHelp(arguments[0], 8022)"><fmt:message key="dialog.admin.groups.objectPermissions" /></label></span>
				<div dojoType="ingrid:SplitContainer" id="groupDataObjects" persist="false" orientation="horizontal" layoutAlign="client" templateCssPath="js/dojo/widget/templates/SplitContainer.css">
		            <!-- LEFT HAND SIDE CONTENT BLOCK 2 START -->
		            <div dojoType="ContentPane" class="inputContainer noSpaceBelow" style="overflow:auto;" sizeShare="38">
						<div class="inputContainer grey noSpaceBelow">
							<div dojoType="ContentPane" id="treeContainerObjects">
								<!-- tree components -->
								<div dojoType="ingrid:TreeController" widgetId="treeControllerObjects"></div>
								<div dojoType="ingrid:TreeListener" widgetId="treeListenerObjects"></div>	
								<div dojoType="ingrid:TreeDocIcons" widgetId="treeDocIconsObjects"></div>	
								<div dojoType="ingrid:TreeDecorator" listener="treeListenerObjects"></div>
		                  
								<!-- tree -->
								<div dojoType="ingrid:Tree" listeners="treeControllerObjects;treeListenerObjects;treeDocIconsObjects" widgetId="treeObjects">
<!-- 
									<div dojoType="ingrid:TreeNode" title="Objekte" objectId="o1" isFolder="true" nodeDocType="Objects" nodeAppType="Objekt"></div>
 -->
								</div>
							</div>
							<div class="spacer"></div>
						</div>
					</div>
					<!-- LEFT HAND SIDE CONTENT BLOCK 2 END -->
		
		            <!-- RIGHT HAND SIDE CONTENT BLOCK 2 START -->
		            <div dojoType="ContentPane" class="inputContainer noSpaceBelow" style="overflow:hidden;" sizeshare="62">
 						<div class="selectEntryBtn">
							<button dojoType="ingrid:Button" id="addObjectButton" onClick="javascript:scriptScope.addObject();">&nbsp;>&nbsp;</button>
						</div>

						<div id="groupDataObjectsData" class="inputContainer grey field">
							<div class="tableContainer third2 rows7">
								<table id="groupDataRightsObjectsList" dojoType="ingrid:FilteringTable" minRows="7" headClass="fixedHeader" cellspacing="0" class="filteringTable nosort interactive">
									<thead>
										<tr>
											<th nosort="true" field="title" dataType="String" width="358"><fmt:message key="dialog.admin.groups.objectName" /></th>
											<th nosort="true" field="single" dataType="String" width="85"><fmt:message key="dialog.admin.groups.objectSingle" /></th>
											<th nosort="true" field="subtree" dataType="String" width="85"><fmt:message key="dialog.admin.groups.objectTree" /></th>
										</tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<!-- RIGHT HAND SIDE CONTENT BLOCK 2 END -->
				</div>
			</div>
			<!-- CONTENT BLOCK 2 END -->
	
	        <!-- CONTENT BLOCK 3 START -->
	        <!-- SPLIT CONTAINER START -->
			<div id="permissionListAddresses" style="display:none;">
				<div class="spacer"></div>
				<div class="spacer"></div>
				<span class="label"><label onclick="javascript:dialog.showContextHelp(arguments[0], 8023)"><fmt:message key="dialog.admin.groups.addressPermissions" /></label></span>
				<div dojoType="ingrid:SplitContainer" id="groupDataAddresses" persist="false" orientation="horizontal" layoutAlign="client" templateCssPath="js/dojo/widget/templates/SplitContainer.css">
		            <!-- LEFT HAND SIDE CONTENT BLOCK 3 START -->
		            <div dojoType="ContentPane" class="inputContainer noSpaceBelow" style="overflow:auto;" sizeShare="38">
						<div class="inputContainer grey noSpaceBelow">
							<div dojoType="ContentPane" id="treeContainerAddresses">
								<!-- tree components -->
								<div dojoType="ingrid:TreeController" widgetId="treeControllerAddresses"></div>
								<div dojoType="ingrid:TreeListener" widgetId="treeListenerAddresses"></div>	
								<div dojoType="ingrid:TreeDocIcons" widgetId="treeDocIconsAddresses"></div>	
								<div dojoType="ingrid:TreeDecorator" listener="treeListenerAddresses"></div>
		                  
								<!-- tree -->
								<div dojoType="ingrid:Tree" listeners="treeControllerAddresses;treeListenerAddresses;treeDocIconsAddresses" widgetId="treeAddresses">
								</div>
							</div>
							<div class="spacer"></div>
						</div>
					</div>
					<!-- LEFT HAND SIDE CONTENT BLOCK 3 END -->
		
		            <!-- RIGHT HAND SIDE CONTENT BLOCK 3 START -->
		            <div dojoType="ContentPane" class="inputContainer noSpaceBelow" style="overflow:hidden;" sizeshare="62">
  						<div class="selectEntryBtn">
							<button dojoType="ingrid:Button" id="addAddressButton" onClick="javascript:scriptScope.addAddress();">&nbsp;>&nbsp;</button>
						</div>


						<div id="groupDataAddressesData" class="inputContainer grey field">
							<div class="tableContainer third2 rows7">
								<table id="groupDataRightsAddressesList" dojoType="ingrid:FilteringTable" minRows="7" headClass="fixedHeader" cellspacing="0" class="filteringTable nosort interactive">
									<thead>
										<tr>
											<th nosort="true" field="title" dataType="String" width="358"><fmt:message key="dialog.admin.groups.addressName" /></th>
											<th nosort="true" field="single" dataType="String" width="85"><fmt:message key="dialog.admin.groups.addressSingle" /></th>
											<th nosort="true" field="subtree" dataType="String" width="85"><fmt:message key="dialog.admin.groups.addressTree" /></th>
										</tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<!-- RIGHT HAND SIDE CONTENT BLOCK 2 END -->
				</div>

			</div>
			<!-- CONTENT BLOCK 2 END -->
		</div>
	</div>
</div>
<!-- CONTENT END -->

</body>
</html>
