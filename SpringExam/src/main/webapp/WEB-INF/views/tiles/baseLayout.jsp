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
		<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/common/contents.css'/>" />
		<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/common/sub.css'/>" />
	</head>
	<body>
		<div id="wrap">
			<div><tiles:insertAttribute name="header" /></div>
			<div><tiles:insertAttribute name="body" /></div>
			<!--Login_Popup-->
			<div class="modal-popup">
				<div class="bg"></div>
				<div id="messagePop" class="pop-layer">
					<div class="pop-container">
						<div class="pop-conts">
							<h1>관리자 로그인</h1>
							<div class="btn-r">
								<a href="#" class="cbtn"><i class="fa fa-times" aria-hidden="true"></i><span class="hide">Close</span></a>
							</div>
							<div id="accordian">
								<form name='loginForm' action='/loginProcess' method='POST'>
									<p><input type="text" name="user_id" id="user_id" class="tbox04" placeholder="아이디"></p>
									<p><input type="password" name="pw" id="pw" class="tbox04" placeholder="비밀번호"></p>	
									<p><a href="javascript:loginForm.submit()" class="btn_login">로그인</a></p>	
								</form>
								<p class="txt_btm">- 아이디와 비밀번호를 입력 하신 후 로그인 버튼을 누르세요.<BR>
			- 보수업체는 보수업체 아이디와 비밀번호를 입력하신 후 로그인 하세요.</p>
							</div>
							
						</div>
					</div>
				</div>
			</div>
			<!--//Login_Popup-->
			<div><tiles:insertAttribute name="footer" /></div>
		</div>
	</body>
</html>