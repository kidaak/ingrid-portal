<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html xmlns="http://www.w3.org/1999/xhtml" lang="de">
<head>
<script type="text/javascript">
var scriptScope = this;
var currentSelectedNode = null;

// Callback for the dwr calls to ExportService.export*
// Wait for three seconds for the call to return and refresh the process info if it does
// If we run into a timeout the job is still running and we simply refresh the process info
// If we detect that the user has running jobs, display an error message that the job could not be started
var exportServiceCallback = {
	timeout: 5000,
	preHook: showLoadingZone,
	postHook: hideLoadingZone,
	callback: function(res){
		refreshExportProcessInfo();
	},
	errorHandler: function(msg, err) {
		hideLoadingZone();
		// We expect a timeout error
		if (msg == "Timeout") {
			refreshExportProcessInfo();
		} else {
			if (msg.indexOf("USER_HAS_RUNNING_JOBS") != -1) {
				dialog.show(message.get("general.error"), message.get("operation.error.userHasRunningJobs"), dialog.WARNING);
			}
		}
	}
}


_container_.addOnLoad(function() {
	initSysLists();
	refreshExportProcessInfo();
});

function startExportCriteria() {
	var exportCriteria = dojo.widget.byId("exportXMLCriteria").getValue();
	if (exportCriteria) {
		exportObjectsWithCriteria(exportCriteria);

	} else {
		dialog.show(message.get("general.error"), message.get("dialog.admin.export.selectExportCriteriaError"), dialog.WARNING);
	}
}

function startExportPartial() {
	if (currentSelectedNode) {
		var exportChildren = !dojo.widget.byId("exportTreeSelectionOnly").checked;

		if (currentSelectedNode.nodeAppType == "O") {
			startObjectExport(currentSelectedNode.uuid, exportChildren);
		} else {
			startAddressExport(currentSelectedNode.uuid, exportChildren);
		}
	} else {
		dialog.show(message.get("general.error"), message.get("dialog.admin.export.selectNodeError"), dialog.WARNING);
	}
}

function startObjectExport(uuid, exportChildren) {
	if (uuid == "objectRoot") {
		exportObjectBranch(null, exportChildren);

	} else {
		exportObjectBranch(uuid, exportChildren);
	}
}

function exportObjectBranch(uuid, exportChildren) {
	ExportService.exportObjectBranch(uuid, exportChildren, exportServiceCallback);
}

function exportObjectsWithCriteria(exportCriteria) {
	ExportService.exportObjectsWithCriteria(exportCriteria, exportServiceCallback);
}

function startAddressExport(uuid, exportChildren) {
	if (uuid == "addressRoot") {
		exportTopAddresses(exportChildren);

	} else if (uuid == "addressFreeRoot") {
		exportFreeAddresses();

	} else {
		exportAddressBranch(uuid, exportChildren);
	}
}

function exportAddressBranch(uuid, exportChildren) {
	ExportService.exportAddressBranch(uuid, exportChildren, exportServiceCallback);
}

function exportTopAddresses(exportChildren) {
	ExportService.exportTopAddresses(exportChildren, exportServiceCallback);
}

function exportFreeAddresses() {
	ExportService.exportFreeAddresses(exportServiceCallback);
}

// Button function for 'start export'. Send a request to the backend to start a new export job
scriptScope.startExport = function() {
	if (dojo.byId("exportType1").checked) {
		startExportCriteria();

	} else if (dojo.byId("exportType2").checked) {
		startExportPartial();

	} else {
		dialog.show(message.get("general.error"), message.get("dialog.admin.export.selectExportTypeError"), dialog.WARNING);
		dojo.debug("No export type selected.");
	}
}

// Button function for the 'select dataset' link.
scriptScope.selectDataset = function() {
	var deferred = new dojo.Deferred();

	deferred.addCallback(function(selectedDataset) {
		dojo.debugShallow(selectedDataset);
		dojo.widget.byId("exportTreeName").setValue(selectedDataset.title);
		currentSelectedNode = selectedDataset;
		dojo.byId("exportType2").checked = true;
	});

	dialog.showPage(message.get("dialog.admin.export.selectNode"), 'mdek_admin_export_select_dataset.jsp', 522, 525, true, {
		// custom parameters
		resultHandler: deferred	
	});
}

