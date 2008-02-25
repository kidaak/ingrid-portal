/*
 * This proxy is used to read from and write to the different gui elements.
 * Additional checks are performed to ensure that no data is lost in the process (e.g.
 * asking the user if unsaved changes should really be discarded)
 *
 * The proxy is called indirectly via the following topics (dojo.event.topic.publish(topic, message)):
 *   topic = '/loadRequest' - argument: {id: nodeUuid, appType: appType, resultHandler: deferred}
 *     nodeUuid - The Uuid of the node
 *     appType  - 'A' for Address, 'O' for Object
 *     resultHandler - (optional) A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/createObjectRequest' - argument: {id: parentUuid, resultHandler: deferred}
 *     parentUuid - The Uuid of the objects parent
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/createAddressRequest' - argument: {id: parentUuid, resultHandler: deferred}
 *     parentUuid - The Uuid of the addresses parent
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/saveRequest' - argument:
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *	   forcePublicationCondition - Tell the backend to adjust the publication condition of subnodes
 *
 *   topic = '/publishObjectRequest' - argument: {resultHandler: deferred}
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/publishAddressRequest' - argument: {resultHandler: deferred}
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/deleteRequest' - argument: {id: nodeUuid, resultHandler: deferred}
 *     nodeUuid - The Uuid of the node which should be deleted
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/deleteWorkingCopyRequest' - argument: {id: nodeUuid, resultHandler: deferred}
 *     nodeUuid - The Uuid of the working copy node which should be deleted
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/canCutObjectRequest' - argument: {id: nodeUuid, resultHandler: deferred}
 *     nodeUuid - The Uuid of the node which should be marked for a cut operation
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/canCutAddressRequest' - argument: {id: nodeUuid, resultHandler: deferred}
 *     nodeUuid - The Uuid of the address which should be marked for a cut operation
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/canCopyObjectRequest' - argument: {id: nodeUuid, copyTree: boolean resultHandler: deferred}
 *     nodeUuid - The Uuid of the node which should be marked for a copied operation
 *     copyTree - specifies whether the complete tree should be copied or only the selected node
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/canCopyAddressRequest' - argument: {id: nodeUuid, copyTree: boolean resultHandler: deferred}
 *     nodeUuid - The Uuid of the address which should be marked for a copied operation
 *     copyTree - specifies whether the complete tree should be copied or only the selected node
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/cutObjectRequest' - argument: {srcId: srcUuid, dstId: dstUuid, resultHandler: deferred}
 *     srcId - The Uuid of the node which should be cut
 *     dstId - The Uuid of the target node where the srcNode should be attached
 *	   forcePublicationCondition - Tell the backend to adjust the publication condition of subnodes
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/cutAddressRequest' - argument: {srcId: srcUuid, dstId: dstUuid, resultHandler: deferred}
 *     srcId - The Uuid of the address which should be cut
 *     dstId - The Uuid of the target address where the srcNode should be attached
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/copyObjectRequest' - argument: {srcId: srcUuid, dstId: dstUuid, copyTree: boolean, resultHandler: deferred}
 *     srcId - The Uuid of the node which should be copied
 *     dstId - The Uuid of the target node where the srcNode should be attached
 *     copyTree - specifies whether the complete tree should be copied or only the selected node
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/copyAddressRequest' - argument: {srcId: srcUuid, dstId: dstUuid, copyTree: boolean, resultHandler: deferred}
 *     srcId - The Uuid of the address which should be copied
 *     dstId - The Uuid of the target address where the srcNode should be attached
 *     copyTree - specifies whether the complete tree should be copied or only the selected node
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *
 *   topic = '/getObjectPathRequest' - argument: {id: nodeUuid, resultHandler: deferred, ignoreDirtyFlag: bool}
 *     nodeUuid - The Uuid of the target Node
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *     ignoreDirtyFlag - boolean value indicating if the dirty flag should be ignored
 *
 *   topic = '/getAddressPathRequest' - argument: {id: nodeUuid, resultHandler: deferred, ignoreDirtyFlag: bool}
 *     nodeUuid - The Uuid of the target Address
 *     resultHandler - A dojo.Deferred which is called when the request has been processed
 *     ignoreDirtyFlag - boolean value indicating if the dirty flag should be ignored
 */


var udkDataProxy = {};

// This flag is set when any value in the gui changes
udkDataProxy.dirtyFlag = false;


// In currentUdk we cache the currently loaded udk in it's original representation.
// Changes are not tracked here! We need it to access static information that is not
// displayed in the gui (e.g. nodeUUID).
var currentUdk = {}; 

// This store holds the comments which are added/modified via the 'add comment' dialog.
var commentStore = {};

// This object holds general information about the catalog (see CatalogBean for content).
var catalogData = {};


