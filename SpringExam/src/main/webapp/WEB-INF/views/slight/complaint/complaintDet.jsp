<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<style>
	/* Clear button styles
	--------------------------------------------- */
	::-ms-clear {
	  display: none;
	}


	.form-control-clear {
	  z-index: 10;
	  pointer-events: auto;
	  cursor: pointer;
	}
</style>

<script type="text/javascript">
	var commonCd = ${MAXRESULT};
	var lightNo = "${param.light_no}";
	var lightType = "${param.lightType}";
	var address = "${param.address}";
	var hj_dong_cd = "${param.hj_dong_cd}";
	var lightGubunlDefault;
	
	$(function(){
		var troubleCd = "${resultMap.trouble_cd }";
		var inform_method = "${resultMap.inform_method }";
		drawCodeData(commonCd, "01", "select", "", troubleCd).then(function(resolvedData) {
			$("#trouble_cd").empty();
			$("#trouble_cd").append(resolvedData);
		})
		.then(function (){
			drawCodeData(commonCd, "13", "select", "").then(function(resolvedData) {
				$("#light_gubun").empty();
				$("#light_gubun").append(resolvedData);
			})
		})
		.then(function (){
			$('input:radio[name=inform_method][value='+inform_method+']').prop("checked", true);
		})
		.then(function (){
			if(lightNo != null && lightNo != "") {
				$("#light_no").val(lightNo);
				$("#light_gubun").val(lightType);
				$("#address").val(address);
				$("#address").attr("readonly", true);
				$("#address").css('background-color', '#ddd');
				$("#dong").val(hj_dong_cd);
				
				lightGubunlDefault = $( '#light_gubun' )[0].selectedIndex;
			}
		});
		
	});
	
	function Save() {
		
		if($("#notice_name").val() == "" || $("#notice_name").val() == null) {
			alert("신고인을 입력하세요");
			$("#notice_name").focus();
			return;
		}
		
		if($("#light_no").val() == "" || $("#light_no").val() == null) {
			if($("#address").val() == "" || $("#address").val() == null) {
				alert("관리번호, 주소를 입력하세요");
				$("#light_no").focus();
				return;
			}
		}
		
		if($("#password").val() == "" || $("#password").val() == null) {
			alert("비밀번호를 입력하세요");
			$("#password").focus();
			return;
		}
		
		if($("#trouble_cd").val() == "" || $("#trouble_cd").val() == null) {
			if($("#repair_cd").val() < 6) {
				alert("고장상태를 선택하세요");
				$("#trouble_cd").focus();
				return;
			}
		}
		
		var inform_method = $('input:radio[name=inform_method]:checked').val();
		if(inform_method == "01") {
			var mobile = $("#mobile").val();
			if(!chkContactNumber(mobile)) {
				alert("SMS 회신 요청 시 연락처를 정확히 입력하세요.");
				return;
			}
		}
		else if(inform_method == "03"){
			var phone = $("#phone").val();
			if(!chkContactNumber(phone)) {
				alert("전화 회신 요청 시 연락처를 정확히 입력하세요.");
				return;
			}
		}
		else if(inform_method == "02"){
			var email = $("#email").val();
			if(!checkEmail(email)) {
				alert("E-MAIL 회신 요청 시 메일주소를 정확히 입력하세요.");
				return;
			}
		}
		
		if($("#progress_status").val().trim() != "01") {
			alert("민원처리중 수정이 불가능합니다.");
			return;
		}
		
		var yn = confirm("민원결과를 수정 하시겠습니까?");
		if(yn){
			$.ajax({
				type : "POST"			
				, url : "/complaint/updateComplaint"
				, data : $("#slightForm").serialize()
				, dataType : "JSON"
				, success : function(obj) {
					getupdateComplaintCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});
		}
	}
	
	function getupdateComplaintCallback(obj) {
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("신고를 성공하였습니다.");
				goToList();
			}
			else if(obj.resultCnt == -2) {
				alert("민원처리중 수정이 불가능합니다.");
				goToList();
			}
			else {
				alert("신고를 실패하였습니다.");	
				return;
			}
		}
	}
	
	function Delete() {
		if($("#progress_status").val().trim() != "01") {
			alert("민원처리중 삭제가 불가능합니다.");
			return;
		}
		
		if(confirm("삭제하시겠습니까?")) {
			$.ajax({
				type : "POST"			
				, url : "/complaint/deleteComplaint"
				, data : $("#slightForm").serialize()
				, dataType : "JSON"
				, success : function(obj) {
					if(obj.resultCnt > -1) {
						alert("삭제 되었습니다.");
						goToList();
					}
					else if(obj.resultCnt == -2) {
						alert("처리가 완료되어 삭제가 불가능합니다.");
						goToList();
					}
				}
				, error : function(xhr, status, error) {
					alert("실패하였습니다.");
				}
			});
		}
	}
	
	function goToList() {
		var frm = document.slightForm;
		frm.action = '/complaint/complaintList';
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
				<li><a href="/complaint/complaintList">민원처리결과조회</a>
				</li>
			</ul>
		</div>
	</div>

	<div id="sub">
		<div id="sub_title"><h3>민원처리결과조회</h3></div>
		<form id="slightForm" name="slightForm">
			<input type="hidden" name="dong" id="dong">
			<input type="hidden" name="repair_no" id="repair_no" value="${resultMap.repair_no }">
			<input type="hidden" name="light_no" id="light_no" value="${resultMap.light_no }">
			<input type="hidden" name="repair_cd" id="repair_cd" value="${resultMap.repair_cd }">
			<input type="hidden" name="progress_status" id="progress_status" value="${resultMap.progress_status }">
			<div id="board_view2">
				<table summary="고장신고목록" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="20%">
						<col width="30%">
						<col width="20%">
						<col width="30%">
					</colgroup>
					<tbody>
						<tr>
							<th>신고종류</th>
							<td>
								<c:out value="${resultMap.light_gubun }" />
							</td>
							<th>관리번호</th>
							<td>
								<c:out value="${resultMap.light_no }" />
							</td>
						</tr>
						<tr>
							<th>신고인</th>
							<td><input type="text" id="notice_name" name="notice_name" class="tbox03" value="${resultMap.notice_name }"></td>
							<th>비밀번호</th>
							<td><input type="password" id="password" name="password" class="tbox03" value="${resultMap.password }"></td>
						</tr>
						<tr>
							<th>주소</th>
							<td id="addr" colspan="3">
								<div style="margin-bottom: 5px;"><input type="text" class="tbox06" id="address" name="address" value="${resultMap.location }"></div>
							</td>
						</tr>
						<tr>
							<th>접수일</th>
							<td><c:out value="${resultMap.notice_date }" /></td>
							<th>처리상황</th>
							<td><c:out value="${resultMap.progress_name }" /></td>
						</tr>
						<tr>
							<th>핸드폰</th>
							<td>
								<input type="text" name="mobile" id="mobile" class="tbox03" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" value="${resultMap.mobile }">
							</td>
							<th>전화번호</th>
							<td>
								<input type="text" name="phone" id="phone" class="tbox03" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" value="${resultMap.phone }">
							</td>
						</tr>
						<tr>
							<th>이메일</th>
							<td>
								<input name="email" type="text" class="tbox03" id="email" size="35" value="${resultMap.email }">
							</td>
							<th>고장상태</th>
							<td>
								<c:if test="${resultMap.repair_cd < '6'}">
									<select class="sel02" name="trouble_cd" size="1" id="trouble_cd" >
									</select>
								</c:if>
							</td>
						</tr>
						<tr>
							<th>상태설명</th>
							<td colspan="3"><textarea name="trouble_detail" id="trouble_detail" cols="55" rows="3">${resultMap.trouble_detail }</textarea></td>
						</tr>
						<tr>
							<th>회신처리결과</th>
							<td colspan="3">
								<span class="pdr10"><input type="radio" name="inform_method" value="01">sms</span>
								<span class="pdr10"><input type="radio" name="inform_method" value="02">e-mail</span>
								<span class="pdr10"><input type="radio" name="inform_method" value="03">전화</span>
								<span class="pdr10"><input type="radio" name="inform_method" value="04" checked="checked">회신안받음</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div id="btn2">
				<p>
					<span ><a href="javascript:Save()" class="btn_blue">수정</a></span>
					<span><a href="javascript:Delete()"  class="btn_gray">삭제</a></span>
					<span><a href="javascript:goToList()"  class="btn_gray">목록으로</a></span>
				</p>
			</div>
		</form>
	</div>
</div>