// Reload the process info for the last run from the backend
refreshExportProcessInfo = function() {
	ExportService.getExportInfo(false, {
		callback: function(exportInfo){
			updateExportInfo(exportInfo);
			if (!jobFinished(exportInfo)) {
				setTimeout("refreshExportProcessInfo()", 2000);
			}
		},
		errorHandler: function(message, err) {
			dojo.debug("Error: "+ message);
			// If there's a timeout try again
			setTimeout("refreshExportProcessInfo()", 2000);
		}
	});
}

function updateExportInfo(exportInfo) {
	if (exportInfo.entityType == "OBJECT") {
		dojo.byId("exportInfoNumExportedEntitiesContainer").innerHTML = message.get("dialog.admin.export.numObjects");
	} else if (exportInfo.entityType == "ADDRESS") {
		dojo.byId("exportInfoNumExportedEntitiesContainer").innerHTML = message.get("dialog.admin.export.numAddresses");
	} else {
		dojo.byId("exportInfoNumExportedEntitiesContainer").innerHTML = message.get("dialog.admin.export.numDatasets");
	}


	if (jobFinished(exportInfo)) {
		dojo.byId("exportInfoTitle").innerHTML = message.get("dialog.admin.export.lastProcessInfo");
		dojo.html.hide(dojo.byId("exportProgressBarContainer"));
		dojo.html.hide(dojo.byId("cancelExportProcessButton"));

		if (exportInfo.exception) {
			dojo.html.show(dojo.byId("exportExceptionMessage"));
			dojo.html.hide(dojo.byId("exportInfoDownload"));
			dojo.html.hide(dojo.byId("exportInfoEndDateContainer"));
			dojo.html.hide(dojo.byId("exportInfoNumExportedEntitiesContainer"));
			dojo.byId("exportInfoNumExportedEntities").innerHTML = "";

		} else if (exportInfo.endTime) {
			dojo.html.hide(dojo.byId("exportExceptionMessage"));
			dojo.html.show(dojo.byId("exportInfoDownload"));
			dojo.html.show(dojo.byId("exportInfoEndDateContainer"));
			dojo.html.show(dojo.byId("exportInfoNumExportedEntitiesContainer"));
			dojo.byId("exportInfoNumExportedEntities").innerHTML = exportInfo.numProcessedEntities;

		} else {
			// No job has been started yet
			dojo.html.hide(dojo.byId("exportExceptionMessage"));
			dojo.html.hide(dojo.byId("exportInfoDownload"));
			dojo.html.hide(dojo.byId("exportInfoEndDateContainer"));
			dojo.html.hide(dojo.byId("exportInfoNumExportedEntitiesContainer"));
			dojo.byId("exportInfoNumExportedEntities").innerHTML = "";
		}
	} else {
		dojo.byId("exportInfoTitle").innerHTML = message.get("dialog.admin.export.currentProcessInfo");
		dojo.html.hide(dojo.byId("exportExceptionMessage"));
		dojo.html.hide(dojo.byId("exportInfoDownload"));
		dojo.html.hide(dojo.byId("exportInfoEndDateContainer"));
		dojo.html.show(dojo.byId("cancelExportProcessButton"));
		dojo.html.show(dojo.byId("exportInfoNumExportedEntitiesContainer"));
		dojo.html.show(dojo.byId("exportProgressBarContainer"));
		dojo.byId("exportInfoNumExportedEntities").innerHTML = exportInfo.numProcessedEntities + " / " + exportInfo.numEntities;

		var progressBar = dojo.widget.byId("exportProgressBar");
		progressBar.setMaxProgressValue(exportInfo.numEntities);
		progressBar.setProgressValue(exportInfo.numProcessedEntities);
	}

	if (exportInfo.startTime) {
		dojo.byId("exportInfoBeginDate").innerHTML = exportInfo.startTime.toLocaleString();
	} else {
		dojo.byId("exportInfoBeginDate").innerHTML = "";
	}

	if (exportInfo.endTime) {
		dojo.byId("exportInfoEndDate").innerHTML = exportInfo.endTime.toLocaleString();
	} else {
		dojo.byId("exportInfoEndDate").innerHTML = "";
	}
}