// TODO Move Dirty Flag handling to another file? 
dojo.addOnLoad(function()
{
	// Common requests
    dojo.event.topic.subscribe("/loadRequest", udkDataProxy, "handleLoadRequest");
    dojo.event.topic.subscribe("/saveRequest", udkDataProxy, "handleSaveRequest");
    dojo.event.topic.subscribe("/deleteRequest", udkDataProxy, "handleDeleteRequest");
    dojo.event.topic.subscribe("/deleteWorkingCopyRequest", udkDataProxy, "handleDeleteWorkingCopyRequest");

	// Object requests
    dojo.event.topic.subscribe("/publishObjectRequest", udkDataProxy, "handlePublishObjectRequest");
    dojo.event.topic.subscribe("/createObjectRequest", udkDataProxy, "handleCreateObjectRequest");
    dojo.event.topic.subscribe("/canCutObjectRequest", udkDataProxy, "handleCanCutObjectRequest");
	dojo.event.topic.subscribe("/canCopyObjectRequest", udkDataProxy, "handleCanCopyObjectRequest");
    dojo.event.topic.subscribe("/cutObjectRequest", udkDataProxy, "handleCutObjectRequest");
    dojo.event.topic.subscribe("/copyObjectRequest", udkDataProxy, "handleCopyObjectRequest");
    dojo.event.topic.subscribe("/getObjectPathRequest", udkDataProxy, "handleGetObjectPathRequest");

	// Address requests
    dojo.event.topic.subscribe("/publishAddressRequest", udkDataProxy, "handlePublishAddressRequest");
    dojo.event.topic.subscribe("/createAddressRequest", udkDataProxy, "handleCreateAddressRequest");
    dojo.event.topic.subscribe("/canCutAddressRequest", udkDataProxy, "handleCanCutAddressRequest");
	dojo.event.topic.subscribe("/canCopyAddressRequest", udkDataProxy, "handleCanCopyAddressRequest");
    dojo.event.topic.subscribe("/cutAddressRequest", udkDataProxy, "handleCutAddressRequest");
    dojo.event.topic.subscribe("/copyAddressRequest", udkDataProxy, "handleCopyAddressRequest");
    dojo.event.topic.subscribe("/getAddressPathRequest", udkDataProxy, "handleGetAddressPathRequest");


	// Set initial values
	udkDataProxy.dirtyFlag = false;
	commentStore = new dojo.collections.Store();	


	// Before a node is selected we ask the user if he wants to save unsaved changes.
	// Connection to the onClick function does not work for some odd reasons (?)
	// We connect to the processNode function instead.
	var treeListener = dojo.widget.byId("treeListener");
	var aroundTreeClick = function(invocation) {
    	if (dojo.html.hasClass(invocation.args[1].target, "TreeLabel")) {	
			if (invocation.args[0].id == "newNode") {
				// Don't display the dialog if a node with id newNode was clicked.
				// This is to prevent the node from being deleted when the user clicks
				// a newly created node
				return invocation.proceed();
			} else {
				var deferred = udkDataProxy.checkForUnsavedChanges(invocation.args[0].id);
				var stdCallback = function() {return invocation.proceed();};
				var errorCallback = function() {dojo.debug("Select cancelled.");};
			}
			deferred.addCallbacks(stdCallback, errorCallback);
			return deferred;
		} else {
			return invocation.proceed();
		}	
	}
	dojo.event.connect("around", treeListener, "processNode", aroundTreeClick);

	// Connect the widgets onChange methods to the setDirtyFlag Method
	dojo.lang.forEach(headerUiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(generalUiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(spatialUiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(timeUiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(extraUiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(availUiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(thesUiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(class0UiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(class1UiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(class2UiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(class3UiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(class4UiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(class5UiInputElements, _connectWidgetWithDirtyFlag);

	dojo.lang.forEach(adrUiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(adrClass0UiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(adrClass1UiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(adrClass2UiInputElements, _connectWidgetWithDirtyFlag);
	dojo.lang.forEach(adrClass3UiInputElements, _connectWidgetWithDirtyFlag);

	_connectStoreWithDirtyFlag(commentStore);

	dojo.event.connect(udkDataProxy, "_setData", udkDataProxy, "resetDirtyFlag");
  }
);

udkDataProxy.setDirtyFlag = function()
{
	this.dirtyFlag = true;
}

udkDataProxy.resetDirtyFlag = function()
{
	this.dirtyFlag = false;
}


function _connectWidgetWithDirtyFlag(widgetId) {
	// We don't need to connect the 'Link' tables. If those tables are changed, the 'master' table (linksTo)
	// will be changed and set the dirty flag 
	if (dojo.string.endsWith(widgetId, "Link")) {
		return;
	}

	var widget = dojo.widget.byId(widgetId);
	if (widget instanceof dojo.widget.RealNumberTextbox) {
    	dojo.event.connect(widget, "onkeyup", udkDataProxy, "setDirtyFlag");
	} else if (widget instanceof dojo.widget.Checkbox) {
    	dojo.event.connect(widget, "onClick", udkDataProxy, "setDirtyFlag");
	} else if (widget instanceof dojo.widget.DropdownDatePicker) {
	    dojo.event.connect(widget, "onValueChanged", udkDataProxy, "setDirtyFlag");
	} else if (widget instanceof ingrid.widget.ValidationTextbox) {
    	dojo.event.connect(widget, "onkeyup", udkDataProxy, "setDirtyFlag");
	} else if (widget instanceof ingrid.widget.Select) {
	    dojo.event.connect(widget, "onValueChanged", udkDataProxy, "setDirtyFlag");
	} else if (widget instanceof ingrid.widget.ComboBox) {
	    dojo.event.connect(widget, "onValueChanged", udkDataProxy, "setDirtyFlag");
	} else if (widget instanceof ingrid.widget.FilteringTable) {
		_connectStoreWithDirtyFlag(widget.store);	
	} else {
		dojo.debug("Can't connect widget "+widgetId+" with dirty flag. Method not implemented for "+widget);
	}
}

function _connectStoreWithDirtyFlag(store) {
	dojo.event.connect(store, "onSetData", udkDataProxy, "setDirtyFlag");
	dojo.event.connect(store, "onClearData", udkDataProxy, "setDirtyFlag");
	dojo.event.connect(store, "onAddData", udkDataProxy, "setDirtyFlag");
	dojo.event.connect(store, "onAddDataRange", udkDataProxy, "setDirtyFlag");
	dojo.event.connect(store, "onRemoveData", udkDataProxy, "setDirtyFlag");
	dojo.event.connect(store, "onUpdateField", udkDataProxy, "setDirtyFlag");
}

// This function has to be called before any UI functions that are about to change the
// state of the tree or the currently displayed dataset. It checks if there are unsaved changes
// and queries the user if he wants to save changes, discard them or abort.
// The function returns a deferred object users can attach callbacks to.
// The deferred object signals an error if the user canceled the operation. No state changes
// should be done in this case.
// @arg nodeId - optional parameter that specifies the node that is about to be loaded
udkDataProxy.checkForUnsavedChanges = function(nodeId)
{
	dojo.debug("Check for unsaved changes called.");

	var deferred = new dojo.Deferred();
	if (this.dirtyFlag == true) {
		dialog.showPage(message.get("dialog.saveChangesTitle"), "mdek_save_changes.html", 342, 130, true, {resultHandler: deferred});

		// If the user was editing a newly created node and he wants to discard the changes
		// delete the newly created node.
		if (currentUdk.uuid == "newNode" && nodeId != "newNode") {
			deferred.addCallback(function(arg) {
				if (arg == "DISCARD") {
					dojo.debug("Discarding the newly created node.");
					var newNode = dojo.widget.byId("newNode");
					newNode.destroy();
				}			
			});
		}
	} else {
		deferred.callback();
	}

	return deferred;
}


udkDataProxy.handleLoadRequest = function(msg)
{
	dojo.debug("About to be loaded: "+msg.id);

	// Don't process newNode and objectRoot load requests.
	if (msg.id == "newNode" || msg.id == "objectRoot" || msg.id == "addressRoot" || msg.id == "addressFreeRoot") {
		msg.resultHandler.callback();
		return;
	}

	var nodeId = msg.id;
	var nodeAppType = msg.appType;
	var resultHandler = msg.resultHandler;
	// TODO Check if we are in a state where it's safe to load data.
	//      If we are, load the data. If not delay the call and bounce back the message (e.g. query user).
	var deferred = udkDataProxy.checkForUnsavedChanges();
	var loadErrback = function() {
		if (typeof(resultHandler) != "undefined") {
			resultHandler.errback(new Error("LOAD_CANCEL_ERROR"));		
		}
	}
	var loadCallback = function() {
		dojo.debug("udkDataProxy calling EntryService.getNodeData("+nodeId+", "+nodeAppType+")");
		// ---- DWR call to load the data ----
		if (nodeAppType == "O") {
			EntryService.getNodeData(nodeId, nodeAppType, "false",
				{
					callback:function(res){
							if (res != null) {
								udkDataProxy._setData(res);
								udkDataProxy._updateTree(res);
								resetRequiredFields();
								if (resultHandler)
									resultHandler.callback();
								udkDataProxy.resetDirtyFlag();
							} else {
	//							dojo.debug(resultHandler);
								if (typeof(resultHandler) != "undefined") {
									resultHandler.errback("Error loading object. The object with the specified id doesn't exist!");
								}
							}
							return res;
						},
					timeout:20000,
					errorHandler:function(message) {
						dojo.debug("Error in js/udkDataProxy.js: Error while waiting for nodeData: " + message);
					},
					exceptionHandler:function(message) {
						dojo.debug("Exception in js/udkDataProxy.js: Exception while waiting for nodeData: " + message);
					}
				});
		} else if (nodeAppType == "A") {
			EntryService.getAddressData(nodeId, "false",
				{
					callback:function(res){
							if (res != null) {
								udkDataProxy._setData(res);
								udkDataProxy._updateTree(res);
								resetRequiredFields();
								if (resultHandler)
									resultHandler.callback();
								udkDataProxy.resetDirtyFlag();
							} else {
								if (typeof(resultHandler) != "undefined") {
									resultHandler.errback("Error loading Address. The Address with the specified id doesn't exist!");
								}
							}
							return res;
						},
					timeout:20000,
					errorHandler:function(message) {
						dojo.debug("Error in js/udkDataProxy.js: Error while waiting for addressData: " + message);
					},
					exceptionHandler:function(message) {
						dojo.debug("Exception in js/udkDataProxy.js: Exception while waiting for addressData: " + message);
					}
				});
		}
	};

	deferred.addCallbacks(loadCallback, loadErrback);
}

udkDataProxy.handleCreateObjectRequest = function(msg)
{
	var nodeId = msg.id;
	if (msg.id == "objectRoot") {
		nodeId = null;
	}

	// TODO Check if we are in a state where it's safe to create a node?
	//      If we are, load the data. If not delay the call and bounce back the message (e.g. query user).
	var deferred = udkDataProxy.checkForUnsavedChanges();
	var loadErrback = function() {msg.resultHandler.errback();}
	var loadCallback = function() {
		EntryService.createNewNode(nodeId,
			{
				callback: function(res){
						msg.resultHandler.callback(res);
						udkDataProxy._setData(res);
						udkDataProxy.setDirtyFlag();
					},
				timeout:10000,
				errorHandler:function(message) {msg.resultHandler.errback("Error in js/udkDataProxy.js: Error while creating a new node."); }
			}
		);	
	}
	deferred.addCallbacks(loadCallback, loadErrback);
}

udkDataProxy.handleCreateAddressRequest = function(msg)
{
	var nodeId = msg.id;
	if (msg.id == "addressRoot" || msg.id == "addressFreeRoot") {
		nodeId = null;
	}

	// TODO Check if we are in a state where it's safe to create a node?
	//      If we are, load the data. If not delay the call and bounce back the message (e.g. query user).
	var deferred = udkDataProxy.checkForUnsavedChanges();
	var loadErrback = function() {msg.resultHandler.errback();}
	var loadCallback = function() {
		EntryService.createNewAddress(nodeId,
			{
				callback: function(res){
						if (msg.id == "addressFreeRoot") {
							res.addressClass = 3;
							res.nodeDocType = "PersonAddress_B";
						}
						msg.resultHandler.callback(res);
						udkDataProxy._setData(res);
						udkDataProxy.setDirtyFlag();
					},
				timeout:10000,
				errorHandler:function(message) {msg.resultHandler.errback("Error in js/udkDataProxy.js: Error while creating a new address."); }
			}
		);	
	}
	deferred.addCallbacks(loadCallback, loadErrback);
}


udkDataProxy.handleSaveRequest = function(msg)
{
	if (currentUdk.nodeAppType == "O")
		udkDataProxy._handleSaveObjectRequest(msg);
	else if (currentUdk.nodeAppType == "A")
		udkDataProxy._handleSaveAddressRequest(msg);
}

udkDataProxy._handleSaveAddressRequest = function(msg) {

	// Address validity check	
	if (!checkValidityOfAddressInputElements()){
		if (msg && msg.resultHandler) {
			msg.resultHandler.errback(new Error("INPUT_INVALID_ERROR"));
		}
		return;
	}

	// Construct an MdekAddressBean from the available data
	var nodeData = udkDataProxy._getData();

	// Deferred obj for the main save operation. The passed resulthandler is called with the appropriate result
	var onSaveDef = new dojo.Deferred();
	onSaveDef.addCallback(function(res) {
		udkDataProxy.resetDirtyFlag();
		udkDataProxy._setData(res);
		udkDataProxy._updateTree(res, nodeData.uuid);
		udkDataProxy.onAfterSave();
		msg.resultHandler.callback(res);	
	});
	onSaveDef.addErrback(function(err) {
		msg.resultHandler.errback(err);
	});


	// ---- DWR call to store the data ----
	dojo.debug("udkDataProxy calling EntryService.saveAddressData("+nodeData.uuid+", true)");
	EntryService.saveAddressData(nodeData, "true",
		{
			callback: function(res) { onSaveDef.callback(res); },
			timeout:10000,
			errorHandler:function(err) {
				dojo.debug("Error in js/udkDataProxy.js: Error while saving addressData:");
				onSaveDef.errback(err);
			}
		}
	);
}


udkDataProxy._handleSaveObjectRequest = function(msg) {
	if (!checkValidityOfInputElements()){
		if (msg && msg.resultHandler) {
			msg.resultHandler.errback(new Error("INPUT_INVALID_ERROR"));
		}
		return;
	}

	// Determine if the publication condition should be adjusted (forced) for subnodes
	var forcePubCond = false;
	if (msg && typeof(msg.forcePublicationCondition) != "undefined") {
		forcePubCond = msg.forcePublicationCondition;
	}

	// Construct an MdekDataBean from the available data
	var nodeData = udkDataProxy._getData();

	// Deferred obj for the main save operation. The passed resulthandler is called with the appropriate result
	var onSaveDef = new dojo.Deferred();
	onSaveDef.addCallback(function(res) {
		udkDataProxy.resetDirtyFlag();
		udkDataProxy._setData(res);
		udkDataProxy._updateTree(res, nodeData.uuid);
		udkDataProxy.onAfterSave();
		msg.resultHandler.callback(res);	
	});
	onSaveDef.addErrback(function(err) {
		msg.resultHandler.errback(err);
	});


	// ---- DWR call to store the data ----
	dojo.debug("udkDataProxy calling EntryService.saveNodeData("+nodeData.uuid+", true, "+forcePubCond+")");
	EntryService.saveNodeData(nodeData, "true", forcePubCond,
		{
			callback: function(res) { onSaveDef.callback(res); },
			timeout:10000,
			errorHandler:function(err) {
				// Check for the publication condition error
				if (err.indexOf("SUBTREE_HAS_LARGER_PUBLICATION_CONDITION") != -1) {
					var onForceSaveDef = new dojo.Deferred();
					
					// If the user wants to save the object anyway, set force save and start another request
					onForceSaveDef.addCallback(function() {
						msg.forcePublicationCondition = true;
						dojo.event.topic.publish("/saveRequest", msg);
					});
					// If the user cancelled the operation notify the result handler
					onForceSaveDef.addErrback(onSaveDef.errback);

					// Display the 'publication condition' dialog with the attached resultHandler
					dialog.showPage(message.get("general.error"), "mdek_pubCond_dialog.html", 342, 220, true, {operation:"SAVE", resultHandler:onForceSaveDef});
				} else {
					dojo.debug("Error in js/udkDataProxy.js: Error while saving nodeData:");
					onSaveDef.errback(err);
				}
			}
		}
	);
}


udkDataProxy.handlePublishObjectRequest = function(msg) {
	// Construct an MdekDataBean from the available data
	var nodeData = udkDataProxy._getData();

	var forcePubCond = false;
	if (msg && typeof(msg.forcePublicationCondition) != "undefined") {
		forcePubCond = msg.forcePublicationCondition;
	}

	// Deferred obj for the main publish operation. The passed resulthandler is called with the appropriate result
	var onPublishDef = new dojo.Deferred();
	onPublishDef.addCallback(function(res) {
		udkDataProxy.resetDirtyFlag();
		udkDataProxy._setData(res);
		udkDataProxy._updateTree(res, nodeData.uuid);
		udkDataProxy.onAfterSave();
		msg.resultHandler.callback(res);	
	});
	onPublishDef.addErrback(function(err) {
		msg.resultHandler.errback(err);
	});


	// ---- DWR call to store the data ----
	dojo.debug("udkDataProxy calling EntryService.saveNodeData("+nodeData.uuid+", false, "+forcePubCond+")");
	EntryService.saveNodeData(nodeData, "false", forcePubCond,
		{
			callback: function(res) { onPublishDef.callback(res); },
			timeout:10000,
			errorHandler:function(err) {
				// Check for the publication condition error
				if (err.indexOf("SUBTREE_HAS_LARGER_PUBLICATION_CONDITION") != -1) {
					var onForcePublishDef = new dojo.Deferred();
					
					// If the user wants to publish the object anyway, set force publish and start another request
					onForcePublishDef.addCallback(function() {
						msg.forcePublicationCondition = true;
						dojo.event.topic.publish("/publishObjectRequest", msg);
					});
					// If the user cancelled the operation notify the result handler
					onForcePublishDef.addErrback(onPublishDef.errback);

					// Display the 'publication condition' dialog with the attached resultHandler
					dialog.showPage(message.get("general.error"), "mdek_pubCond_dialog.html", 342, 220, true, {operation:"SAVE", resultHandler:onForcePublishDef});
				} else {
					dojo.debug("Error in js/udkDataProxy.js: Error while publishing nodeData:");
					onPublishDef.errback(err);
				}
			}
		}
	);
}

udkDataProxy.handlePublishAddressRequest = function(msg) {
	// Construct an MdekDataBean from the available data
	var nodeData = udkDataProxy._getData();

	// Deferred obj for the main publish operation. The passed resulthandler is called with the appropriate result
	var onPublishDef = new dojo.Deferred();
	onPublishDef.addCallback(function(res) {
		udkDataProxy.resetDirtyFlag();
		udkDataProxy._setData(res);
		udkDataProxy._updateTree(res, nodeData.uuid);
		udkDataProxy.onAfterSave();
		msg.resultHandler.callback(res);	
	});
	onPublishDef.addErrback(function(err) {
		msg.resultHandler.errback(err);
	});


	// ---- DWR call to store the data ----
	dojo.debug("udkDataProxy calling EntryService.saveAddressData("+nodeData.uuid+", false)");
	EntryService.saveAddressData(nodeData, "false",
		{
			callback: function(res) { onPublishDef.callback(res); },
			timeout:10000,
			errorHandler:function(err) {
				dojo.debug("Error in js/udkDataProxy.js: Error while publishing address:");
				onPublishDef.errback(err);
			}
		}
	);
}

udkDataProxy.handleDeleteWorkingCopyRequest = function(msg) {
	var nodeAppType = dojo.widget.byId(msg.id).nodeAppType;
	if (nodeAppType == "O")
		udkDataProxy._handleDeleteObjectWorkingCopyRequest(msg);
	else if (nodeAppType == "A")
		udkDataProxy._handleDeleteAddressWorkingCopyRequest(msg);
}

udkDataProxy._handleDeleteAddressWorkingCopyRequest = function(msg) {
	dojo.debug("udkDataProxy calling EntryService.deleteAddressWorkingCopy("+msg.id+")");
	EntryService.deleteAddressWorkingCopy(msg.id, "false",
		{
			callback: function(res){
				if (res != null) {
					udkDataProxy.resetDirtyFlag();
					udkDataProxy._setData(res);
					udkDataProxy._updateTree(res, msg.id);
					udkDataProxy.onAfterSave();
				}
				msg.resultHandler.callback(res);
			},
			timeout:10000,
			errorHandler:function(message) {
				alert("Error in js/udkDataProxy.js: Error while deleting address working copy: " + message);
				msg.resultHandler.errback();
			}
		}
	);
}

udkDataProxy._handleDeleteObjectWorkingCopyRequest = function(msg) {
	dojo.debug("udkDataProxy calling EntryService.deleteObjectWorkingCopy("+msg.id+")");
	EntryService.deleteObjectWorkingCopy(msg.id, "false",
		{
			callback: function(res){
				if (res != null) {
					udkDataProxy.resetDirtyFlag();
					udkDataProxy._setData(res);
					udkDataProxy._updateTree(res, msg.id);
					udkDataProxy.onAfterSave();
				}
				msg.resultHandler.callback(res);
			},
			timeout:10000,
			errorHandler:function(message) {
				alert("Error in js/udkDataProxy.js: Error while deleting working copy: " + message);
				msg.resultHandler.errback();
			}
		}
	);
}


udkDataProxy.handleDeleteRequest = function(msg) {
	var nodeAppType = dojo.widget.byId(msg.id).nodeAppType;
	if (nodeAppType == "O") {
		dojo.debug("udkDataProxy calling EntryService.deleteNode("+msg.id+")");
		EntryService.deleteNode(msg.id, "false",
			{
				callback: function(res){msg.resultHandler.callback(res);},
				timeout:10000,
				errorHandler:function(err) {
					alert("Error in js/udkDataProxy.js: Error while deleting node: " + err);
					msg.resultHandler.errback(err);
				}
			}
		);
	} else if (nodeAppType == "A") {
		dojo.debug("udkDataProxy calling EntryService.deleteAddress("+msg.id+")");
		EntryService.deleteAddress(msg.id, "false",
			{
				callback: function(res){msg.resultHandler.callback(res);},
				timeout:10000,
				errorHandler:function(err) {
					alert("Error in js/udkDataProxy.js: Error while deleting address: " + err);
					msg.resultHandler.errback(err);
				}
			}
		);
	}
}

udkDataProxy.handleCanCutObjectRequest = function(msg) {
	dojo.debug("udkDataProxy calling EntryService.canCutNode("+msg.id+")");	

	EntryService.canCutObject(msg.id,
		{
			callback: function(res){msg.resultHandler.callback();},
			timeout:10000,
			errorHandler:function(err) {
				dojo.debug("Error in js/udkDataProxy.js: Error while marking a node for a cut operation: " + err);
				msg.resultHandler.errback(err);
			}
		}
	);
}

udkDataProxy.handleCanCutAddressRequest = function(msg) {
	dojo.debug("udkDataProxy calling EntryService.canCutAddress("+msg.id+")");	

	EntryService.canCutAddress(msg.id,
		{
			callback: function(res){msg.resultHandler.callback();},
			timeout:10000,
			errorHandler:function(err) {
				dojo.debug("Error in js/udkDataProxy.js: Error while marking an address for a cut operation: " + err);
				msg.resultHandler.errback(err);
			}
		}
	);
}


udkDataProxy.handleCanCopyObjectRequest = function(msg) {
	dojo.debug("udkDataProxy calling EntryService.canCopyNode("+msg.id+", "+msg.copyTree+")");	

	EntryService.canCopyObject(msg.id,
		{
			callback: function(res){msg.resultHandler.callback();},
			timeout:30000,
			errorHandler:function(err) {
				dojo.debug("Error in js/udkDataProxy.js: Error while marking a node for a copy operation: " + err);
				msg.resultHandler.errback(err);
			}
		}
	);
}

udkDataProxy.handleCanCopyAddressRequest = function(msg) {
	dojo.debug("udkDataProxy calling EntryService.canCopyAddress("+msg.id+", "+msg.copyTree+")");	

	EntryService.canCopyAddress(msg.id,
		{
			callback: function(res){msg.resultHandler.callback();},
			timeout:30000,
			errorHandler:function(err) {
				dojo.debug("Error in js/udkDataProxy.js: Error while marking an address for a copy operation: " + err);
				msg.resultHandler.errback(err);
			}
		}
	);
}

udkDataProxy.handleCutObjectRequest = function(msg) {
	if(msg.dstId == "objectRoot") {
		msg.dstId = null;
	}

	var forcePubCond = false;
	if (msg && typeof(msg.forcePublicationCondition) != "undefined") {
		forcePubCond = msg.forcePublicationCondition;
	}

	dojo.debug("udkDataProxy calling EntryService.moveNode("+msg.srcId+", "+msg.dstId+", "+forcePubCond+")");	
	EntryService.moveNode(msg.srcId, msg.dstId, forcePubCond,
		{
			callback: function(res) { msg.resultHandler.callback(res); },
			timeout:30000,
			errorHandler:function(err) {
				// Check for the publication condition error
				if (err.indexOf("SUBTREE_HAS_LARGER_PUBLICATION_CONDITION") != -1) {
					var onForceMoveDef = new dojo.Deferred();

					// If the user wants to publish the object anyway, set force publish and start another request
					onForceMoveDef.addCallback(function() {
						msg.forcePublicationCondition = true;
						dojo.event.topic.publish("/cutObjectRequest", msg);
					});
					// If the user cancelled the operation notify the result handler
					onForceMoveDef.addErrback(msg.resultHandler.errback);

					// Display the 'publication condition' dialog with the attached resultHandler
					dialog.showPage(message.get("general.error"), "mdek_pubCond_dialog.html", 342, 220, true, {operation:"MOVE", resultHandler:onForceMoveDef});
				} else {
					dojo.debug("Error in js/udkDataProxy.js: Error while moving nodeData:");
					msg.resultHandler.errback(err);
				}
			}
		}
	);
}

udkDataProxy.handleCutAddressRequest = function(msg) {
	var srcId = msg.srcId;
	var dstId = msg.dstId;
	var moveToFreeAddress = false;

	if (dstId == "addressRoot") {
		dstId = null;
	} else if (dstId == "addressFreeRoot") {
		dstId = null;
		moveToFreeAddress = true;
	}

	dojo.debug("udkDataProxy calling EntryService.moveAddress("+srcId+", "+dstId+", "+moveToFreeAddress+")");	
	EntryService.moveAddress(srcId, dstId, moveToFreeAddress,
		{
			callback: function(res) { msg.resultHandler.callback(res); },
			timeout:30000,
			errorHandler:function(err) {
				dojo.debug("Error in js/udkDataProxy.js: Error while moving address:");
				msg.resultHandler.errback(err);
			}
		}
	);
}

udkDataProxy.handleCopyObjectRequest = function(msg) {
	dojo.debug("udkDataProxy calling EntryService.copyNode("+msg.srcId+", "+msg.dstId+", "+msg.copyTree+")");	

	var srcId = msg.srcId;
	var dstId = msg.dstId;

	if (dstId == "objectRoot") {
		dstId = null;
	}

	var onCopyDef = new dojo.Deferred();
	onCopyDef.addCallback(function(res) {
		// Copy operation was successful. Pass the copied node to the result handler
		msg.resultHandler.callback(res);
	});
	onCopyDef.addErrback(function(err) {
		msg.resultHandler.errback(err);
	});

	EntryService.copyNode(srcId, dstId, msg.copyTree,
		{
			callback: function(res) { onCopyDef.callback(res); },
			timeout:3000,	// Wait three seconds for the call to finish and display the 'please wait' dialog afterwards 
			errorHandler:function(err) {
				if (err == "Timeout") {
					var onCopyOpFinishedDef = new dojo.Deferred();
					// TODO we need to return some information about the copied node!
					onCopyOpFinishedDef.addCallback(function (res) {
						if (res == "JOB_CANCELLED") {
							onCopyDef.callback(null);
						} else {
							onCopyDef.callback(res);
						}
					});
					onCopyOpFinishedDef.addErrback(function (err) {onCopyDef.errback(err);});
					dialog.showPage(message.get("general.hint"), "mdek_waitForJob_dialog.html", 350, 155, true, {resultHandler:onCopyOpFinishedDef});
				} else {
					dojo.debug("Error in js/udkDataProxy.js: Error while copying nodes: " + err);
					onCopyDef.errback(err);
				}
			}
		}
	);
}

udkDataProxy.handleCopyAddressRequest = function(msg) {
	var srcId = msg.srcId;
	var dstId = msg.dstId;
	var copyToFreeAddress = false;

	if (dstId == "addressRoot") {
		dstId = null;
	} else if (dstId == "addressFreeRoot") {
		dstId = null;
		copyToFreeAddress = true;
		msg.copyTree = false;
	}

	var onCopyDef = new dojo.Deferred();
	onCopyDef.addCallback(function(res) {
		// Copy operation was successful. Pass the copied node to the result handler
		msg.resultHandler.callback(res);
	});
	onCopyDef.addErrback(function(err) {
		msg.resultHandler.errback(err);
	});

	dojo.debug("udkDataProxy calling EntryService.copyAddress("+msg.srcId+", "+msg.dstId+", "+msg.copyTree+", "+copyToFreeAddress+")");	
	EntryService.copyAddress(srcId, dstId, msg.copyTree, copyToFreeAddress,
		{
			callback: function(res) { onCopyDef.callback(res); },
			timeout:3000,	// Wait three seconds for the call to finish and display the 'please wait' dialog afterwards 
			errorHandler:function(err) {
				if (err == "Timeout") {
					var onCopyOpFinishedDef = new dojo.Deferred();
					// TODO we need to return some information about the copied node!
					onCopyOpFinishedDef.addCallback(function (res) {
						if (res == "JOB_CANCELLED") {
							onCopyDef.callback(null);
						} else {
							onCopyDef.callback(res);
						}
					});
					onCopyOpFinishedDef.addErrback(function (err) {onCopyDef.errback(err);});
					dialog.showPage(message.get("general.hint"), "mdek_waitForJob_dialog.html", 350, 155, true, {resultHandler:onCopyOpFinishedDef});
				} else {
					dojo.debug("Error in js/udkDataProxy.js: Error while copying addresses: " + err);
					onCopyDef.errback(err);
				}
			}
		}
	);
}


udkDataProxy.handleGetObjectPathRequest = function(msg) {
	var loadErrback = function() {msg.resultHandler.errback();}
	var loadCallback = function() {
		dojo.debug("udkDataProxy calling EntryService.getPathToObject("+msg.id+")");	
		EntryService.getPathToObject(msg.id, {
				callback: function(res){msg.resultHandler.callback(res);},
				timeout:10000,
				errorHandler:function(message) {
					alert("Error in js/udkDataProxy.js: Error while getting path to node: " + message);
					msg.resultHandler.errback();
				}
			}
		);	
	}

	if (msg.ignoreDirtyFlag) {
		// If the dirty flag is ignored, the request can be started
		loadCallback(); 
	} else {
		// Otherwise check for unsaved changes and start the request afterwards
		var deferred = udkDataProxy.checkForUnsavedChanges();
		deferred.addCallbacks(loadCallback, loadErrback);
	}
}

udkDataProxy.handleGetAddressPathRequest = function(msg) {
	var loadErrback = function() {msg.resultHandler.errback();}
	var loadCallback = function() {
		dojo.debug("udkDataProxy calling EntryService.getPathToAddress("+msg.id+")");	
		EntryService.getPathToAddress(msg.id, {
				callback: function(res){msg.resultHandler.callback(res);},
				timeout:10000,
				errorHandler:function(message) {
					alert("Error in js/udkDataProxy.js: Error while getting path to address: " + message);
					msg.resultHandler.errback();
				}
			}
		);	
	}

	if (msg.ignoreDirtyFlag) {
		// If the dirty flag is ignored, the request can be started
		loadCallback(); 
	} else {
		// Otherwise check for unsaved changes and start the request afterwards
		var deferred = udkDataProxy.checkForUnsavedChanges();
		deferred.addCallbacks(loadCallback, loadErrback);
	}
}


// event.connect point. Called when data has been saved 
udkDataProxy.onAfterSave = function() { dojo.debug("onAfterSave()"); }
udkDataProxy.onAfterPublish = function() { dojo.debug("onAfterPublish()"); }

udkDataProxy._setData = function(nodeData)
{
	currentUdk = nodeData;
/*
	dojo.debug("NodeData Properties: ");
	for (property in nodeData)
	{
	  dojo.debug(property+": "+ nodeData[property]);
	}
*/
	// -- We check if we received an Address or Object and call the corresponding function --
	switch (nodeData.nodeAppType.toUpperCase())
	{
	case 'A':
		udkDataProxy._setAddressData(nodeData);
		break;
	case 'O':
		udkDataProxy._setObjectData(nodeData);
		break;
	default:
		dojo.debug("Error in udkDataProxy._setData - Node Type must be \'A\' or \'O\'!");
		break;
	}  
}

udkDataProxy._setAddressData = function(nodeData)
{
	// Set the address type list values depending on the parent class
	var parentClass = nodeData.parentClass;
	if (parentClass == null) {
		if (nodeData.addressClass == 3)
			parentClass = -2;
		else 
			parentClass = -1;
	}

	var addressTypeDP = dojo.widget.byId("addressType").dataProvider;

	var valueList = [];
	switch (parentClass) {
		case -2:	// Free Address Root
			valueList.push([message.get("address.type.custom"), "AddressType3"]);
			break;

		case -1: // Root Address
			valueList.push([message.get("address.type.institution"), "AddressType0"]);
			break;

		case 0:	// Institution
			valueList.push([message.get("address.type.institution"), "AddressType0"]);
			valueList.push([message.get("address.type.unit"), "AddressType1"]);
			valueList.push([message.get("address.type.person"), "AddressType2"]);
			break;

		case 1:	// Unit
			valueList.push([message.get("address.type.unit"), "AddressType1"]);
			valueList.push([message.get("address.type.person"), "AddressType2"]);
			break;

		case 2:	// Person (a person must not have any subAddresses)
			dojo.debug("Error in udkDataProxy._setAddressData - A 'person' is not allowed to have any sub addresses!");
			break;

		case 3:	// Custom Address (a custom address must not have any subAddresses)
			dojo.debug("Error in udkDataProxy._setAddressData - A 'custom address' is not allowed to have any sub addresses!");
			break;

		default:
			dojo.debug("Error in udkDataProxy._setAddressData - Unknown parent address type: "+parentClass);
			break;
	}
	addressTypeDP.setData(valueList);


	// ------------------ Header ------------------
	dojo.widget.byId("addressTitle").setValue(udkDataProxy._createAddressTitle(nodeData));
	dojo.widget.byId("addressType").setValue("AddressType"+nodeData.addressClass);
	dojo.byId("addressWorkState").innerHTML = nodeData.workState;
	dojo.byId("addressCreationTime").innerHTML = nodeData.creationTime;
	dojo.byId("addressModificationTime").innerHTML = nodeData.modificationTime;

	// ------------------ Address and Function ------------------
	dojo.widget.byId("addressStreet").setValue(nodeData.street);
	dojo.widget.byId("addressCountry").setValue(nodeData.countryCode);
	dojo.widget.byId("addressZipCode").setValue(nodeData.postalCode);
	dojo.widget.byId("addressCity").setValue(nodeData.city);
	dojo.widget.byId("addressPOBox").setValue(nodeData.pobox);
	dojo.widget.byId("addressZipPOBox").setValue(nodeData.poboxPostalCode);
	dojo.widget.byId("addressNotes").setValue(nodeData.addressDescription);
	dojo.widget.byId("addressTasks").setValue(nodeData.task);
	dojo.widget.byId("addressCom").store.setData(udkDataProxy._addTableIndices(nodeData.communication));

	// -- Thesaurus --
	dojo.widget.byId("thesaurusTermsAddress").store.setData(udkDataProxy._addTableIndices(nodeData.thesaurusTermsTable));
	dojo.widget.byId("thesaurusFreeTermsListAddress").store.setData(udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.thesaurusFreeTermsTable)));

	// -- Links --
	var linkTable = nodeData.linksFromObjectTable;
	udkDataProxy._addTableIndices(linkTable);
	udkDataProxy._addObjectLinkLabels(linkTable);  
	udkDataProxy._addIcons(linkTable);
	dojo.widget.byId("associatedObjName").store.setData(linkTable);

	// Comments
	commentStore.setData(udkDataProxy._addTableIndices(udkDataProxy._addDisplayDates(nodeData.commentTable)));

	var institution = "";
	dojo.lang.forEach(nodeData.parentInstitutions, function(item) {
		institution += item+"\n";
	});
	institution = dojo.string.trim(institution);

	var addressFields = ["headerAddressType0Institution", "headerAddressType0Unit", "headerAddressType1Institution", "headerAddressType1Unit",
		"headerAddressType2Institution", "headerAddressType2Lastname", "headerAddressType2Firstname", "headerAddressType2Style",
		"headerAddressType2Title", "headerAddressType3Lastname", "headerAddressType3Firstname", "headerAddressType3Style",
		"headerAddressType3Title", "headerAddressType3Institution"];

	dojo.lang.forEach(addressFields, function(field){ dojo.widget.byId(field).setValue(""); });

	// ------------------ Class specific content ------------------
	switch(nodeData.addressClass) {
		case 0:
			dojo.widget.byId("headerAddressType0Institution").setValue(institution);
			dojo.widget.byId("headerAddressType0Unit").setValue(nodeData.organisation);
			break;
		case 1:
			dojo.widget.byId("headerAddressType1Institution").setValue(institution);
			dojo.widget.byId("headerAddressType1Unit").setValue(nodeData.organisation);
			break;
		case 2:
			dojo.widget.byId("headerAddressType2Institution").setValue(institution);
			dojo.widget.byId("headerAddressType2Lastname").setValue(nodeData.name);
			dojo.widget.byId("headerAddressType2Firstname").setValue(nodeData.givenName);
			dojo.widget.byId("headerAddressType2Style").setValue(nodeData.nameForm);
			dojo.widget.byId("headerAddressType2Title").setValue(nodeData.titleOrFunction);
			break;
		case 3:
			dojo.widget.byId("headerAddressType3Lastname").setValue(nodeData.name);
			dojo.widget.byId("headerAddressType3Firstname").setValue(nodeData.givenName);
			dojo.widget.byId("headerAddressType3Style").setValue(nodeData.nameForm);
			dojo.widget.byId("headerAddressType3Title").setValue(nodeData.titleOrFunction);
			dojo.widget.byId("headerAddressType3Institution").setValue(nodeData.organisation);
			break;
		default:
			dojo.debug("Error in udkDataProxy._setAddressData - Address Class must be 0, 1, 2 or 3!");
			break;
	}
}

udkDataProxy._setObjectData = function(nodeData)
{
  /* 
   * 1. Set the data common to all objects which is:
   *   Header, General, Spatial, Time, Extra Info,
   *   Availability, Thesaurus and Links
   *
   * 2. Set the variable information depending on the object class
   *
   */

  // ------------------ Header ------------------
  var formWidget = dojo.widget.byId("headerFormObject");

//  dojo.debug("HeaderObjectForm before setting values: " + dojo.json.serialize(formWidget.getValues()));

  if (nodeData.objectName == null)
  	dojo.widget.byId("objectName").setValue(message.get("tree.newNodeName"));
  else
  	dojo.widget.byId("objectName").setValue(nodeData.objectName);

  dojo.widget.byId("objectClass").setValue("Class"+nodeData.objectClass);
  dojo.byId("workState").innerHTML = nodeData.workState;
  dojo.byId("creationTime").innerHTML = nodeData.creationTime;
  dojo.byId("modificationTime").innerHTML = nodeData.modificationTime;

//  dojo.widget.byId("last_editor").setValue("test last editor");

//  dojo.debug("HeaderObjectForm after setting values: " + dojo.json.serialize(formWidget.getValues()));


  // ------------------ Object Content ------------------
  formWidget = dojo.widget.byId("contentFormObject");
//  dojo.debug("ContentFormObject before setting values: " + dojo.json.serialize(formWidget.getValues()));

  // --- General ---
  dojo.widget.byId("generalShortDesc").setValue(nodeData.generalShortDescription);
  dojo.widget.byId("generalDesc").setValue(nodeData.generalDescription);
  var addressTable = nodeData.generalAddressTable;
  udkDataProxy._addTableIndices(addressTable);
  udkDataProxy._addIcons(addressTable);
  udkDataProxy._addAddressTitles(addressTable);
  udkDataProxy._addAddressLinkLabels(addressTable);
  dojo.widget.byId("generalAddress").store.setData(addressTable);
  // Comments
  commentStore.setData(udkDataProxy._addTableIndices(udkDataProxy._addDisplayDates(nodeData.commentTable)));

  // Init the publication select widget depending on the publication condition of the parent
  var widgetDP = dojo.widget.byId("extraInfoPublishArea").dataProvider;
  var valueList = [];
  if (nodeData.parentPublicationCondition == null)
  	nodeData.parentPublicationCondition = 1;

  switch (nodeData.parentPublicationCondition) {
	case 1: valueList.push([message.get("extraInfo.publicationCondition.internet"), "1"]);
	case 2: valueList.push([message.get("extraInfo.publicationCondition.intranet"), "2"]);
	case 3: valueList.push([message.get("extraInfo.publicationCondition.internal"), "3"]);
//	case 4: valueList.push([message.get("extraInfo.publicationCondition.notShared"), "4"]);
	default: valueList.unshift(["", ""]);
  }
  widgetDP.setData(valueList);


  // -- Spatial --
  // The table containing entries from the sns is indexed by their topicID
  dojo.widget.byId("spatialRefAdminUnit").store.setData(udkDataProxy._addTableIndices(nodeData.spatialRefAdminUnitTable));
  // The table containing free entries needs generated indices
  dojo.widget.byId("spatialRefLocation").store.setData(udkDataProxy._addTableIndices(nodeData.spatialRefLocationTable));

  dojo.widget.byId("spatialRefAltMin").setValue(nodeData.spatialRefAltMin);
  dojo.widget.byId("spatialRefAltMax").setValue(nodeData.spatialRefAltMax);
  dojo.widget.byId("spatialRefAltMeasure").setValue(nodeData.spatialRefAltMeasure);
  dojo.widget.byId("spatialRefAltVDate").setValue(nodeData.spatialRefAltVDate);
  dojo.widget.byId("spatialRefExplanation").setValue(nodeData.spatialRefExplanation);

  // -- Time --
  dojo.widget.byId("timeRefType").setValue(nodeData.timeRefType);
  if (nodeData.timeRefDate1) { dojo.widget.byId("timeRefDate1").setValue(nodeData.timeRefDate1); }
  else { dojo.widget.byId("timeRefDate1").clearValue(); }
  if (nodeData.timeRefDate2) { dojo.widget.byId("timeRefDate2").setValue(nodeData.timeRefDate2); }
  else { dojo.widget.byId("timeRefDate2").clearValue(); }
  dojo.widget.byId("timeRefStatus").setValue(nodeData.timeRefStatus);
  dojo.widget.byId("timeRefPeriodicity").setValue(nodeData.timeRefPeriodicity);
  dojo.widget.byId("timeRefIntervalNum").setValue(nodeData.timeRefIntervalNum);
  dojo.widget.byId("timeRefIntervalUnit").setValue(nodeData.timeRefIntervalUnit);
  dojo.widget.byId("timeRefExplanation").setValue(nodeData.timeRefExplanation);
  dojo.widget.byId("timeRefTable").store.setData(udkDataProxy._addTableIndices(nodeData.timeRefTable));

  // -- Extra Info --
  dojo.widget.byId("extraInfoLangMetaData").setValue(nodeData.extraInfoLangMetaData);
  dojo.widget.byId("extraInfoLangData").setValue(nodeData.extraInfoLangData);
  dojo.widget.byId("extraInfoPublishArea").setValue(nodeData.extraInfoPublishArea);
  dojo.widget.byId("extraInfoPurpose").setValue(nodeData.extraInfoPurpose);
  dojo.widget.byId("extraInfoUse").setValue(nodeData.extraInfoUse);
  dojo.widget.byId("extraInfoXMLExportTable").store.setData(udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.extraInfoXMLExportTable)));
  dojo.widget.byId("extraInfoLegalBasicsTable").store.setData(udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.extraInfoLegalBasicsTable)));

  // -- Availability --
  dojo.widget.byId("availabilityOrderInfo").setValue(nodeData.availabilityOrderInfo);
  dojo.widget.byId("availabilityNoteUse").setValue(nodeData.availabilityNoteUse);
  dojo.widget.byId("availabilityCosts").setValue(nodeData.availabilityCosts);
  dojo.widget.byId("availabilityDataFormat").store.setData(udkDataProxy._addTableIndices(nodeData.availabilityDataFormatTable));
  dojo.widget.byId("availabilityMediaOptions").store.setData(udkDataProxy._addTableIndices(nodeData.availabilityMediaOptionsTable));


  // -- Thesaurus --
  dojo.widget.byId("thesaurusTerms").store.setData(udkDataProxy._addTableIndices(nodeData.thesaurusTermsTable));
  dojo.widget.byId("thesaurusFreeTermsList").store.setData(udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.thesaurusFreeTermsTable)));
  dojo.widget.byId("thesaurusTopics").store.setData(udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.thesaurusTopicsList)));
  dojo.widget.byId("thesaurusEnvTopics").store.setData(udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.thesaurusEnvTopicsList)));
  dojo.widget.byId("thesaurusEnvCats").store.setData(udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.thesaurusEnvCatsList)));
  dojo.widget.byId("thesaurusEnvExtRes").setValue(nodeData.thesaurusEnvExtRes);

  // -- Links --
  var objLinkTable = nodeData.linksToObjectTable;
  var urlLinkTable = nodeData.linksToUrlTable;
  var linkTable = objLinkTable.concat(urlLinkTable);

  udkDataProxy._addTableIndices(linkTable);
  udkDataProxy._addObjectLinkLabels(linkTable);
  udkDataProxy._addUrlLinkLabels(linkTable);
  udkDataProxy._addIcons(linkTable);
  dojo.widget.byId("linksTo").store.setData(linkTable);

  linkTable = nodeData.linksFromObjectTable;
  udkDataProxy._addTableIndices(linkTable);
  udkDataProxy._addObjectLinkLabels(linkTable);  
  udkDataProxy._addIcons(linkTable);
  dojo.widget.byId("linksFrom").store.setData(linkTable);

  // Clear all object classes
	udkDataProxy._setObjectDataClass0(nodeData);
	udkDataProxy._setObjectDataClass1(nodeData);
	udkDataProxy._setObjectDataClass2(nodeData);
	udkDataProxy._setObjectDataClass3(nodeData);
	udkDataProxy._setObjectDataClass4(nodeData);
	udkDataProxy._setObjectDataClass5(nodeData);

//  dojo.debug("ContentFormObject after setting values: " + dojo.json.serialize(formWidget.getValues()));

// The values are set with the corresponding setter methods
// We could also set the values through the form
//  dojo.widget.byId("contentFormObject").setValues(myObj);
//  dojo.widget.byId("headerFormAddress").setValues(myObj);
//  dojo.widget.byId("contentFormAddress").setValues(myObj);
}

udkDataProxy._setObjectDataClass0 = function(nodeData) {}

udkDataProxy._setObjectDataClass1 = function(nodeData) {
	dojo.widget.byId("ref1DataSet").setValue(nodeData.ref1DataSet);
	dojo.widget.byId("ref1Coverage").setValue(nodeData.ref1Coverage);
	dojo.widget.byId("ref1VFormatTopology").setValue(nodeData.ref1VFormatTopology);

	// The spatial system table is a combobox that allows free entries but also entries associated with IDs
	// If the reference system ID == -1 then we receive a free entry, otherwise we have to resolve the id
	if (nodeData.ref1SpatialSystemId == -1) {
		dojo.widget.byId("ref1SpatialSystem").setValue(nodeData.ref1SpatialSystem);
	} else {
		var dispVal = ref1SpatialSystemDP.getDisplayValueForValue(nodeData.ref1SpatialSystemId);
		if (dispVal != null) {
			dojo.widget.byId("ref1SpatialSystem").setValue(dispVal);
		} else {
			dojo.widget.byId("ref1SpatialSystem").setValue("");
		}	
	}

	dojo.widget.byId("ref1AltAccuracy").setValue(nodeData.ref1AltAccuracy);
	dojo.widget.byId("ref1PosAccuracy").setValue(nodeData.ref1PosAccuracy);
	dojo.widget.byId("ref1BasisText").setValue(nodeData.ref1BasisText);
	dojo.widget.byId("ref1DataBasisText").setValue(nodeData.ref1DataBasisText);
	dojo.widget.byId("ref1ProcessText").setValue(nodeData.ref1ProcessText);

	dojo.widget.byId("ref1Representation").store.setData(udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.ref1Representation)));
	dojo.widget.byId("ref1Data").store.setData(udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.ref1Data)));

	dojo.widget.byId("ref1VFormatDetails").store.setData(udkDataProxy._addTableIndices(nodeData.ref1VFormatDetails));
	dojo.widget.byId("ref1Scale").store.setData(udkDataProxy._addTableIndices(nodeData.ref1Scale));
	dojo.widget.byId("ref1SymbolsText").store.setData(udkDataProxy._addTableIndices(nodeData.ref1SymbolsText));
	dojo.widget.byId("ref1KeysText").store.setData(udkDataProxy._addTableIndices(nodeData.ref1KeysText));
}

