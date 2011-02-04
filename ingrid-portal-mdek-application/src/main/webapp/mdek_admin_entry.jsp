<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<!-- Set the locale to the value of parameter 'lang' and init the message bundle messages.properties -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="<%= request.getParameter("lang") == null ? "de" : request.getParameter("lang") %>" scope="session" />
<fmt:setBundle basename="messages" scope="session"/>

<html xmlns="http://www.w3.org/1999/xhtml" lang="de">
<head>
<title><fmt:message key="ui.entry.admin.title" /></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="author" content="wemove digital solutions" />
<meta name="copyright" content="wemove digital solutions GmbH" />

<script type="text/javascript">
    // browser check (only IE7/8, FF2/3)
	var browser = navigator.appName;
	var version = navigator.appVersion;
	if (!(version.indexOf("MSIE 7") != -1 || version.indexOf("MSIE 8") != -1 || (browser=="Netscape" && version.indexOf("5.0") != -1 && version.indexOf("Chrome") == -1))) {
		document.location.href = "not_supported_browser.jsp"
	}
</script>

<script src='/ingrid-portal-mdek-application/js/error_handler.js'></script>

<script src='/ingrid-portal-mdek-application/dwr/interface/AddressService.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/interface/BackendService.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/interface/CatalogService.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/interface/CatalogManagementService.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/interface/ExportService.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/interface/HelpService.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/interface/ImportService.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/interface/ObjectService.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/interface/QueryService.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/interface/SecurityService.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/interface/SNSService.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/interface/TreeService.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/interface/UtilityService.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/interface/VersionInformation.js'></script>

<script src='/ingrid-portal-mdek-application/dwr/engine.js'></script>
<script src='/ingrid-portal-mdek-application/dwr/util.js'> </script>


<script type="text/javascript">
var userLocale = '<%= request.getParameter("lang") == null ? "de" : request.getParameter("lang") %>';
var selenium = '<%= request.getParameter("selenium") == null ? false : true %>';
var isDebug = <%= "true".equals(request.getParameter("debug")) %>;
var djConfig = {locale: userLocale, isDebug: isDebug, /* use with care, may lead to unexpected errors! */debugAtAllCosts: false, debugContainerId: "dojoDebugOutput"};
</script>
<script type="text/javascript" src="dojo-0.4.1-ingrid/dojo.js"></script>
<script type="text/javascript" src="js/config.js"></script>
<script type="text/javascript" src="js/message.js"></script>
<script type="text/javascript" src="js/includes.js"></script>
<script type="text/javascript" src="js/dialog.js"></script>
<script type="text/javascript" src="js/common.js"></script>

<script type="text/javascript" src="js/utilities.js"></script>
<script type="text/javascript" src="js/admin_groups.js"></script>


<script type="text/javascript">

// click handler for main menus
var menus = [{menu:"page1", submenus:["page1" , "page1Sub2", "page1Sub3"]}, 
			 {menu:"page2", submenus:["page2", "page2Sub2", "page2Sub3"]},
			 {menu:"page3", submenus:["page3", "page3Sub2", "page3Sub3", "page3Sub4", "page3Sub5", "page3Sub6", "page3Sub7", "page3Sub8"]},
			 {menu:"page4", submenus:["page4", "page4Sub2"]}
			];
var currentMenu = null;
var currentSubMenu = new Array();

var currentUser = null;
var catalogData = null;


dojo.addOnLoad(function() {
	hideSplash();

	// Initially select 'Nutzerverwaltung - Nutzeradministration'
	clickMenu('page2', 'page2');

	// initiate debug console if necessary
	if (djConfig.isDebug) {
		dojo.debug("The current version of dojo is: ", dojo.version.toString());
		var console = dojo.byId("dojoDebugConsole");
		console.style.visibility = "visible";
	}


	initGeneralEventListeners();

	var def = initCatalogData();
	def.addCallback(initCurrentUser);
	def.addCallback(initPageHeader);
	def.addCallback(initMenu);
	def.addCallback(initSessionKeepalive);
});

function initMenu() {
	// Show menu one, three and four for cat_admin
	if (currentUser.role == 1) {
		dojo.byId("page1Menu").style.display = "";
		dojo.byId("page3Menu").style.display = "";
		dojo.byId("page4Menu").style.display = "";
	}
}