function jobFinished(exportInfo) {
	// endTime != null -> job has an end time means it's done
	// exception != null -> job has an exception -> done
	// startTime == null -> no start time means something went wrong (no previous job exists?)
	return (exportInfo.endTime != null || exportInfo.exception != null || exportInfo.startTime == null);
}


scriptScope.downloadLastExport = function() {
	ExportService.getLastExportFile({
		callback: function(exportFile) {
			dojo.debug(exportFile);
			dwr.engine.openInDownload(exportFile);
		},
		errorHandler: function(errMsg, err) {
			displayErrorMessage(err);
		}		
	});
}

scriptScope.cancelExport = function() {
	ExportService.cancelRunningJob({
		callback: function() {
			// do nothing
		},
		errorHandler: function(errMsg, err) {
			displayErrorMessage(err);
		}		
	});
}

scriptScope.showJobException = function() {
	ExportService.getExportInfo(false, {
		callback: function(exportInfo){
	    	dialog.show(message.get("general.error"), UtilGeneral.getStackTrace(exportInfo.exception), dialog.INFO, null, 800, 600);
		},
		errorHandler: function(message, err) {
			dojo.debug("Error: "+ message);
		}
	});
}

function showLoadingZone() {
    dojo.html.setVisibility(dojo.byId("exportLoadingZone"), "visible");
}

function hideLoadingZone() {
    dojo.html.setVisibility(dojo.byId("exportLoadingZone"), "hidden");
}

function initSysLists() {
	var def = new dojo.Deferred();

	var selectWidgetIDs = ["exportXMLCriteria"]; 
	// Setting the language code to "de". Uncomment the previous block to enable language specific settings depending on the browser language
	var languageCode = UtilCatalog.getCatalogLanguage();

	var lstIds = [];
	dojo.lang.forEach(selectWidgetIDs, function(item){
		lstIds.push(dojo.widget.byId(item).listId);
	});

	CatalogService.getSysLists(lstIds, languageCode, {
		callback: function(res) {
			dojo.lang.forEach(selectWidgetIDs, function(widgetId) {
				var selectWidget = dojo.widget.byId(widgetId);
				selectWidget.dataProvider.setData(res[selectWidget.listId]);	
			});
			def.callback();
		},
		errorHandler:function(mes){
			dialog.show(message.get("general.error"), message.get("init.loadError"), dialog.WARNING);
			dojo.debug("Error: "+mes);
			def.errback(mes);
		}
	});

	return def;
}

</script>
</head>

