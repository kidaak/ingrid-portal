/*
 * **************************************************-
 * InGrid Portal MDEK Application
 * ==================================================
 * Copyright (C) 2014 - 2015 wemove digital solutions GmbH
 * ==================================================
 * Licensed under the EUPL, Version 1.1 or – as soon they will be
 * approved by the European Commission - subsequent versions of the
 * EUPL (the "Licence");
 * 
 * You may not use this work except in compliance with the Licence.
 * You may obtain a copy of the Licence at:
 * 
 * http://ec.europa.eu/idabc/eupl5
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the Licence is distributed on an "AS IS" basis,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the Licence for the specific language governing permissions and
 * limitations under the Licence.
 * **************************************************#
 */
define(["dojo/_base/declare",
        "dojo/_base/array", 
        "dojo/Deferred", 
        "dojo/_base/lang", 
        "dojo/dom-style", 
        "dojo/topic", 
        "dojo/query",
        "dojo/string",
        "dojo/on", 
        "dojo/aspect", 
        "dojo/dom", 
        "dojo/dom-class",
        "dijit/registry", 
        "dojo/cookie",
        "ingrid/message", 
        "ingrid/dialog",
        "ingrid/utils/Grid", 
        "ingrid/utils/UI", 
        "ingrid/utils/List", 
        "ingrid/utils/Syslist"
], function(declare, array, Deferred, lang, style, topic, query, string, on, aspect, dom, domClass, registry, cookie, message, dialog, UtilGrid, UtilUI, UtilList, UtilSyslist) {

    return declare(null, {
        
        inspireIsoConnection: {
            title: "Inspire / ISO - Connection",
            description: "According to the GDI_DE Conventions, an ISO categorie is added automatically to a corresponding INSPIRE-topic. " +
            		"The category cannot be removed until the INSPIRE topic is present. If an INSPIRE topic is removed, then the ISO" +
            		"category also will be removed.",
            run: function() {
                
                // mapped INSPIRE-topic IDs to ISO-category IDs
                var mapping = {101: 13, 103: 13, 104: 3, 105: 13, 106: 15, 107: 18, 108: 12, 109: 7, 201: 6, 202: 10,
                        203: 10, 204: 8, 301: 3, 302: 17, 303: 8, 304: 15, 305: 9, 306: 19, 307: 17, 308: 17, 309: 1, 310: 16,
                        311: 15, 312: 8, 313: 4, 315: 14, 316: 14, 317: 2, 318: 2, 319: 2, 320: 5, 321: 5};
                
                var updateIsoCategories = function(id, deleteEntry) {
                    var mappedEntry = mapping[id];
                    if (!mappedEntry) return;
                    
                    var entry = UtilSyslist.getSyslistEntryName( 527, mappedEntry );
                    if (deleteEntry) {
                        // remove all automatically added entries
                        var itemIndexes = [];
                        array.forEach( UtilGrid.getTableData( "thesaurusTopics" ), function(row, index) {
                            if (row.title === mappedEntry)
                                itemIndexes.push( index );
                        } );
                        UtilGrid.removeTableDataRow( "thesaurusTopics", itemIndexes );

                    } else {
                        // check if entry already exists in table
                        var exists = dojo.some( UtilGrid.getTableData( "thesaurusTopics" ), function(row) {
                            return row.title == mappedEntry; // String-Number comparison
                        } );

                        // add entry to table if it doesn't already exist
                        if (!exists) {
                            UtilGrid.addTableDataRow( "thesaurusTopics", { title: mappedEntry } );
                            return entry;
                        }
                    }
                    return false;
                };
                
                // react when inspire topics has been added
                var inspireGridChanges = function(result, args) {
                    console.log("Inspire data behaviour");
                    var msg = args[0];
                    var objClass = registry.byId("objectClass").get("value");
                    // only react if class == 1
                    if (objClass == "Class1") {
                        // remove old dependent values
                        if (msg.oldItem) {
                            updateIsoCategories(msg.oldItem.title, true);
                        }
                        // add new dependent value
                        if (msg.type !== "deleted") {
                            var added = updateIsoCategories(msg.item.title, false);
                            if (added) {
                                UtilUI.showToolTip( "thesaurusInspire", string.substitute(message.get("validation.isocategory.added"), [added]) );
                            }
                        }
                    }
                };
                
                aspect.after(UtilGrid.getTable("thesaurusInspire"), "onCellChange", inspireGridChanges);
                aspect.after(UtilGrid.getTable("thesaurusInspire"), "notifyChangedData", inspireGridChanges);
                
                // if a category is removed that belongs to a set INSPIRE topic, then we won't allow it
                // -> instead we have to remove the topic first
                var isoCategoriesChanges = function(result, args) {
                    var msg = args[0];
                    // if cell is changed, then we must not allow to remove the old item
                    if (msg.oldItem) msg.items = [msg.oldItem];
                    var objClass = registry.byId("objectClass").get("value");
                    // only react if class == 1
                    if (objClass == "Class1") {
                        var topics = UtilGrid.getTableData("thesaurusInspire");
                        array.forEach(msg.items, function(item) {
                            // check if the deleted item is a connected category from an INSPIRE-topic
                            array.some(topics, function(topic) {
                                var mappedId = mapping[topic.title];
                                var id = UtilSyslist.getSyslistEntryKey( 527, item.title );
                                if (mappedId == id) { // Integer and String comparison!!!
                                    // re-insert removed category again
                                    if (msg.oldItem) {
                                        UtilGrid.updateTableDataRow( "thesaurusTopics", msg.row, msg.oldItem );
                                    } else {
                                        UtilGrid.addTableDataRow( "thesaurusTopics", { title: item.title } );
                                    }
                                    
                                    // show tooltip for explanation
                                    var inspireName = UtilSyslist.getSyslistEntryName( 6100, topic.title );
                                    UtilUI.showToolTip( "thesaurusTopics",  string.substitute(message.get("validation.isocategory.delete.dependent"), [inspireName]) );
                                    return true;
                                }
                            });
                        });
                    }
                };
                
                aspect.after(UtilGrid.getTable("thesaurusTopics"), "onCellChange", isoCategoriesChanges );
                aspect.after(UtilGrid.getTable("thesaurusTopics"), "onDeleteItems", isoCategoriesChanges );
            }
        }
        
    } )();
});