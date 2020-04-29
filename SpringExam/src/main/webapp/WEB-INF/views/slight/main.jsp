<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var loginChk = eval("${loginChk}");
	
	if(typeof loginChk !== "undefined") {
		modal_popup('messagePop');
	}
	
	$(document).scroll(function (){
		if($(this).scrollTop() > 0){
			//alert("스크롤 내림");
			$("#header").attr("id", "header2");
			$("#top").attr("id", "top2");
			$("#navi").attr("id", "navi2");
			$("#logo").attr("id", "logo2");
			$("#login").attr("id", "login2");
		}else{
			$("#header2").attr("id", "header");
			$("#top2").attr("id", "top");
			$("#navi2").attr("id", "navi");
			$("#logo2").attr("id", "logo");
			$("#login2").attr("id", "login");
		}
	});

	/* function goList() {
		location.href= "/board/board";
	}

	function goLogout() {
		location.href= "/logout";
	}
	
	function goLogin() {
		location.href= "/login/loginPage";
	} */
</script>
<!-- 메인배너 -->
<div id="main_bnr">
	<div class="slider">
		<div class="bd">
			<ul>
				<li class="banner01"><img src="resources/css/images/main/main_txt1.png"  title="도로조명 관리시스템"/></li>  
				<li class="banner02"><img src="resources/css/images/main/main_txt1.png"  title="도로조명 관리시스템"/></li>  
				<li class="banner03"><img src="resources/css/images/main/main_txt1.png"  title="도로조명 관리시스템"/></li>  
				<li class="banner04"><img src="resources/css/images/main/main_txt1.png"  title="도로조명 관리시스템"/></li>  
			</ul>
		</div>
	</div>
	<script type="text/javascript">
	jQuery(".slider").hover(function(){
		 jQuery(this).find(".arrow").stop(true,true).fadeIn(300) 
		 },function(){ 
			jQuery(this).find(".arrow").fadeOut(300) });
		 jQuery(".slider").slide({mainCell:".bd ul",autoPlay:true,trigger:"click"});
	</script>
	
</div>

<!-- dashboard_box -->
<div id="dashbox">
	<div id="dash_box01">
		<div id="quick_menu">
			<ul>
				<li><a href="#" class="qmenu01"><p>민원결과</p></a></li>
				<li><a href="#" class="qmenu02"><p>지도보기</p></a></li>
			</ul>
			<ul>
				<li><a href="#" class="qmenu03"><p>통계안내</p></a></li>
				<li><a href="#" class="qmenu04"><p>보수이력</p></a></li>
			</ul>
		</div>
	</div>
	<!--  전체통계 -->
	<div id="dash_box02">
		<div id="tabmenu">
			<ul>
				<li><a href="#"  class="tab_on">일 간</a></li>
				<li><a href="#" >주 간</a></li>
				<li><a href="#">월 간</a></li>
				
			</ul>
		</div>
		<div id="all_number">
			<ul>
				<li class="alltxt"><span class="black01">종합</span></li>
				<li class="allnum"><span class="blue01">총 2,345건</span></li>
			</ul>
		</div>
		<div id="snumber">
			<ul>
				<li class="snum01">
					<span class="black04">신고접수</span>
					<span class="black05">25건</span>
				</li>
				<li class="snum02">
					<span class="black04">작업지시</span>
					<span class="black05">25건</span>
				</li>
			</ul>
			<ul>
				<li class="snum03">
					<span class="black04">작업진행</span>
					<span class="black05">25건</span>
				</li>
				<li class="snum04">
					<span class="black04">보수완료</span>
					<span class="black05">25건</span>
				</li>
			</ul>
		</div>

		<div id="report">
			<ul>
				<li><span class="blue02">신고건수</span></li>
				<li>
					<span class="black02">어제</span>
					<span class="black03">15건</span>
				</li>
				<li>
					<span class="black02">지난주</span>
					<span class="black03">57건</span>
				</li>
				<li>
					<span class="black02">지난달</span>
					<span class="black03">250건</span>
				</li>
			</ul>
			
		</div>
	</div>

	<!--  실시간현황 -->
	<div id="dash_box03">
		<h3>실시간 현황</h3>
		<a href="#" class="box03_more">상세보기 </a>
		<div id="all_rtime">
			<p>
				<span>가로등</span><br />
				<span><b>총 250건</b></span>
			</p>
		</div>
		<div id="s_rtime">
			<div id="rtime_selbox">
				<select id="" class="select01">
					<option value="" selected="selected" class="option">가로등 실시간현황</option>
					<option value=""   class="option">보안등 실시간현황</option>
					<option value="" class="option">보안등 실시간현황</option>
					<option value="" class="option">보안등 실시간현황</option>
				</select>
			</div>
			<div id="rtime_list">
				<ul>
					<li>신고접수</li>
					<li class="result">215건</li>
				</ul>
				<ul>
					<li>작업지시</li>
					<li class="result">5건</li>
				</ul>
				<ul>
					<li>작업진행</li>
					<li class="result">10건</li>
				</ul>
				<ul>
					<li>보수완료</li>
					<li class="result">27건</li>
				</ul>
			</div>
		</div>
	</div>