udkDataProxy._setObjectDataClass2 = function(nodeData) {
	dojo.widget.byId("ref2Author").setValue(nodeData.ref2Author);
	dojo.widget.byId("ref2Publisher").setValue(nodeData.ref2Publisher);
	dojo.widget.byId("ref2PublishedIn").setValue(nodeData.ref2PublishedIn);
	dojo.widget.byId("ref2PublishLocation").setValue(nodeData.ref2PublishLocation);
	dojo.widget.byId("ref2PublishedInIssue").setValue(nodeData.ref2PublishedInIssue);
	dojo.widget.byId("ref2PublishedInPages").setValue(nodeData.ref2PublishedInPages);
	dojo.widget.byId("ref2PublishedInYear").setValue(nodeData.ref2PublishedInYear);
	dojo.widget.byId("ref2PublishedISBN").setValue(nodeData.ref2PublishedISBN);
	dojo.widget.byId("ref2PublishedPublisher").setValue(nodeData.ref2PublishedPublisher);
	dojo.widget.byId("ref2LocationText").setValue(nodeData.ref2LocationText);
	dojo.widget.byId("ref2DocumentType").setValue(nodeData.ref2DocumentType);
	dojo.widget.byId("ref2BaseDataText").setValue(nodeData.ref2BaseDataText);
	dojo.widget.byId("ref2BibData").setValue(nodeData.ref2BibData);
	dojo.widget.byId("ref2Explanation").setValue(nodeData.ref2Explanation);
}

