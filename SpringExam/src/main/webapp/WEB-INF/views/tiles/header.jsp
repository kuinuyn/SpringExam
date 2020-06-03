<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/common/sub.css'/>" />
<!-- font-awesome -->
<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" />
<script type="text/javascript">

$(document).ready(function() {
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
	
	//header
	$('#main_menu1').mouseover(function() { 
		$('#main_menu1').addClass('menu_on');
		$('#main_menu2').removeClass('menu_on');
		$('#main_menu3').removeClass('menu_on');
		$('#main_menu4').removeClass('menu_on');
		$('#main_menu5').removeClass('menu_on');
		$('#main_menu6').removeClass('menu_on');
		$('#main_menu7').removeClass('menu_on');
		$('#navi_s_area').addClass('on');
		$('.smenu01').addClass('on');
		$('.smenu02').removeClass('on');
		$('.smenu03').removeClass('on'); 
		$('.smenu04').removeClass('on'); 
		$('.smenu05').removeClass('on');
		$('.smenu06').removeClass('on'); 
		$('.smenu07').removeClass('on');
	});
	$('#main_menu2').mouseover(function() { 
		$('#main_menu2').addClass('menu_on');
		$('#main_menu1').removeClass('menu_on');
		$('#main_menu3').removeClass('menu_on');
		$('#main_menu4').removeClass('menu_on');
		$('#main_menu5').removeClass('menu_on');
		$('#main_menu6').removeClass('menu_on');
		$('#main_menu7').removeClass('menu_on');
		$('#navi_s_area').addClass('on');
		$('.smenu02').addClass('on');
		$('.smenu01').removeClass('on');
		$('.smenu03').removeClass('on');
		$('.smenu04').removeClass('on'); 
		$('.smenu05').removeClass('on');
		$('.smenu06').removeClass('on'); 
		$('.smenu07').removeClass('on'); 
	});
	$('#main_menu3').mouseover(function() {
		$('#main_menu3').addClass('menu_on');
		$('#main_menu1').removeClass('menu_on');
		$('#main_menu2').removeClass('menu_on');
		$('#main_menu3').removeClass('menu_on');
		$('#main_menu5').removeClass('menu_on');
		$('#main_menu6').removeClass('menu_on');
		$('#main_menu7').removeClass('menu_on');
		$('#navi_s_area').addClass('on');
		$('.smenu03').addClass('on');
		$('.smenu01').removeClass('on');
		$('.smenu02').removeClass('on'); 
		$('.smenu04').removeClass('on'); 
		$('.smenu05').removeClass('on');
		$('.smenu06').removeClass('on'); 
		$('.smenu07').removeClass('on'); 
	});
	$('#main_menu4').mouseover(function() {
		$('#main_menu4').addClass('menu_on');
		$('#main_menu1').removeClass('menu_on');
		$('#main_menu2').removeClass('menu_on');
		$('#main_menu3').removeClass('menu_on');
		$('#main_menu5').removeClass('menu_on');
		$('#main_menu6').removeClass('menu_on');
		$('#main_menu7').removeClass('menu_on');
		$('#navi_s_area').addClass('on');
		$('.smenu04').addClass('on');
		$('.smenu01').removeClass('on');
		$('.smenu02').removeClass('on'); 
		$('.smenu03').removeClass('on'); 
		$('.smenu05').removeClass('on');
		$('.smenu06').removeClass('on'); 
		$('.smenu07').removeClass('on'); 
	});
	$('#main_menu5').mouseover(function() {
		$('#main_menu5').addClass('menu_on');
		$('#main_menu1').removeClass('menu_on');
		$('#main_menu2').removeClass('menu_on');
		$('#main_menu3').removeClass('menu_on');
		$('#main_menu4').removeClass('menu_on');
		$('#main_menu6').removeClass('menu_on');
		$('#main_menu7').removeClass('menu_on');
		$('#navi_s_area').addClass('on');
		$('.smenu05').addClass('on');
		$('.smenu01').removeClass('on');
		$('.smenu02').removeClass('on'); 
		$('.smenu03').removeClass('on'); 
		$('.smenu04').removeClass('on');
		$('.smenu06').removeClass('on'); 
		$('.smenu07').removeClass('on'); 
		
		<sec:authorize access="hasAnyRole('ROLE_USER')">
			$('.smenu05').css("margin-left", "500px");
		</sec:authorize>
	});
	$('#main_menu6').mouseover(function() {
		$('#main_menu6').addClass('menu_on');
		$('#main_menu1').removeClass('menu_on');
		$('#main_menu2').removeClass('menu_on');
		$('#main_menu3').removeClass('menu_on');
		$('#main_menu4').removeClass('menu_on');
		$('#main_menu5').removeClass('menu_on');
		$('#main_menu7').removeClass('menu_on');
		$('#navi_s_area').addClass('on');
		$('.smenu06').addClass('on');
		$('.smenu01').removeClass('on');
		$('.smenu02').removeClass('on'); 
		$('.smenu03').removeClass('on'); 
		$('.smenu04').removeClass('on');
		$('.smenu05').removeClass('on'); 
		$('.smenu07').removeClass('on'); 
	});
	$('#main_menu7').mouseover(function() {
		$('#main_menu7').addClass('menu_on');
		$('#main_menu1').removeClass('menu_on');
		$('#main_menu2').removeClass('menu_on');
		$('#main_menu3').removeClass('menu_on');
		$('#main_menu4').removeClass('menu_on');
		$('#main_menu5').removeClass('menu_on');
		$('#main_menu6').removeClass('menu_on');
		$('#navi_s_area').addClass('on');
		$('.smenu07').addClass('on');
		$('.smenu01').removeClass('on');
		$('.smenu02').removeClass('on'); 
		$('.smenu03').removeClass('on'); 
		$('.smenu04').removeClass('on');
		$('.smenu05').removeClass('on'); 
		$('.smenu06').removeClass('on'); 
	});
	
	$('#navi').mouseenter(function() {
		
		$("#header2").attr("id", "header2");
		$("#top2").attr("id", "top2");
		$("#navi2").attr("id", "navi2");
		$("#logo2").attr("id", "logo2");
		$("#login2").attr("id", "login2");
	}); 
	
	$('#header2').mouseleave(function() {
		$('#main_menu1').removeClass('menu_on');
		$('#main_menu2').removeClass('menu_on');
		$('#main_menu3').removeClass('menu_on');
		$('#main_menu4').removeClass('menu_on');
		$('#main_menu5').removeClass('menu_on');
		$('#main_menu6').removeClass('menu_on');
		$('#main_menu7').removeClass('menu_on');
		$('.smenu01').removeClass('on');
		$('.smenu02').removeClass('on'); 
		$('.smenu03').removeClass('on'); 
		$('.smenu04').removeClass('on');
		$('.smenu05').removeClass('on'); 
		$('.smenu06').removeClass('on'); 
		$('.smenu07').removeClass('on'); 
		$('#navi_s_area').removeClass('on');
		
	});
	
	//header
});

