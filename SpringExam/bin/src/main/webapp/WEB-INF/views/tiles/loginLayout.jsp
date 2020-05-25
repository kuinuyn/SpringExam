<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>도로조명관리시스템</title>
		<%@ include file="/WEB-INF/include/include-header.jspf"%>
		<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/common/contents.css'/>" />
	</head>
	<body>
		<div id="wrap">
			<%-- <div><tiles:insertAttribute name="header" /></div> --%>
			<div><tiles:insertAttribute name="body" /></div>
		</div>
	</body>
</html>