<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- development: 'dojo-src'     release: 'dojo-src/release/dojo' -->
<% String dojoPath = "dojo-src/release/dojo"; request.getSession(true).setAttribute("dojoPath", dojoPath); %>

<link rel="stylesheet" href="dojo-src/release/dojo/css/styles.css" />
<script type="text/javascript" src="dojo-src/release/dojo/dojo/dojo.js" djConfig="parseOnLoad:false, locale:userLocale"></script>
<script type="text/javascript" src="dojo-src/release/dojo/custom/layer.js"></script>
<script type="text/javascript">
    var isRelease = true;
</script>