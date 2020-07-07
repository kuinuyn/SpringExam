<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!-- header -->
<header class="navbar navbar-fixed-top" id="navbar">
    <h1 class="hide">도로조명정보시스템</h1>
    <div class="navbar-content">
    	<h2><a href="javascript:history.back()" title="뒤로가기"><i class="fa fa-angle-left txt-white"></i></a> ${pageNm }</h2>
        <div id="toggle-sidebar"><i class="fa fa-bars"></i></div>
    </div>
</header>
<!-- //header -->
<hr>

<!-- navbar -->
<nav class="sidebar sidebar-right" id="sidebar">
    
	<h2 class="hide"> 메뉴</h2>
    <ul>
        <li class="close-sb n1"><a href="${contextPath }/mobile/index"><i class="fa fa-home"></i>HOME</a></li>
        <li class="close-sb n1"><a href="${contextPath }/mobile/trouble/troubleReport"><i class="fa fa-bullhorn"></i>고장신고</a></li>
		<li class="close-sb n1"><a href="${contextPath }/mobile/complain/complainList"><i class="fa fa-check-circle"></i>진행결과</a></li>
		<li class="close-sb n1"><a href="${contextPath }/mobile/notice/noticeList"><i class="fa fa-bars"></i>공지사항</a></li>
		<li class="close-sb n1"><a href="${contextPath }/mobile/notice/guide"><i class="fa fa-exclamation-circle"></i>사용안내</a></li>
		<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS')">
			<li class="close-sb n1"><a href="${contextPath }/mobile/login" class="btn_login"><span>관리자 로그인</span></a></li>
		</sec:authorize>
		<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
			<li class="close-sb n1"><a href="${contextPath }/logout" class="btn_login"><span>로그아웃</span></a></li>
		</sec:authorize>
	</ul>

</nav>
<!-- //navbar -->
<hr>