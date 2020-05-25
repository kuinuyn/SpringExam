<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/code/code.tld" %>
<code:select var="MAXRESULT"/>
<!DOCTYPE html>
<html>
	<head lang="ko">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>도로조명관리시스템</title>
		
		<%@ include file="/WEB-INF/include/include-header.jspf"%>
	</head>
	<body>
		<div style="width:100%; height:100%;">
			<div id="left" class="tiles header"><tiles:insertAttribute name="left" /></div>
			<div id="main" class="tiles main"><tiles:insertAttribute name="body" /></div>
		</div>
	</body>
</html>