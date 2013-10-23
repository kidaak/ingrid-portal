// ========================================================================================================================
// Defaultwerte bei neuem Objekt der Objektklasse "Geodatensatz" (REDMINE-119)
// ========================================================================================================================
// ------------------------
// JS
// ------------------------
// default values when creating new objects of class 1 - geodata (REDMINE-119)
dojo.subscribe("/onObjectClassChange", function(data) { 
    if (currentUdk.uuid === "newNode" && data.objClass === "Class1") { 
        dijit.byId("ref1BasisText").set("value", "keine Angabe");
        dijit.byId("ref1DataSet").set("value", "5"); // "Datensatz"
        UtilGrid.setTableData("thesaurusInspire", [{title: 99999}]); // "Kein INSPIRE-Thema"
        UtilGrid.setTableData("extraInfoConformityTable", [{specification:"INSPIRE-Richtlinie", level:3}]); // "nicht evaluiert"
        UtilGrid.setTableData("ref1SpatialSystem", [{title:"EPSG 25832: ETRS89 / UTM Zone 32N"}]);
        dijit.byId("availabilityDataFormatInspire").set("value", "Geographic Markup Language (GML)");
    }
});


// ========================================================================================================================
// Neues Auswahlfeld/Liste: "Informationsgegenstand" (REDMINE-193)
// - Erstellung einer Tabelle(ID:'Informationsgegenstand') mit einer Spalte(ID:'informationHmbTG') und Indexnamen der Spalte 'infoHmbTG' und Breite 691px
// - Spaltentyp ist eine Liste in der die Codeliste übertragen wird
// ========================================================================================================================
// ------------------------
// IDF
// ------------------------
importPackage(Packages.de.ingrid.iplug.dsc.om);
//add Namespaces to Utility for convenient handling of NS !
DOM.addNS("gmd", "http://www.isotc211.org/2005/gmd");
DOM.addNS("gco", "http://www.isotc211.org/2005/gco");

if (!(sourceRecord instanceof DatabaseSourceRecord)) {
  throw new IllegalArgumentException("Record is no DatabaseRecord!");
}

var id = sourceRecord.get(DatabaseSourceRecord.ID);
var igcProfileControlId = XPATH.getString(igcProfileControlNode, "igcp:id");
var columnName = 'informationHmbTG'; // the column of the table to get the value from
var contentLabel = SQL.all("SELECT add2.data, add2.list_item_id FROM `additional_field_data` as add1, `additional_field_data` as add2 WHERE add1.obj_id=? AND add1.field_key=? AND add2.parent_field_id=add1.id AND add2.`field_key`=?", [id, igcProfileControlId, columnName]);

if ( contentLabel && contentLabel.size() > 0) {
  var i;
  var dataMetadata = DOM.getElement(idfDoc, "//idf:idfMdMetadata/gmd:identificationInfo");
  var dataIdentification = DOM.getElement(idfDoc, "//idf:idfMdMetadata/gmd:identificationInfo/gmd:MD_DataIdentification");

  if (!dataIdentification) dataIdentification = dataMetadata.addElement("gmd:MD_DataIdentification");

  var path = ["gmd:resourceFormat", "gmd:graphicOverview", "gmd:resourceMaintenance","gmd:pointOfContact", "gmd:status","gmd:credit","gmd:purpose"];

  // find first present node from paths
  var nodeBeforeInsert = null;
  for (var i=0; i<path.length; i++) {
      // get the last occurrence of this path if any
      nodeBeforeInsert = DOM.getElement(dataIdentification, path[i]+"[last()]");
      if (nodeBeforeInsert) { break; }
  }

  // write keys of thesaurus codelist
  var keywords;
  var keywordsParent;
  if (nodeBeforeInsert) {
      keywordsParent = nodeBeforeInsert.addElementAsSibling("gmd:descriptiveKeywords");
  } else {
      keywordsParent = dataIdentification.addElement("gmd:descriptiveKeywords");
  }
  keywords = keywordsParent.addElement("gmd:MD_Keywords");

  for (i=0; i<contentLabel.size(); i++) {
      keywords.addElement("gmd:keyword/gco:CharacterString").addText(contentLabel.get(i).get("list_item_id"));
  }

  keywords.addElement("gmd:type/gmd:MD_KeywordTypeCode")
      .addAttribute("codeList", "http://www.tc211.org/ISO19139/resources/codeList.xml#MD_KeywordTypeCode")
      .addAttribute("codeListValue", "theme");
  
  var thesCit = keywords.addElement("gmd:thesaurusName/gmd:CI_Citation");
  thesCit.addElement("gmd:title/gco:CharacterString").addText("HmbTG-Informationsgegenstand");
  var thesCitDate = thesCit.addElement("gmd:date/gmd:CI_Date");
  thesCitDate.addElement("gmd:date/gco:Date").addText("2013-08-02");
  thesCitDate.addElement("gmd:dateType/gmd:CI_DateTypeCode")
  .addAttribute("codeListValue", "publication")
  .addAttribute("codeList", "http://www.isotc211.org/2005/resources/codeList.xml#CI_DateTypeCode");
  
  // write values of all keywords (no relation to thesaurus anymore!)
  keywords = keywordsParent.addElementAsSibling("gmd:descriptiveKeywords/gmd:MD_Keywords");
  for (i=0; i<contentLabel.size(); i++) {
      keywords.addElement("gmd:keyword/gco:CharacterString").addText(contentLabel.get(i).get("data"));
  }
}


