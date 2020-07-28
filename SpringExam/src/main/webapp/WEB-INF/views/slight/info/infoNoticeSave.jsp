<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<%-- <%@ include file="/WEB-INF/include/include-daum-editor-header.jspf"%> --%>
<link rel="stylesheet" href="${contextPath }/resources/daumeditor/css/editor.css" type="text/css" charset="utf-8" />
<script type="text/javascript" src="${contextPath }/resources/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="${contextPath }/resources/js/editor_form.js"></script>
<script type="text/javascript">

var flag = "";

	$(function() {
		loadContent();
		
		var no = $("#no").val();
		
		if(no== "" || no==null)
			{
				flag = "등록";
			}else
			{
				flag = "수정";
			}
	});

	function Save() {
		var yn = confirm("공지사항을 "+ flag + " 하시겠습니까?");
		if(yn){
			$.ajax({
				type : "POST"			
				, url : "/info/updateInfoNotice"
				, data : $("#slightForm").serialize()
				, dataType : "JSON"
				, success : function(obj) {
					updateNoticeCallback(obj);
				}
				, error : function(xhr, status, error) {
					alert(error);
				}
			});
		}
	}
	
	function updateNoticeCallback(obj) {
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert(flag+"을 성공하였습니다.");
				goToList();
			}
			else {
				alert(flag+"을 실패하였습니다.");	
				return;
			}
		}
	}
	
	function Delete() {
		var yn = confirm("공지사항을 삭제 하시겠습니까?");
		if(yn){
			$.ajax({
				type : "POST"			
				, url : "/info/deleteInfoNotice"
				, data : $("#slightForm").serialize()
				, dataType : "JSON"
				, success : function(obj) {
					if(obj != null) {
						if(obj.resultCnt > -1) {
							alert("삭제되었습니다.");
							goToList();
						}
						else {
							alert("삭제 실패하였습니다.");	
							return;
						}
					}
				}
				, error : function(xhr, status, error) {
					alert(error);
				}
			});
		}
	}
	
	function goToList() {
		var frm = document.slightForm;
		frm.action = '/info/infoNoticeList';
		frm.method ="post";
		frm.submit();
	}
	
	function loadContent() {
		var attachments = {};
		Editor.modify({
			"attachments" : function() { /* 저장된 첨부가 있을 경우 배열로 넘김, 위의 부분을 수정하고 아래 부분은 수정없이 사용 */
				var allattachments = [];
				for ( var i in attachments) {
					allattachments = allattachments.concat(attachments[i]);
				}
				return allattachments;
			}(),
			"content" : document.getElementById("content")
		/* 내용 문자열, 주어진 필드(textarea) 엘리먼트 */
		});
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
						<li><a href="/info/infoServicesList">이용안내</a></li>
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
			<input type="hidden" id="no" name="no" value="${resultMap.no }">
			<div id="board_view2">
				<table summary="공지사항목록" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="20%">
						<col width="80%">
					</colgroup>
					<tr>
						<th>제목</th>
						<td>
							<input type="text" id="subject" name="subject" class="tbox06" value="${resultMap.subject }" maxlength ="20" >
						</td>
					</tr>
					<tr>
						<th>내용</th>
						<td>
							<div id="editor_frame"></div>
							<textarea name="content" id="content" rows="10" cols="100" style="width:766px; height:412px;display: none;">
								<c:out value="${resultMap.content}" escapeXml="false"/>
							</textarea>
						</td>
					</tr>
					<tr>
						<th>첨부파일</th>
						<td>
						</td>
					</tr>
				</table>
			</div>
		</form>
		<div id="btn2">
			<p>
				<span><a href="javascript:validation(Save);" class="btn_blue">저장</a></span>
				<span><a href="javascript:Delete()"  class="btn_gray">삭제</a></span>
				<span><a href="javascript:goToList()"  class="btn_gray">목록으로</a></span>
			</p>
		</div>
	</div>
</div>

