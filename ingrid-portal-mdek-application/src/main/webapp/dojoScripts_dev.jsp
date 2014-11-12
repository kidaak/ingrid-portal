<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- development: 'dojo-src'     release: 'dojo-src/release/dojo' -->
<% String dojoPath = "dojo-src"; request.getSession(true).setAttribute("dojoPath", dojoPath); %>

<link rel="stylesheet" href="css/styles_dev.css" />
<script type="text/javascript" src="<%=dojoPath%>/dojo/dojo.js" djConfig="parseOnLoad:false, locale:userLocale"></script>
<script type="text/javascript" src="<%=dojoPath%>/custom/layer.js"></script>
<script type="text/javascript">
    var isRelease = false;
</script>