udkDataProxy._setObjectDataClass3 = function(nodeData) {
	dojo.widget.byId("ref3ServiceType").setValue(nodeData.ref3ServiceType);
	dojo.widget.byId("ref3SystemEnv").setValue(nodeData.ref3SystemEnv);
	dojo.widget.byId("ref3History").setValue(nodeData.ref3History);
	dojo.widget.byId("ref3BaseDataText").setValue(nodeData.ref3BaseDataText);
	dojo.widget.byId("ref3Explanation").setValue(nodeData.ref3Explanation);

//	dojo.debug("Setting service version to: "+udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.ref3ServiceVersion)));
	dojo.widget.byId("ref3ServiceVersion").store.setData(udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.ref3ServiceVersion)));

	// Prepare the operation table for display.
	// Add table indices to the main obj and paramList
	// Add table indices and convert to tableData: platform, addressList and dependencies
	if (nodeData.ref3Operation) {
		for (var i = 0; i < nodeData.ref3Operation.length; ++i) {
			udkDataProxy._addTableIndices(nodeData.ref3Operation[i].paramList);
			nodeData.ref3Operation[i].platform = udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.ref3Operation[i].platform));
			nodeData.ref3Operation[i].addressList = udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.ref3Operation[i].addressList));
			nodeData.ref3Operation[i].dependencies = udkDataProxy._addTableIndices(udkDataProxy._listToTableData(nodeData.ref3Operation[i].dependencies));		
		}
	}	
	dojo.widget.byId("ref3Operation").store.setData(udkDataProxy._addTableIndices(nodeData.ref3Operation));
}

