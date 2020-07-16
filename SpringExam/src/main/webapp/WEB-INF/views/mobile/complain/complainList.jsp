<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
	<meta charset="utf-8" />
	<title>도로조명정보시스템</title>
	<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0" />
	<%@ include file="/WEB-INF/include/include-mobile-header.jspf"%>
	
	<script type="text/javascript">
		$(function (){
			var resultCd = "${resultCd}";
			var resultMsg = "${resultMsg}";
			
			if(resultCd == "N") {
				alert(resultMsg);
			}
			var today = new Date();
			$("#searchMonth").val(today.getMonth()+1);
			
			Search();
			
		});
		
		$(document).on("keypress", "#password", function (e) {
			if (e.which == 13){
				getComplaintModify();  // 실행할 이벤트
			}
		});
		
		$(document).on("keypress", "#keyword", function (e) {
			if (e.which == 13){
				Search();  // 실행할 이벤트
			}
		});
		
		Date.prototype.yyyymmdd = function() {
		    var yyyy = this.getFullYear().toString();
		    var mm = (this.getMonth() + 1).toString();
		    var dd = this.getDate().toString();
		 
		    return yyyy +"-"+ (mm[1] ? mm : '0'+mm[0]) +"-"+ (dd[1] ? dd : '0'+dd[0]);
		}
		
		function Search() {
			$("#current_page_no").val("1");
			var sDate = new Date(parseInt($("#searchYear").val()), parseInt($("#searchMonth").val())-1, 1);
			var eDate = new Date(parseInt($("#searchYear").val()), parseInt($("#searchMonth").val()), 0);
			
			$.ajax({
				type : "POST"			
				, url : "/complaint/getComplaintList"
				, data : {"current_page_no":$("#current_page_no").val(), "sDate":sDate.yyyymmdd(), "eDate":eDate.yyyymmdd(), "searchType":$("#searchType").val(), "keyword":$("#keyword").val()}
				, dataType : "JSON"
				, success : function(obj) {
					getSearchCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});
		}
		
		function moreSearch() {
			$("#current_page_no").val(parseInt($("#current_page_no").val())+1);
			
			var sDate = new Date(parseInt($("#searchYear").val()), parseInt($("#searchMonth").val())-1, 1);
			var eDate = new Date(parseInt($("#searchYear").val()), parseInt($("#searchMonth").val()), 0);
			
			$.ajax({
				type : "POST"			
				, url : "/complaint/getComplaintList"
				, data : {"current_page_no":$("#current_page_no").val(), "sDate":sDate.yyyymmdd(), "eDate":eDate.yyyymmdd(), "searchType":$("#searchType").val(), "keyword":$("#keyword").val()}
				, dataType : "JSON"
				, success : function(obj) {
					getMoreSearchCallback(obj);
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
				
				var str = "";
				var btnStr = "";
				//접수번호,신고구분,접수일,고장상태,관리번호,주소,신고인,전화번호,보수일,처리상황
				if(listLen > 0) {
					for(i=0; i<listLen; i++) {
						str += "<li>";
						<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS','ROLE_USER')">
							str += "	<a href='#' onclick='pwPopup(\""+list[i].repair_no+"\");return false;'>";
						</sec:authorize>
						<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
							str += "	<a href='javascript:getComplaintModify(\""+list[i].repair_no+"\")'>";
						</sec:authorize>
						str += "		<p>";
						str += "			<span>접수번호</span> ";
						str += "			<span class='black04'>"+list[i].repair_no+"</span> ";
						str += "			<span class='pdl10'>관리번호</span> ";
						str += "			<span class='black04'>"+list[i].light_no+"</span>";
						str += "		</p>";
						str += "		<p>";
						str += "			<span>접수일</span>";
						str += "		<span class='black04'> "+list[i].notice_date+"</span> ";
						str += "		<span class='pdl10'>처리상황</span> ";
						if(list[i].progress_status == "01") {
							btnStr = "신고접수";
						}
						else if(list[i].progress_status == "02" || list[i].progress_status == "03") {
							btnStr = "작업지시";
						}
						else if(list[i].progress_status == "04" || list[i].progress_status == "05") {
							btnStr = "보수완료";
						}
						str += "		<span  class='sky02'>"+btnStr+"</span>";
						str += "	</p>";
						str += "	<span class='arrow-right'><i class='fa fa-angle-right' aria-hidden='true'></i></span>";
						str += "</a>";
						str += "</li>";
						
					}
					
				}
				else {
					str += "<li>";
					str += "	<p colspan='10' style='text-align: center;'><span>등록된 글이 존재하지 않습니다.</span></p>";
					str += "</li>";
				}
				
				$(".list2").html(str);
			}
			
			var pageNo = parseInt($("#current_page_no").val());
			if(pageNo == Math.ceil((data.totalCount / 10))) {
				$(".group").hide();
			}
			else {
				$(".group").show();
			}
		}
		
		function getMoreSearchCallback(obj) {
			var state = obj.state;
			if(state == "SUCCESS"){
				var data = obj.data;			
				var list = data.list;
				var listLen = list.length;		
				
				var str = "";
				var btnStr = "";
				//접수번호,신고구분,접수일,고장상태,관리번호,주소,신고인,전화번호,보수일,처리상황
				if(listLen > 0) {
					for(i=0; i<listLen; i++) {
						str += "<li>";
						<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS','ROLE_USER')">
							str += "	<a href='#' onclick='pwPopup(\""+list[i].repair_no+"\");return false;'>";
						</sec:authorize>
						<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
							str += "	<a href='javascript:getComplaintModify(\""+list[i].repair_no+"\")'>";
						</sec:authorize>
						str += "		<p>";
						str += "			<span>접수번호</span> ";
						str += "			<span class='black04'>"+list[i].repair_no+"</span> ";
						str += "			<span class='pdl10'>관리번호</span> ";
						str += "			<span class='black04'>"+list[i].light_no+"</span>";
						str += "		</p>";
						str += "		<p>";
						str += "			<span>접수일</span>";
						str += "		<span class='black04'> "+list[i].notice_date+"</span> ";
						str += "		<span class='pdl10'>처리상황</span> ";
						if(list[i].progress_status == "01") {
							btnStr = "신고접수";
						}
						else if(list[i].progress_status == "02" || list[i].progress_status == "03") {
							btnStr = "작업지시";
						}
						else if(list[i].progress_status == "04" || list[i].progress_status == "05") {
							btnStr = "보수완료";
						}
						str += "		<span  class='sky02'>"+btnStr+"</span>";
						str += "	</p>";
						str += "	<span class='arrow-right'><i class='fa fa-angle-right' aria-hidden='true'></i></span>";
						str += "</a>";
						str += "</li>";
						
					}
					
				}
				else {
					str += "<li>";
					str += "	<p colspan='10' style='text-align: center;'><span>등록된 글이 존재하지 않습니다.</span></p>";
					str += "</li>";
				}
				
				$(".list2").append(str);
				
			}
			var pageNo = parseInt($("#current_page_no").val());
			if(pageNo == Math.ceil((data.totalCount / 10))) {
				$(".group").hide();
			}
		}
		
		function getComplaintModify(repairNo) {
			<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS','ROLE_USER')">
				if($("#password").val() == null || $("#password").val() == "") {
					alert("비밀번호를 입력하세요.");
					
					return;
				}
				else {
					//$("#detailForm").attr({action:'/mobile/complain/complainModify'}).submit();
					var frm = document.detailForm;
					frm.action =  "/mobile/complain/complainModify";
					frm.submit();
				}
			</sec:authorize>
			<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
				if(repairNo != undefined) {
					$("#repairNo").val(repairNo);
				}
				//$("#detailForm").attr({action:'/mobile/complain/complainModify'}).submit();
				var frm = document.detailForm;
				frm.action =  "/mobile/complain/complainModify";
				frm.submit();
			</sec:authorize>
		}
		
		function pwPopup(repairNo) {
			$("#repairNo").val(repairNo);
			modal_popup("messagePop");
		};
	</script>
</head>
<body>
	<%@ include file="../sidebar.jsp" %>
	
	<!-- content -->
<!-- List -->
<section id="content">
	<form id="slightForm" name="slightForm" method="post" action="">
		<input type="hidden" id="current_page_no" name="current_page_no" value="1" />
		<input type="hidden" id="searchType" name="searchType" value="1" />
		<div id="list_search">
			<div id="list_searchbox">
				<ul>
					<li>
						<select class="select_y" id="searchYear">
							<c:forEach items="${searchYearList}" var="year">
								<option value="${year }">${year }년</option>
							</c:forEach>
						</select>
					</li>
					<li>
						<select class="select_m" id="searchMonth">
							<option value="12" >12</option>
							<option value="11" >11</option>
							<option value="10" >10</option>
							<option value="9" >09</option>
							<option value="8" >08</option>
							<option value="7" >07</option>
							<option value="6" >06</option>
							<option value="5" >05</option>
							<option value="4" >04</option>
							<option value="3" >03</option>
							<option value="2" >02</option>
							<option value="1" >01</option>
						</select>
					</li>
					<li><input type="text" name="keyword" id="keyword" class="box_txt" placeholder="신고자로 검색"></li>
					<li><a href="javascript:Search()" class="sbtn"></a></li>
				</ul>
			</div>
		</div>
	</form>
	<div id="slist">
		<ul class="list2">
		</ul>
		
	</div>
	<div class="group">
		<div class="btn-area"><a href="javascript:moreSearch()" class="btn btn-large btn-white2"><i class="fa fa-plus"></i> 더보기</a></div>
	</div>
	</section>
	<!-- // List -->
	<!-- //content -->
	   
	<!--PW_Popup-->
	<div class="modal-popup">
		<div class="bg"></div>
		<div id="messagePop" class="pop-layer">
			<div class="pop-container">
				<div class="pop-conts">
					<h1>비밀번호</h1>
					<div class="btn-r">
						<a href="#" class="cbtn"><i class="fa fa-times" aria-hidden="true"></i><span class="hide">Close</span></a>
					</div>
					<form id="detailForm" name="detailForm" method="post" action="">
						<input type="hidden" id="repairNo" name="repairNo" />
						<div id="accordian">
							<p><input type="password" id="password" name="password" class="tbox02" placeholder="비밀번호입력"></p>
							<p><a href="javascript:getComplaintModify()" class="btn_ok">확인</a></p>	
							
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<!--//PW_Popup-->
		
</body>
</html>