function chkSession() {
	
}

</script>

<!--// 메인배너 -->
<!-- header -->
<div id="header2">
	<div id="top2">
		<div id="top_menu">
			<div id="logo2"><a href="/"><img src="/resources/css/images/logo.png" alt="포항시"/></a></div>
			<div id="navi2">
			<h2 class="hide">메뉴</h2>
				<ul>
					<li id="main_menu1" class=""><a href="#" >고장신고</a></li>
					<li id="main_menu2" class=""><a href="#" >민원처리결과조회</a></li>
					<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
						<li id="main_menu3" class=""><a href="#" >기본정보관리</a></li>
						<li id="main_menu4" class=""><a href="#" >보수이력관리</a></li>
						<li id="main_menu5" class=""><a href="#" >보수내역관리</a></li>
						<li id="main_menu7" class=""><a href="#" >이용안내</a></li>
					</sec:authorize>
					<sec:authorize access="hasAnyRole('ROLE_USER')">
						<li id="main_menu4" class=""><a href="#" >보수내역관리</a></li>
						<li id="main_menu5" class=""><a href="#" >이용안내</a></li>
					</sec:authorize>
					<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS')">
						<li id="main_menu4" class=""><a href="#" >이용안내</a></li>
					</sec:authorize>
				</ul>
			</div> 
			<sec:authorize access="isAnonymous()">
				<c:set var="pathURI" value="${requestScope['javax.servlet.forward.servlet_path']}" />
				<c:if test="${pathURI eq '/complaint/complaintList' or pathURI eq '/trouble/trblReportList'}">
					<div id="login2">
						<span><a href="#" class="btn_login" onclick="modal_popup('messagePop');return false;">로그인</a></span>
					</div>
				</c:if>
			</sec:authorize>
			<sec:authorize access="isAuthenticated()">
				<div id="login2">
					<span><a href="/logout"  class="btn_login">로그아웃</a></span>
				</div>
			</sec:authorize>
		</div>
	</div>
	<!-- 소메뉴 영역 class="on"하면 서브바 보임 -->
	<div id="navi_s_area" class="">
		<div id="navi_smenu">
			<!--  고장신고 소메뉴-->
			<ul class="smenu01" >
				<li><a href="/trouble/trblReportList">고장신고</a></li>
				<li><a href="/trouble/trblCreateList">기타사항</a></li>
			</ul>
			 
			<!--  민원처리 소메뉴 -->
			<ul class="smenu02 " >
				<li><a href="/complaint/complaintList">민원처리결과조회</a></li>
			</ul>
			
			<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
				<!-- 기본정보관리소메뉴-->
				<ul class="smenu03 " >
					<li><a href="/equipment/securityLightList">보안등관리</a></li>
					<li><a href="/equipment/streetLightList">가로등관리</a></li>
					<li><a href="/equipment/distributionBoxList">분전함관리</a></li>
					<li><a href="/equipment/gisLightList">GIS관리</a></li>
					<li><a href="/equipment/equipStaitstice" >통계관리</a></li>
					<li><a href="/system/systemMemberList">사용자관리</a></li>
				</ul>
				
				<!-- 보수이력관리 -->
				<ul class="smenu04 " >
					<li><a href="/repair/systemRepairList">보수이력관리</a></li>
					<li><a href="/repair/systemRepairList2" >신설현황</a></li>
					<li><a href="/repair/systemRepairList3">이설현황</a></li>
					<li><a href="/repair/systemRepairList4" >철거현황</a></li>
					<li><a href="/repair/systemMaterialList">자재관리</a></li>
					<li><a href="#" >자재입/출고관리</a></li>
				</ul>
	
				<!-- 보수내역관리 -->
				<ul class="smenu05 " >
					<li><a href="/company/companyRepair">보수내역입력</a></li>
					<li><a href="/company/companyInfo" >정보변경</a></li>
				</ul>
				
				<!-- 이용안내 -->
				<ul class="smenu07 " >
					<li><a href="/info/infoServicesList">서비스 소개</a></li>
					<li><a href="/info/infoReportList">이용안내</a></li>
					<li><a href="#" >공지사항</a></li>
				</ul>
			</sec:authorize>
				
			<sec:authorize access="hasAnyRole('ROLE_USER')">
				<!-- 보수내역관리 -->
				<ul class="smenu04">
					<li><a href="/company/companyRepair">보수내역입력</a></li>
					<li><a href="/company/companyInfo" >정보변경</a></li>
				</ul>
				
				<!-- 이용안내 -->
				<ul class="smenu05">
					<li><a href="/info/infoServicesList">서비스 소개</a></li>
					<li><a href="/info/infoReportList">이용안내</a></li>
					<li><a href="#" >공지사항</a></li>
				</ul>
				
			</sec:authorize>

			<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS')">
				<!-- 이용안내 -->
				<ul class="smenu04 " >
					<li><a href="/info/infoServicesList">서비스 소개</a></li>
					<li><a href="/info/infoReportList">이용안내</a></li>
					<li><a href="#" >공지사항</a></li>
				</ul>
			</sec:authorize>
		</div>
	</div>
	<!-- // 소메뉴 영역-->
</div>
<!--// header -->