function initPageHeader() {
	// Display the current user and role
	var roleName = UtilSecurity.getRoleName(currentUser.role);
	var title = UtilAddress.createAddressTitle(currentUser.address);
	dojo.byId("currentUserName").innerHTML = title;
	dojo.byId("currentUserRole").innerHTML = roleName;

	// Display the current catalog name
	dojo.byId("currentCatalogName").innerHTML = catalogData.catalogName;
}


function initCatalogData() {
	var deferred = new dojo.Deferred();

	CatalogService.getCatalogData({
		callback: function(res) {
			// Update catalog Data
			catalogData = res;
			deferred.callback();
		},
		errorHandler:function(mes){
			dialog.show(message.get("general.error"), message.get("init.loadError"), dialog.WARNING);
			dojo.debug(mes);
			deferred.errback();
		}
	});

	return deferred;
}


function initCurrentUser() {
	var def = new dojo.Deferred();

	SecurityService.getCurrentUser({
		callback: function(user) {
			currentUser = user;
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

function initGeneralEventListeners() {
	// Disable backspace default behaviour (browser back button)
	if (dojo.render.html.ie) {
		// Registering IE onkeydown with dojo doesn't work as it should
		// Therefore we need to directly register with the documents onkeydown function
		document.onkeydown = function(e) {
			var evt = (e) ? e : window.event; 
			dojo.event.browser.fixEvent(evt);

			if (evt.keyCode == evt.KEY_BACKSPACE) {
				var tagName = evt.target.tagName.toLowerCase();
				if (!(tagName == 'input') && !(tagName == 'textarea')) {
//					dojo.debug("Preventing backspace default behaviour on "+evt.target);
					evt.preventDefault();
				}

			} else if (evt.keyCode == evt.KEY_F5) {			
				dialog.show(message.get("general.hint"), message.get("dialog.browserFunctionDisabled"), dialog.INFO);

			    evt.keyCode = 0;
			    evt.cancelBubble = true;
			    evt.returnValue = false;
			    return false;
			}
		}

	} else {
		dojo.event.browser.addListener(document, "onkeydown", function(evt){
			if (evt.keyCode == evt.KEY_BACKSPACE) {
				if (!(evt.target instanceof HTMLInputElement) && !(evt.target instanceof HTMLTextAreaElement)) {
//					dojo.debug("Preventing backspace default behaviour on "+evt.target);
					evt.preventDefault();
				}

			} else if (evt.keyCode == evt.KEY_F5) {			
				dialog.show(message.get("general.hint"), message.get("dialog.browserFunctionDisabled"), dialog.INFO);
				evt.preventDefault();
			}
		});
	}


	// Catch the window close event
	if(selenium == false || selenium == 'false'){
		window.onbeforeunload = function(evt){
			if (dojo.render.html.ie) {
				// Catch clicks on the upper left and upper right corner. Also catch clicks on the app's 'close' button.
				if ( (event.clientY < 0 && (event.clientX > (document.documentElement.clientWidth - 15) || event.clientX < 15))
				   ||(event.clientY < 23 && event.clientX > document.documentElement.clientWidth - 172 && event.clientX < document.documentElement.clientWidth - 9) ) {
			  		event.returnValue = message.get("general.closeWindow");
				}
	
			} else {
				return message.get("general.closeWindow");
			}
		}
	}
}

//Init session keepalive
function initSessionKeepalive() {
	var def = UtilCatalog.getSessionRefreshIntervalDef();

	def.addCallback(function(sessionRefreshInterval) {
		if (sessionRefreshInterval > 0) {
			var interval = sessionRefreshInterval * 60 * 1000;
			setInterval("UtilGeneral.refreshSession();", interval);
		}
	});
}


function clickMenu(menuName, submenuName) {
	// Activate the menu by removing the following lines
	// --- DEACTIVATE BEGIN ---
//	dojo.debug("Main menu is deactivated. Activate it by uncommenting the corresponding lines in mdek_entry.jsp - function clickMenu()");
//	return;
	// --- DEACTIVATE END ---

	for(var i=0; i<menus.length; i++) {
		var menu = menus[i].menu;
		var submenus = menus[i].submenus;
		if (menu != menuName) {
			dojo.widget.byId(menu).hide();
			dojo.html.removeClass(dojo.byId(menu+"Menu"), "current");
			dojo.byId(menu+"Subnavi").style.display="none";
			for (var j=0; j<submenus.length; j++) {
				dojo.widget.byId(submenus[j]).hide();
			}
		} else {
			dojo.widget.byId(menu).show();
			dojo.html.addClass(dojo.byId(menu+"Menu"), "current");
			dojo.byId(menu+"Subnavi").style.display="block";
			
			if (!submenuName)  {
				submenuName = currentSubMenu[menu];
			}
			for (var j=0; j<submenus.length; j++) {
				if (!submenuName)  {
					submenuName = submenus[j];
				}
				if (submenus[j] != submenuName) {
					dojo.widget.byId(submenus[j]).hide();
					dojo.html.removeClass(dojo.byId(menu+"Subnavi"+(j+1)), "current");
				} else {
					dojo.widget.byId(submenus[j]).show();
					dojo.html.addClass(dojo.byId(menu+"Subnavi"+(j+1)), "current");
					currentSubMenu[menu] = submenus[j];
				}
			}
		}
	}
}

switchLanguage = function() {
	document.location.href="mdek_admin_entry.jsp?lang="+UtilLanguage.getNextLanguage();
}

function hideSplash(){
	dojo.byId("splash").style.display="none";
	dojo.byId("layout").style.top="0px";
}


</script>

<link rel="StyleSheet" href="css/main.css" type="text/css" />
<link rel="StyleSheet" href="css/admin.css" type="text/css" />

<style type="text/css">
	@import url(css/scrolling_table.css);
</style>

</head>

<body>

<div id="splash" style="position: absolute; top: 0px; width: 100%;z-index: 100; height:2000px;background-color:#FFFFFF">
<div style="position: relative; width: 100%;z-index: 100;top:200px">
   <div align="center" style="line-height:16px">
        <div style="width:550px; height:20px; background-color:#156496">&nbsp;</div>
        <div style="width:550px; background-color:#e6f0f5; font-family:Verdana,Helvetica,Arial,sans-serif; font-size:12px; padding: 20px 0px 20px 0px; margin:0px">
          <p style="font-size:24px; font-weight:bold; line-height:16px; margin:16px"><script>document.write(message.get("ui.entry.admin.title"))</script></p>
<!--           <p style="font-size:16px; font-weight:bold; line-height:16px; margin:16px">Version 1.0.0</p>  -->
          <p style="font-size:12px; font-weight:normal; line-height:16px; margin:16px"><script>document.write(message.get("ui.entry.loadingMessage"))</script></p>
        </div>
   </div>
</div>
</div>


<div id="blockInputDiv" style="position: absolute; top: 0px; left: 0px; width: 100%; height:100%; z-index: 99; visibility:hidden"></div> 


<div dojoType="LayoutContainer" id="layout" class="layout" layoutChildPriority="top-bottom">

  <div dojoType="FloatingPane" title="Dojo Debug Console" constrainToContainer="true" resizable="true" id="dojoDebugConsole"
    displayMinimizeAction="false" displayMaximizeAction="true" displayCloseAction="true"	style="width:300px; height:500px; left:1000px; top:0; visibility:hidden;">
    <div dojoType="ContentPane" id="dojoDebugOutput"></div>
  </div>

  <!-- NAVIGATION START -->
	<div dojoType="ContentPane" id="headSection" layoutAlign="top">
  	<div dojoType="ContentPane" style="height:70px; background-image:url(img/head_bg.gif);">
  	  <div id="logo"><img src="img/logo.gif" width="119" height="24" alt="PortalU" /></div>
  	  <div id="title"><img src="img/title_erfassung.gif" width="158" height="24" alt="Metadatenerfassung" /></div>
  	  <div id="metaNavi">
  	    <ul>
  	      <li><span id="currentUserName">Benutzername</span> · <span id="currentUserRole">Rollenbezeichnung</span> · <span id="currentCatalogName">Katalogname</span></li>
  	      <li class="seperator">|</li>
  	      <li><a href="javascript:void(0);" onclick="javascript:window.open('mdek_help.jsp', 'Hilfe', 'width=750,height=550,resizable=yes,scrollbars=yes,locationbar=no');" title="<fmt:message key="general.help" />"><script>document.write(message.get("menu.general.help"))</script></a></li>
  	      <li class="seperator">|</li>
  	      <li><a href="javascript:void(0);" onclick="javascript:window.open('http://www.portalu.de:80/ingrid-portal/portal/disclaimer.psml', 'impressum', 'width=966,height=994,resizable=yes,scrollbars=yes,locationbar=no');" title="<fmt:message key="general.imprint" />"><script>document.write(message.get("menu.general.disclaimer"))</script></a></li>
  	      <li class="seperator">|</li>
  	      <li><a href="javascript:void(0);" onclick="javascript:switchLanguage();"><script>document.write(UtilLanguage.getNextLanguageName())</script></a></li>
  	      <li class="seperator">|</li>
  	      <li><a href="javascript:void(0);" onclick="javascript:dialog.showPage('Info', 'mdek_info_dialog.html', 365, 210, false); return false;" title="Info"><script>document.write(message.get("menu.general.info"))</script></a></li>
  	      <li class="seperator">|</li>
  	      <li><a href="#dummyAnchor" onClick="window.location.href='closeWindow.jsp';" title="<fmt:message key="dialog.links.close" />"><strong><script>document.write(message.get("menu.general.closeApplication"))</script></strong></a></li>
  	    </ul>
  	  </div>
  	  <div id="navi">
  	    <ul>
  	      <li><a id="page1Menu" style="display:none;" onClick="clickMenu('page1')" href="javascript:void(0);" class="current" title="<fmt:message key="menu.admin.main.catalog" />"><script>document.write(message.get("menu.admin.main.catalog"))</script></a></li>
  	      <li><a id="page2Menu" onClick="clickMenu('page2')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.user.admin.user" />"><script>document.write(message.get("menu.admin.main.user"))</script></a></li>
  	      <li><a id="page3Menu" style="display:none;" onClick="clickMenu('page3')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.management" />"><script>document.write(message.get("menu.admin.main.management"))</script></a></li>
  	      <li><a id="page4Menu" style="display:none;" onClick="clickMenu('page4')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.importexport" />"><script>document.write(message.get("menu.admin.main.importExport"))</script></a></li>
  	    </ul>
  	  </div>
  	  
	  <div id="page1Subnavi" class="subnavi" style="display:none">
  	    <ul>
  	      <li><a id="page1Subnavi1" onClick="clickMenu('page1', 'page1')" href="javascript:void(0);" class="current" title="<fmt:message key="menu.admin.main.catalog.settings" />"><script>document.write(message.get("menu.admin.main.catalog.settings"))</script></a></li>
  	      <li><a id="page1Subnavi2" onClick="clickMenu('page1', 'page1Sub2')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.catalog.settings.field" />"><script>document.write(message.get("menu.admin.main.catalog.fieldSettings"))</script></a></li>
  	      <li><a id="page1Subnavi3" onClick="clickMenu('page1', 'page1Sub3')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.catalog.settings.general" />"><script>document.write(message.get("menu.admin.main.catalog.generalSettings"))</script></a></li>
  	    </ul>	  
	  </div>
	  <div id="page2Subnavi" class="subnavi" style="display:none">
  	    <ul>
  	      <li><a id="page2Subnavi1" onClick="clickMenu('page2', 'page2')" href="javascript:void(0);" class="current" title="<fmt:message key="menu.admin.main.user.admin.user" />"><script>document.write(message.get("menu.admin.main.user.userAdmin"))</script></a></li>
  	      <li><a id="page2Subnavi2" onClick="clickMenu('page2', 'page2Sub2')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.user.admin.group" />"><script>document.write(message.get("menu.admin.main.user.groupAdmin"))</script></a></li>
  	      <li><a id="page2Subnavi3" onClick="clickMenu('page2', 'page2Sub3')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.user.permissions" />"><script>document.write(message.get("menu.admin.main.user.permissions"))</script></a></li>
  	    </ul>
  	  </div>
	  <div id="page3Subnavi" class="subnavi" style="display:none">
  	    <ul>
  	      <li><a id="page3Subnavi1" onClick="clickMenu('page3', 'page3')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.management.analysis" />"><script>document.write(message.get("menu.admin.main.management.analysis"))</script></a></li>	  
  	      <li><a id="page3Subnavi2" onClick="clickMenu('page3', 'page3Sub2')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.management.duplicates" />"><script>document.write(message.get("menu.admin.main.management.duplicates"))</script></a></li>	  
  	      <li><a id="page3Subnavi3" onClick="clickMenu('page3', 'page3Sub3')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.management.urls" />"><script>document.write(message.get("menu.admin.main.management.urls"))</script></a></li>	  
  	      <li><a id="page3Subnavi4" onClick="clickMenu('page3', 'page3Sub4')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.management.codelists" />"><script>document.write(message.get("menu.admin.main.management.codelists"))</script></a></li>	  
  	      <li><a id="page3Subnavi5" onClick="clickMenu('page3', 'page3Sub5')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.management.additionalfields" />"><script>document.write(message.get("menu.admin.main.management.additionalFields"))</script></a></li>	  
  	      <li><a id="page3Subnavi6" onClick="clickMenu('page3', 'page3Sub6')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.management.deleteadress" />"><script>document.write(message.get("menu.admin.main.management.deleteAddress"))</script></a></li>	  
  	      <li><a id="page3Subnavi7" onClick="clickMenu('page3', 'page3Sub7')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.management.searchterms" />"><script>document.write(message.get("menu.admin.main.management.searchTerms"))</script></a></li>	  
  	      <li><a id="page3Subnavi8" onClick="clickMenu('page3', 'page3Sub8')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.management.searchterms.spatial" />"><script>document.write(message.get("menu.admin.main.management.spatialSearchTerms"))</script></a></li>	  
  	    </ul>
	  </div>
	  <div id="page4Subnavi" class="subnavi" style="display:none">
  	    <ul>
   	      <li><a id="page4Subnavi1" onClick="clickMenu('page4', 'page4')" href="javascript:void(0);" class="current" title="<fmt:message key="menu.admin.main.importexport.export" />"><script>document.write(message.get("menu.admin.main.importExport.export"))</script></a></li>
  	      <li><a id="page4Subnavi2" onClick="clickMenu('page4', 'page4Sub2')" href="javascript:void(0);" title="<fmt:message key="menu.admin.main.importexport.import" />"><script>document.write(message.get("menu.admin.main.importExport.import"))</script></a></li>
  	    </ul>
  	  </div>
    </div>
  
  </div>
  <!-- NAVIGATION END -->
  
  <div widgetId="page1" dojoType="ContentPane" layoutAlign="client" href="mdek_admin_catalog_settings.jsp" preload="false" executeScripts="true"></div>
  <div widgetId="page1Sub2" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_catalog_field_settings.jsp" preload="false" executeScripts="true"></div>
  <div widgetId="page1Sub3" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_general_settings.jsp" preload="false" executeScripts="true"></div>
  <div widgetId="page2" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_user_administration.jsp" preload="false" refreshOnShow="true" executeScripts="true"></div>
  <div widgetId="page2Sub2" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_group_administration.jsp" preload="false" executeScripts="true"></div>
  <div widgetId="page2Sub3" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_permission_overview.jsp" preload="false" executeScripts="true"></div>

  <div widgetId="page3" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_catman_analysis.jsp" preload="false" executeScripts="true"></div>
  <div widgetId="page3Sub2" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_catman_duplicates.jsp" preload="false" executeScripts="true"></div>
  <div widgetId="page3Sub3" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_catman_urls.jsp" preload="false" executeScripts="true"></div>
  <div widgetId="page3Sub4" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_catman_codelists.jsp" preload="false" executeScripts="true"></div>
  <div widgetId="page3Sub5" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_catman_additional_fields.jsp" preload="false" executeScripts="true"></div>
  <div widgetId="page3Sub6" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_catman_delete_address.jsp" preload="false" executeScripts="true"></div>
  <div widgetId="page3Sub7" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_catman_search_terms.jsp" preload="false" executeScripts="true"></div>
  <div widgetId="page3Sub8" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_catman_locations.jsp" preload="false" executeScripts="true"></div>

  <div widgetId="page4" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_export.jsp" preload="false" executeScripts="true"></div>
  <div widgetId="page4Sub2" dojoType="ContentPane" layoutAlign="client" style="display:none" href="mdek_admin_import.jsp" preload="false" executeScripts="true"></div>

</div>

</body>
</html>
