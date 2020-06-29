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
		var resultCd = "${resultCd}";
		var resultMsg = "${resultMsg}";
		
		if(resultCd == "N") {
			alert(resultMsg);
		}
		
		//drawCodeData(리스트, 코드타입, 태그이름, 모드, 현재선택코드)
		drawCodeData(commonCd, "13", "select", "ALL", lightGubun).then(function(resolvedData) {
			$("#light_gubun").empty();
			$("#light_gubun").append(resolvedData);
			
		})
		.then(function() {
			drawCodeData(commonCd, "01", "select", "").then(function(resolvedData) {
				$("#trouble_cd").empty();
				$("#trouble_cd").append(resolvedData);
				$("#trouble_cd").parents("li").hide();
			})
		})
		.then(function() {
			drawCodeData(commonCd, "03", "select", "").then(function(resolvedData) {
				$("#progress_status").empty();
				$("#progress_status").append(resolvedData);
				$("#progress_status").parents("li").hide();
			})
		})
		.then(function() {
			if(pageNo != "" && pageNo != null) {
				Search(pageNo);
			}
			else {
				Search();
			}
		});
		
		$("#password").keypress(function (e) {
			if (e.which == 13){
				getComplaintDet();  // 실행할 이벤트
			}
		});
		
		$("#searchType").change(function() {
			var searchType = $(this).val();
			
			if(searchType == "") {
				$("#keyword").val("");
				$("#keyword").show();
				$("#keyword").addClass("tbox03_gray");
				$("#keyword").attr("readonly", true);
				$("#trouble_cd").parents("li").hide();
				$("#progress_status").parents("li").hide();
			}
			else if(searchType == 1 || searchType == 2 || searchType == 3 || searchType == 7) {
				$("#keyword").val("");
				$("#keyword").show();
				$("#keyword").removeClass("tbox03_gray");
				$("#keyword").addClass("tbox03");
				$("#keyword").attr("readonly", false);
				$("#trouble_cd").parents("li").hide();
				$("#progress_status").parents("li").hide();
			}
			else if(searchType == 4) {
				$("#keyword").val("");
				$("#keyword").hide();
				$("#trouble_cd").parents("li").show();
				$("#progress_status").parents("li").hide();
			}
			else if(searchType == 5) {
				$("#keyword").val("");
				$("#keyword").hide();
				$("#trouble_cd").parents("li").hide();
				$("#progress_status").parents("li").show();
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
	
	function Search(currentPageNo, orderNm, order) {
		if(currentPageNo === undefined){
			currentPageNo = "1";
		}
		
		$("#current_page_no").val(currentPageNo);
		
		var searchType = $("#searchType").val();
		if(searchType == 4) {
			if($("#trouble_cd").val() == "" || $("#trouble_cd").val() == null) {
				alert("고장상태을 선택하세요.");
				$("#trouble_cd").focus();
				return;
			}
		}
		else if(searchType == 5) {
			if($("#progress_status").val() == "" || $("#progress_status").val() == null) {
				alert("처리상태를 선택하세요.");
				$("#progress_status").focus();
				return;
			}
		}
		
		if(orderNm == undefined && order == undefined) {
			$(".sortable").removeClass("order-asc");
			$(".sortable").removeClass("order-desc")
		}
		else {
			$("#orderNm").val(orderNm);
			$("#order").val(order);
		}
		
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
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+formatContactNumber(list[i].contact)+" </a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].repair_date+" </a></span></td>";
					if(list[i].progress_status == "01") {
						btnStr = "<span><a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")' class='btn_red'>신고접수</a></span>";
					}
					else if(list[i].progress_status == "02" || list[i].progress_status == "03") {
						btnStr = "<span><a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")' class='btn_orange'>작업지시</a></span>";
					}
					else if(list[i].progress_status == "04" || list[i].progress_status == "05") {
						btnStr = "<span><a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")' class='btn_blue02'>보수완료</a></span>";
					}
					str += "	<td style='text-align: center;'> "+btnStr+" </td>";
					str += "</a></tr>";
				}
				
				var summaryChildNodes = $("#summary").find('td');
				var key = "";
				summaryChildNodes.eq(0).find(".red02").text(totalCount+"건");
				for(var i=0; i<summaryChildNodes.size(); i++) {
					key = "status0"+(i+1)+"Cnt";
					statusCnt = data[key];
					summaryChildNodes.eq(i).find(".red02").text(statusCnt+"건");
				}
			}
			else {
				str += "<tr>";
				str += "	<td colspan='10' style='text-align: center;'>등록된 글이 존재하지 않습니다.</td>";
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
					if(key == "contact") {
						$("#"+element).text(formatContactNumber(data[key]));
					}
					else {
						$("#"+element).text(data[key]);
					}
				}
				
				if(key == "repair_no") {
					$("#repairNo").val(data['repair_no'].trim());
				}
			}
		}
		
		modalPopupCallback( function() {
			modal_popup2('messagePop2');
			$("#password").focus();
		});
		
	}
	
	function modalPopupCallback(fnNm) {
		fnNm();
	}
	
	function chkComplaint(flag) {
		if($("#password").val() == null || $("#password").val() == "") {
			alert("비밀번호를 입력하세요.");
			
			return;
		}
		
		if(flag == "D") {
			deleteComplaint();
		}
		else {
			$("#detailForm").attr({action:'/complaint/complaintDet'}).submit();
		}
	}
	
	function getComplaintDet() {
		<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS','ROLE_USER')">
			if($("#password").val() == null || $("#password").val() == "") {
				alert("비밀번호를 입력하세요.");
				
				return;
			}
			else {
				$("#detailForm").attr({action:'/complaint/complaintDet'}).submit();
			}
		</sec:authorize>
		<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
			$("#detailForm").attr({action:'/complaint/complaintDet'}).submit();
		</sec:authorize>
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
						<li><a href="/company/companyRepair" >보수내역관리</a></li>
						<li><a href="/info/infoServicesList">이용안내</a></li>
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
			<input type="hidden" id="order" name="order" value="" />
			<input type="hidden" id="orderNm" name="orderNm" value="" />
			<div id="search_box">
				<ul class="inform_num">
					<li>
						<table align="center" cellpadding="0" cellspacing="0">
							<tbody id="summary">
								<tr>
									<td>
										<span class="black07">총건수</span>
										<span class="red02">0건</span>
									</td>
									<td>
										<span class="black07">신고접수</span>
										<span class="red02">0건</span>
									</td>
									<td>
										<span class="black07">작업지시</span>
										<span class="red02">0건</span>
									</td> 
									<td>
										<span class="black07">보수완료</span>
										<span class="red02">0건</span>
									</td>
									<td>
										<span class="black07">일일신고접수</span>
										<span class="red02">0건</span>
									</td>
								</tr>
							</tbody>
						</table>
					</li>
				</ul>
				<ul>
					<li class="title">등록일</li>
					<li>
						<input type="text" id="sDate" name="sDate" class="tbox02" readonly="readonly">
						~ 
						<input type="text" id="eDate" name="eDate" class="tbox02" readonly="readonly">
					</li>
					<li class="pdl10">
						<select class="sel01" id="light_gubun" name="light_gubun">
						</select>
					</li>
					<li>
						<select class="sel01" id="searchType" name="searchType">
							<option selected value="">전체</option>
							<option value="1">신고인</option>
							<option value="2">주소</option>
							<option value="3">관리번호</option>
							<option value="4">고장상태</option>
							<option value="5">처리상태</option>
						</select>
					</li>
					<li><input type="text" name="keyword" id="keyword" class="tbox03_gray" readonly="readonly"></li>
					<li>
						<select id="trouble_cd" name="trouble_cd" class="sel01">
						</select>
					</li>
					<li>
						<select id="progress_status" name="progress_status" class="sel01">
						</select>
					</li>
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
						<th class="sortable" onclick="sortEvent(this)"><p class="tt">접수번호 <span class="tt-text">클릭 시 접수번호에 따라 정렬순서 변경</span></p></th>
						<th>신고구분</th>
						<th class="sortable" onclick="sortEvent(this)"><p class="tt">접수일<span class="tt-text">클릭 시 접수일에 따라 정렬순서 변경</span></p></th>
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
				<div class="pop_detail2 ">
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
									<td><span id="det_trouble_detail"></span></td>
								</tr>
								<tr>
									<th>보수처리일</th>
									<td><span id="det_repair_date"></span></td>
									<th>처리결과회신</th>
									<td><span id="det_inform_method_nm"></span></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div id="btn">
						<p>
						<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
							<span><a href="#" onclick="javascript:getComplaintDet()" class="btn_gray02">수정</a></span>
						</sec:authorize>
						<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS','ROLE_USER')">
							<span><a href="#" onclick="modal_popup5('messagePop5');return false;" class="btn_gray02">수정</a></span>
						</sec:authorize>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--//결과조회 상세 Popup-->

<!--비밀번호 Popup-->
<div class="modal-popup5">
	<div class="bg"></div>
	<div id="messagePop5" class="pop-layer4">
		<div class="pop-container">
			<div class="pop-conts">
				<div class="btn-r">
					<a href="#" class="cbtn"><i class="fa fa-times" aria-hidden="true"></i><span class="hide">Close</span></a>
				</div>
				<form id="detailForm" name="detailForm" method="post" action="">
					<input type="hidden" id="repairNo" name="repairNo" />
					<div class="pop_pw">
						<p>
							<h3>비밀번호</h3>
							<input type="password" name="password" id="password" class="tbox12">
							<span ><a href="javascript:getComplaintDet()" class="btn_blue03" >확인</a></span>
						</p>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<!--//비밀번호_Popup-->