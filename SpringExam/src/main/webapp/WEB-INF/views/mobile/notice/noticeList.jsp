<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
	<meta charset="utf-8" />
	<title>도로조명정보시스템</title>
	<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0" />
	<%@ include file="/WEB-INF/include/include-mobile-header.jspf"%>
	
	<script type="text/javascript">
		$(document).ready(function (){
			//Search();
		});
		
	</script>
	
</head>
<body>
	<%@ include file="../sidebar.jsp" %>
	
	<!-- content -->
<!-- List -->
<section id="content">
	<h2 class="hide">공지사항 리스트</h2>
	<div class="accordion-item">
		<a href="#" class="heading">
			<div class="title"><span class="warning">공지</span> 새로워진 도로조명을 소개합니다.<span class="ico_ar"></span></div>
		</a>
		<div class="conten">
			<p class="aco_tbox">
			<span class="txt-gray2">안녕하세요. 한국인터넷빌링입니다.<BR><BR>
			도로조명정보시스템이 새롭게 리뉴얼 됬습니다.<BR>
			자세한 기능은 사용안내 메뉴를 통해 확인해보시기 바랍니다.<BR>
			앞으로 더나은 서비스를 위해 노력하겠습니다.<BR><BR>
			감사합니다.<BR>
			</p>
		</div>
	</div>
	<div class="accordion-item">
		<a href="#" class="heading">
			<div class="title">공지내용2<span class="ico_ar"></span></div>
		</a>
		<div class="conten">
			<p class="aco_tbox">
			<span class="txt-gray2">
			공지내용2
			</p>
		</div>
	</div>
</section>
<!-- // List -->
<!-- //content -->

<script type="text/javascript" src="${contextPath }/resources/js/mobile/jquery_notice.js"></script>
</body>
</html>