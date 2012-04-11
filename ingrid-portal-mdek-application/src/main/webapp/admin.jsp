<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<fmt:setLocale value="<%= request.getParameter("lang") == null ? "de" : request.getParameter("lang") %>" scope="session" />
<fmt:setBundle basename="messages" scope="session"/>

<%
    String currentUser = (String)request.getSession(true).getAttribute("userName");
    if (!"admin".equals(currentUser)) {
        String destination ="login.jsp";
        response.sendRedirect(response.encodeRedirectURL(destination));
    }
%>

<html dir="ltr">
    
    <head>
    
        <style type="text/css">
            body, html { width:100%; height:100%; margin:0; padding:0; overflow:hidden; font: normal 11px/16px Verdana, Arial, Helvetica, sans-serif;}
			div.table { display:table; border-collapse:collapse; }
			div.tr { display:table-row; }
			div.td { display:table-cell; padding:5px; }
			h1 { position: absolute; left: 150px; top: 2px; margin: 0; font-size: 20px; }
			h2 { height: 28px; width: 180px; background-color: #D1E4F1; padding: 12px 0 0px 10px; margin-top: 0; margin-left: 40px; font: bold 12px/15px Verdana, Arial, Helvetica, sans-serif; color: #464646;}
			h3 { background-color: #F5F8EB; height: 28px; padding: 12px 19px 0; margin: 0; font-size: 16px; line-height: 18px; font-weight: bold; font-family: Arial, Helvetica, sans-serif; }
			#header {height: 80px; background-color: #68A5D2; margin: 0 0 35px; padding: 0; color: #A2C6E3;}
			#menu { width: 240px; padding: 0 0 10px; position: absolute;}
			ul { background-color: #F5F8EB; padding: 20px 0 20px 40px;}
            li a {color: #464646 !important;}
			a, a:VISITED {text-decoration: none; color: #176798;}
			li {list-style: none; line-height: 14px; margin-bottom: 8px; }
			#logoutContainer { position: absolute; top: 0px; right: 0px; background-color: white; padding: 3px 14px; }
			#cataloguesView .td {border: 1px solid; padding: 3px 10px;}
			.container { background-color: #fff;}
			.content {left: 240px; position: relative; top: 0px; display: none; border: 1px solid #DDE9BD; width: 75%; min-height: 650px;}
			.content div { margin: 19px; }
			.bold { font-weight: bold; }
			.error { color: red; }
			.block {width: 40px; height: 40px; background-color: #68A5D2; position: absolute; } 
			.block p {padding-left: 10px; color: white; font-size: 20px; margin-top: 10px; font-weight: bold;}
			
			input[type="button"]:hover, input[type="submit"]:hover, button:hover { background: #1B78B1;}
			input[type="button"], input[type="submit"], button {min-width: 110px;top: 2px;padding: 4px 10px;margin-right: 5px;background: #68A5D2;color: white;font-weight: bold;border: none;}
	    </style>
    
        <script type="text/javascript" src="dojo-src/release/dojo/dojo/dojo.js" djConfig="parseOnLoad:false"></script>
        
        <script type='text/javascript' src='dwr/engine.js'></script>
        <script type='text/javascript' src='dwr/util.js'></script>
        <script src='/ingrid-portal-mdek-application/dwr/interface/SecurityService.js'></script>
        <script src='/ingrid-portal-mdek-application/dwr/interface/UserRepoManager.js'></script>
        <script src='/ingrid-portal-mdek-application/dwr/interface/CatalogManagementService.js'></script>
        
        <script type="text/javascript">
            var previousContent = "welcomeDiv";
        
            var loggedInUser = "<%= request.getSession(true).getAttribute("userName") %>";
            console.debug("user is: " + loggedInUser);
            getAllUsers();
            getAllAvailableUsers();
            createCatalogueTable();

            dojo.connect(window, "onload", function() {
                dojo.style(previousContent, "display", "block");
            });
            

            function showLoginError() {
                document.getElementById("error").style.display = "block";
            }

            function getAllUsers() {
                UserRepoManager.getAllUsers(function(users) {
                    createUserTable(users, "users", "userChoice");
                });
            }

            function getAllAvailableUsers() {
                UserRepoManager.getAllAvailableUsers(function(users) {
                    createUserTable(users, "usersChoice", "userChoiceAdd");
                });
            }

            function createUserTable(users, id, parentId) {
                console.debug(users);
                var element = dojo.create("select", {id: id});
                dojo.forEach(users, function(user) {
                    dojo.place(dojo.create("option", { innerHTML: user }), element);

                });
                dojo.place(element, parentId);
            }

            function createCatalogueTable() {
                // get all connected catalogues
                CatalogManagementService.getConnectedCataloguesInfo(function(iplugs) {
                    var atLeastOneNotConnectedIPlug = false;
                    var atLeastOneConnectedIPlug = false;
                    if (iplugs) {
                        var element = dojo.create("select", {id:"catalogueSelectAdd"});
                        var elementDisconnect = dojo.create("select", {id:"catalogueSelectDisconnect"});
                        dojo.forEach(iplugs, function(iplug) {
                            // add to table only if iplug is connected to a user/catAdmin
                            if (iplug.admin) {
	                            var row = dojo.create("div", {'class':'tr'});
	                            dojo.create("div", {'class':'td', innerHTML:iplug.iplug}, row);
	                            dojo.create("div", {'class':'td', innerHTML:iplug.admin}, row);
	                            dojo.place(row, "cataloguesView");

	                            // fill select box for catalogues to disconnect
	                            dojo.place(dojo.create("option", { value: iplug.admin, innerHTML: iplug.iplug }), elementDisconnect);
	                            atLeastOneConnectedIPlug = true;
                            } else {
                                // select box shows only not connected catalogues
                                dojo.place(dojo.create("option", { innerHTML: iplug.iplug }), element);
                                atLeastOneNotConnectedIPlug = true;
                            }
                        });
                        dojo.place(element, "catalogueChoiceAdd");
                        dojo.place(elementDisconnect, "catalogueChoiceDisconnect");

                        if (atLeastOneNotConnectedIPlug) {
                            dojo.style("containerAddCatalogueEmpty", "display", "none");
                            dojo.style("containerAddCatalogue", "display", "");
                        }
                        if (atLeastOneConnectedIPlug) {
                            dojo.style("containerDisconnectCatalogueEmpty", "display", "none");
                            dojo.style("containerDisconnectCatalogue", "display", "");
                        }
                    }
                });
                
                
            }

            function addUser() {
                var name = dojo.byId("name").value;
                var password = dojo.byId("password").value;

                // check if username already exists
                if (!usernameExists(name)) { 
	                UserRepoManager.addUser(name, password, function(success) {
	                    window.location.reload();
	                    console.debug("success adding user: " + success);
	                });
                } else {
                    dojo.style("errorExisitingUsername", "display", "");
                }
            }

            function usernameExists(name) {
                var userBox = dojo.byId("usersChoice");
                for (var i=0; i<dojo.byId("usersChoice").length; i++) {
                    if (name == userBox.options[i].value)
                        return true;;
                }
                return false;
            } 

            function removeUser() {
                var name = dojo.byId("users").value;
                UserRepoManager.removeUser(name, function(success) {
                    window.location.reload();
                    console.debug("success removing user: " + success);
                });
            }

            function addCatalogue() {
                var catalogue = dojo.byId("catalogueSelectAdd").value;
                var login = dojo.byId("usersChoice").value;

                SecurityService.createCatAdmin(catalogue, login, {
                    callback: function(result) {
                                  console.debug(result);
                                  if (result == true) {
                                      window.location.reload();
                                  }
                              }

                });
            }

            function removeCatalogue() {
                var box = dojo.byId("catalogueSelectDisconnect");
                var login = box.value;
                var catalogue = box.options[box.selectedIndex].text;
                SecurityService.removeCatAdmin(catalogue, login, {
                    callback: function(result) {
                                  console.debug(result);
                                  if (result == true) {
                                      window.location.reload();
                                  }
                              }

                });
            }

            function showContent(divId) {
                if (previousContent == divId) return;
                
                dojo.style(divId, "display", "block");
                if (previousContent) dojo.style(previousContent, "display", "");
                previousContent = divId;
            }
        </script>
    </head>
    
    <body>
        <div id="header">
            <img src="img/logo.gif" alt="InGrid Editor">
            <h1>InGrid Editor Administration</h1>
            <span id="logoutContainer"><a href="logout.jsp">Logout</a></span>
        </div>
        <div id="menu">
	        <div class="block"><p>1</p></div><h2>Benutzerverwaltung</h2>
	        <ul>
	            <li><a href="#" onclick="showContent('addUserDiv');">Add User</a></li>
	            <li><a href="#" onclick="showContent('removeUserDiv');">Remove User</a></li>
	        </ul>
	        <div class="block"><p>2</p></div>
	        <h2>Katalogverwaltung</h2>
	        <ul>
	            <li><a href="#" onclick="showContent('catOverviewDiv');">Show Catalogues</a></li>
	            <li><a href="#" onclick="showContent('addCatDiv');">Add Catalogue</a></li>
	            <li><a href="#" onclick="showContent('revomeCatDiv');">Remove Catalogue</a></li>
            </ul>
        </div>
        <div id="welcomeDiv" class="content">
            <h3>Welcome</h3>
            <div>Here you can manage the users and connected catalogues.</div>
        </div>
        <div id="addUserDiv" class="content">
            <h3>Add User</h3>
	        <div class="table container">
	            <div class="tr bold">
	                <div class="td">Username:</div>
	                <div class="td">Password:</div>
	            </div>
	            <div class="tr">
	                <div class="td"><input id="name" type="text"></div>
	                <div class="td"><input id="password" type="password"></div>
	                <div class="td"><input type="button" onclick="addUser()" value="Add User"></div>
	            </div>
	        </div>
	        <span id="errorExisitingUsername" class="error" style="display:none;">A user with this login already exists!</span>
	    </div>
        
        <div id="removeUserDiv" class="content">
            <h3>Remove User</h3>
	        <div class="table container">    
	            <div class="tr">
	                <div class="td"></div>
	                <div id="userChoice" class="td"></div>
	                <div class="td"><input type="button" onclick="removeUser()" value="Remove User"></div>
	            </div>
	        </div>
	    </div>

        <div id="catOverviewDiv" class="content">
            <h3>Show Catalogues</h3>
	        <div id="cataloguesView" class="table container">
	            <div class="tr bold">
	                <div class="td">ID</div>
	<!--                 <div class="td">Katalogname</div> -->
	<!--                 <div class="td">Partner</div> -->
	<!--                 <div class="td">Anbieter</div> -->
	<!--                 <div class="td">Administrator</div> -->
	                <div class="td">Login</div>
	            </div>
	        </div>
	    </div>
        
        <div id="addCatDiv" class="content"> 
            <h3>Add Catalogue</h3>
	        <div id="containerAddCatalogue" class="table container" style="display:none;">
	            <div class="tr bold">
	                <div class="td">Catalogue</div>
	                <div class="td">User</div>
	            </div>
	            <div class="tr">
	                <div id="catalogueChoiceAdd" class="td"></div>
	                <div id="userChoiceAdd" class="td"></div>
	                <div class="td"><input type="button" onclick="addCatalogue()" value="Add Catalogue"></div>
	            </div>
	        </div>
	        <div id="containerAddCatalogueEmpty">There's no free catalogue available.</div>
        </div>
        
        <div id="revomeCatDiv" class="content">
            <h3>Remove Catalogue</h3>
	        <div id="containerDisconnectCatalogue" class="table container" style="display:none;">
	            <div class="tr bold">
	                <div class="td">Catalogue</div>
	            </div>
	            <div class="tr">
	                <div id="catalogueChoiceDisconnect" class="td"></div>
	                <div class="td"><input type="button" onclick="removeCatalogue()" value="Remove Catalogue"></div>
	            </div>
	        </div>
	        <div id="containerDisconnectCatalogueEmpty">There's no connected catalogue available.</div>
        </div>
    </body>
</html>