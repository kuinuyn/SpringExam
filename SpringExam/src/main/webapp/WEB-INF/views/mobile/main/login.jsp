<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<title>도로조명정보시스템</title>
	<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0" />
	<%@ include file="/WEB-INF/include/include-mobile-header.jspf"%>
	
	<script type="text/javascript">
		$(document).ready(function() {
			$(document).ready(function (){
				if("${param.fail}" == "true") {
					alert("아이디와 비밀번호를 확인하세요.");
				}
			});
			
			$("#user_id").keypress(function (e) {
				if (e.which == 13){
					$("#pw").focus();  // 실행할 이벤트
				}
			});
			$("#pw").keypress(function (e) {
				if (e.which == 13){
					loginProcess();  // 실행할 이벤트
				}
			});
		});
	
		function loginProcess() {
			var chk = true;
			
			if($("#user_id").val() == "" || $("#user_id").val() == null) {
				alert("아이디를 입력하세요.");
				$("#user_id").focus();
				chk = false;
			}
			
			if(chk) {
				if($("#pw").val() == "" || $("#pw").val() == null) {
					alert("비밀번호를 입력하세요.");
					$("#pw").focus();
					chk = false;
				}
			}
			
			if(chk) {
				document.loginForm.submit();
			}
		}
	</script>
</head>
<body>
	<!-- content -->
	<!-- Login -->
	<section id="content">
		<h2 class="hide">로그인</h2>
		<div id="login">
			<p><a href="${contextPath }/index" class="login_logo">로그인로고</a></p>
			<div id="login_tbox">
				<form name='loginForm' action='/loginProcess' method='POST'>
					<p><input type="text" id="user_id" name="user_id" class="loginbox" placeholder="아이디"></p>
					<p><input type="password" id="pw" name="pw" class="loginbox" placeholder="비밀번호"></p>	
					<p><a href="javascript:loginProcess()" class="btn_login">로그인</a></p>	
					<p><a href="${contextPath }/index" class="btn_home">홈으로</a></p>	
				</form>
			</div>
				
		</div>
	</section>
	<!-- //  Login -->
	<!-- //content -->
</body>
</html>