// ========================================================================================================================
// Neue Checkbox: "Veröffentlichung gemäß HmbTG" (REDMINE-192)
// - Erstellung einer einfachen Checkbox mit
//    ID: publicationHmbTG
//    Titel: Veröffentlichung gemäß HmbTG
// ========================================================================================================================
// ------------------------
// JS
// ------------------------
dojo.connect(dijit.byId("publicationHmbTG"), "onChange", function(isChecked) {
    if (isChecked) {
        dojo.addClass("uiElementAddInformationsgegenstand", "required");
    } else {
        dojo.removeClass("uiElementAddInformationsgegenstand", "required");
    }
});

// tick checkbox if "open data" has been selected (REDMINE-194)
dojo.connect(dijit.byId("isOpenData"), "onChange", function(isChecked) {
    if (isChecked) {
        dijit.byId("publicationHmbTG").set("value", true);
    }
});

// ------------------------
// IDF
// ------------------------
importPackage(Packages.de.ingrid.iplug.dsc.om);
//add Namespaces to Utility for convenient handling of NS !
DOM.addNS("gmd", "http://www.isotc211.org/2005/gmd");
DOM.addNS("gco", "http://www.isotc211.org/2005/gco");

if (!(sourceRecord instanceof DatabaseSourceRecord)) {
  throw new IllegalArgumentException("Record is no DatabaseRecord!");
}

var id = sourceRecord.get(DatabaseSourceRecord.ID);
var igcProfileControlId = XPATH.getString(igcProfileControlNode, "igcp:id");
var contentLabel = SQL.all("SELECT add1.data FROM `additional_field_data` as add1 WHERE add1.obj_id=? AND add1.field_key=?", [id, igcProfileControlId]);
if (contentLabel && contentLabel.size() > 0) {
    var isChecked = contentLabel.get(0).get("data") == "true";
    if (isChecked) {
        
        var i;
        var dataIdentification = DOM.getElement(idfDoc, "//idf:idfMdMetadata/gmd:identificationInfo/gmd:MD_DataIdentification");
        
        var path = ["gmd:resourceFormat", "gmd:graphicOverview", "gmd:resourceMaintenance","gmd:pointOfContact", "gmd:status","gmd:credit","gmd:purpose"];
        
        // find first present node from paths
        var nodeBeforeInsert = null;
        for (i=0; i<path.length; i++) {
            // get the last occurrence of this path if any
            nodeBeforeInsert = DOM.getElement(dataIdentification, path[i]+"[last()]");
            if (nodeBeforeInsert) { break; }
        }
        
        // write keys of thesaurus codelist
        var keywords;
        var keywordsParent;
        if (nodeBeforeInsert) {
            keywordsParent = nodeBeforeInsert.addElementAsSibling("gmd:descriptiveKeywords");
        } else {
            keywordsParent = dataIdentification.addElement("gmd:descriptiveKeywords");
        }
        keywords = keywordsParent.addElement("gmd:MD_Keywords");
        keywords.addElement("gmd:keyword/gco:CharacterString").addText("hmbtg");
    }
}


