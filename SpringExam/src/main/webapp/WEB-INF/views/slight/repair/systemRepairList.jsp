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
		var repair_cd = "${param.repair_cd}";
		
		//drawCodeData(리스트, 코드타입, 태그이름, 모드, 현재선택코드)
		drawCodeData(commonCd, "13", "select", "ALL", lightGubun).then(function(resolvedData) {
			$("#light_gubun").empty();
			$("#light_gubun").append(resolvedData);
			
		})
		
		drawCodeData(commonCd, "14", "select", "ALL", repair_cd).then(function(resolvedData) {
				$("#repair_cd").empty();
				$("#repair_cd").append(resolvedData);
		})
						
		.then(function() {
			
			$("#searchCom").parents("li").hide();
			
			if(pageNo != "" && pageNo != null) {
				Search(pageNo);
			}
			else {
				Search();
			}
		});
		
		$("#searchType").change(function() {
			var searchType = $(this).val();
			
			if(searchType == "") {
				$("#keyword").val("");
				$("#keyword").show();
				$("#keyword").addClass("tbox03_gray");
				$("#keyword").attr("readonly", true);
				$("#searchCom").parents("li").hide();
			}
			else if(searchType == 1 || searchType == 2 || searchType == 3 || searchType == 4) {
				$("#keyword").val("");
				$("#keyword").show();
				$("#keyword").removeClass("tbox03_gray");
				$("#keyword").addClass("tbox03");
				$("#keyword").attr("readonly", false);
				$("#searchCom").parents("li").hide();
			}
			else if(searchType == 5) {
				$("#keyword").val("");
				$("#keyword").hide();
				$("#searchCom").parents("li").show();
			}
		});	
		
		$("#searchCom").change(function() {
			Search();
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
			var btnStr1 = "";
			var btnStr2 = "";			
			
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
					str += "	<td style='text-align: center;'><span> "+list[i].progress_name+" </span></td>";							
					if(list[i].progress_status == "01") {
						btnStr = "<span><a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")' class='btn_orange'>작업지시</a></span>";
					}
					else if(list[i].progress_status == "02" || list[i].progress_status == "03") {
						btnStr = "<span><a href='javascript:updateRepairCancel(\""+list[i].repair_no+"\")' class='btn_red'>작업지시취소</a></span>";						
					}
					else if(list[i].progress_status == "04" || list[i].progress_status == "05") {
						btnStr = "<span><a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")' class='btn_blue02'>재작업지시</a></span>";								
					}
					str += "	<td style='text-align: center;'> "+btnStr+" </td>";
					if(list[i].progress_status == "04") {
						btnStr1 = "<span><a onclick=\"modal_popup4('messagePop4');return false;\" class='btn_gray03'>수리내역</a></span>";						
					}	
					str += "	<td style='text-align: center;'> "+btnStr1+" </td>"; //					
					if(list[i].progress_status == "04") {
						btnStr2 = "<span><a onclick=\"modal_popup4('messagePop4');return false;\" class='btn_gray03'>사진대지</a></span>";					
					}
					str += "	<td style='text-align: center;'> "+btnStr2+" </td>"; //					
					str += "</tr>";
				}
			}
			else {
				str += "<tr>";
				str += "	<td colspan='12' style='text-align: center;'>등록된 글이 존재하지 않습니다.</td>";
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
		
		if(data != null){
			for(var key in data){
				$("#"+key).val(data[key]);
			}

//			alert("data['progress_status']:::"+data['progress_status']);
//			alert("data['light_no']:::"+data['light_no']);
//			alert("data['repair_no']:::"+data['repair_no']);

			frm1.repair_no.value = data['repair_no'];
			frm1.light_no.value = data['light_no'];

//			작업지시 건 여부
			if(data['repair_no1'] == "" || data['repair_no1'] == null) {
//			if(data['progress_status'] == "01") {
				$("#saveFlag").val("I");					
			} else {
				$("#saveFlag").val("U");				
			}
		
		}
		
		modalPopupCallback( function() {
			modal_popup4('messagePop4');
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
	
	function excelAllDownload() {
		var currentRow = $("#board_list_AllExcel > table > thead> tr > th").length;
		var headerArr = new Array();
		
		for(i=0; i<currentRow; i++) {
			headerArr.push($("#board_list_AllExcel > table > thead> tr").find("th:eq("+i+")").text());
		}
		
		var f = document.slightForm;
		f.method = "POST";
		f.action = "${contextPath}/repair/downloadExcel";
		f.excelHeader.value = headerArr;
		f.submit();
	}

	function excelAllDownload1() {
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
	
	function Save() {
//		alert("11111");
		validation(saveSubmit);		
	};
	
	function validation(callback) {
//		alert("22222");		
		if($("#searchCom1").val() == "" || $("#searchCom1").val() == null) {
			alert("업체를 선택하세요.");
			return;
		}
		
		/* $("th > span.t_red").each(function(index, item) {
			header = $(item).parent().text();
			header = header.substring(0, (header.length - 1));
			value = $(item).parent().next().children().val();
			if(typeof value == "undefined") {
				value = $(item).parent().next().text();
			}
			
			if(value == "" || value == null) {
				alert(header+msg);
				chk = false;
				return;
			}
			
		}); */
		
		/* var filesChk = $("input[name=files]").val();
		if(filesChk == "") {
			$("input[name=files]").remove();
		} */
		
		callback(function(){});
	}	
	
	function saveSubmit() {
			
		var yn = confirm("작업지시를 하시겠습니까?");
		if(yn){
			/*	$("#frm1").ajaxForm({
				url : "/repair/updateRepair"
				, enctype : "multipart/form-data"
				, cache : false
				, async : true
				, type	: "POST"
				, success : function(obj) {
					updateRepairCallback(obj);
				}
				, error 	: function(xhr, status, error) {}
			}).submit(); */
			
			$.ajax({
				type : "POST"			
				, url : "/repair/updateRepair"
				, data : $("#frm1").serialize()
				, dataType : "JSON"
				, success : function(obj) {
					updateRepairCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});			
			
		}
	}
	
	function updateRepairCallback(obj) {
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("작업지시가 완료되었습니다.");
				$('.modal-popup2 .bg').trigger("click");
				Search(); // goToList();
			}
			else {
				alert("오류가 발생했습니다.");	
				return;
			}
		}
	}

	function updateRepairCancel(repairNo){

		var yn = confirm("작업지시 취소를 하시겠습니까?");
		if(yn) {
			
			$.ajax({
				type : "POST"			
				, url : "/repair/updateRepairCancel"
				, data : {"repairNo":repairNo}
				, dataType : "JSON"
				, success : function(obj) {
					updateRepairCancelCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});						
		}			
	}
	
	function updateRepairCancelCallback(obj){
		
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("작업지시 취소가 완료되었습니다.");
				Search(); // goToList();
			}
			else {
				alert("오류가 발생했습니다.");	
				return;
			}
		}
		
	}
	
	function goToList() {
		var frm = document.slightForm;
		frm.action = '/repair/getSystemRepairList';
		frm.method ="post";
		frm.submit();
		//$("#slightForm").attr({action:'/equipment/securityLight'}).submit();
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
					<!--<li class="pdl10">
						<select class="sel01" id="light_gubun" name="light_gubun">
						</select>
					</li>-->
					<li class="pdl10">
						<select class="sel01" id="repair_cd" name="repair_cd">						
						</select>
					</li>
					<li>
						<select class="sel01" id="searchType" name="searchType">
							<option selected value="">전체</option>
							<option value="1">신고인</option>
							<option value="2">주소</option>
							<option value="3">새주소</option>							
							<option value="4">관리번호</option>
							<option value="5">시공업체</option>
						</select>
					</li>
					<!-- <li>
						<select class="sel01">
							<option selected>검색조건</option>
							<option>관리번호</option>
							<option>이메일주소</option>
						</select>
					</li> -->
					<li><input type="text" name="keyword" id="keyword" class="tbox03_gray" readonly="readonly"></li>
					<li><!-- 시공업체 선택시 사용  -->
						<select id="searchCom" name="searchCom" class="sel01">
							<c:forEach items="${searchComInfo}" var="cominfo">
								<option value="">선택</option>							
								<option value="${cominfo.member_id }">${cominfo.com_name }</option>
							</c:forEach>
						</select>
					</li>					
					<li><a href="javascript:Search()"  class="btn_search01">검 색</a></li>
				</ul>
			</div>
		</form>
		<div id="toptxt">
			<ul>
				<li><span class="black03">총개수: 0개</span></li>
				<li class="b_right"><span ><a href="javascript:excelAllDownload1()" class="btn_gray03">전체수리내역</a></span></li>
				<!--<li class="b_right"><span ><a href="javascript:excelAllDownload1()" class="btn_gray03">전체 진대지 다운로드</a></span></li>-->				
			</ul>
		</div>
		
		<div id="board_list">
			<table summary="보수이력관리목록" cellpadding="0" cellspacing="0">
				<caption>접수번호,민원종류,관리번호,신고인,전화번호,접수일,지시일,보수일,처리상황,작업지시,수리내역,사진대지</caption>
				<colgroup>
					<col width="9%">
					<col width="10%">
					<col width="9%">
					<col width="8%">
					<col width="9%">
					<col width="8%">
					<col width="8%">
					<col width="8%">
					<col width="7%">
					<col width="8%">
					<col width="8%">
					<col width="8%">										
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
						<th>작업지시</th>
						<th>수리내역</th>
						<th>사진대지</th>						
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

<!-- 보수이력관리 전체수리내역 엑셀 -->
<div id="board_list_AllExcel">
	<table summary="보수이력관리 전체수리내역 엑셀" cellpadding="0" cellspacing="0">
		<caption>접수번호,민원종류,관리번호,신고인,지번주소,도로명주소,전화번호,접수일,지시일,보수일,고장상태,처리상황,시공업체,수리내역</caption>
		<colgroup>
			<col width="7%">
			<col width="7%">
			<col width="7%">
			<col width="7%">
			<col width="8%">
			<col width="8%">			
			<col width="7%">					
			<col width="7%">
			<col width="7%">
			<col width="7%">			
			<col width="7%">
			<col width="7%">
			<col width="7%">
			<col width="7%">										
		</colgroup>
		<thead>
			<tr>
				<th>접수번호</th>
				<th>민원종류</th>
				<th>관리번호</th>
				<th>신고인</th>
				<th>지번주소</th>
				<th>도로명주소</th>				
				<th>전화번호</th>
				<th>접수일</th>
				<th>지시일</th>
				<th>보수일</th>
				<th>고장상태</th>				
				<th>처리상황</th>
				<th>시공업체</th> 
				<th>수리내역</th>
			</tr>
		</thead>
		<tbody id="tbody">
		</tbody>
	</table>
</div>

<!-- -->
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
<!-- -->

<!-- 작업지시 -->
<div class="modal-popup4">
	<div class="bg"></div>
	<div id="messagePop4" class="pop-layer3">
		<div class="pop-container">
			<div class="pop-conts">
				<div class="btn-r">
					<a href="#" class="cbtn"><i class="fa fa-times " aria-hidden="true"></i><span class="hide">Close</span></a>
				</div>
				<div class="pop_system ">
					<div id="board_view3">
						<h3>보수이력관리 작업지시</h3>
						<form name="frm1" id="frm1" method="post">
							<input type="hidden" id="saveFlag" name="saveFlag" value="">
							<input type="hidden" name="repair_no" value="">
							<input type="hidden" name="light_no" value="">
							<!-- 텍스트컬러- 고장신고-blue 고장상태-red -->
							<table summary="보수이력관리 작업지시" cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="14%">
									<col width="36%">
									<col width="14%">
									<col width="36%">
								</colgroup>
								<tbody>
									<tr>
										<th>업체</th>
										<td colspan="3"><span class="">
										<select id ="searchYear" name="searchYear" class="sel01">
										<c:forEach items="${searchYearList}" var="year">
											<option value="${year.year }">${year.year }년</option>
										</c:forEach>
										</select>
										<select id="searchCom1" name="searchCom1" class="sel01">
											<option value="">선택</option>
										<c:forEach items="${searchComInfo}" var="cominfo">									
											<option value="${cominfo.member_id }">${cominfo.com_name }</option>
										</c:forEach>
										</select>
										</span></td>
									</tr>
									<tr>
										<th>작업지시사항</th>
										<td colspan="3">
											<span><input type="text" name="remark_etc" id="remark_etc" class="tbox03"></span>
											<span><a href="javascript:Save()" class="btn_search01">지시 </a></span>											
										</td>
									</tr>
								</tbody>
							</table>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--//작업지시 -->

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
