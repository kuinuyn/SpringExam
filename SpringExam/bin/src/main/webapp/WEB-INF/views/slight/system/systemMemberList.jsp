<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};

	$(function(){
		Search();
		areaTag();
		
		$("input[type=radio][name=grade]").change(function() {
			if($(this).val() == "01") {
				$("#trArea").hide();
			}
			else {
				$("#trArea").show();
			}
		});
		
		$("input[type=text][name=member_id]").change(function() {
			if($("#saveFlag").val() == "U") {
				$("#chkIdFlag").val("N");
			}
		});
		
		$("#searchYear").change(function() {
			Search();
		});
	});
	
	function areaTag() {
		var list = commonCd;
		var listCnt = list.length;
		var restr = "<p>";
		var cnt = 0;
		
		for(i=0; i < listCnt; i++) {
			if(list[i].code_type == "06") {
				cnt++;
				restr += "<span style='display: inline-block;width: 20%;'><input type='checkbox' name='area' value='"+list[i].data_code+"'>"+list[i].data_code_name+"</span>";
				if(cnt % 5 == 0) {
					restr += "</p><p>";
				}
				else {
					if(listCnt == (i+1)) {
						restr += "</p>";
					}
				}
			}
		}
		
		$("#tdArea").empty();
		$("#tdArea").html(restr);
	}
	
	function Search(currentPageNo) {
		if(currentPageNo === undefined){
			currentPageNo = "1";
		}
		
		$("#current_page_no").val(currentPageNo);
		
		$.ajax({
			type : "POST"			
			, url : "/system/getSystemMemberList"
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
					str += "	<td><span> <a href='javascript:getSystemMemberDetail(\""+list[i].member_id+"\")'>"+list[i].member_id+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getSystemMemberDetail(\""+list[i].member_id+"\")'>"+list[i].com_name+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getSystemMemberDetail(\""+list[i].member_id+"\")'>"+list[i].member_name+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getSystemMemberDetail(\""+list[i].member_id+"\")'>"+list[i].phone+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getSystemMemberDetail(\""+list[i].member_id+"\")'>"+list[i].mobile+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getSystemMemberDetail(\""+list[i].member_id+"\")'>"+list[i].email+" </a></span></td>";
					str += "	<td><span> <a href='javascript:getSystemMemberDetail(\""+list[i].member_id+"\")'>"+list[i].data_code_name+" </a></span></td>";
					str += "	<td><span> <a href='javascript:getSystemMemberDetail(\""+list[i].member_id+"\")'>"+list[i].login_yn+" </a></span></td>";
					str += "</tr>";
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
	
	function getSystemMemberDetail(memberId) {
		if(memberId == "" || memberId == null) {
			$("#saveFlag").val("I");
			$("#chkBtn").show();
			$("#member_id").removeClass("tbox07_gray");
			$("#member_id").prop("readonly", false);
			$("input[type=text]").val("");
			$("input[type=radio][value=01]").prop("checked", true);
			$("input[type=checkbox][name=area]").prop("checked", false);
			$("#trArea").hide();
			modal_popup2('messagePop2');
			
			return;
		}
		
		$.ajax({
			type : "POST"			
			, url : "/system/getSystemMemberDetail"
			, data : {"memberId":memberId}
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
			
			var areaArr = new Array();
			if(data['grade'] != "" && data['grade'] != null) {
				if(data['grade'] != '01') {
					areaArr = data['area'].split(";");
					$("input[type=checkbox][name=area]").prop("checked", false);
					
					for(i = 0; i<areaArr.length; i++) {
						$("input[type=checkbox][name=area][value="+areaArr[i]+"]").prop("checked", true);
					}
					$("#trArea").show();
				}
				else {
					$("input[type=checkbox][name=area]").prop("checked", false);
					$("#trArea").hide();
				}
				
				$("input[type=radio][name=grade][value="+data['grade']+"]").prop("checked", true);
			}
			
			if(data['login_yn'] != "" && data['login_yn'] != null) {
				$("input[type=radio][name=login_yn][value="+data['login_yn']+"]").prop("checked", true);
			}
			
		}
		modalPopupCallback( function() {
			$("#saveFlag").val("U");
			$("#chkIdFlag").val("Y");
			$("#chkBtn").hide();
			$("#member_id").addClass("tbox07_gray");
			$("#member_id").prop("readonly", true);
			modal_popup2('messagePop2');
		});
		
	}
	
	function modalPopupCallback(fnNm) {
		fnNm();
	}
	
	function chkMemberId() {
		if($("#member_id").val() == "" || $("#member_id").val() == null) {
			alert("아이디를 입력하세요.");
			$("#member_id").focus();
			return;
		}
		
		$.ajax({
			type : "POST"			
			, url : "/system/chkMemberId"
			, data : {"member_id":$("#member_id").val()}
			, dataType : "JSON"
			, success : function(obj) {
				chkMemberIdCallback(obj);
			}
			, error : function(xhr, status, error) {
				
			}
		});
	}
	
	function chkMemberIdCallback(obj) {
		var chkFlag;
		
		if(obj.resultMap != null) {
			chkFlag = obj.resultMap.chkFlag;
			if(chkFlag == "Y") {
				$("#chkIdFlag").val("Y");
				alert("등록가능한 아이디입니다.");
			}
			else {
				alert("중복된 아이디 입니다.");
				return;
			}
		}
	}
	
	function Save() {
		if($("#chkIdFlag").val() != "Y") {
			$("#member_id").focus();
			alert("아이디 중복확인 하세요.");
			return;
		}
		
		if($("#password").val() == "" || $("#password").val() == null) {
			$("#password").focus();
			alert("비밀번호를 입력하세요.");
			return;
		}
		else {
			if($("#password").val() != $("#passwordChk").val()) {
				$("#passwordChk").focus();
				alert("비밀번호를 확인하세요.");
				return;
			}
		}
		
		if($("#member_name").val() == "" || $("#member_name").val() == null) {
			$("#member_name").focus();
			alert("담당자를 입력하세요.");
			return;
		}
		
		if($("#phone").val() == "" || $("#phone").val() == null) {
			$("#phone").focus();
			alert("전화번호를 입력하세요.");
			return;
		}
		
		if($("#mobile").val() == "" || $("#mobile").val() == null) {
			$("#mobile").focus();
			alert("휴대폰번호를 입력하세요.");
			return;
		}
		
		if($("input[type=radio][name=grade]:checked").val() != "01") {
			if(!$("input[type=checkbox][name=area]").is(":checked")) {
				alert("담당지역을 선택하세요.");
				$("input[type=checkbox][name=area]").focus();
				return;
			}
		}
		
		var obj = $("#frm").serializeArray();
		var json = {};
		var area = "";
		for(i=0; i<obj.length; i++) {
			json[obj[i].name] = obj[i].value;
			if(obj[i].name == "area") {
				area += obj[i].value+";";
			}
		}
		
		json['area'] = area.substring(0, (area.length-1));
		
		var yn = confirm("사용자 정보를 저장 하시겠습니까?");
		if(yn){
			$.ajax({
				type : "POST"			
				, url : "/system/updateSystemMember"
				, data : json
				, dataType : "JSON"
				, success : function(obj) {
					getUpdateMemberCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});
		}
	}
	
	function getUpdateMemberCallback(obj) {
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("저장 되었습니다.");
				$('.modal-popup2 .bg').trigger("click");
				Search();
			}
			else if (obj.resultCnt == -1){
				alert("중복된 아이디입니다.");	
				return;
			}
			else if (obj.resultCnt == -2){
				alert("비밀번호를 확인하세요.");	
				return;
			}
		}
	}
	
	function Delete() {
		
		var yn = confirm("사용자 정보를 삭제 하시겠습니까?");
		if(yn){
			$.ajax({
				type : "POST"			
				, url : "/system/deleteSystemMember"
				, data : $("#frm").serialize()
				, dataType : "JSON"
				, success : function(obj) {
					getDeleteMemberCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});
		}
	}
	
	function getDeleteMemberCallback(obj) {
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("삭제 되었습니다.");
				$('.modal-popup2 .bg').trigger("click");
				Search();
			}
			else {
				alert("삭제 실패했습니다.");
				return;
			}
		}
	}
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
				<li><a href="#">보안등관리 <img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
					<ul>
						<li><a href="/equipment/securityLightList">보안등관리</a></li>
						<li><a href="/equipment/streetLightList">가로등관리</a></li>
						<li><a href="/equipment/distributionBoxList">분전함관리</a></li>
						<li><a href="#">GIS관리</a></li>
						<li><a href="/equipment/equipStaitstice" >통계관리</a></li>
						<li><a href="/system/systemMemberList">사용자관리</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="sub">
		<div id="sub_title"><h3>사용자 관리</h3></div>
		<form id="slightForm" name="slightForm" method="post" action="">
			<input type="hidden" id="function_name" name="function_name" value="Search" />
			<input type="hidden" id="current_page_no" name="current_page_no" value="1" />
			<div id="toptxt">
				<ul>
					<li  class="b_right">
						<select id ="searchYear" name="searchYear" class="sel01">
							<c:forEach items="${searchYearList}" var="year">
								<option value="${year.year }">${year.year }년</option>
							</c:forEach>
						</select>
					</li>
				</ul>
			</div>
		</form>
		<div id="board_list">
			<!--  사용자관리 리스트 -->
			<table summary="사용자관리" cellpadding="0" cellspacing="0">
				
				<colgroup>
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th>아이디</th>
						<th>업체명</th>
						<th>이름</th>
						<th>전화번호</th>
						<th>휴대폰</th>
						<th>이메일</th>
						<th>구분</th>
						<th>로그인여부</th>
					</tr>
				</thead>
				<tbody id="tbody">
				
				</tbody>
			</table>
		</div>
		<div style="width:1160px;margin:0 auto;text-align:center;overflow:hidden;margin-top: 10px;">
			<span style="float: right;"><a href="javascript:getSystemMemberDetail()" class="btn_blue03">등록</a></span>
		</div>
		<div id="pagination">
		</div>
		
	</div>
</div>

<!-- 상세 Popup-->
<div class="modal-popup2">
	<div class="bg"></div>
	<div id="messagePop2" class="pop-layer">
		<div class="pop-container">
			<div class="pop-conts">
				<div class="btn-r">
					<a href="#" class="cbtn"><i class="fa fa-times " aria-hidden="true"></i><span class="hide">Close</span></a>
				</div>
				<div class="pop_detail2 ">
					<h3>사용자 상세내역</h3>
					<form name="frm" id="frm" method="post">
						<input type="hidden" id="saveFlag" name="saveFlag" value="">
						<input type="hidden" id="chkIdFlag" name="chkIdFlag" value="">
						<div id="board_view">
							<!-- 사용자내역-->
							<table  cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="14%">
									<col width="36%">
									<col width="14%">
									<col width="36%">
								</colgroup>
								<tbody>
									
									<tr>
										<th>아이디</th>
										<td>
											<span>
												<input type="text" name="member_id" id="member_id" class="tbox07_gray" placeholder="ID" readonly="readonly">
											</span>
											<span id="chkBtn">
												<a href="#"  class="btn_blue03" onclick="chkMemberId()">확인</a>
											</span>
										</td>
										<th>년도</th>
										<td>
											<span>
											<select name="year" id="year" class="sel03">
												<c:forEach items="${searchYearList}" var="year">
													<option value="${year.year }">${year.year }년</option>
												</c:forEach>
											</select>
											</span>
										</td>
									</tr>
									
									<tr>
										<th>비밀번호</th>
										<td><span><input type="password" name="password" id="password" class="tbox07" placeholder="******"></span></td>
										<th>비밀번호확인</th>
										<td><span><input type="password" name="passwordChk" id="passwordChk" class="tbox07" value=""></span></td>
									</tr>
									<tr>
										<th>구분</th>
										<td>
											<span class="pdr10"><input type="radio" name="grade" value="01" checked="checked"> 시청담당자</span>
											<span class="pdr10"><input type="radio" name="grade" value="02"> 읍면동담당자</span>
											<div><span class="pdr10"><input type="radio" name="grade" value="03"> 보수업체 담당자</span></div>
										</td>
										<th>로그인 여부</th>
										<td>
											<span class="pdr10"><input type="radio" name="login_yn" value="Y" checked="checked"> Y</span>
											<span class="pdr10"><input type="radio" name="login_yn" value="N"> N</span>
										</td>
									</tr>
									
								</tbody>
							</table>
						</div>
	
						<div id="board_view" class="pdt40">
							<!-- 사용자내역-->
							<table  cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="14%">
									<col width="36%">
									<col width="14%">
									<col width="36%">
								</colgroup>
								<tbody>
									
									<tr>
										<th>부서(업체)명</th>
										<td colspan="3"><span><input type="text" name="com_name" id="com_name" class="tbox07" value=""></span></td>
									</tr>
									
									<tr>
										<th>담당자</th>
										<td><span><input type="text" name="member_name" id="member_name" class="tbox07" value=""></span></td>
										<th>이메일주소</th>
										<td><span><input type="text" name="email" id="email" class="tbox07" value=""></span></td>
									</tr>
									<tr>
										<th>전화번호</th>
										<td><span><input type="text" name="phone" id="phone" class="tbox07" value=""></span></td>
										<th>휴대폰번호</th>
										<td><span><input type="text" name="mobile" id="mobile" class="tbox07" value=""></span></td>
									</tr>
									<tr id="trArea" style="display: none;">
										<th>담당지역</th>
										<td id="tdArea" colspan="3">
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</form>
					
					<div id="btn">
						<p>
						<span><a href="javascript:Delete()" class="btn_gray02"> 삭제</a></span>
						<span><a href="javascript:Save()" class="btn_gray02">저장</a></span>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--//상세 Popup-->