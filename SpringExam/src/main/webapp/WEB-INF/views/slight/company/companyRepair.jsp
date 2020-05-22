<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};

	$(function(){
		var pageNo = "${param.current_page_no}";
		var repairCd = "${param.repair_cd}";
		var paramSDate = "${param.sDate}";
		var paramEDate = "${param.eDate}";
		
	
		
		//drawCodeData(리스트, 코드타입, 태그이름, 태그ID, 모드, 현재선택코드)
		drawCodeData(commonCd, "14", "select", "ALL", "", repairCd).then(function(resolvedData) {
			$("#sch_repair_cd").empty();
			$("#sch_repair_cd").append(resolvedData);
			
		})			
		
		.then(function() {
			if(pageNo != "" && pageNo != null) {
				Search(pageNo);
			}
			else {
				Search();
			}
		});
		
		$("#sch_where2").hide();
		
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
			, url : "/company/getCompanyRepairList"
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
			//접수번호,민원종류,관리번호,신고인,전화번호,접수일,보수일,처리상황
			if(listLen > 0) {
				for(i=0; i<listLen; i++) {
					str += "<tr>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].repair_no2+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].repair_name+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].light_no+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].notice_name+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].phone+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].notice_date+" </a></span></td>";
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
			$("#toptxt .black03").text("총개수: "+totalCount+"개");
			$("#pagination").html(pagination);
		}
	}
	
	function getRepairDetail(repairNo) {
		$("#repairNo").val(repairNo);
		$.ajax({
			type : "POST"			
			, url : "/company/getCompanyRepairDetail"
			, data : {"repairNo":repairNo}
			, dataType : "JSON"
			, success : function(obj) {
				getSearchDetailCallback(obj);
			}
			, error : function(xhr, status, error) {
				
			}
		});
		
	}
	
	function getSearchDetailCallback(obj) {
		var data = obj.resultData;
		
		var photo1 = "";
		var photo2 = "";
		var photo3 = "";
				
		if(data != null) {
			var key, element, repairRst = "";
			var repairList = {};
			for(key in data) {
				//alert("key : "+key +"      data : "+ data);
				element = "det_"+key;
				if($("#"+element).length > 0) {
					$("#"+element).text(data[key]);
				}
				
				if($("#"+key).length > 0) {
					$("#"+key).val(data[key]);
				}
				
				
			}
		}
		
		if(data['downLoadFiles'] != null && data['downLoadFiles'] != "") {
			var downLoadFiles = data['downLoadFiles'];
			var filePah = "";
			alert("다운파일2341 : " + downLoadFiles.length+ 1);
			for(i = 0; i<downLoadFiles.length; i++) {
				
				filePah = downLoadFiles[i].file_path+"/"+downLoadFiles[i].file_name_key;
				//$("#detail_slight").children().eq(i).children("img").attr("src", filePah)
				
				
				//alert("#### : " +downLoadFiles[i].file_no);
				
				$("#detail_slight"+i).attr("src", filePah)
			}
		}
		else {
			alert("3");
			for(i = 0; i<$("#detail_slight").children().size(); i++) {
				$("#detail_slight").children().eq(i).children("img").attr("src", "/resources/css/images/sub/slight_noimg.gif");
			}
		}
		
		
		
		modalPopupCallback( function() {
			modal_popup2('messagePop2');
		});
		
		
		
			
		
		
			
	}
	
	function modalPopupCallback(fnNm) {
		fnNm();
	}

	
	function excelDownload() {
		var currentRow = $("#board_list > table > thead> tr > th").length;
		var headerArr = new Array();
		for(i=0; i<currentRow; i++) {
			headerArr.push($("#board_list > table > thead> tr").find("th:eq("+i+")").text());
		}
		
		var f = document.slightForm;
		f.method = "POST";
		f.action = "${contextPath}/company/downloadExcel";
		f.excelHeader.value = headerArr;
		f.submit();
	}
	
	function onDisplay(val)
	{
			
		if(val == "" ||val == "0" || val=="1" || val=="3" || val=="5") {

			$("#sch_where2").hide();
			$("#sch_where3").show();
			
		} else if (val=="4") {


			$("#sch_where2").show();
			$("#sch_where3").hide();
			
			drawCodeData(commonCd, "03", "select", "ALL", "", "").then(function(resolvedData) {
				$("#sch_where2").empty();
				$("#sch_where2").append(resolvedData);
				
			})
			
		}else if (val=="6") {

			
			$("#sch_where2").show();
			$("#sch_where3").hide();
			
			drawCodeData(commonCd, "06", "select", "ALL", "", "").then(function(resolvedData) {
				$("#sch_where2").empty();
				$("#sch_where2").append(resolvedData);
				
				
				
			})
		}else if(val=="2") {			
			$("#sch_where2").show();
			$("#sch_where3").hide();
			
			$("#sch_where2").empty();
		}
			
		
	}
	
	function goToMod() {
		var frm = document.slightForm;
		frm.action = '/company/companyRepairMod';
		frm.method ="post";
		frm.submit();
	};
	

</script>
<div id="container">
	<!-- local_nav -->
	<div id="local_nav_area">
		<div id="local_nav">
			<ul class="smenu">
				<li><a href="#" ><img src="/resources/css/images/sub/icon_home.png" alt="HOME" /></a></li>
				<li><a href="#" >기본정보관리 <img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
					<ul>
						<li><a href="/trouble/trblReportList">고장신고</a></li>
						<li><a href="/complaint/complaintList" >민원처리결과조회</a></li>
						<li><a href="/equipment/securityLightList" >기본정보관리</a></li>
						<li><a href="/repair/systemRepairList">보수이력관리</a></li>
						<li><a href="/company/companyRepair" >보수내역관리</a></li>
						<li><a href="#">이용안내</a></li>
					</ul>
				</li>
				<li><a href="#">정보변경 <img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
					<ul>
						<li><a href="/company/companyRepair">보수내역관리</a></li>
						<li><a href="/company/companyInfo">정보변경</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="sub">
		<div id="sub_title"><h3>보수내역입력</h3></div>
		<!-- 검색박스 -->
		<form id="slightForm" name="slightForm" method="post" action="">
		<input type="hidden" id="excelHeader" name="excelHeader" value="" />
		<input type="hidden" id="repairNo" name="repairNo" value="">
			<input type="hidden" id="function_name" name="function_name" value="Search" />
			<input type="hidden" id="current_page_no" name="current_page_no" value="1" />
			<div id="search_box">
				<ul>
					<li class="title">접수일</li>
					<li>
						<input type="text" id="sDate" name="sDate" class="tbox02">
						~ 
						<input type="text" id="eDate" name="eDate" class="tbox02">
					</li>
					<li class="pdl10">
						<select class="sel01" id="sch_repair_cd" name="sch_repair_cd">
						</select>
					</li>
					<li>
						<select class="sel01" id="sch_where1" name="sch_where1" onchange="onDisplay(this.value)">
							<option value = "0">전체</option>
							<option value = "5">신고인</option>
							<option value = "1">관리번호</option>
							<option value = "4">처리상황</option>
							<option value = "6">동명</option>
							<option value = "2">시공업체</option>
						</select>
					</li>
					<li class="pdl10">
						<select class="sel01" id="sch_where2" name="sch_where2"  >
						</select>
					</li>
					<li><input type="text" id="sch_where3" name="sch_where3" class="tbox03"></li>
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
				<caption>접수번호,민원종류,관리번호,신고인,전화번호,접수일,보수일,처리상황</caption>
				<colgroup>
					<col width="10%">
					<col width="11%">
					<col width="12%">
					<col width="11%">
					<col width="11%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th>접수번호</th>
						<th>민원종류</th>
						<th>관리번호</th>
						<th>신고인</th>
						<th>전화번호</th>
						<th>접수일</th>
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
<form id="slightDetailForm" name="slightDetailForm" method="post" action="">
<div class="modal-popup2">
	<div class="bg"></div>
	<div id="messagePop2" class="pop-layer">
		<div class="pop-container">
			<div class="pop-conts">
				<div class="btn-r">
					<a href="#" class="cbtn"><i class="fa fa-times " aria-hidden="true"></i><span class="hide">Close</span></a>
				</div>
				<div class="pop_detail2 ">
					<h3>보수내역 상세조회</h3>
					<div id="board_view">
						<!-- 텍스트컬러- 고장신고-blue 고장상태-red -->
						<table summary="보수내역현황목록" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="14%">
								<col width="36%">
								<col width="14%">
								<col width="36%">
							</colgroup>
							<tbody>
							<tr>
							</tr>
							<tr>
									<th>관리번호</th>
									<td colspan="3"><span id="det_light_no"></span></td>
								</tr>
								<tr>
									<th>주소</th>
									<td colspan="3"><span id="det_location"></span></td>
								</tr>
								
								<tr>
								<th>지지방식</th>
								<td><span id="det_stand_cd_nm"></span></td>
								<th>등기구 형태</th>
								<td><span id="det_lamp1_cd_etc"></span></td>
								</tr>
								
								<tr>
								<th>광원종류</th>
								<td><span id="det_lamp2_cd_nm"></span></td>
								<th>꽝원용량</th>
								<td><span id="det_lamp3_cd_nm"></span></td>
								</tr>
								
								<tr>
								<th>점 멸 기</th>
								<td colspan="3"><span id="det_onoff_cd_nm"></span></td>
								</tr>
								
								<tr>
								<th>신고구분</th>
								<td><span id="det_repair_nm"></span></td>
								<th>작업구분</th>
								<td><span id="det_repair_gubun_nm"></span></td>
								</tr>
								
								<tr>
								<th>고장상태</th>
								<td><span id="det_trouble_nm"></span></td>
								<th>상태설명</th>
								<td><span id="det_trouble_detail"></span></td>
								</tr>
								
								<tr>
								<th>접 수 일</th>
								<td><span id="det_repair_date"></span></td>
								<th>작업지시일</th>
								<td><span id="det_modify_date"></span></td>
								</tr>
								
								<tr>
								<th>보 수 일</th>
								<td><span id="det_last_update"></span></td>
								<th>처리상황</th>
								<td><span id="det_remark"></span></td>
								</tr>
								
								<tr>
								<th>신 고 인</th>
								<td><span id="det_notice_name"></span></td>
								<th>전화번호</th>
								<td><span id="det_phone"></span></td>
								</tr>
								
								<tr>
								<th>이 메 일</th>
								<td><span id="det_email"></span></td>
								<th>휴대폰번호</th>
								<td><span id="det_mobile"></span></td>
								</tr>
								
								<tr>
								<th>처리결과 회신</th>
								<td><span id="det_inform_nm"></span></td>
								<th>공사업자</th>
								<td><span id="det_com_name"></span></td>
								</tr>
								
								<tr>
								<th>작업지시사항</th>
								<td colspan="3"><span id="det_remark_etc"></span></td>
								</tr>
								<tr>
								<th>비고</th>
								<td colspan="3"><span id="det_repair_bigo"></span> </td>
								</tr>
								
								
								
								<tr>
									<th>진행상황</th>
									<td colspan="3"><span id="det_progress_status_nm"> </span>	</td>
								</tr>
								
								<tr>
								<th>보수내역</th>
								<td colspan="3"><span id="det_repair_desc"> </span></td>
								</tr>
								
								
																
								
							</tbody>
						</table>
						<table id = "detail_slight">
						<colgroup>
								<col width="14%">
								<col width="86%">
							</colgroup>
						<tbody >
							<tr>
							<th>보수전사진</th>
							<td><img id = "detail_slight0" src="/resources/css/images/sub/slight_noimg.gif" width="250" height="200"></td>
							</tr>
							<tr>
							<th>보수중사진</th>
							<td><img id = "detail_slight1" src="/resources/css/images/sub/slight_noimg.gif" width="250" height="200"></td>
							</tr>
							<tr>
							<th>보수후사진</th>
							<td><img id = "detail_slight2" src="/resources/css/images/sub/slight_noimg.gif" width="250" height="200"></td>
							</tr>						
					</tbody>
						</table>
					<div id="btn">
						<p>
						<span><a href="#"  class="btn_gray02">닫기</a></span>
						<span><a href="javascript:goToMod()"  class="btn_gray02">수정</a></span>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</form>
<!--//결과조회 상세 Popup-->
