<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html dir="ltr">

<head>
<title>InGrid Editor</title>
<link rel="shortcut icon" href="../img/iconLogo.gif" type="image/x-icon">
<link rel="stylesheet" href="../css/slick.grid.css" type="text/css" media="screen" charset="utf-8" />

<script type="text/javascript">
            var userLocale = 'de';
</script>

<link rel="stylesheet" href="../css/styles.css" />
<link rel="stylesheet" href="../css/imageReferences.css" />
<script type="text/javascript" src="../dojo-src/dojo/dojo.js" djConfig="parseOnLoad:false, locale:userLocale"></script>
<script type="text/javascript" src="../dojo-src/custom/layer.js"></script>
<script type="text/javascript">
    var isRelease = false;
</script>


<script type='text/javascript' src='../dwr/engine.js'></script>
<script type='text/javascript' src='../dwr/util.js'></script>

<script src='../dwr/interface/CatalogService.js'></script>
<script src='../dwr/interface/TreeService.js'></script>
<script src='../dwr/interface/ObjectService.js'></script>
<script src='../dwr/interface/AddressService.js'></script>
<script src='../dwr/interface/SecurityService.js'></script>
<script src='../dwr/interface/SNSService.js'></script>
<script src='../dwr/interface/QueryService.js'></script>
<script src='../dwr/interface/HelpService.js'></script>
<script src='../dwr/interface/CTService.js'></script>
<script src='../dwr/interface/HttpService.js'></script>
<script src='../dwr/interface/GetCapabilitiesService.js'></script>
<script src='../dwr/interface/ImportService.js'></script>
<script src='../dwr/interface/ExportService.js'></script>
<script src='../dwr/interface/CatalogManagementService.js'></script>
<script src='../dwr/interface/UtilityService.js'></script>

<script type="text/javascript" src="../js/config.js"></script>
<script type="text/javascript" src="../js/message.js"></script>
<script type="text/javascript" src="../js/utilities.js"></script>
<script type="text/javascript" src="../js/dialog.js"></script>
<script type="text/javascript" src="../js/error_handler.js"></script>
<script type="text/javascript" src="../js/menuEventHandler.js"></script>
<script type="text/javascript" src="../js/eventSubscriber.js"></script>


<script type="text/javascript" src="../js/layoutCreator.js"></script>
<script type="text/javascript" src="../js/debugFunctions.js"></script>
<script type="text/javascript" src="../js/menu.js"></script>
<script type="text/javascript" src="../js/toolbar.js"></script>

<script type="text/javascript" src="../js/dojo/dijit/CustomGrid.js"></script>
<script type="text/javascript" src="../js/dojo/dijit/CustomTree.js"></script>

<script type="text/javascript" src="../js/rules_required.js"></script>
<script type="text/javascript" src="../js/rules_validation.js"></script>
<script type="text/javascript" src="../js/rules_checker.js"></script>

<script type="text/javascript" src="../js/tree.js"></script>

<script type="text/javascript" src="../js/dojo/dijit/CustomGridRowMover.js"></script>
<script type="text/javascript" src="../js/dojo/dijit/CustomGridRowSelector.js"></script>
<script type="text/javascript" src="../js/dojo/dijit/CustomGridEditors.js"></script>
<script type="text/javascript" src="../js/dojo/dijit/CustomGridFormatters.js"></script>


<script type="text/javascript">
dojo.require("ingrid.dijit.tree.LazyTreeStoreModel");
dojo.require("dijit.layout.TabContainer");

scrollBarWidth = 17;

dojo.addOnLoad(function() {
    // create BorderContainer (Splitpane)
    var main = new dijit.layout.BorderContainer({ 
        design: "headline",
        gutters: false,
        toggleSplitterClosedThreshold: "100px",
        toggleSplitterOpenSize: "80px",
        style: "width:100%; heigth: 100%;",
        liveSplitters: false }, "contentContainer");
    var contentPane = new dojox.layout.ContentPane({
        id: "contentPane",
        //splitter: true,
        region: "center",
        style: "padding: 10px;"
        }).placeAt(main.domNode);
    
    dojo.require("dijit.layout.StackContainer");
    
    // top pane - menu 
    var topMenuPane = new dijit.layout.ContentPane({
        id: "menubarPane",
        splitter: false,
        region: "top",
        style: "height: 32px;"
        }, "menuContainer");
    
    var menu = new dijit.MenuBar({}).placeAt(topMenuPane.domNode);
    menu.addChild(new dijit.MenuBarItem({
        label: "Tables",
        onClick: function(){
            dijit.byId("stackContainer").selectChild(dijit.byId("pageTable"));
        }
    }));
    menu.addChild(new dijit.MenuBarItem({
        label: "Dialogs",
        onClick: function(){
            dijit.byId("stackContainer").selectChild(dijit.byId("pageDialogTest"));
        }
    }));

    sc = new dijit.layout.StackContainer({
        style: "width: 100%;",
        id: "stackContainer"
    }).placeAt(dijit.byId("contentPane").domNode);
    
    var tableTests = new dojox.layout.ContentPane({
        id: "pageTable",
        title: "tables",
        layoutAlign: "client",
        href: "CustomGridTest.jsp?c="+userLocale,
        scriptHasHooks: true,
        executeScripts: true
    });

    var dialogTests = new dojox.layout.ContentPane({
        id: "pageDialogTest",
        layoutAlign: "client",
        href: "DialogTest.jsp?c="+userLocale,
        scriptHasHooks: true,
        executeScripts: true
    });
    
    sc.addChild(tableTests);
    sc.addChild(dialogTests);
    sc.startup();

    main.startup();
    
    sc.selectChild(dijit.byId("pageDialogTest"));
});
</script>
</head>
<body class="claro">
    <div id="contentContainer" class="contentSection">
        <div id="menuContainer"></div>
    </div>

</body>
</html>
