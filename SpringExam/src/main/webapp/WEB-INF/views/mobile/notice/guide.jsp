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
	<h2 class="hide">사용안내</h2>
	<div id="guide">
		<p><span class="black05">1. 관리번호 입력</span></p>
		<p><span class="gray01">상단 검색박스에 관리번호를 입력하면 GIS 팝업이 열립니다.</span></p>
		<p class="imgbox"><span class="guide_img01"></span></p>
		<p><span class="black05">2. 팝업 고장신고 버튼 클릭</span></p>
		<p><span class="gray01">가로등 팝업페이지가 열리면 고장신고 버튼을 클릭해주세요.</span></p>
		<p class="imgbox"><span class="guide_img02"></span></p>
		<p><span class="black05">3. 작성후 신고하기 클릭</span></p>
		<p><span class="gray01">고장신고 작성페이지로 이동해서 위치사진 확인 후, <BR>항목작성하고 신고하기 버튼을 누르면 신고가 완료됩니다.</span></p>
		<p class="imgbox2"><span class="guide_img03"></span></p>
	</div>
</section>
<!-- // List -->
<!-- //content -->

<script type="text/javascript" src="${contextPath }/resources/js/mobile/jquery_notice.js"></script>
</body>
</html>