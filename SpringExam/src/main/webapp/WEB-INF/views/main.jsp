<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	$(document).ready(function(){
		
	});

	function goList() {
		location.href= "/board/board";
	}

	function goLogout() {
		location.href= "/logout";
	}
	
	function goLogin() {
		location.href= "/login/loginPage";
	}
</script>
<body>
	<h1>
		Hello world!  
	</h1>
	<sec:authorize access="isAuthenticated()">
		<button id="listBtn" name="listBtn" onclick="javascript:goList()" >리스트</button>
		<button id="logoutBtn" name="logoutBtn" onclick="javascript:goLogout()" >로그아웃</button>
	</sec:authorize>
	<sec:authorize access="isAnonymous()">
		<button id="logoutBtn" name="logoutBtn" onclick="javascript:goLogin()" >로그인</button>
	</sec:authorize>
</body>
</html>
