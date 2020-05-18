<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};

	$(function(){
		var searchArea = "${param.par_hj_dong}";
		var pageNo = "${param.current_page_no}";
		var lightGubun = "${param.light_gubun}";
		var paramSDate = "${param.sDate}";
		var paramEDate = "${param.eDate}";
		
		//drawCodeData(리스트, 코드타입, 태그이름, 모드, 현재선택코드)
		drawCodeData(commonCd, "13", "select", "ALL", lightGubun).then(function(resolvedData) {
			$("#light_gubun").empty();
			$("#light_gubun").append(resolvedData);
			
		})
		.then(function() {
			if(pageNo != "" && pageNo != null) {
				Search(pageNo);
			}
			else {
				Search();
			}
		});
		
		var today = new Date();
		var sDate = (paramSDate == "" || paramSDate == null) ? new Date(today.getFullYear(), today.getMonth(), today.getDate()-100) : paramSDate;
		var eDate = (paramEDate == "" || paramEDate == null) ? new Date(today.getFullYear(), today.getMonth(), today.getDate()) : paramEDate;
		
		$("#sDate").datepicker({
			showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시 ^ both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시 
			, maxDate : eDate
			, dateFormat: 'yy-mm-dd'
			, buttonImage : "/resources/css/images/icon/calendar.gif"
		});
		$('#sDate').datepicker('setDate', sDate);
		
		$("#eDate").datepicker({
			showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시 ^ both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시 
			, maxDate : eDate
			, dateFormat: 'yy-mm-dd'
			, buttonImage : "/resources/css/images/icon/calendar.gif"
		});
		$('#eDate').datepicker('setDate', eDate);
		
		//$(".ui-datepicker-trigger").css("display", "none");
		
		$(".ui-datepicker-trigger").attr("style", "margin-left:4px; vertical-align:middle;");
	});
	
	function Search(currentPageNo) {
		if(currentPageNo === undefined){
			currentPageNo = "1";
		}
		
		$("#current_page_no").val(currentPageNo);
		
		$.ajax({
			type : "POST"			
			, url : "/repair/getSystemRepairList"
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
		var state = obj.state;
		if(state == "SUCCESS"){
			var data = obj.data;			
			var list = data.list;
			var listLen = list.length;		
			var totalCount = data.totalCount;
			var pagination = data.pagination;
			
			var str = "";
			var btnStr = "";
			if(listLen > 0) {
				for(i=0; i<listLen; i++) {
					str += "<tr>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].repair_no+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].light_gubun+"</a></span></td>";
					str += "	<td><span> <a href='javascript:goGisMap(\""+list[i].light_no+"\")'>"+list[i].light_no+"</a></span></td>";
					//str += "	<td><span> <a href='javascript:modal_popup3(\"messagePop3\")'>"+list[i].light_no+"</a></span></td>";
					str += "	<td><span> "+list[i].notice_name+" </span></td>";
					str += "	<td><span> "+list[i].contact+" </span></td>";
					str += "	<td><span> "+list[i].notice_date+" </span></td>";
					str += "	<td><span> "+list[i].modify_date+" </span></td>";
					str += "	<td><span> "+list[i].repair_date+" </span></td>";
					if(list[i].progress_status == "01") {
						btnStr = "<span><a onclick=\"modal_popup2('messagePop2');return false;\" class='btn_orange'>신고접수</a></span>";
					}
					else if(list[i].progress_status == "02" || list[i].progress_status == "03") {
						btnStr = "<span><a onclick=\"modal_popup2('messagePop2');return false;\" class='btn_red'>작업지시취소</a></span>";
					}
					else if(list[i].progress_status == "04" || list[i].progress_status == "05") {
						btnStr = "<span><a onclick=\"modal_popup2('messagePop2');return false;\" class='btn_blue'>재작업지시</a></span>";
					}
					str += "	<td style='text-align: center;'> "+btnStr+" </td>";
					str += "</tr>";
				}
			}
			else {
				str += "<tr>";
				str += "	<td colspan='9' style='text-align: center;'>등록된 글이 존재하지 않습니다.</td>";
				str += "</tr>";
			}
			
			$("#tbody").html(str);
			$("#toptxt .black03").text("총개수: "+totalCount+"개");
			$("#pagination").html(pagination);
		}
	}
	
	function getRepairDetail(repairNo) {
		
		$.ajax({
			type : "POST"			
			, url : "/repair/getSystemRepairDetail"
			, data : {"repairNo":repairNo}
			, dataType : "JSON"
			, success : function(obj) {
				getDetailSearchCallback(obj);
			}
			, error : function(xhr, status, error) {
				
			}
		});
	}
	
	function getDetailSearchCallback(obj) {
		var data = obj.resultData;
		
		modalPopupCallback( function() {
			modal_popup2('messagePop2');
		});
		
	}
	
	function modalPopupCallback(fnNm) {
		fnNm();
	}
	
	function goGisMap(lightNo) {
		var frm = document.frm;
		
		frm.searchLightNo.value = lightNo;
		frm.action =  "${contextPath}/common/map/mapContentDaum2";
		frm.target = 'mapContentDaum';
		frm.submit();
		
		modal_popup3("messagePop3");
	}
	
	function goToTrbList(lightNo, light_type, address, hj_dong_cd) {
		$("#light_no").val(lightNo);
		$("#lightType").val(light_type);
		$("#address").val(address);
		$("#hj_dong_cd").val(hj_dong_cd);
		$("#slightForm").attr({action:'/trouble/trblReportList'}).submit();
		
	}
	
	function excelDownload() {
		var currentRow = $("#board_list > table > thead> tr > th").length;
		var headerArr = new Array();
		
		for(i=0; i<currentRow; i++) {
			headerArr.push($("#board_list > table > thead> tr").find("th:eq("+i+")").text());
		}
		
		var f = document.slightForm;
		f.method = "POST";
		f.action = "${contextPath}/repair/downloadExcel";
		f.excelHeader.value = headerArr;
		f.submit();
	}
</script>
<div id="container">
	<!-- local_nav -->
	<div id="local_nav_area">
		<div id="local_nav">
			<ul class="smenu">
				<li><a href="#" ><img src="/resources/css/images/sub/icon_home.png" alt="HOME" /></a></li>
				<li><a href="#" >보수이력관리 <img src="/resources/css/images/sub/icon_down.png"/></a>
					<ul>
						<li><a href="/trouble/trblReportList">고장신고</a></li>
						<li><a href="/complaint/complaintList" >민원처리결과조회</a></li>
						<li><a href="/equipment/securityLightList" >기본정보관리</a></li>
						<li><a href="/repair/systemRepairList">보수이력관리</a></li>
						<li><a href="#" >보수내역관리</a></li>
						<li><a href="#">이용안내</a></li>
					</ul>
				</li>
				<li><a href="#">보수이력관리</a>
					<ul>
						<li><a href="/repair/systemRepairList">보수이력관리</a></li>
						<li><a href="#" >신설현황</a></li>
						<li><a href="#">이설현황</a></li>
						<li><a href="#" >철거현황</a></li>
						<li><a href="#">자재관리</a></li>
						<li><a href="#" >자재입/출고관리</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="sub">
		<div id="sub_title"><h3>보수이력관리</h3></div>
		<!-- 검색박스 -->
		<form id="slightForm" name="slightForm" method="post" action="">
			<input type="hidden" id="excelHeader" name="excelHeader" value="" />
			<input type="hidden" id="function_name" name="function_name" value="Search" />
			<input type="hidden" id="current_page_no" name="current_page_no" value="1" />
			<div id="search_box">
				<ul>
					<li class="title">등록일</li>
					<li>
						<input type="text" id="sDate" name="sDate" class="tbox02">
						~ 
						<input type="text" id="eDate" name="eDate" class="tbox02">
					</li>
					<li class="pdl10">
						<select class="sel01" id="light_gubun" name="light_gubun">
						</select>
					</li>
					<li>
						<select class="sel01">
							<option selected>검색조건</option>
							<option>관리번호</option>
							<option>이메일주소</option>
						</select>
					</li>
					<li><input type="text" name="" class="tbox03"></li>
					<li><a href="javascript:Search()"  class="btn_search01">검 색</a></li>
				</ul>
			</div>
		</form>
		<div id="toptxt">
			<ul>
				<li><span class="black03">총개수: 0개</span></li>
				<li class="b_right"><span ><a href="javascript:excelDownload()" class="btn_gray03">엑셀 다운로드</a></span></li>
			</ul>
		</div>
		
		<div id="board_list">
			<table summary="보수이력관리목록" cellpadding="0" cellspacing="0">
				<caption>접수번호,민원종류,관리번호,신고인,전화번호,접수일,지시일,보수일,처리상황,작업지시,수리내역,사진대지</caption>
				<colgroup>
					<col width="11%">
					<col width="12%">
					<col width="12%">
					<col width="11%">
					<col width="12%">
					<col width="11%">
					<col width="11%">
					<col width="11%">
					<col width="9%">
				</colgroup>
				<thead>
					<tr>
						<th>접수번호</th>
						<th>민원종류</th>
						<th>관리번호</th>
						<th>신고인</th>
						<th>전화번호</th>
						<th>접수일</th>
						<th>지시일</th>
						<th>보수일</th>
						<th>처리상황</th>
					</tr>
				</thead>
				<tbody id="tbody">
				</tbody>
			</table>
		</div>
		<div id="pagination">
		</div>
	</div>
</div>

<!-- 작업지시 -->
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
					<p><INPUT TYPE="text" NAME="" class="tbox04" placeholder="아이디"></p>
					<p><INPUT TYPE="text" NAME="" class="tbox04" placeholder="비밀번호"></p>	
					<p><a href="#" class="btn_login">로그인</a></p>	
					<p class="txt_btm">- 아이디와 비밀번호를 입력 하신 후 로그인 버튼을 누르세요.<BR>
- 보수업체는 보수업체 아이디와 비밀번호를 입력하신 후 로그인 하세요.</p>
				</div>
				
			</div>
		</div>
	</div>
</div>
<!--//작업지시-->

<!--결과조회 상세 Popup-->
<div class="modal-popup2">
	<div class="bg"></div>
	<div id="messagePop2" class="pop-layer">
		<div class="pop-container">
			<div class="pop-conts">
				<div class="btn-r">
					<a href="#" class="cbtn"><i class="fa fa-times " aria-hidden="true"></i><span class="hide">Close</span></a>
				</div>
				<div class="pop_detail ">
					<h3>민원처리 상세조회</h3>
					<div id="board_view">
						<!-- 텍스트컬러- 고장신고-blue 고장상태-red -->
						<table summary="민원처리현황목록" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="14%">
								<col width="36%">
								<col width="14%">
								<col width="36%">
							</colgroup>
							<tbody>
								<tr>
									<th>구분</th>
									<td colspan="3"><span class="">고장신고</span></td>
								</tr>
								<tr>
									<th>읍/면/동</th>
									<td colspan="3"><span >남양주시 오납읍</span></td>
								</tr>
								<tr>
									<th>상세주소</th>
									<td colspan="3"><span>보안면유천리916-1</span></td>
								</tr>
								<tr>
									<th>관리번호</th>
									<td><span>2016.11.02</span></td>
									<th>고장상태</th>
									<td><span>작업지시</span></td>
								</tr>
								
								<tr>
									<th>접수일</th>
									<td><span>2016.11.02</span></td>
									<th>처리상황</th>
									<td><span>작업지시</span></td>
								</tr>
								<tr>
									<th>신고인</th>
									<td><span>150W</span></td>
									<th>전화번호</th>
									<td><span>032</span></td>
								</tr>
								<tr>
									<th>이메일</th>
									<td><span>abd@</span></td>
									<th>휴대폰번호</th>
									<td><span>010-000-0000</span></td>
								</tr>
								<tr>
									<th>고장상태</th>
									<td><span class="red01">불이 안들어와요</span></td>
									<th>상태설명</th>
									<td><span>불이 안들어와요불이 안들어와요</span></td>
								</tr>
								<tr>
									<th>보수처리일</th>
									<td><span>2016.11.02</span></td>
									<th>처리결과회신</th>
									<td><span>SMS</span></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div id="btn">
						<p>
						<span><a href="#"  class="btn_gray02"> 삭제</a></span>
						<span><a href="#"  class="btn_gray02">수정</a></span>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--//결과조회 상세 Popup-->

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
						<iframe id="mapContentDaum" name="mapContentDaum" scrolling="no" style="width: 100%; height: 100%;" class="p_map"></iframe>
						<form name="frm" id="frm" method="post">
							<input type="hidden" id="searchLightNo" name="searchLightNo">
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--//고장신고 지도 Popup-->