</div>
<!-- //dashboard_box -->

<!-- content -->
<div id="board">
	<div id="board01">
		<h3>고장신고</h3>
		<a href="#" class="more">더보기</a>
		<ul>
			<a href="#" >
				<li><span>202003-0202</span>   </li>
				<li><span>가로등/불편신고</span>   </li>
				<li><span>2020-03-04</span>   </li>
				<li><span class="orange01">신고접수</span>

				<!--
				폰트컬러 3가지
				신고접수 class="orange01"/ 작업지시 class="red01"/ 보수완료class="blue03"
				-->
				
				</li>
			</a>
		</ul>
		<ul>
			<a href="#" >
				<li><span>202003-0202</span>   </li>
				<li><span>가로등/불편신고</span>   </li>
				<li><span>2020-03-04</span>   </li>
				<li><span class="orange01">신고접수</span></li>
			</a>
		</ul>
		<ul>
			<a href="#" >
				<li><span>202003-0202</span>   </li>
				<li><span>가로등/불편신고</span>   </li>
				<li><span>2020-03-04</span>   </li>
				<li><span class="red01">작업지시</span>   </li>
			</a>
		</ul>
		
	</div>
	<div id="board02">
		<h3>보수이력</h3>
		<a href="#" class="more">더보기</a>
		
		<ul>
			<a href="#" >
				<li><span>202003-0202</span>   </li>
				<li><span>가로등/불편신고</span>   </li>
				<li><span>2020-03-04</span>   </li>
				<li><span class="red01">작업지시</span>   </li>
			</a>
		</ul>
		<ul>
			<a href="#" >
				<li><span>202003-0202</span>   </li>
				<li><span>가로등/불편신고</span>   </li>
				<li><span>2020-03-04</span>   </li>
				<li><span class="blue03">보수완료</span>   </li>
			</a>
		</ul>
		<ul>
			<a href="#" >
				<li><span>202003-0202</span>   </li>
				<li><span>가로등/불편신고</span>   </li>
				<li><span>2020-03-04</span>   </li>
				<li><span class="blue03">보수완료</span>   </li>
			</a>
		</ul>
	</div>
	<div id="customer">
		<a  class="csicon"></a>
		<p class="cstitle"><span class="black06">고객지원센터</span> </p>
		<p class="csnum"><span class="yellow01">02-812-6711</span> </p>
		<p class="cstime"><span class="gray01">상담시간 09:00~18:00</span> </p>
	</div>
</div>
<div id="banner"><a href="#"><img src="resources/css/images/main/bnr_txt.png"></a></div>

<!-- 서비스 업체ci 슬라이드로 움직이게 -->
<div id="service_area">
	<h3>SLIGHT SERVICE AREA</h3>
	<ul>
		<li class="arrow01"><a href="#"><img src="resources/css/images/main/area/arrow01.png"></a></li>
		<li><img src="resources/css/images/main/area/01.png"></li>
		<li><img src="resources/css/images/main/area/02.png"></li>
		<li><img src="resources/css/images/main/area/03.png"></li>
		<li><img src="resources/css/images/main/area/04.png"></li>
		<li><img src="resources/css/images/main/area/05.png"></li>
		<li><img src="resources/css/images/main/area/01.png"></li>
		<li><img src="resources/css/images/main/area/02.png"></li>
		<li><img src="resources/css/images/main/area/03.png"></li>
		<li><img src="resources/css/images/main/area/04.png"></li>
		<li class="arrow02"><a href="#"><img src="resources/css/images/main/area/arrow02.png"></a></li>
	</ul>
</div>
<!-- //content -->

