<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};

	$(function(){	
		
		Search("1");
	});
	
	function Search(currentPageNo) {
		
		
		if(currentPageNo === undefined){
			currentPageNo = "1";
		}
		
		$("#current_page_no").val(currentPageNo);
		
		$.ajax({
			type : "POST"			
			, url : "/info/getInfoNoticeList"
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
		slightDetailForm.reset();
		
		
		var state = obj.state;
		if(state == "SUCCESS"){
			var data = obj.data;			
			var list = data.list;
			var listLen = list.length;		
			var totalCount = data.totalCount;
			var pagination = data.pagination;
			
			
			var str = "";
			var btnStr = "";
			//자재번호,자재명,업체명,자재규격,자재단가,내구현황,비고
			if(listLen > 0) {
				for(i=0; i<listLen; i++) {
					str += "<tr>";
					str += "	<td><span> <a href='javascript:getMaterialDetail(\""+list[i].data_code+"\", \""+list[i].company_id+"\")'>"+list[i].data_code+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getMaterialDetail(\""+list[i].data_code+"\", \""+list[i].company_id+"\")'>"+list[i].data_code_name+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getMaterialDetail(\""+list[i].data_code+"\", \""+list[i].company_id+"\")'>"+list[i].company_id+"</a></span></td>";
					str += "</a></tr>";
				}
			}
			else {
				str += "<tr>";
				str += "	<td colspan='3' style='text-align: center;'>등록된 글이 존재하지 않습니다.</td>";
				str += "</tr>";
			}
			
			$("#tbody").html(str);
			$("#toptxt .black03").text("총개수: "+totalCount+"개");
			$("#pagination").html(pagination);
		}
	}
	
	function getMaterialDetail(dataCode, company_id) {
		$("#dataCode").val(dataCode);
		$.ajax({
			type : "POST"			
			, url : "/info/getInfoNoticeDetail"
			, data : {"dataCode":dataCode, "sch_year":$("#sch_year").val(), "company_id":company_id}
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
		
		var comp_nm_temp = "";
		
		if(data != null) {
			
			var obj1 = $("#slightDetailForm").serializeArray();
			
			for(i=0; i<obj1.length; i++) {
				for(var key in data){
					//alert("obj1[i].name : "+obj1[i].name + "    key : "+key);
					if(key == obj1[i].name) {
						if(key == "company_id")
						{
							comp_nm_temp = data[key];
						}
					//alert(data[key]);
						$("#"+key).val(data[key]);
						//console.log(key+" : "+data[key]);
																		
					} 
				}
			}

			$("#tbodyKey").show();
			$("#new").hide();
			$("#update").show();
			$("#delete").show();

			$("#flag").val("U");
			
			searchCompany($("#sch_year").val(), $("#company_id"), comp_nm_temp);
			
		}
		
		modalPopupCallback( function() {
			modal_popup2('messagePop2');
		});
			
	}
	
	function modalPopupCallback(fnNm) {
		fnNm();
	}
	
	function doNew() {
		
		slightDetailForm.reset();
		
		$("#tbodyKey").hide();
		$("#new").show();
		$("#update").hide();
		$("#delete").hide();
		
		$("#flag").val("I");
		
		searchCompany($("#sch_year").val(), $("#company_id"), "");
		
		
		modalPopupCallback( function() {
			modal_popup2('messagePop2');
		});
	}
	
	
function doDel() {
	
	
	$("#flag").val("D");

	doSave();	
}

function doUpdate() {
	
	
	$("#flag").val("U");

	doSave();	
}
	
	
	function doSave() {
		var yn = "";		
		
		
		if($("#flag").val() == "I")
			{
				if($("#data_code_name").val() == "" || $("#data_code_name").val() == null) {
					$("#data_code_name").focus();
					alert("자재명을 입력하세요.");
					return;
				}
				
				yn = confirm("자재정보를 등록하시겠습니까?");
			}else if($("#flag").val() == "U")
			{
				if($("#data_code_name").val() == "" || $("#data_code_name").val() == null) {
					$("#data_code_name").focus();
					alert("자재명을 입력하세요.");
					return;
				}
				
				yn = confirm("자재정보를 수정하시겠습니까?");
			}else if($("#flag").val() == "D")
			{
				yn = confirm("자재정보를 삭제하시겠습니까?");
			}
		
		
		var obj = $("#slightDetailForm").serializeArray();
		var json = {};
		
		for(i=0; i<obj.length; i++) {
			json[obj[i].name] = obj[i].value;
			
		}
		
		if(yn){
			$("#slightForm").ajaxForm({
					type : "POST"			 
					, url : "/info/updateInfoNotice"
					, data : json
					, dataType : "JSON"
				, success : function(obj) {
					updateSystemMaterialCallback(obj);
				}
				, error 	: function(xhr, status, error) {}
			}).submit();
		}
		
	};
	
	function updateSystemMaterialCallback(obj) {
		if(obj != null) {
			
			if($("#flag").val() == "I")
			{
				
				if(obj.resultCnt > -1) {
					alert("등록을 성공하였습니다.");
					popupClose();
					Search();
				}
				else {
					alert("등록을 실패하였습니다.");	
					return;
				}
				
			}else if($("#flag").val() == "U")
			{
				
				if(obj.resultCnt > -1) {
					alert("수정을 성공하였습니다.");
					popupClose();
					Search();
				}
				else {
					alert("수정을 실패하였습니다.");	
					return;
				}
				
			}else if($("#flag").val() == "D")
			{
				
				if(obj.resultCnt > -1) {
					alert("삭제를 성공하였습니다.");
					Search();

					popupClose();
				}
				else {
					alert("삭제를 실패하였습니다.");	
					return;
				}
				
			}
			
		}
	}
		
	
function searchCompany(st_yy, ele,sel) {
		
		$.ajax({
			type : "POST"			
			, url : "/equipment/getCompanyId"
			, data : {"searchYear" : st_yy}
			, dataType : "JSON"
			, success : function(obj) {
				var option = "<option value=''>선택</option>";
				for(i=0; i<obj.resultData.length; i++) {
					
					if(obj.resultData[i].data_code == sel) {
						option += "<option value='"+obj.resultData[i].data_code+"' selected>"+obj.resultData[i].data_code_name+"</option>";
					}
					else {
						option += "<option value='"+obj.resultData[i].data_code+"'>"+obj.resultData[i].data_code_name+"</option>";
					}
				}
				
				$(ele).html(option);
			}
			, error : function(xhr, status, error) {
				
			}
		});
	}


function popupClose() {
	
	$('.modal-popup2').fadeOut();
}
	

</script>
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
				<li><a href="#">공지사항<img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
					<ul>
						<li><a href="/info/infoServicesList">서비스 소개</a></li>
						<li><a href="/info/infoReportList">이용안내</a></li>
						<li><a href="/info/infoNoticeList" >공지사항</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="sub">
		<div id="sub_title"><h3>공지사항</h3></div>
		<!-- 검색박스 -->
		<form id="slightForm" name="slightForm" method="post" action="">
		<input type="hidden" id="dataCode" name="dataCode" value="">
			<input type="hidden" id="function_name" name="function_name" value="Search" />
			<input type="hidden" id="current_page_no" name="current_page_no" value="1" />
			<div id="search_box">
				<ul>
					<li class="title">공지년도</li>
					<li>
					<select id="sch_year" name="sch_year" class="sel01" onchange='javascript:Search("1")'  >
						<c:forEach items="${searchYearList}" var="year">
							<option value="${year }">${year }년</option>
						</c:forEach>
					</select>
					
					<li><a href="javascript:Search()"  class="btn_search01">검 색</a></li>
				</ul>
			</div>
		</form>
			<div id="toptxt">
			<ul>
				<li><span class="black03">총개수: 0개</span></li>				
				<!--li class="b_right"><span ><a href="javascript:doNew()" class="btn_gray03">등록</a></span></li-->							
			</ul>
		</div>
		<div id="board_list">
			<table summary="자재목록" cellpadding="0" cellspacing="0">
				<caption>번호,제목,작성일</caption>
				<colgroup>
					<col width="10%">
					<col width="70%">
					<col width="20%">
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>작성일</th>
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
		<input type="hidden" id="flag" name="flag" value="">
<div class="modal-popup2">
	<div class="bg"></div>
	<div id="messagePop2" class="pop-layer">
		<div class="pop-container">
			<div class="pop-conts">
				<div class="btn-r">
					<a href="#" class="cbtn"><i class="fa fa-times " aria-hidden="true"></i><span class="hide">Close</span></a>
				</div>
				<div class="pop_detail2 ">
					<h3>자재관리</h3>
					<div id="board_view">
						<!-- 텍스트컬러- 고장신고-blue 고장상태-red -->
						<table summary="자재현황" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="14%">
								<col width="36%">
								<col width="14%">
								<col width="36%">
							</colgroup>
							
								<tbody id="tbodyKey" >
								<tr>
									<th>해당년도</th>
									<td colspan="3"><input id="year" name="year" value="" class="tbox01" readonly/> </td>
								</tr>
								
								<tr>
									<th>자재번호</th>
									<td colspan="3"><input id="data_code" name="data_code" value="" class="tbox01" readonly/> </td>
								</tr>
								</tbody>
								<tbody>
								<tr>
									<th>자재명</th>
									<td colspan="3"><input id="data_code_name" name="data_code_name" value="" class="tbox07" maxlength="50"/> </td>
								</tr>
								
								<tr>
									<th>업체명</th>
									<td colspan="3"><span class="">
												<select class="sel03" id="company_id" name="company_id" >
													<option value="">업체명</option>
												</select>
											</span> </td>
								</tr>
								
								<tr>
									<th>자재규격</th>
									<td colspan="3"><input id="standard" name="standard" value="" class="tbox07" maxlength="200"/> </td>
								</tr>
								
								<tr>
									<th>자재단가</th>
									<td colspan="3"><input id="danga" name="danga" value="" class="tbox07" maxlength="20" /> </td>
								</tr>
								
								<tr>
									<th>단위</th>
									<td colspan="3"><select class="sel03" id="unit" name="unit" >
													<option value="">선택</option>
													<option value="EA">EA</option>
													<option value="M">M</option>
												</select></td>
								</tr>
								
								<tr>
									<th>비고</th>
									<td colspan="3"><input id="remarks" name="remarks" value="" class="tbox07" maxlength="100" /> </td>
								</tr>
								
								
								
							</tbody>
						</table>
						
					<div id="btn">
						<p>
						<span><a href=" javascript:popupClose()"  class="btn_gray02">닫기</a></span>
						<span id="new"><a href="javascript:doSave()"  class="btn_gray02">등록</a></span>
						<span id="update"><a href="javascript:doUpdate()"  class="btn_gray02">수정</a></span>
						<span id="delete"><a href="javascript:doDel()"  class="btn_gray02">삭제</a></span>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>
</form>
<!--//결과조회 상세 Popup-->