<body>

	<!-- CONTENT START -->
	<div dojoType="ContentPane" layoutAlign="client">

		<div class="contentBlockWhite top">
			<div id="winNavi">
				<a href="#" title="Hilfe">[?]</a>
			</div>
			<div class="content">
	
				<!-- LEFT HAND SIDE CONTENT START -->
				<div class="spacer"></div>
				<div class="spacer"></div>
				<div class="inputContainer field grey noSpaceBelow">
					<div class="checkboxContainer">
						<span class="entry first"><input type="radio" name="exportType" id="exportType1" class="radio" /><label class="noRightMargin" for="exportType1" onclick="javascript:dialog.showContextHelp(arguments[0], 'Teilexport')"><fmt:message key="dialog.admin.export.partialExport" /></label></span>
						<span class="rightAlign marginRight"><div dojoType="ingrid:Combobox" toggle="plain" listId="1370" style="width:485px;" widgetId="exportXMLCriteria"></div></span>
						<div class="fill"></div>
					</div>
					<div class="checkboxContainer">
						<span class="entry first"><input type="radio" name="exportType" id="exportType2" class="radio" /><label class="noRightMargin" for="exportType2" onclick="javascript:dialog.showContextHelp(arguments[0], 'Teilbaumexport')"><fmt:message key="dialog.admin.export.treeExport" /></label></span>
						<span class="functionalLink marginRight" style="position:relative; top:43px"><img src="img/ic_fl_popup.gif" width="10" height="9" alt="Popup" /><a href="javascript:scriptScope.selectDataset()" title="Teilbaum ausw&auml;hlen [Popup]"><fmt:message key="dialog.admin.export.selectTree" /></a></span>
						<span class="rightAlign marginRight"><input type="text" id="exportTreeName" name="exportTreeName" class="w503" disabled="true" dojoType="ingrid:ValidationTextBox" /></span>
						<span class="rightAlign marginRight"><span class="input w513 leftAlign"><input type="checkbox" name="exportTreeSelectionOnly" id="exportTreeSelectionOnly" dojoType="Checkbox" /><label onclick="javascript:dialog.showContextHelp(arguments[0], 'Nur der ausgew&auml;hlte Datensatz')"><fmt:message key="dialog.admin.export.selectedNodeOnly" /></label></span></span>
						<div class="fill"></div>
					</div>

				</div> <!-- inputContainer end -->
				<div class="inputContainer">
					<span class="button w644" style="height:20px !important;">
						<span style="float:right;">
							<button dojoType="ingrid:Button" title="Export starten" onClick="javascript:scriptScope.startExport();"><fmt:message key="dialog.admin.export.start" /></button>
						</span>
						<span id="exportLoadingZone" style="float:left; margin-top:1px; z-index: 100; visibility:hidden">
							<img src="img/ladekreis.gif" />
						</span>
					</span>
		            <div class="fill"></div>
				</div>

				<div class="inputContainer noSpaceBelow">
					<div id="exportProcessInfo" class="infobox w670">
						<span class="icon"><img src="img/ic_info_download.gif" width="16" height="16" alt="Info" /></span>
						<span id="exportInfoTitle" class="title"></span>
						<div id="exportProcessInfoContent">
							<p id="exportInfoDownload"><fmt:message key="dialog.admin.export.result" /> <a href="javascript:void(0);" onclick="javascript:scriptScope.downloadLastExport();" title="Export-Datei">link</a></p>
							<p id="exportExceptionMessage"><fmt:message key="dialog.admin.export.error" /> <a href="javascript:void(0);" onclick="javascript:scriptScope.showJobException();" title="Fehlerinformationen">link</a></p>
							<table cellspacing="0">
								<tr>
									<td><fmt:message key="dialog.admin.export.startTime" /></td>
									<td id="exportInfoBeginDate"></td></tr>
									<tr><td id="exportInfoEndDateContainer"><fmt:message key="dialog.admin.export.endTime" /></td>
									<td id="exportInfoEndDate"></td></tr>
									<tr><td id="exportInfoNumExportedEntitiesContainer"></td>
									<td id="exportInfoNumExportedEntities"></td></tr>
									<tr><td id="exportProgressBarContainer" colspan=2><div dojoType="ProgressBar" id="exportProgressBar" width="310" height="10" /></td></tr>
							</table>
							<span id="cancelExportProcessButton" class="button" style="height:20px !important;">
								<span style="float:right;">
									<button dojoType="ingrid:Button" title="Prozess abbrechen" onClick="javascript:scriptScope.cancelExport();"><fmt:message key="dialog.admin.export.cancel" /></button>
								</span>
							</span>

						</div> <!-- processInfoContent end -->
					</div> <!-- processInfo end -->
				</div> <!-- inputContainer end -->
				<!-- LEFT HAND SIDE CONTENT END -->
			</div> <!-- content end -->
		</div> <!-- contentBlockWhite end -->
	</div> <!-- ContentPane end -->
<!-- CONTENT END -->

</body>
</html>