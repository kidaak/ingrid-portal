<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html xmlns="http://www.w3.org/1999/xhtml" lang="de">
<head>
<title>Kommentarbereich</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="author" content="wemove digital solutions" />
<meta name="copyright" content="wemove digital solutions GmbH" />

<script type="text/javascript">
var dirtyFlag = null;

_container_.addOnLoad(function() {
	dirtyFlag = udkDataProxy.dirtyFlag;

	var srcStore = commentStore;
	var dstStore = dojo.widget.byId("commentCommentsTable").store;
	
	// Set the comment table title
	var nodeTitle = "";
	if (currentUdk.nodeAppType == "O") {
		nodeTitle = dojo.widget.byId("objectName").getValue();
	} else if (currentUdk.nodeAppType == "A") {
		nodeTitle = dojo.widget.byId("addressTitle").getValue();	
	}
	dojo.byId("commentTableLabel").innerHTML = dojo.string.substituteParams(message.get("dialog.commentTitle"), nodeTitle);
	dstStore.setData(srcStore.getData());

	if (!currentUdk.writePermission) {
		dojo.widget.byId("addCommentButton").disable();
		dojo.widget.byId("commentNewComment").disable();
		dojo.html.addClass(dojo.widget.byId("commentCommentsTable").domNode, "readonly");
		dojo.html.removeClass(dojo.widget.byId("commentCommentsTable").domNode, "interactive");
		dojo.widget.byId("commentCommentsTable").removeContextMenu();
	}

	var setDirtyFlag = function(){ dirtyFlag = true; }
	dojo.event.connectOnce(dstStore, "onAddData", setDirtyFlag);
	dojo.event.connectOnce(dstStore, "onRemoveData", setDirtyFlag);
	dojo.event.connectOnce(dstStore, "onUpdateField", setDirtyFlag);
});

_container_.addOnUnload(function() {
	var srcStore = dojo.widget.byId("commentCommentsTable").store;
	var dstStore = commentStore;

	dstStore.setData(srcStore.getData());

	dirtyFlag ? udkDataProxy.setDirtyFlag() : udkDataProxy.resetDirtyFlag();
});


addComment = function() {
	var commentStore = dojo.widget.byId("commentCommentsTable").store;
	var newComment = dojo.widget.byId("commentNewComment").getValue();
	newComment = dojo.string.trim(newComment);

	if (newComment != "") {
		var key = UtilStore.getNewKey(commentStore);
		var userName = UtilAddress.createAddressTitle(currentUser.address);
//		commentStore.addData({Id: key, comment: newComment, date: new Date(), title: userName});
		var newCommentBean = {Id: key, comment: newComment, date: new Date(), user: {uuid: currentUser.addressUuid}, title: userName};

		commentStore.addData(newCommentBean);
		dojo.widget.byId("commentNewComment").setValue("");
	}
}


</script>
</head>

<body>

<div dojoType="ContentPane">

  <div id="comment" class="contentBlockWhite top wideBlock">
    <div id="winNavi">
		<a href="javascript:void(0);" onclick="javascript:dialog.showContextHelp(arguments[0], 7042)" title="Hilfe">[?]</a>
	  </div>
	  <div id="commentContent" class="content">

      <!-- CONTENT START -->
      <div class="inputContainer wide">
        <span id="commentTableLabel" class="label"></span>
  	    <div class="tableContainer rows8 wide">
  	    <table id="commentCommentsTable" dojoType="ingrid:FilteringTable" defaultDateFormat="%d.%m.%Y %H:%M" minRows="8" cellspacing="0" class="filteringTable interactive nosort relativePos">
  	      <thead>
  		      <tr>
        			<th nosort="true" field="date" dataType="Date" width="120"><fmt:message key="dialog.comments.date" /></th>
        			<th nosort="true" field="title" dataType="String" width="185"><fmt:message key="dialog.comments.user" /></th>
        			<th nosort="true" field="comment" dataType="String" width="677"><fmt:message key="dialog.comments.comment" /></th>
  		      </tr>
  	      </thead>
  	      <tbody>
  	      </tbody>
  	    </table>
  	  </div>

      <div class="inputContainer wide noSpaceBelow">
        <span class="label"><label for="commentNewComment" onclick="javascript:dialog.showContextHelp(arguments[0], 7043, 'Neuen Kommentar verfassen')"><fmt:message key="dialog.comments.newComment" /></label></span>
        <span class="input field grey">
			<input type="text" mode="textarea" id="commentNewComment" class="w915 h085" dojoType="ingrid:ValidationTextbox" />
        </span>
        <span class="button w915" style="height:20px !important;">
			<span style="float:right;">
				<button dojoType="ingrid:Button" title="Kommentar eintragen" id="addCommentButton" onClick="addComment"><fmt:message key="dialog.comments.addComment" /></button>
			</span>
        </span>
  	  </div>
      <!-- CONTENT END -->

    </div>
  </div>
</div>

</body>
</html>