udkDataProxy._setObjectDataClass4 = function(nodeData) {
	dojo.widget.byId("ref4ParticipantsText").setValue(nodeData.ref4ParticipantsText);
	dojo.widget.byId("ref4PMText").setValue(nodeData.ref4PMText);
	dojo.widget.byId("ref4Explanation").setValue(nodeData.ref4Explanation);
}

udkDataProxy._setObjectDataClass5 = function(nodeData) {
	dojo.widget.byId("ref5MethodText").setValue(nodeData.ref5MethodText);
	dojo.widget.byId("ref5Explanation").setValue(nodeData.ref5Explanation);

	dojo.widget.byId("ref5dbContent").store.setData(udkDataProxy._addTableIndices(nodeData.ref5dbContent));
}




/*******************************************
 * Methods for sending data to the backend *
 *******************************************/

udkDataProxy._getData = function()
{
  var nodeData = {};

  nodeData.nodeAppType = currentUdk.nodeAppType;

  // -- We check which node needs to get saved --
  switch (nodeData.nodeAppType.toUpperCase())
  {
    case 'A':
      udkDataProxy._getAddressData(nodeData);
      break;
    case 'O':
      udkDataProxy._getObjectData(nodeData);
      break;
    default:
      dojo.debug("Error in udkDataProxy._getData - Node Type must be \'A\' or \'O\'!");
      break;
  }

  return (nodeData);
}

