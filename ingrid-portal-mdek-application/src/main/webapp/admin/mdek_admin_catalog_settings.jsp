<%--
  **************************************************-
  Ingrid Portal MDEK Application
  ==================================================
  Copyright (C) 2014 - 2015 wemove digital solutions GmbH
  ==================================================
  Licensed under the EUPL, Version 1.1 or – as soon they will be
  approved by the European Commission - subsequent versions of the
  EUPL (the "Licence");
  
  You may not use this work except in compliance with the Licence.
  You may obtain a copy of the Licence at:
  
  http://ec.europa.eu/idabc/eupl5
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the Licence is distributed on an "AS IS" basis,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the Licence for the specific language governing permissions and
  limitations under the Licence.
  **************************************************#
  --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html xmlns="http://www.w3.org/1999/xhtml" lang="de">
    <head>
        <script type="text/javascript">
        
        var pageCatSettings = _container_;
            
        require([
            "dojo/_base/array",
            "dojo/_base/lang",
            "dojo/Deferred",
            "dijit/registry",
            "dijit/form/Select",
            "dijit/form/CheckBox",
            "dijit/form/NumberTextBox",
            "dojo/on",
            "ingrid/layoutCreator",
            "ingrid/dialog",
            "ingrid/init",
            "ingrid/utils/Syslist",
            "ingrid/utils/List",
            "ingrid/utils/Catalog"
        ], function(array, lang, Deferred, registry, Select, CheckBox, NumberTextBox, on, layoutCreator, dialog, init, UtilSyslist, UtilList, UtilCatalog) {
            
            console.log("catalog settings");
        
            // extend the typical widget to accept listIds for syslists
            // deprecated! used a different way now ... or?
            //dojo.extend(dijit._Widget, { listId:"0" });
            
            
            // Storage for the current catalog. We need to get the uuid from somewhere
            pageCatSettings.currentCatalogData = null;
            
            on(_container_, "Load", function() {
                try {
                    // create select boxes for syslists
                    var storeProps = { data: { identifier: '1', label: '0' } };
                    layoutCreator.createSelectBox("adminCatalogCountry", null, storeProps, function() {
                        return UtilSyslist.getSyslistEntry(6200);
                    });
                    layoutCreator.createSelectBox("adminCatalogLanguage", null, storeProps,  function() {
                        return UtilSyslist.getSyslistEntry(99999999);
                    });

                    console.debug("update fields");
                    if (UtilCatalog.catalogData !== null) {
                        updateInputFields(UtilCatalog.catalogData);
                        pageCatSettings.currentCatalogData = UtilCatalog.catalogData;
                    }
                    else {
                        reloadCatalogData();
                    }
                        
                    var checkbox = registry.byId("adminCatalogExpire");
                    var inputField = registry.byId("adminCatalogExpiryDuration");
                    
                    on(checkbox, "click", function(){ //!!!connectOnce
                        checkbox.checked ? inputField.set('disabled', false) : inputField.set('disabled', true);
                    });
                    
                } catch (err) {
                    console.error("error in init", err);
                }
                
            });
            
            function updateInputFields(catalogData) {
                registry.byId("adminCatalogName").set("value", catalogData.catalogName);
                registry.byId("adminCatalogNamespace").set("value", catalogData.catalogNamespace);
                registry.byId("adminCatalogPartnerName").set("value", catalogData.partnerName);
                registry.byId("adminCatalogProviderName").set("value", catalogData.providerName);
                registry.byId("adminCatalogCountry").set("value", catalogData.countryCode);
                registry.byId("adminCatalogLanguage").set("value", catalogData.languageCode);
                registry.byId("adminCatalogSpatialRef").set("value", catalogData.location.name);
                registry.byId("adminCatalogSpatialRef").location = catalogData.location;
                registry.byId("adminCatalogAtomDownload").set("value", catalogData.atomUrl);
                if (catalogData.workflowControl == "Y") {
                    registry.byId("adminCatalogWorkflowControl").set("value", true);
                }
                else {
                    registry.byId("adminCatalogWorkflowControl").set("value", false);
                }
                if (catalogData.expiryDuration !== null && catalogData.expiryDuration > 0) {
                    registry.byId("adminCatalogExpire").set("value", true);
                    registry.byId("adminCatalogExpiryDuration").set('disabled', false);
                    registry.byId("adminCatalogExpiryDuration").set("value", catalogData.expiryDuration);
                }
                else {
                    registry.byId("adminCatalogExpire").set("value", false);
                    registry.byId("adminCatalogExpiryDuration").set("value", "0");
                    registry.byId("adminCatalogExpiryDuration").set('disabled', true);
                }
                if (catalogData.sortByClass === "Y") {
                    registry.byId("adminCatalogSortByClass").set("value", true);
                } else {
                    registry.byId("adminCatalogSortByClass").set("value", false);
                }
            }
            
            function reloadCatalogData() {
                CatalogService.getCatalogData({
                    callback: function(res){
                        // Update catalog Data
                        updateInputFields(res);
                        pageCatSettings.currentCatalogData = res;
                        UtilCatalog.catalogData = res;
                    },
                    errorHandler: function(mes){
                        dialog.show("<fmt:message key='general.error' />", "<fmt:message key='dialog.loadCatalogError' />", dialog.WARNING);
                        console.error(mes);
                    }
                });
            }
            
            function saveCatalogData() {
                var newCatalogData = {};
                newCatalogData.uuid = pageCatSettings.currentCatalogData.uuid;
                newCatalogData.catalogName = registry.byId("adminCatalogName").get("value");
                newCatalogData.catalogNamespace = registry.byId("adminCatalogNamespace").get("value");
                newCatalogData.partnerName = registry.byId("adminCatalogPartnerName").get("value");
                newCatalogData.providerName = registry.byId("adminCatalogProviderName").get("value");
                newCatalogData.countryCode = registry.byId("adminCatalogCountry").get("value");
                newCatalogData.languageCode = registry.byId("adminCatalogLanguage").get("value");
                newCatalogData.location = registry.byId("adminCatalogSpatialRef").location;
                newCatalogData.atomUrl = registry.byId("adminCatalogAtomDownload").get("value");
                // add a slash at the end
                if (dojo.lastIndexOf(newCatalogData.atomUrl, "/") != newCatalogData.atomUrl.length-1) newCatalogData.atomUrl += "/";
                newCatalogData.expiryDuration = (registry.byId("adminCatalogExpire").checked ? registry.byId("adminCatalogExpiryDuration").get("value") : "0");
                newCatalogData.workflowControl = registry.byId("adminCatalogWorkflowControl").checked ? "Y" : "N";
                newCatalogData.sortByClass = registry.byId("adminCatalogSortByClass").checked ? "Y" : "N";
                console.debug("validating");
                if (!isValidCatalog(newCatalogData)) {
                    dialog.show("<fmt:message key='general.error' />", "<fmt:message key='dialog.admin.catalog.requiredFieldsHint' />", dialog.WARNING);
                    return;
                }
                console.debug("storing");
                CatalogService.storeCatalogData(newCatalogData, {
                    callback: function(res){
                        // Update catalog Data
                        updateInputFields(res);
                        UtilCatalog.catalogData = res;
                        pageCatSettings.currentCatalogData = res;
                        // init.initPageHeader();
                        init.initCatalogData();
                        dialog.show("<fmt:message key='general.hint' />", "<fmt:message key='dialog.admin.catalog.saveSuccess' />", dialog.INFO);
                        
                    },
                    errorHandler: function(errMsg) {
                        if (errMsg.indexOf("USER_HAS_NO_PERMISSION_ON_ENTITY") != -1) {
                            dialog.show("<fmt:message key='general.error' />", "<fmt:message key='dialog.admin.catalog.permissionError' />", dialog.WARNING);
                            
                        }
                        else {
                            dialog.show("<fmt:message key='general.error' />", "<fmt:message key='dialog.storeCatalogError' />", dialog.WARNING);
                        }
                        
                        console.error(errMsg);
                    }
                });
            }
            
            function selectSpatialReference() {
                var def = new Deferred();
                dialog.showPage("<fmt:message key='dialog.admin.catalog.selectLocation.title' />", "admin/dialogs/mdek_admin_catalog_spatial_reference_dialog.jsp", 530, 230, true, {
                    resultHandler: def
                });
                
                def.then(function(result){
                    var spatialRefWidget = registry.byId("adminCatalogSpatialRef");
                    UtilList.addSNSLocationLabels([result]);
                    spatialRefWidget.set("value", result.label);
                    spatialRefWidget.location = result;
                });
            }
            
            function isValidCatalog(cat) {
                if(cat.location.name) // can be undefined now
                    return (lang.trim(cat.countryCode).length !== 0 &&
                    lang.trim(cat.languageCode).length !== 0 &&
                    lang.trim(cat.location.name).length !== 0 &&
                    lang.trim(cat.catalogNamespace).length !== 0/* &&
                    dojo.validate.isInteger(cat.expiryDuration) &&
                    dojo.validate.isInRange(cat.expiryDuration, {
                        min: 0,
                        max: 2147483647
                    })*/);
                else
                    return false;
            }

            /*
             *  PUBLIC METHODS
             */
            pageCatSettings = {
                selectSpatialReference: selectSpatialReference,
                saveCatalogData: saveCatalogData,
                reloadCatalogData: reloadCatalogData
            };
        
        });
            
        </script>
    </head>
    <body>
        <!-- CONTENT START -->
        <!--<div data-dojo-type="dijit/layout/ContentPane" layoutAlign="client">-->
            <div id="contentSection" class="contentBlockWhite">
                <div id="adminCatalog" class="content">
                    <!-- LEFT HAND SIDE CONTENT START -->
                    <div class="inputContainer field grey noSpaceBelow">
                        <div id="winNavi" style="top:0;">
                            <a href="javascript:void(0);" onclick="window.open('mdek_help.jsp?lang='+userLocale+'&hkey=catalog-administration-1#catalog-administration-1', 'Hilfe', 'width=750,height=550,resizable=yes,scrollbars=yes,locationbar=no')" title="<fmt:message key="general.help" />">[?]</a>
                        </div>
                        <span class="outer"><div>
                        <span class="label">
                            <label for="adminCatalogName" onclick="require('ingrid/dialog').showContextHelp(arguments[0], 8001)">
                                <fmt:message key="dialog.admin.catalog.catalogName" />
                            </label>
                        </span>
                        <span class="input"><input type="text" id="adminCatalogName" style="width:100%;" data-dojo-type="dijit/form/ValidationTextBox" /></span>
                        </div></span>
                        <span class="outer"><div>
                        <span class="label">
                            <label for="adminCatalogNamespace" onclick="require('ingrid/dialog').showContextHelp(arguments[0], 8100)">
                                <fmt:message key="dialog.admin.catalog.catalogNamespace" />*
                            </label>
                        </span>
                        <span class="input"><input type="text" id="adminCatalogNamespace" style="width:100%;" required="true" tooltipPosition="below" data-dojo-type="dijit/form/ValidationTextBox" /></span>
                        </div></span>
                        <span class="outer"><div>
                            <span class="label">
                            <label for="adminCatalogPartnerName" onclick="require('ingrid/dialog').showContextHelp(arguments[0], 8002)">
                                <fmt:message key="dialog.admin.catalog.partnerName" />
                            </label>
                        </span>
                        <span class="input"><input type="text" id="adminCatalogPartnerName" style="width:100%;" data-dojo-type="dijit/form/ValidationTextBox" />
                        </span>
                        </div></span>
                        <span class="outer"><div>
                            <span class="label">
                            <label for="adminCatalogProviderName" onclick="require('ingrid/dialog').showContextHelp(arguments[0], 8003)">
                                <fmt:message key="dialog.admin.catalog.providerName" />
                            </label>
                        </span>
                        <span class="input"><input type="text" id="adminCatalogProviderName" style="width:100%;" data-dojo-type="dijit/form/ValidationTextBox" /></span>
                        </div></span>
                        <span class="outer"><div>
                            <span class="label required">
                            <label for="adminCatalogCountry" onclick="require('ingrid/dialog').showContextHelp(arguments[0], 8004)">
                                <fmt:message key="dialog.admin.catalog.state" />*
                            </label>
                        </span>
                        <span class="input">
                            <div id="adminCatalogCountry" listId="6200" required="true" style="width:100%;" maxHeight="150"></div>
                            <!--<div data-dojo-type="dojo.data.ItemFileWriteStore" jsId="storeCountry" data="countryData"></div>
                            <input class="spaceBelow" data-dojo-type="dijit/form/Select" store="storeCountry" required="true" style="width:100%;" maxHeight="150" listId="6200" id="adminCatalogCountry" />-->
                        </span>
                        </div></span>
                        <span class="outer"><div>
                            <span class="label required">
                            <label for="adminCatalogLanguage" onclick="require('ingrid/dialog').showContextHelp(arguments[0], 8005)">
                                <fmt:message key="dialog.admin.catalog.language" />*
                            </label>
                        </span>
                        <span class="input">
                            <div id="adminCatalogLanguage" listId="99999999" required="true" style="width:100%;" maxHeight="150" disabled="true"></div>
                            <!--<div data-dojo-type="dojo.data.ItemFileWriteStore" jsId="storeLanguage" data="langData"></div>
                            <input class="spaceBelow" data-dojo-type="dijit/form/Select" store="storeLanguage" required="true" style="width:100%;" maxHeight="150" disabled="true" listId="99999999" id="adminCatalogLanguage" />-->
                        </span>
                        </div></span>
                        <span class="outer"><div>
                            <span class="label required left">
                            <label for="adminCatalogSpatialRef" onclick="require('ingrid/dialog').showContextHelp(arguments[0], 8006)">
                                <fmt:message key="dialog.admin.catalog.location" />*
                            </label>
                        </span>
                        <span class="functionalLink marginRight">
                            <img src="img/ic_fl_popup.gif" width="10" height="9" alt="Popup" />
                            <a href="javascript:void(0);" onclick="pageCatSettings.selectSpatialReference();" title="<fmt:message key="dialog.admin.catalog.locationLink" /> [Popup]"><fmt:message key="dialog.admin.catalog.locationLink" /></a>
                        </span>
                        <span class="input">
                            <input type="text" required="true" id="adminCatalogSpatialRef" style="width:100%;" disabled="true" data-dojo-type="dijit/form/ValidationTextBox" />
                        </span>
                        </div></span>
                        <span class="outer">
                            <div>
                                <span class="label left">
                                    <label for="adminCatalogSpatialRef" onclick="require('ingrid/dialog').showContextHelp(arguments[0], 8091)">
                                        <fmt:message key="dialog.admin.catalog.atomDownloadService" />
                                    </label>
                                </span>
                                <span class="input">
                                    <input type="text" required="false" id="adminCatalogAtomDownload" style="width:100%;" data-dojo-type="dijit/form/ValidationTextBox" />
                                </span>
                            </div>
                        </span>
                        <span class="outer "><div>
                        <div class="checkboxContainer">
                            <span class="input">
                                <input type="checkbox" id="adminCatalogWorkflowControl" data-dojo-type="dijit/form/CheckBox" />
                                <label for="adminCatalogWorkflowControl" class="inActive">
                                    <fmt:message key="dialog.admin.catalog.activateWorkflowControl" />
                                </label>
                            </span>
                            <span class="input">
                                <input type="checkbox" id="adminCatalogExpire" data-dojo-type="dijit/form/CheckBox" />
                                <label class="inActive">
                                    <fmt:message key="dialog.admin.catalog.expireAfter" />
                                    <input id="adminCatalogExpiryDuration" style="width:33px !important; height: 16px;" min="1" max="2147483647" maxlength="10" data-dojo-type="dijit/form/NumberTextBox" />
                                    <fmt:message key="dialog.admin.catalog.days" />
                                </label>
                            </span>
                            <span class="input">
                                <input type="checkbox" id="adminCatalogSortByClass" data-dojo-type="dijit/form/CheckBox" />
                                <label class="inActive">
                                    <fmt:message key="dialog.admin.catalog.sortByClass" />
                                </label>
                            </span>
                        </div>
                        </div></span>
                        <div class="fill"></div>
                    </div>
                    <!--
                    <div class="inputContainer">
                    <span class="button w644"><a href="#" class="buttonBlue" title="<fmt:message key="dialog.admin.catalog.save" />"><fmt:message key="dialog.admin.catalog.save" /></a><a href="#" class="buttonBlue" title="<fmt:message key="dialog.wizard.create.cancel" />"><fmt:message key="dialog.wizard.create.cancel" /></a></span>
                    </div>
                    -->
                    <div class="inputContainer">
                        <span class="button"><span style="float:right;">
                                <button id="adminCS_save" data-dojo-type="dijit/form/Button" title="<fmt:message key="dialog.admin.catalog.save" />" onclick="pageCatSettings.saveCatalogData()" >
                                    <fmt:message key="dialog.admin.catalog.save" />
                                </button>
                            </span><span style="float:right;">
                                <button id="adminCS_reset" data-dojo-type="dijit/form/Button" title="<fmt:message key="dialog.admin.catalog.reset" />" onclick="pageCatSettings.reloadCatalogData()" >
                                    <fmt:message key="dialog.admin.catalog.reset" />
                                </button>
                            </span><span id="adminCatalogLoadingZone" style="float:left; margin-top:1px; z-index: 100; visibility:hidden"><img src="img/ladekreis.gif" /></span></span>
                    </div><!-- LEFT HAND SIDE CONTENT END -->
                </div>
            </div>
        <!--</div>--><!-- CONTENT END -->
    </body>
</html>
