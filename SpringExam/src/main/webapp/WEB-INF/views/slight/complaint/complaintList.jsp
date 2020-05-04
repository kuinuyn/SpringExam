<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};

	$(function(){
		var searchArea = "${param.par_hj_dong}";
		var pageNo = "${param.current_page_no}";
		var repairCd = "${param.repair_cd}";
		var paramSDate = "${param.sDate}";
		var paramEDate = "${param.eDate}";
		
		//drawCodeData(리스트, 코드타입, 태그이름, 태그ID, 모드, 현재선택코드)
		drawCodeData(commonCd, "14", "select", "ALL", "", repairCd).then(function(resolvedData) {
			$("#repair_cd").empty();
			$("#repair_cd").append(resolvedData);
			
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
			, url : "/complaint/getComplaintList"
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
			//접수번호,신고구분,접수일,고장상태,관리번호,주소,신고인,전화번호,보수일,처리상황
			if(listLen > 0) {
				for(i=0; i<listLen; i++) {
					str += "<tr>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].repair_no+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].light_gubun+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].notice_date+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].trouble_nm+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].light_no+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].location+" </a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].notice_name+" </a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].contact+" </a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].repair_date+" </a></span></td>";
					if(list[i].progress_status == "01") {
						btnStr = "<span><a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")' class='btn_orange'>신고접수</a></span>";
					}
					else if(list[i].progress_status == "02" || list[i].progress_status == "03") {
						btnStr = "<span><a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")' class='btn_red'>작업지시취소</a></span>";
					}
					else if(list[i].progress_status == "04" || list[i].progress_status == "05") {
						btnStr = "<span><a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")' class='btn_blue'>재작업지시</a></span>";
					}
					str += "	<td style='text-align: center;'> "+btnStr+" </td>";
					str += "</a></tr>";
				}
			}
			else {
				str += "<tr>";
				str += "	<td colspan='9' style='text-align: center;'>등록된 글이 존재하지 않습니다.</td>";
				str += "</tr>";
			}
			
			$("#tbody").html(str);
			$("#total_count").text(totalCount);
			$("#pagination").html(pagination);
		}
	}
	
	function getRepairDetail(repairNo) {
		
		$.ajax({
			type : "POST"			
			, url : "/complaint/getComplaintDetail"
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
		
		if(data != null) {
			var key, element, repairRst = "";
			var repairList = {};
			for(key in data) {
				element = "det_"+key;
				if($("#"+element).length > 0) {
					$("#"+element).text(data[key]);
				}
			}
		}
		
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
</script>
<div id="container">
	<!-- local_nav -->
	<div id="local_nav_area">
		<div id="local_nav">
			<ul class="smenu">
				<li><a href="#" ><img src="/resources/css/images/sub/icon_home.png" alt="HOME" /></a></li>
				<li><a href="#" >민원처리결과조회 <img src="/resources/css/images/sub/icon_down.png"/></a>
					<ul>
						<li><a href="/trouble/trblReportList">고장신고</a></li>
						<li><a href="/complaint/complaintList" >민원처리결과조회</a></li>
						<li><a href="/equipment/securityLightList" >기본정보관리</a></li>
						<li><a href="/repair/systemRepairList">보수이력관리</a></li>
						<li><a href="#" >보수내역관리</a></li>
						<li><a href="#">이용안내</a></li>
					</ul>
				</li>
				<li><a href="/complaint/complaintList">민원처리결과조회  </a>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="sub">
		<div id="sub_title"><h3>민원처리 결과조회</h3></div>
		<!-- 검색박스 -->
		<form id="slightForm" name="slightForm" method="post" action="">
			<input type="hidden" id="function_name" name="function_name" value="Search" />
			<input type="hidden" id="current_page_no" name="current_page_no" value="1" />
			<div id="search_box">
				<ul class="inform_num">
					<li>
						<table align="center" cellpadding="0" cellspacing="0">
							<tbody>
								<tr>
									<td>
										<span class="black07">총건수</span>
										<span class="red02">0건</span>
									</td>
									<!-- <td>
										<span class="black07">신고접수</span>
										<span class="red02">0건</span>
									</td> -->
									<!-- <td>
										<span class="black07">작업지시</span>
										<span class="red02">0건</span>
									</td> -->
									<!-- <td>
										<span class="black07">보수완료</span>
										<span class="red02">0건</span>
									</td> -->
									<!-- <td>
										<span class="black07">일일신고접수</span>
										<span class="red02">0건</span>
									</td> -->
								</tr>
							</tbody>
						</table>
					</li>
				</ul>
				<ul>
					<li class="title">등록일</li>
					<li>
						<input type="text" id="sDate" name="sDate" class="tbox02">
						~ 
						<input type="text" id="eDate" name="eDate" class="tbox02">
					</li>
					<li class="pdl10">
						<select class="sel01" id="repair_cd" name="repair_cd">
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
		
		<div id="board_list">
			<table summary="보수이력관리목록" cellpadding="0" cellspacing="0">
				<caption>접수번호,신고구분,접수일,고장상태,관리번호,주소,신고인,전화번호,보수일,처리상황</caption>
				<colgroup>
					<col width="10%">
					<col width="10%">
					<col width="9%">
					<col width="11%">
					<col width="10%">
					<col width="12%">
					<col width="9%">
					<col width="11%">
					<col width="9%">
					<col width="9%">
				</colgroup>
				<thead>
					<tr>
						<th>접수번호</th>
						<th>신고구분</th>
						<th>접수일</th>
						<th>고장상태</th>
						<th>관리번호</th>
						<th>주소</th>
						<th>신고인</th>
						<th>전화번호</th>
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
									<td colspan="3"><span id="det_light_gubun"></span></td>
								</tr>
								<tr>
									<th>주소</th>
									<td colspan="3"><span id="det_location"></span></td>
								</tr>
								<tr>
									<th>관리번호</th>
									<td colspan="3"><span id="det_light_no"></span></td>
								</tr>
								
								<tr>
									<th>접수일</th>
									<td><span id="det_notice_date"></span></td>
									<th>처리상황</th>
									<td><span id="det_progress_name"></span></td>
								</tr>
								<tr>
									<th>신고인</th>
									<td><span id="det_notice_name"></span></td>
									<th>연락처</th>
									<td><span id="det_contact"></span></td>
								</tr>
								<tr>
									<th>이메일</th>
									<td colspan="3"><span id="det_email"></span></td>
								</tr>
								<tr>
									<th>고장상태</th>
									<td><span class="red01"  id="det_trouble_nm"></span></td>
									<th>상태설명</th>
									<td><span id="det_trouble_desc"></span></td>
								</tr>
								<tr>
									<th>보수처리일</th>
									<td><span id="det_repair_date">2016.11.02</span></td>
									<th>처리결과회신</th>
									<td><span id="det_inform_method"></span></td>
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