udkDataProxy._getAddressData = function(nodeData) {

	// ------------- General Static Data -------------
	nodeData.uuid = currentUdk.uuid;
	var parentUuid = dojo.widget.byId(currentUdk.uuid).parent.id;
	if (parentUuid != "addressRoot" && parentUuid != "addressFreeRoot") {
		nodeData.parentUuid = parentUuid;
	}

	// ------------------ Header ------------------
	nodeData.addressClass = dojo.widget.byId("addressType").getValue()[11];		// AddressTypex

	// ------------------ Address and Function ------------------
	nodeData.street = dojo.widget.byId("addressStreet").getValue();
	nodeData.countryCode = dojo.widget.byId("addressCountry").getValue();
	nodeData.postalCode = dojo.widget.byId("addressZipCode").getValue();
	nodeData.city = dojo.widget.byId("addressCity").getValue();
	nodeData.pobox = dojo.widget.byId("addressPOBox").getValue();
	nodeData.poboxPostalCode = dojo.widget.byId("addressZipPOBox").getValue();
	nodeData.addressDescription = dojo.widget.byId("addressNotes").getValue();
	nodeData.task = dojo.widget.byId("addressTasks").getValue();
	nodeData.communication = udkDataProxy._getTableData("addressCom");

	// -- Thesaurus --
	nodeData.thesaurusTermsTable = udkDataProxy._getTableData("thesaurusTermsAddress");
	nodeData.thesaurusFreeTermsTable = udkDataProxy._tableDataToList(udkDataProxy._getTableData("thesaurusFreeTermsListAddress"));

	// -- Links --
	nodeData.linksFromObjectTable = udkDataProxy._getTableData("associatedObjName");

	// Comments
	nodeData.commentTable = commentStore.getData();


  // ------------------ Class specific content ------------------
	switch(nodeData.addressClass) {
		case '0':
//			nodeData.organisation = dojo.widget.byId("headerAddressType0Institution").getValue();
			nodeData.organisation = dojo.widget.byId("headerAddressType0Unit").getValue();
			break;
		case '1':
//			dojo.widget.byId("headerAddressType1Institution").setValue(nodeData.organisation);
			nodeData.organisation = dojo.widget.byId("headerAddressType1Unit").getValue();
			break;
		case '2':
//			dojo.widget.byId("headerAddressType2Institution").setValue(nodeData.organisation);
			nodeData.name = dojo.widget.byId("headerAddressType2Lastname").getValue();
			nodeData.givenName = dojo.widget.byId("headerAddressType2Firstname").getValue();
			nodeData.nameForm = dojo.widget.byId("headerAddressType2Style").getValue();
			nodeData.titleOrFunction = dojo.widget.byId("headerAddressType2Title").getValue();
			break;
		case '3':
			nodeData.name = dojo.widget.byId("headerAddressType3Lastname").getValue();
			nodeData.givenName = dojo.widget.byId("headerAddressType3Firstname").getValue();
			nodeData.nameForm = dojo.widget.byId("headerAddressType3Style").getValue();
			nodeData.titleOrFunction = dojo.widget.byId("headerAddressType3Title").getValue();
			nodeData.organisation = dojo.widget.byId("headerAddressType3Institution").getValue();
			break;
		default:
			dojo.debug("Error in udkDataProxy._getAddressData - Address Class must be 0, 1, 2 or 3!");
			break;
	}

  dojo.debug("------ ADDRESS DATA ------");
  dojo.debugShallow(nodeData);
  dojo.debug("------ ADDRESS DATA END ------");
}

