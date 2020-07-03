<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	function openTab(ele, num) {
		
		$(".tit_on").removeClass();
		$("#s_guide_title").find("a").eq(num).addClass("tit_on");
		
		$("#s_guidebox").children("div").eq(num).show();
		$("#s_guidebox").children("div").not(":eq("+num+")").hide();
	}
</script>
<!-- container -->
<div id="container">
	<!-- local_nav -->
	<div id="local_nav_area">
		<div id="local_nav">
			<ul class="smenu">
				<li><a href="#" ><img src="/resources/css/images/sub/icon_home.png" alt="HOME" /></a></li>
				<li><a href="#" >이용안내 <img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
					<ul>
						<li><a href="/trouble/trblReportList">고장신고</a></li>
						<li><a href="/complaint/complaintList" >민원처리결과조회</a></li>
						<li><a href="/equipment/securityLightList" >기본정보관리</a></li>
						<li><a href="/repair/systemRepairList">보수이력관리</a></li>
						<li><a href="/company/companyRepair" >보수내역관리</a></li>
						<li><a href="#">이용안내</a></li>
					</ul>
				</li>
				<li><a href="#">이용안내<img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
					<ul>
						<li><a href="/info/infoServicesList">서비스 소개</a></li>
						<li><a href="/info/infoReportList">이용안내</a></li>
						<li><a href="/info/infoNoticeList" >공지사항</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	<!-- //local_nav -->

	<div id="sub">
		<div id="sub_title"><h3>서비스 이용안내</h3></div>
		<div id="s_guide_title">
			<p>
				<a href="javascript:openTab(this, 0);" class="tit_on">신고하기</a>
				<a href="javascript:openTab(this, 1);">민원처리결과조회</a>
			</p>
		</div>
		<div id="s_guidebox">
			<div>
				<p><span class="blue04">01</span>고장신고 메뉴에서 관리번호 검색버튼을 클릭해주세요.</p>
				<p class="guide01_01"></p>
				<p><span class="blue04">02</span>지도팝업이 열리면 GIS 통해서 해당 보안등 위치팝업 하단에 고장신고 버튼을 클릭해주세요.</p>
				<p class="guide01_02"></p>
				<p><span class="blue04">03</span>신고항목내역을 채우신뒤 하단에 등록버튼을 클릭하시면 고장신고 접수완료됩니다.</p>
				<p class="guide01_03"></p>
			</div>
			
			<div style="display: none;">
				<p><span class="blue04">01</span>민원처리결과조회 리스트 처리상황쪽 버튼(신고접수/작업지시/보수완료)을 클릭해주세요.</p>
				<p class="guide02_01"></p>
				<p><span class="blue04">02</span>민원처리결과조회 상세페이지를 팝업으로 확인하실 수 있습니다.</p>
				<p class="guide02_02"></p>
			</div>
		</div>
		
	</div>
</div>
<!-- //container -->