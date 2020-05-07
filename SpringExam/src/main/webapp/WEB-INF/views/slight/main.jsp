<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};
	
	$(document).ready(function (){
		var loginChk = eval("${loginChk}");
		
		if(typeof loginChk !== "undefined") {
			$("#user_id").focus();
			modal_popup('messagePop');
		}
		
		if("${param.fail}" == "true") {
			modal_popup('messagePop');
			$("#user_id").focus();
			alert("아이디와 비밀번호를 확인하세요.");
		}
		
		//drawCodeData(리스트, 코드타입, 태그이름, 모드, 현재선택코드)
		drawCodeData(commonCd, "13", "select", "").then(function(resolvedData) {
			$("#light_type").empty();
			$("#light_type").append(resolvedData);
			$("#light_type").find("option").eq(0).remove();
			$("#light_type").find("option").addClass("option");
		})
		.then(function() {
			Search('0');
		});
		
		$("#light_type").change(function() {
			var num = 0;
			var childNodes = $("#tabmenu").find('li')
			var title = "가로등";
			var childrens = $("#all_rtime > p").children('span');
			
			if($(this).val() == 2) {
				var title = "보안등";
			}
			else if($(this).val() == 3) {
				var title = "분점함";
			}
			
			childrens.eq(0).text(title);
			
			for(var i=0; i<childNodes.size(); i++) {
				if(childNodes.eq(i).find('.tab_on').size() > 0) {
					num = i;
				}
			}
			Search(num);
		});
		
		$("#keyword").keypress(function (e) {
			if (e.which == 13){
				searchMap();  // 실행할 이벤트
			}
		});
		
		$("#map_open").click(function() {
			$("#side_list").attr("style", "display:block;");
			$("#side_title2").attr("style", "display:none;");
			$("#map_open").attr("style", "display:none;");
		});
		
		$("#map_close").click(function() {
			$("#side_list").attr("style", "display:none;");
			$("#side_title2").attr("style", "display:block;");
			$("#map_open").attr("style", "display:block;")
		});
	});
	
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

	function openTab(ele, num) {
		$(".tab_on").removeClass();
		var nodes = ele.childNodes;
		nodes.item(0).setAttribute('class', 'tab_on');
		
		Search(num);
	}
	
	function Search(num) {
		$("#searchType").val(num);
		$("#searchLightType").val($("#light_type").val());
		
		$.ajax({
			type : "POST"			
			, url : "/getSummary"
			, data : $("#slightForm").serialize()
			, dataType : "JSON"
			, success : function(obj) {
				getSearchCallback(obj);
			}
			, error : function(xhr, status, error) {
			}
		});
	}
	
	function getSearchCallback(obj) {
		var lightCnt = obj.lightCnt;
		var summaryMap = obj.summaryMap;
		
		if(lightCnt > 0) {
			var childrens = $("#all_rtime").children('p');
			childrens.find('b').text("총 "+lightCnt+"건");
		}
		
		if(summaryMap != null) {
			$(".blue01").text("총 "+summaryMap.totalCnt+"건");
			var summaryChildNodes = $("#snumber").find('li');
			var statusCnt = 0;
			var summaryKey = "";
			
			for(var i=0; i<summaryChildNodes.size(); i++) {
				key = "status0"+(i+1)+"Cnt";
				statusCnt = summaryMap[key];
				summaryChildNodes.eq(i).find(".black05").text(statusCnt+"건");
			}
			
			var lightChildNodes = $("#rtime_list").find('ul');
			var lightTypeStatusCnt = 0;
			var lightKey = "";
			
			for(var i=0; i<lightChildNodes.size(); i++) {
				lightKey = "lightTypeStatus0"+(i+1)+"Cnt";
				lightTypeStatusCnt = summaryMap[lightKey];
				lightChildNodes.eq(i).find(".result").text(lightTypeStatusCnt+"건");
			}
		}
		
	}
	
	function goToComplaintList() {
		$("#slightForm").attr({action:'/complaint/complaintList'}).submit();
	}
	
	function goToRepairList(lightType) {
		if(lightType == 'lightType') {
			$("#light_gubun").val($("#light_type").val());
		}
		else {
			$("#light_gubun").val('');
		}
		$("#slightForm").attr({action:'/repair/systemRepairList'}).submit();
	}
	
	function goGisMap() {
		var frm = document.frm;
		
		frm.action =  "${contextPath}/common/map/mapContentDaum2";
		frm.target = 'mapContentDaum';
		frm.submit();
		
		$("#keyword").val("");
		$("#side_title .red02").text("총 0건");
		$("#side_title2 .red02").text("총 0건");
		var resArrd = "";
		resArrd = "<ul>";
		resArrd += "<li>검색결과가 없습니다.</li>";
		resArrd += "</ul>";
		$("#side_search_list").html(resArrd);
		
		modal_popup3("messagePop3");
		$("#keyword").focus();
	}
	
	function mapOpenTab(ele, num) {
		$(".tab_on").removeClass();
		var nodes = ele.childNodes;
		nodes.item(0).setAttribute('class', 'tab_on');
		
		if(num == 1) {
			$("#sbox_adr").show();
			$("#searchbox_btn").css("top", "22px");
			$("#sidebox01").css("height", "125px");
		}
		else {
			$("#sbox_adr").hide();
			$("#searchbox_btn").css("top", "0");
			$("#sidebox01").css("height", "120px");
		}
	}
	
	function searchMap() {
		var num = 0;
		var childNodes = $("#side_tab").find('li')
		
		for(var i=0; i<childNodes.size(); i++) {
			if(childNodes.eq(i).find('.tab_on').size() > 0) {
				num = i+1;
			}
		}
		
		var searchGubun = $("input[type=radio][name=searchGubun]:checked").val();
		
		if($("#keyword").val() == null || $("#keyword").val() == "") {
			alert("검색어를 입력하세요.");
			return;
		}
		
		$.ajax({
			type : "POST"			
			, url : "/common/map/mapDataKakao"
			, data : {"keyword" : $("#keyword").val(), "keytype" : num, "searchGubun" : searchGubun}
			, dataType : "JSON"
			, success : function(obj) {
				getSearchMapCallback(obj);
			}
			, error : function(xhr, status, error) {
				
			}
		});
	}
	
	function getSearchMapCallback(obj) {
		var state = obj.returnMsg;
		var dataSet = new Array();
		var arrList = new Array();
		var resArrd = "";
		var arrListVal = 2;
		
		if(state != false) {
			dataSet = state.split("^");
			var dataList = new Array();
			$("#side_title .red02").text("총 "+dataSet.length+"건");
			$("#side_title2 .red02").text("총 "+dataSet.length+"건");
			
			for(var i = 0;i < dataSet.length; i++) {
				dataList = dataSet[i].split("|");
				arrList[i] = new Array(dataList.length);
				
				for(var j = 0;j < dataList.length; j++) {
					arrList[i][j] = toTrim(dataList[j]);
				}
			}
			
			resArrd = "<ul>";
			if(arrList[0][1] != "" && arrList[0][1] != undefined) {	
				for(var k = 0;k < arrList.length; k++) {
					if(arrList[k][3] != "" && arrList[k][3] != undefined && arrList[k][4] != "" && arrList[k][4] != undefined) {
						/* if(searchGubun == "new") arrListVal = 8;
						else arrListVal = 2; */
						
						resArrd += "<li style=\"text-align:left;\"><a href=\"javascript:onBodyUrl('"+arrList[k][3]+"', '"+arrList[k][4]+"', '"+arrList[k][1]+"');\"  >["+[arrList[k][1]]+"]"+arrList[k][arrListVal]+"</a></li>";
					}
				}
			}
			resArrd += "</ul>";
		}
		else {
			$("#side_title .red02").text("총 0건");
			$("#side_title2 .red02").text("총 0건");
			
			resArrd = "<ul>";
			resArrd += "<li>검색결과가 없습니다.</li>";
			resArrd += "</ul>";
		}
		
		$("#side_search_list").html(resArrd);
	}
	
	function onBodyUrl(xPos, yPos, searchLightNo) {	
		var ifra = document.getElementById('mapContentDaum').contentWindow; 
		
		ifra.map_move(xPos, yPos, searchLightNo);
		ifra.onAjaxData(xPos, yPos, searchLightNo);
	}
	
	function goToTrbList(lightNo, light_type, address, hj_dong_cd) {
		$("#light_no").val(lightNo);
		$("#lightType").val(light_type);
		$("#address").val(address);
		$("#hj_dong_cd").val(hj_dong_cd);
		$("#troubleForm").attr({action:'/trouble/trblReportList'}).submit();
	}
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
				<li><a href="/complaint/complaintList" class="qmenu01"><p>민원결과</p></a></li>
				<li><a href="javascript:goGisMap()" class="qmenu02"><p>지도보기</p></a></li>
			</ul>
			<ul>
				<li><a href="#" class="qmenu03"><p>통계안내</p></a></li>
				<li><a href="/repair/systemRepairList" class="qmenu04"><p>보수이력</p></a></li>
			</ul>
		</div>
	</div>
	<!-- 고장신고 -->
	<form id="troubleForm" name="troubleForm" method="post" action="">
		<input type="hidden" id="light_no" name="light_no" value="">
		<input type="hidden" id="lightType" name="lightType" value="">
		<input type="hidden" id="address" name="address" value="">
		<input type="hidden" id="hj_dong_cd" name="hj_dong_cd" value="">
	</form>
	
	<!--  전체통계 -->
	<form id="slightForm" name="slightForm" method="post" action="">
		<input type="hidden" id="searchType" name="searchType" value="0">
		<input type="hidden" id="searchLightType" name="searchLightType" value="">
		<input type="hidden" id="light_gubun" name="light_gubun" value="">
	</form>
	
	<div id="dash_box02">
		<div id="tabmenu">
			<ul>
				<li onclick="openTab(this, 0)"><a href="#"  class="tab_on">일 간</a></li>
				<li onclick="openTab(this, 1)"><a href="#" >주 간</a></li>
				<li onclick="openTab(this, 2)"><a href="#">월 간</a></li>
				
			</ul>
		</div>
		<div id="all_number">
			<ul>
				<li class="alltxt"><span class="black01">종합</span></li>
				<li class="allnum"><span class="blue01">총 0건</span></li>
			</ul>
		</div>
		<div id="snumber">
			<ul>
				<li class="snum01">
					<span class="black04">신고접수</span>
					<span class="black05">0건</span>
				</li>
				<li class="snum02">
					<span class="black04">작업지시</span>
					<span class="black05">0건</span>
				</li>
			</ul>
			<ul>
				<li class="snum03">
					<span class="black04">작업진행</span>
					<span class="black05">0건</span>
				</li>
				<li class="snum04">
					<span class="black04">보수완료</span>
					<span class="black05">0건</span>
				</li>
			</ul>
		</div>

		<div id="report">
			<ul>
				<li><span class="blue02">신고건수</span></li>
				<li>
					<span class="black02">어제</span>
					<span class="black03"><c:out value="${lastSummaryMap.yesterdayCnt }" />건</span>
				</li>
				<li>
					<span class="black02">지난주</span>
					<span class="black03"><c:out value="${lastSummaryMap.lastWeekCnt }" />건</span>
				</li>
				<li>
					<span class="black02">지난달</span>
					<span class="black03"><c:out value="${lastSummaryMap.lastMonthCnt }" />건</span>
				</li>
			</ul>
			
		</div>
	</div>

	<!--  실시간현황 -->
	<div id="dash_box03">
		<h3>실시간 현황</h3>
		<a href="javascript:goToRepairList('lightType')" class="box03_more">상세보기 </a>
		<div id="all_rtime">
			<p>
				<span>가로등</span><br />
				<span><b>총 0건</b></span>
			</p>
		</div>
		<div id="s_rtime">
			<div id="rtime_selbox">
				<select id="light_type" class="select01">
					<option value="2" selected="selected" class="option">가로등 실시간현황</option>
					<option value="1" class="option">보안등 실시간현황</option>
					<option value="3" class="option">분전함 실시간현황</option>
				</select>
			</div>
			<div id="rtime_list">
				<ul>
					<li>신고접수</li>
					<li class="result">0건</li>
				</ul>
				<ul>
					<li>작업지시</li>
					<li class="result">0건</li>
				</ul>
				<ul>
					<li>작업진행</li>
					<li class="result">0건</li>
				</ul>
				<ul>
					<li>보수완료</li>
					<li class="result">0건</li>
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
		<a href="javascript:goToComplaintList()" class="more">더보기</a>
		<c:forEach items="${lastSummaryMap.complaintList }" var="complaintList">
			<ul>
				<a href="#" >
					<li><span><c:out value="${complaintList.repair_no }"/></span>   </li>
					<li><span><c:out value="${complaintList.light_gubun }"/></span>   </li>
					<li><span><c:out value="${complaintList.notice_date }"/></span>   </li>
					<c:choose>
						<c:when test="${complaintList.progress_status eq '01'}">
							<li><span class="orange01">신고접수</span></li>
						</c:when>
						<c:when test="${complaintList.progress_status eq '02'}">
							<li><span class="red01">작업지시</span></li>
						</c:when>
						<c:when test="${complaintList.progress_status eq '03'}">
							<li><span class="red01">처리중</span></li>
						</c:when>
						<c:when test="${complaintList.progress_status eq '04'}">
							<li><span class="blue03">보수완료</span></li>
						</c:when>
					</c:choose>
				</a>
			</ul>
		</c:forEach>
	</div>
	<div id="board02">
		<h3>보수이력</h3>
		<a href="javascript:goToRepairList()" class="more">더보기</a>
		
		<c:forEach items="${lastSummaryMap.repairList }" var="repairList">
			<ul>
				<a href="#" >
					<li><span><c:out value="${repairList.repair_no }"/></span></li>
					<li><span><c:out value="${repairList.light_gubun }"/></span></li>
					<li><span><c:out value="${repairList.notice_date }"/></span></li>
					<c:choose>
						<c:when test="${repairList.progress_status eq '01'}">
							<li><span class="orange01">신고접수</span></li>
						</c:when>
						<c:when test="${repairList.progress_status eq '02'}">
							<li><span class="red01">작업지시</span></li>
						</c:when>
						<c:when test="${repairList.progress_status eq '03'}">
							<li><span class="red01">처리중</span></li>
						</c:when>
						<c:when test="${repairList.progress_status eq '04'}">
							<li><span class="blue03">보수완료</span></li>
						</c:when>
					</c:choose>
				</a>
			</ul>
		</c:forEach>
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
<!--고장신고 지도 Popup-->
<div class="modal-popup3">
	<div class="bg"></div>
	<div id="messagePop3" class="pop-layer2">
		<div class="pop-container">
			<div class="pop-conts">
				<div class="btn-r">
					<a href="#" class="cbtn"><i class="fa fa-times " aria-hidden="true"></i><span class="hide">Close</span></a>
				</div>
				<div class="pop_map ">
					<h3 class="hide">고장신고</h3>
					<div id="mapbg">
						<%-- <div class="p_map">
							<iframe src="${contextPath}/common/map/mapContentDaum2" scrolling="no" style="width: 100%; height: auto;" class="p_map"/>
							<%@ include file="/WEB-INF/views/common/map/mapContentDaum2.jsp"%>
						</div> --%>
						<iframe id="mapContentDaum" name="mapContentDaum" scrolling="no" style="width: 100%; height: 100%;" class="p_map"></iframe>
						<form name="frm" id="frm" method="post">
							<input type="hidden" id="searchLightNo" name="searchLightNo">
						</form>
					</div>
					<div id="sidebox01">
						<div id="side_tab">
							<ul>
								<li onclick="mapOpenTab(this, 1)"><a href="#" >주소선택</a></li>
								<li onclick="mapOpenTab(this, 2)"><a href="#" class="tab_on">관리번호</a></li>
							</ul>
						</div>
						<div id="sidebox_search">
							<div id="sbox_adr" style="display: none;">
								<span><input type="radio" name="searchGubun" value="new" checked="checked">도로명</span>
								<span><input type="radio" name="searchGubun" value="">지번</span>
							</div>
							<div id="searchbox"><input type="text" name="keyword" id="keyword" class="tbox05"></div>
							<a href="javascript:searchMap();"><div id="searchbox_btn"><span class="hide">검색</span></div></a>
						</div>
					</div>
					<div id="sidebox02">
						<!-- 검색창을 펼쳤을때 -->
						<div id="side_list">
							<div id="side_title">
								<span>검색결과</span>
								<span class="red02">총 0건</span>
							</div>
							<div id="side_search_list" >
								<ul>
									<li>검색결과가 없습니다.</li>
								</ul>
							</div>
							<a href="#"><div id="map_close"><span class="hide">축소버튼</span></div></a>
						</div>
						
						<!-- 검색창을 축소했을때 -->
						<div id="side_title2" style="display: none;">
							<span>검색결과</span>
							<span class="red02">총 0건</span>
						</div>
						<a href="#"><div id="map_open" style="display: none;"><span class="hide">확대버튼</span></div></a>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--//고장신고 지도 Popup-->
