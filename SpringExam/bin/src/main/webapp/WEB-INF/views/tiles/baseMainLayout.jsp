<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/code/code.tld" %>
<code:select var="MAXRESULT"/>
<!DOCTYPE html>
<html>
	<head lang="ko">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=1160, user-scalable=yes">
		<title>도로조명관리시스템</title>
		
		<%@ include file="/WEB-INF/include/include-header.jspf"%>
	</head>
	<body>
		<div id="wrap">
			<div><tiles:insertAttribute name="header" /></div>
			<div><tiles:insertAttribute name="body" /></div>
			<div><tiles:insertAttribute name="footer" /></div>
		</div>
	</body>
</html>