udkDataProxy._getObjectData = function(nodeData)
{
  /* 
   * 1. Get the static data that is not displayed in the gui which is:
   *    nodeUuid, id, hasChildren
   * 
   * 2. Get the data common to all objects which is:
   *    Header, General, Spatial, Time, Extra Info,
   *    Availability, Thesaurus and Links
   *
   * 3. Get the variable information depending on the object class
   *
   */

  // ------------- General Static Data -------------
  nodeData.uuid = currentUdk.uuid;
  nodeData.hasChildren = currentUdk.hasChildren; // Do we need to store this?
  var parentUuid = dojo.widget.byId(currentUdk.uuid).parent.id;
  if (parentUuid != "objectRoot") {
  	nodeData.parentUuid = parentUuid;
  }


  // ------------------ Header ------------------
  nodeData.objectName = dojo.widget.byId("objectName").getValue();
//  nodeData.last_editor = dojo.widget.byId("last_editor").getValue();

  // ------------------ Object Content ------------------
  // --- General ---
  nodeData.generalShortDescription = dojo.widget.byId("generalShortDesc").getValue();
  nodeData.generalDescription = dojo.widget.byId("generalDesc").getValue();
  nodeData.objectClass = dojo.widget.byId("objectClass").getValue()[5]; // Value is a string: "Classx" where x is the class
  nodeData.generalAddressTable = udkDataProxy._getTableData("generalAddress");
  // Comments
  nodeData.commentTable = commentStore.getData();

  // -- Spatial --
  nodeData.spatialRefAdminUnitTable = udkDataProxy._getTableData("spatialRefAdminUnit");
  nodeData.spatialRefLocationTable = udkDataProxy._getTableData("spatialRefLocation");

  nodeData.spatialRefAltMin = dojo.widget.byId("spatialRefAltMin").getValue();
  nodeData.spatialRefAltMax = dojo.widget.byId("spatialRefAltMax").getValue();
  nodeData.spatialRefAltMeasure = dojo.widget.byId("spatialRefAltMeasure").getValue();
  nodeData.spatialRefAltVDate = dojo.widget.byId("spatialRefAltVDate").getValue();
  nodeData.spatialRefExplanation = dojo.widget.byId("spatialRefExplanation").getValue();

  // -- Time --
  nodeData.timeRefType = dojo.widget.byId("timeRefType").getValue();

  if (dojo.widget.byId("timeRefType").getValue() != "") {
	  if (dojo.widget.byId("timeRefDate1").getValue() != "") {
		  nodeData.timeRefDate1 = dojo.widget.byId("timeRefDate1").getDate();
	  }
	  if (dojo.widget.byId("timeRefDate2").getValue() != "") {
		  nodeData.timeRefDate2 = dojo.widget.byId("timeRefDate2").getDate();
	  }
  }

  nodeData.timeRefStatus = dojo.widget.byId("timeRefStatus").getValue();
  nodeData.timeRefPeriodicity = dojo.widget.byId("timeRefPeriodicity").getValue();
  nodeData.timeRefIntervalNum = dojo.widget.byId("timeRefIntervalNum").getValue();
  nodeData.timeRefIntervalUnit = dojo.widget.byId("timeRefIntervalUnit").getValue();
  nodeData.timeRefExplanation = dojo.widget.byId("timeRefExplanation").getValue();
  nodeData.timeRefTable = udkDataProxy._getTableData("timeRefTable");

  // -- Extra Info --
  nodeData.extraInfoLangMetaData = dojo.widget.byId("extraInfoLangMetaData").getValue();
  nodeData.extraInfoLangData = dojo.widget.byId("extraInfoLangData").getValue();
  nodeData.extraInfoPublishArea = dojo.widget.byId("extraInfoPublishArea").getValue();
  nodeData.extraInfoPurpose = dojo.widget.byId("extraInfoPurpose").getValue();
  nodeData.extraInfoUse = dojo.widget.byId("extraInfoUse").getValue();
	
  nodeData.extraInfoXMLExportTable = udkDataProxy._tableDataToList(udkDataProxy._getTableData("extraInfoXMLExportTable"));
  nodeData.extraInfoLegalBasicsTable = udkDataProxy._tableDataToList(udkDataProxy._getTableData("extraInfoLegalBasicsTable"));

  // -- Availability --
  nodeData.availabilityOrderInfo = dojo.widget.byId("availabilityOrderInfo").getValue();
  nodeData.availabilityNoteUse = dojo.widget.byId("availabilityNoteUse").getValue();
  nodeData.availabilityCosts = dojo.widget.byId("availabilityCosts").getValue();
  nodeData.availabilityDataFormatTable = udkDataProxy._getTableData("availabilityDataFormat");
  nodeData.availabilityMediaOptionsTable = udkDataProxy._getTableData("availabilityMediaOptions");

  // -- Thesaurus --
  nodeData.thesaurusTermsTable = udkDataProxy._getTableData("thesaurusTerms");
  nodeData.thesaurusFreeTermsTable = udkDataProxy._tableDataToList(udkDataProxy._getTableData("thesaurusFreeTermsList"));
  nodeData.thesaurusTopicsList = udkDataProxy._tableDataToList(udkDataProxy._getTableData("thesaurusTopics"));
  nodeData.thesaurusEnvTopicsList = udkDataProxy._tableDataToList(udkDataProxy._getTableData("thesaurusEnvTopics"));
  nodeData.thesaurusEnvCatsList = udkDataProxy._tableDataToList(udkDataProxy._getTableData("thesaurusEnvCats"));
  nodeData.thesaurusEnvExtRes = dojo.widget.byId("thesaurusEnvExtRes").checked;


  // -- Links --
  var linksToTable = udkDataProxy._getTableData("linksTo");
  var objLinks = [];
  var urlLinks = [];
  dojo.lang.forEach(linksToTable, function(link) {
	if (link.url) {
  		urlLinks.push(link);
  	} else {
  		objLinks.push(link);  	
  	}
  });

  nodeData.linksToObjectTable = objLinks;
  nodeData.linksToUrlTable = urlLinks;
  nodeData.linksFromObjectTable = udkDataProxy._getTableData("linksFrom");


  // -- Check which object type was received and fill the appropriate fields --
  switch (nodeData.objectClass)
  {
    case '0':
      udkDataProxy._getObjectDataClass0(nodeData);
      break;
    case '1':
      udkDataProxy._getObjectDataClass1(nodeData);
      break;
    case '2':
      udkDataProxy._getObjectDataClass2(nodeData);
      break;
    case '3':
      udkDataProxy._getObjectDataClass3(nodeData);
      break;
    case '4':
      udkDataProxy._getObjectDataClass4(nodeData);
      break;
    case '5':
      udkDataProxy._getObjectDataClass5(nodeData);
      break;
    default:
      dojo.debug("Error in udkDataProxy._getObjectData - Object Class must be 0...5!");
      break;
  }

  dojo.debug("------ OBJECT DATA ------");
  dojo.debugShallow(nodeData);
  dojo.debug("------ OBJECT DATA END ------");
}

udkDataProxy._getObjectDataClass0 = function(nodeData) {};

udkDataProxy._getObjectDataClass1 = function(nodeData) {
	nodeData.ref1DataSet = dojo.widget.byId("ref1DataSet").getValue();
	nodeData.ref1Coverage = dojo.widget.byId("ref1Coverage").getValue();
	nodeData.ref1VFormatTopology = dojo.widget.byId("ref1VFormatTopology").getValue();

	// The spatial system table is a combobox that allows free entries but also entries associated with IDs
	// If we have a free entry the reference system ID = -1
	nodeData.ref1SpatialSystem = dojo.widget.byId("ref1SpatialSystem").getValue();

	var val = ref1SpatialSystemDP.getValueForDisplayValue(nodeData.ref1SpatialSystem);
	if (val != null) {
		nodeData.ref1SpatialSystemId = val;
	} else {
		nodeData.ref1SpatialSystemId = -1;
	}	

	nodeData.ref1AltAccuracy = dojo.widget.byId("ref1AltAccuracy").getValue();
	nodeData.ref1PosAccuracy = dojo.widget.byId("ref1PosAccuracy").getValue();
	nodeData.ref1BasisText = dojo.widget.byId("ref1BasisText").getValue();
	nodeData.ref1DataBasisText = dojo.widget.byId("ref1DataBasisText").getValue();
	nodeData.ref1ProcessText = dojo.widget.byId("ref1ProcessText").getValue();


	nodeData.ref1Representation = udkDataProxy._tableDataToList(udkDataProxy._getTableData("ref1Representation"));
	nodeData.ref1Data = udkDataProxy._tableDataToList(udkDataProxy._getTableData("ref1Data"));

	nodeData.ref1VFormatDetails = udkDataProxy._getTableData("ref1VFormatDetails");
	nodeData.ref1Scale = udkDataProxy._getTableData("ref1Scale");
	nodeData.ref1SymbolsText = udkDataProxy._getTableData("ref1SymbolsText");
	nodeData.ref1KeysText = udkDataProxy._getTableData("ref1KeysText");
};

