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
		
		var lightNo = "${param.light_no}";
		var lightType = "${param.lightType}" != "" && "${param.lightType}" != null ? "${param.lightType}" : "${param.light_type}";
		var address = "${param.address}";
		var hj_dong_cd = "${param.hj_dong_cd}";
		
		$(function(){
			drawCodeData(commonCd, "01", "select", "").then(function(resolvedData) {
				$("#trouble_cd").empty();
				$("#trouble_cd").append(resolvedData);
			})
			.then(function() {
				drawCodeData(commonCd, "14", "select", "").then(function(resolvedData) {
					$("#repair_cd").empty();
					$("#repair_cd").append(resolvedData);
					
					$("#repair_cd option[value=6]").remove();
					$("#repair_cd option[value=7]").remove();
					$("#repair_cd option[value=8]").remove();
				})
			})
			.then(function() {
				if(lightNo != null && lightNo != "") {
					$("#light_no").val(lightNo);
					$(".text").prepend(lightNo);
					$("#light_gubun").val(lightType);
					$("#address").val(address);
					//$("#address").attr("readonly", true);
					//$("#address").css('background-color', '#ddd');
					$("#dong").val(hj_dong_cd);
				}
			});
		});
		
		function Save() {
			if($("#repair_cd").val() == "" || $("#repair_cd").val() == null) {
				alert("신고종류를 입력하세요");
				$("#repair_cd").focus();
				return;
			}
			
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
			
			if($("#trouble_cd").val() == "" || $("#trouble_cd").val() == null) {
				alert("고장상태를 입력하세요");
				$("#trouble_cd").focus();
				return;
			}
			
			var yn = confirm("고장신고 하시겠습니까?");
			if(yn){
				$.ajax({
					type : "POST"			
					, url : "/trouble/insertTrobleReport"
					, data : $("#troubleForm").serialize()
					, dataType : "JSON"
					, success : function(obj) {
						getInsertTrobleCallback(obj);
					}
					, error : function(xhr, status, error) {
						
					}
				});
			}
		}
		
		function getInsertTrobleCallback(obj) {
			if(obj != null) {
				if(obj.resultCnt > -1) {
					alert("신고를 성공하였습니다.");
					window.location.reload(true);
				}
				else {
					alert("신고를 실패하였습니다.");	
					return;
				}
			}
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
		<form id="troubleForm" name="troubleForm">
			<input type="hidden" id="light_gubun" name="light_gubun">
			<input type="hidden" id="dong" name="dong">
			<input type="hidden" id="light_no" name="light_no">
			<div class="group">
				<ul class="box">
					<!-- 사진없을시 빼주세요 -->
					<li>
						<p><img src="/resources/css/img/noimg1.png" class="light_img"></p>
						<!-- <p class="simg">
							<span  class="simg"><img src="/resources/css/img/noimg1.png" class="light_img_s"></span>
						</p> -->
					</li>
					<!-- //사진없을시 빼주세요 -->
		
					<li><span class="title">신고종류</span><span>
							<select class="sel02" name="repair_cd" size="1" id="repair_cd">
							</select>
						</span>
					</li>
					<li><span class="title">관리번호</span><span class="text"><a href="/mobile/trouble/troubleMap" class="btn-search btn-gray btn-point" style="margin-left: 10px;">관리번호 검색</a></span></li>
					<li><span class="title">주소</span><span><input type="text" id="address" name="address" class="tbox"></span></li>
					<li><span class="title">신고인명</span><span><input type="text" id="notice_name" name="notice_name" class="tbox"></span></li>
					<li><span class="title">연락처</span><span><input type="text" id="phone" name="phone" class="tbox"></span></li>
					<li><span class="title">휴대번호</span><span><input type="text" id="mobile" name="mobile" class="tbox"></span></li>
					<li><span class="title">이메일</span><span><input type="text" id="email" name="email" class="tbox"></span></li>
					<li><span class="title">비밀번호</span><span><input type="password" id="password" name="password" class="tbox"></span></li>
					<li><span class="title">고장상태</span><span>
							<select class="sel02" name="trouble_cd" size="1" id="trouble_cd">
							</select>
						</span>
					</li>
					<li><span class="title">상태설명</span><span><textarea name="" rows="" cols=""  class="tbox"></TEXTAREA></span></li>
					<li>
						<span class="title">회신결과</span>
						<span><input type="radio" name="inform_method" value="01">sms</span>
						<span><input type="radio" name="inform_method" value="02">e-mail</span>
						<span><input type="radio" name="inform_method" value="03">전화</span>
						<span><input type="radio" name="inform_method" value="04" checked="checked">회신안받음</span>
					</li>
				</ul>
				<div class="btn-area"><a href="javascript:Save()" class="btn btn-large btn-point">신고하기</a></div>
			   
			</div>
		</form>
	</section>
	<!-- //content -->
	
	<!-- // List -->
	<!-- //content -->
</body>
</html>