<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<sec:authentication var="principal" property="principal" />
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
		var state = obj.state;
		if(state == "SUCCESS"){
			var data = obj.data;			
			var list = data.list;
			var listLen = list.length;		
			var totalCount = data.totalCount;
			var pagination = data.pagination;
			
			
			var str = "";
			var btnStr = "";
			//관리번호, 제목
			if(listLen > 0) {
				for(i=0; i<listLen; i++) {
					str += "<tr>";
					str += "	<td onclick='javascript:getNoticeDetail(\""+list[i].no+"\")'><span> "+list[i].no+"</span></td>";
					str += "	<td onclick='javascript:getNoticeDetail(\""+list[i].no+"\")'><span>"+list[i].subject+"</span></td>";
					str += "</tr>";
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
	
	function getNoticeDetail(no) {
		$("#no").val(no);
		$.ajax({
			type : "POST"			
			, url : "/info/getInfoNoticeDetail"
			, data : {"no":no}
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
			
			for(var key in data){
				//alert("obj1[i].name : "+obj1[i].name + "    key : "+key);
				if(key == "content") {
					$("#"+key).html(data[key]);
				}
				else {
					$("#"+key).text(data[key]);
				}
				console.log(key+" : "+data[key]);
																	
			}

		}
		
		modalPopupCallback( function() {
			modal_popup2('messagePop2');
		});
			
	}
	
	function modalPopupCallback(fnNm) {
		fnNm();
	}
	
	function doUpdate() {
		var frm = document.slightForm;
		frm.action = '/info/infoNoticeSave';
		frm.method ="post";
		frm.submit();
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
			<input type="hidden" id="no" name="no" value="">
			<input type="hidden" id="function_name" name="function_name" value="Search" />
			<input type="hidden" id="current_page_no" name="current_page_no" value="1" />
			<%-- <div id="search_box">
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
			</div> --%>
		</form>
			<div id="toptxt">
			<ul>
				<li><span class="black03">총개수: 0개</span></li>
				<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
					<li class="b_right"><span ><a href="/info/infoNoticeSave" class="btn_gray03">등록</a></span></li>							
				</sec:authorize>
			</ul>
		</div>
		<div id="board_list">
			<table summary="공지사항" cellpadding="0" cellspacing="0">
				<caption>번호,제목</caption>
				<colgroup>
					<col width="20%">
					<col width="*">
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
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
					<h3>공지사항</h3>
					<div id="board_view">
						<!-- 텍스트컬러- 고장신고-blue 고장상태-red -->
						<table summary="공지사항" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="14%">
								<col width="86%">
							</colgroup>
							
							<tbody>
								<tr>
									<th>제목</th>
									<td><div id="subject"></div></td>
								</tr>
								<tr>
									<th>비고</th>
									<td><div id="content"></div></td>
								</tr>
							</tbody>
						</table>
						
						<div id="btn">
							<p>
								<span><a href=" javascript:popupClose()"  class="btn_gray02">닫기</a></span>
								<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
									<span id="update"><a href="javascript:doUpdate()"  class="btn_gray02">수정</a></span>
								</sec:authorize>
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--//결과조회 상세 Popup-->

