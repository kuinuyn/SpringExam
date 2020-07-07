<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="code" uri="/WEB-INF/tlds/code/code.tld" %>
<code:select var="MAXRESULT"/>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>도로조명정보시스템</title>
	<%@ include file="/WEB-INF/include/include-mobile-header.jspf"%>
	
	<script type="text/javascript">
		var commonCd = ${MAXRESULT};
		
		$(function(){
			var troubleCd = "${resultMap.trouble_cd }";
			var repairCd = "${resultMap.repair_cd }";
			var inform_method = "${resultMap.inform_method }";
			
			drawCodeData(commonCd, "01", "select", "", troubleCd).then(function(resolvedData) {
				$("#trouble_cd").empty();
				$("#trouble_cd").append(resolvedData);
			})
			.then(function (){
				$('input:radio[name=inform_method][value='+inform_method+']').prop("checked", true);
			})
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
					$("#mobile").focus();
					return;
				}
			}
			else if(inform_method == "03"){
				var phone = $("#phone").val();
				if(!chkContactNumber(phone)) {
					alert("전화 회신 요청 시 연락처를 정확히 입력하세요.");
					$("#phone").focus();
					return;
				}
			}
			else if(inform_method == "02"){
				var email = $("#email").val();
				if(!checkEmail(email)) {
					alert("E-MAIL 회신 요청 시 메일주소를 정확히 입력하세요.");
					$("#email").focus();
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
			frm.action = '/mobile/complain/complainList';
			frm.method ="post";
			frm.submit();
		}
	</script>
</head>
<body>
	<!-- header -->
	<!-- //header -->
	<%@ include file="../sidebar.jsp" %>
	<!-- content -->
	<!-- List -->
	<section id="content">
		<form id="slightForm" name="slightForm">
			<input type="hidden" id="light_no" name="light_no" value="${resultMap.light_no }">
			<input type="hidden" id="repair_no" name="repair_no" value="${resultMap.repair_no }">
			<input type="hidden" name="repair_cd" id="repair_cd" value="${resultMap.repair_cd }">
			<input type="hidden" name="progress_status" id="progress_status" value="${resultMap.progress_status }">
			<div class="group">
				<ul class="box">
					<li><span class="title">신고종류</span><span class="text">${resultMap.light_gubun }</span></li>
					<li><span class="title">관리번호</span><span class="text">${resultMap.light_no }</span></li>
					<li><span class="title">주소</span><span><input type="text" id="address" name="address" class="tbox" value="${resultMap.location }"></span></li>
					<li><span class="title">신고인명</span><span><input type="text" id="notice_name" name="notice_name" class="tbox" value="${resultMap.notice_name }"></span></li>
					<li><span class="title">연락처</span><span><input type="text" id="phone" name="phone" class="tbox" value="${resultMap.phone }"></span></li>
					<li><span class="title">휴대번호</span><span><input type="text" id="mobile" name="mobile" class="tbox" value="${resultMap.mobile }"></span></li>
					<li><span class="title">이메일</span><span><input type="text" id="email" name="email" class="tbox" value="${resultMap.email }"></span></li>
					<li><span class="title">비밀번호</span><span><input type="password" id="password" name="password" class="tbox" value="${resultMap.password }"></span></li>
					<li><span class="title">고장상태</span><span>
							<select class="sel02" name="trouble_cd" size="1" id="trouble_cd">
							</select>
						</span>
					</li>
					<li><span class="title">상태설명</span><span><textarea name="trouble_detail" id="trouble_detail" rows="" cols=""  class="tbox"> ${resultMap.trouble_detail }</TEXTAREA></span></li>
					<li>
						<span class="title">회신결과</span>
						<span><input type="radio" name="inform_method" value="01">sms</span>
						<span><input type="radio" name="inform_method" value="02">e-mail</span>
						<span><input type="radio" name="inform_method" value="03">전화</span>
						<span><input type="radio" name="inform_method" value="04" checked="checked">회신안받음</span>
					</li>
				</ul>
				<div class="btn-area">
					<p>
						<a href="javascript:Save()" class="btn btn-small btn-point">수정</a>
						<a href="javascript:goToList()" class="btn btn-small btn-point">목록</a>
						<a href="javascript:Delete()" class="btn btn-small btn-white">삭제</a>
					</p>
				</div>
			   
			</div>
		</form>
	</section>
	<!-- //content -->
	
	<!-- // List -->
	<!-- //content -->
	
	<!--PW_Popup-->
</body>
</html>