// ========================================================================================================================
// Wenn OpenData (REDMINE-117)
// - neues Keyword "#opendata_hh#"
// - toggle fields
// ========================================================================================================================
// ------------------------
// JS
// ------------------------
var openDataAddressCheck = null;
dojo.connect(dijit.byId("isOpenData"), "onChange", function(isChecked) {
    if (isChecked) {
        // add check for address of type publisher (Herausgeber) when publishing
        // we check name and not id cause is combo box ! id not adapted yet if not saved !
        openDataAddressCheck = dojo.subscribe("/onBeforeObjectPublish", function(/*Array*/notPublishableIDs) {
            // get name of codelist entry for entry-id "10" = "publisher"/"Herausgeber"
            var entryNamePublisher = UtilSyslist.getSyslistEntryName(505, 10);
        
            // check if entry already exists in table
            var data = UtilGrid.getTableData("generalAddress");
            var containsPublisher = dojo.some(data, function(item) { if (item.nameOfRelation == entryNamePublisher) return true; });
            if (!containsPublisher)
                notPublishableIDs.push("generalAddress");
        });

        // set publication condition to Internet
        dijit.byId("extraInfoPublishArea").attr("value", 1, true);

        // set Nutzungsbedingungen to "Datenlizenz Deutschland Namensnennung". Extract from syslist !
        var entryNameLicense = UtilSyslist.getSyslistEntryName(6500, 1);
        dijit.byId("availabilityUseConstraints").attr("value", entryNameLicense, true);

        // SHOW mandatory fields ONLY IF EXPANDED !
        dojo.addClass("uiElement5064", "showOnlyExpanded"); // INSPIRE-Themen
        dojo.addClass("uiElement3520", "showOnlyExpanded"); // Fachliche Grundlage
        dojo.addClass("uiElement5061", "showOnlyExpanded"); // Datensatz/Datenserie
        dojo.addClass("uiElement3565", "showOnlyExpanded"); // Datendefizit
        dojo.addClass("uiElementN006", "showOnlyExpanded"); // Geothesaurus-Raumbezug
        dojo.addClass("uiElement3500", "showOnlyExpanded"); // Raumbezugssystem
        dojo.addClass("uiElement5041", "showOnlyExpanded"); // Sprache des Metadatensatzes
        dojo.addClass("uiElement5042", "showOnlyExpanded"); // Sprache der Ressource
        dojo.addClass("uiElementN024", "showOnlyExpanded"); // Konformität
        dojo.addClass("uiElement1315", "showOnlyExpanded"); // Kodierungsschema

    } else {
        // unregister from check for publisher address
        if (openDataAddressCheck)
            dojo.unsubscribe(openDataAddressCheck);

        // remove "keine" from access constraints
        var data = UtilGrid.getTableData('availabilityAccessConstraints');
        var posToRemove = 0;
        var entryExists = dojo.some(data, function(item) {
            if (item.title == "keine") {
                return true;
            }
            posToRemove++;
        });
        if (entryExists) {
            UtilGrid.removeTableDataRow('availabilityAccessConstraints', [posToRemove]);
        }

        // remove license set when open data was clicked
        dijit.byId("availabilityUseConstraints").attr("value", "");

        // ALWAYS SHOW mandatory fields !
        dojo.removeClass("uiElement5064", "showOnlyExpanded"); // INSPIRE-Themen
        dojo.removeClass("uiElement3520", "showOnlyExpanded"); // Fachliche Grundlage
        dojo.removeClass("uiElement5061", "showOnlyExpanded"); // Datensatz/Datenserie
        dojo.removeClass("uiElement3565", "showOnlyExpanded"); // Datendefizit
        dojo.removeClass("uiElementN006", "showOnlyExpanded"); // Geothesaurus-Raumbezug
        dojo.removeClass("uiElement3500", "showOnlyExpanded"); // Raumbezugssystem
        dojo.removeClass("uiElement5041", "showOnlyExpanded"); // Sprache des Metadatensatzes
        dojo.removeClass("uiElement5042", "showOnlyExpanded"); // Sprache der Ressource
        dojo.removeClass("uiElementN024", "showOnlyExpanded"); // Konformität
        dojo.removeClass("uiElement1315", "showOnlyExpanded"); // Kodierungsschema
    }
});

// ------------------------
// IDF
// ------------------------
importPackage(Packages.de.ingrid.iplug.dsc.om);
//add Namespaces to Utility for convenient handling of NS !
DOM.addNS("gmd", "http://www.isotc211.org/2005/gmd");
DOM.addNS("gco", "http://www.isotc211.org/2005/gco");

if (!(sourceRecord instanceof DatabaseSourceRecord)) {
  throw new IllegalArgumentException("Record is no DatabaseRecord!");
}

var id = sourceRecord.get(DatabaseSourceRecord.ID);
var openDataKeyword = DOM.getElement(idfDoc, "//idf:idfMdMetadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword[gco:CharacterString='opendata']");
if (openDataKeyword) {
    var hhKeyword = openDataKeyword.addElementAsSibling("gmd:keyword");
    hhKeyword.addElement("gco:CharacterString").addText("#opendata_hh#");
}