udkDataProxy._getObjectDataClass2 = function(nodeData) {
	nodeData.ref2Author = dojo.widget.byId("ref2Author").getValue();
	nodeData.ref2Publisher = dojo.widget.byId("ref2Publisher").getValue();
	nodeData.ref2PublishedIn = dojo.widget.byId("ref2PublishedIn").getValue();
	nodeData.ref2PublishLocation = dojo.widget.byId("ref2PublishLocation").getValue();
	nodeData.ref2PublishedInIssue = dojo.widget.byId("ref2PublishedInIssue").getValue();
	nodeData.ref2PublishedInPages = dojo.widget.byId("ref2PublishedInPages").getValue();
	nodeData.ref2PublishedInYear = dojo.widget.byId("ref2PublishedInYear").getValue();
	nodeData.ref2PublishedISBN = dojo.widget.byId("ref2PublishedISBN").getValue();
	nodeData.ref2PublishedPublisher = dojo.widget.byId("ref2PublishedPublisher").getValue();
	nodeData.ref2LocationText = dojo.widget.byId("ref2LocationText").getValue();
	nodeData.ref2DocumentType = dojo.widget.byId("ref2DocumentType").getValue();
	nodeData.ref2BaseDataText = dojo.widget.byId("ref2BaseDataText").getValue();
	nodeData.ref2BibData = dojo.widget.byId("ref2BibData").getValue();
	nodeData.ref2Explanation = dojo.widget.byId("ref2Explanation").getValue();
};


udkDataProxy._getObjectDataClass3 = function(nodeData) {
	nodeData.ref3ServiceType = dojo.widget.byId("ref3ServiceType").getValue();
	nodeData.ref3SystemEnv = dojo.widget.byId("ref3SystemEnv").getValue();
	nodeData.ref3History = dojo.widget.byId("ref3History").getValue();
	nodeData.ref3BaseDataText = dojo.widget.byId("ref3BaseDataText").getValue();
	nodeData.ref3Explanation = dojo.widget.byId("ref3Explanation").getValue();

	nodeData.ref3ServiceVersion = udkDataProxy._tableDataToList(udkDataProxy._getTableData("ref3ServiceVersion"));

	// Convert the containing operation tables to lists
	// Add table indices and convert to tableData: platform, addressList and dependencies
	nodeData.ref3Operation = [];
	var op = udkDataProxy._getTableData("ref3Operation");
	if (op) {
		for (var i = 0; i < op.length; ++i) {
			var operationData = {};
			operationData.name = op[i].name;
			operationData.description = op[i].description;
			operationData.operationsCall = op[i].operationsCall;
			operationData.paramList = op[i].paramList;
			operationData.platform = udkDataProxy._tableDataToList(op[i].platform);
			operationData.addressList = udkDataProxy._tableDataToList(op[i].addressList);
			operationData.dependencies = udkDataProxy._tableDataToList(op[i].dependencies);

			nodeData.ref3Operation.push(operationData);
		}
	}	
};

udkDataProxy._getObjectDataClass4 = function(nodeData) {
	nodeData.ref4ParticipantsText = dojo.widget.byId("ref4ParticipantsText").getValue();
	nodeData.ref4PMText = dojo.widget.byId("ref4PMText").getValue();
	nodeData.ref4Explanation = dojo.widget.byId("ref4Explanation").getValue();
};

udkDataProxy._getObjectDataClass5 = function(nodeData) {
	nodeData.ref5MethodText = dojo.widget.byId("ref5MethodText").getValue();
	nodeData.ref5Explanation = dojo.widget.byId("ref5Explanation").getValue();

	nodeData.ref5dbContent = udkDataProxy._getTableData("ref5dbContent");
};


/*******************************************
 *            Helper functions             *
 *******************************************/

// Looks for the node widget with uuid = nodeData.uuid and updates the
// tree data (label, type, etc.) according to the given nodeData
udkDataProxy._updateTree = function(nodeData, oldUuid) {
	dojo.debug("_updateTree("+nodeData.uuid+", "+oldUuid+")");
	if (typeof(oldUuid) == "undefined") {
		oldUuid = nodeData.uuid;
	}

	var title = "";
	if (nodeData.nodeAppType == "O") {
		title = nodeData.objectName;
	} else if (nodeData.nodeAppType == "A") {
		title = udkDataProxy._createAddressTitle(nodeData);
	}

	// If we change the uuid (= widgetId) of a node the treeNode has to be created again
	// because otherwise dojo doesn't 'register' the changed widgetId 
	// Currently a changed uuid is only possible if a new Node is updated.
	if (nodeData.uuid != oldUuid && oldUuid == "newNode") {
		var oldWidget = dojo.widget.byId(oldUuid);
		var parent = oldWidget.parent;

		// A new node is a leaf node. It's safe to destroy it
		oldWidget.destroy();
		var treeController = dojo.widget.byId("treeController");
		treeController.createChild(parent, "last", {
			contextMenu: 'contextMenu1',
			isFolder: false,
			nodeDocType: nodeData.nodeDocType,
			title: title,
			dojoType: 'ingrid:TreeNode',
			nodeAppType: nodeData.nodeAppType,
			id: nodeData.uuid
		});
	} else {
		var node = dojo.widget.byId(oldUuid);
		if (node) {
			node.nodeDocType = nodeData.nodeDocType;	
			dojo.widget.byId("treeDocIcons").setnodeDocTypeClass(node);
			node.setTitle(title);
			node.id = nodeData.uuid;	
		} else {
			dojo.debug("Error in _updateTree: TreeNode widget not found. ID: "+nodeData.uuid);
		}
	}
}


// Returns an array representing the data of the table with name 'tableName'
// The keys are stored in the fields named: 'Id' 
udkDataProxy._getTableData = function(tableName)
{
  return dojo.widget.byId(tableName).store.getData();
}

// Creates table data from a list of values.
// ["a", "b", "c"] -> [{identifier: "a"}, {identifier: "b"}, {identifier: "c"}]
udkDataProxy._listToTableData = function(list, identifier) {
	var resultList = [];
	if (typeof(identifier) == "undefined")
		identifier = "title";

	dojo.lang.forEach(list, function(item){
		var x = {};
		x[identifier] = item;
		resultList.push(x);
	});
	return resultList;
}


//Creates a list from table data
// [{identifier: "a"}, {identifier: "b"}, {identifier: "c"}] -> ["a", "b", "c"] 
udkDataProxy._tableDataToList = function(tableData, identifier) {
	var resultList = [];
	if (typeof(identifier) == "undefined") {
		identifier = "title";
	}

	for (var i = 0; i < tableData.length; ++i) {
		resultList.push(tableData[i][identifier]);
	}

	return resultList;
}

// Add Indices (Id values) to a passed list
udkDataProxy._addTableIndices = function(list) {
	if (list) {
		for (var i = 0; i < list.length; ++i) {
			list[i].Id = i;
		}
		return list;
	} else {
		return [];
	}
}

udkDataProxy._addDisplayDates = function(list) {
	if (list) {
		for (var i = 0; i < list.length; ++i) {
//			list[i].displayDate = list[i].date.toLocaleString();
			list[i].displayDate = dojo.date.format(list[i].date, {formatLength:"short", datePattern:"dd.MM.yyyy", timePattern:"H:m"});
		}
		return list;
	} else {
		return [];
	}
}

// Add object link labels to a passed list.
// This function iterates over all entries in the list and adds a value: 'linkLabel' to each node
// which is a href to the menuEventHandler 'selectNodeInTree' function
udkDataProxy._addObjectLinkLabels = function(list) {
	for (var i = 0; i < list.length; ++i) {
		list[i].linkLabel = "<a href='javascript:menuEventHandler.handleSelectNodeInTree(\""+list[i].uuid+"\", \"O\");'"+
		                    "title='"+list[i].title+"'>"+list[i].title+"</a>";
	}
	return list;
}

udkDataProxy._addAddressTitles = function(list) {
	for (var i = 0; i < list.length; ++i) {
		list[i].title = udkDataProxy._createAddressTitle(list[i]);
	}
	return list;
}

udkDataProxy._addAddressLinkLabels = function(list) {
	for (var i = 0; i < list.length; ++i) {
		list[i].linkLabel = "<a href='javascript:menuEventHandler.handleSelectNodeInTree(\""+list[i].uuid+"\", \"A\");'"+
		                    "title='"+list[i].title+"'>"+list[i].title+"</a>";
	}
	return list;
}


udkDataProxy._addUrlLinkLabels = function(list) {
	for (var i = 0; i < list.length; ++i) {
		if (list[i].url) {
			if (dojo.string.startsWith(list[i].url, "http://"))
				list[i].linkLabel = "<a href='"+list[i].url+"' target=\"_blank\" title='"+list[i].name+"'>"+list[i].name+"</a>";
			else
				list[i].linkLabel = list[i].name;
		}
	}
	return list;
}

udkDataProxy._addIcons = function(list) {
	for (var i = 0; i < list.length; ++i) {
		if (typeof(list[i].objectClass) != "undefined") {
			list[i].icon = "<img src='img/UDK/udk_class"+list[i].objectClass+".gif' width=\"16\" height=\"16\" alt=\"Object\" />";
		} else if (typeof(list[i].addressClass) != "undefined") {
			switch (list[i].addressClass) {
				case 0:	// Institution
					list[i].icon = "<img src='img/UDK/addr_institution.gif' width=\"16\" height=\"16\" alt=\"Address\" />";		
					break;
				case 1:	// Unit
					list[i].icon = "<img src='img/UDK/addr_unit.gif' width=\"16\" height=\"16\" alt=\"Address\" />";		
					break;
				case 2:	// Person
					list[i].icon = "<img src='img/UDK/addr_person.gif' width=\"16\" height=\"16\" alt=\"Address\" />";		
					break;
				case 3:	// Free
					list[i].icon = "<img src='img/UDK/addr_free.gif' width=\"16\" height=\"16\" alt=\"Address\" />";		
					break;
				default:
					list[i].icon = "<img src='img/UDK/addr_institution.gif' width=\"16\" height=\"16\" alt=\"Address\" />";		
					break;
			}
		} else if (typeof(list[i].url) != "undefined") {
			list[i].icon = "<img src='img/UDK/url.gif' width=\"16\" height=\"16\" alt=\"Url\" />";		
		} else {
			list[i].icon = "noIcon";
		}
	}
	return list;
}

udkDataProxy._createAddressTitle = function(adr) {
	var title = "";
	switch (adr.addressClass) {
		case 0: // Institution
			title = adr.organisation;
			break;
		case 1:	// Unit
			title = adr.organisation;
			break;
		case 2: // Person
			if (adr.name) title += adr.name;
			if (adr.givenName) title += ", "+adr.givenName;
			break;
		case 3: // Freie Adresse
			if (adr.name) title += adr.name;
			if (adr.givenName) title += ", "+adr.givenName;
			if (adr.organisation) title += " ("+adr.organisation+")";
			break;
		default:
			break;
	}
	if (title == null)
		return message.get("tree.newAddressName");
	else
		return dojo.string.trim(title);
}