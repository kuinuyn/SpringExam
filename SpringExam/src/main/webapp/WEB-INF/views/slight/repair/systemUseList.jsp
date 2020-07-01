<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};
	$(function(){	
	
		searchCompany($("#searchYear").val(), $("#searchCom"), "");			
		Search();
		
		$("#searchYear").change(function() {		
			searchCompany($("#searchYear").val(), $("#searchCom"), "");			
			Search();
		});
		
		$("#searchCom").change(function() {
			Search();
		});		
	});	
	
	function Search(currentPageNo) {
		if(currentPageNo === undefined){
			currentPageNo = "1";
		}
		
		$("#current_page_no").val(currentPageNo);
		
		$.ajax({
			type : "POST"			
			, url : "/repair/getSystemUseList"
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
			var residualQuantity = "";
			
			var str = "";
			var btnStr = "";
			//코드번호,자재명,제조사,입고량,출고량,잔량    
			if(listLen > 0) {
				for(i=0; i<listLen; i++) {
					
					residualQuantity = ""+list[i].in_cnt - list[i].out_cnt;
					
					str += "<tr>";  
					str += "	<td><span> <a href='javascript:getSystemUseDetail(\""+list[i].part_cd+"\", \""+list[i].part_name+"\", \""+list[i].year+"\", \""+list[i].comp_nm+"\", \""+list[i].company_id+"\")'>"+list[i].part_cd+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getSystemUseDetail(\""+list[i].part_cd+"\", \""+list[i].part_name+"\", \""+list[i].year+"\", \""+list[i].comp_nm+"\", \""+list[i].company_id+"\")'>"+list[i].part_name+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getSystemUseDetail(\""+list[i].part_cd+"\", \""+list[i].part_name+"\", \""+list[i].year+"\", \""+list[i].comp_nm+"\", \""+list[i].company_id+"\")'>"+list[i].comp_nm+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getSystemUseDetail(\""+list[i].part_cd+"\", \""+list[i].part_name+"\", \""+list[i].year+"\", \""+list[i].comp_nm+"\", \""+list[i].company_id+"\")'>"+list[i].in_cnt+" 개</a></span></td>";
					str += "	<td><span> <a href='javascript:getSystemUseDetail(\""+list[i].part_cd+"\", \""+list[i].part_name+"\", \""+list[i].year+"\", \""+list[i].comp_nm+"\", \""+list[i].company_id+"\")'>"+list[i].out_cnt+" 개 </a></span></td>";
					str += "	<td><span> <a href='javascript:getSystemUseDetail(\""+list[i].part_cd+"\", \""+list[i].part_name+"\", \""+list[i].year+"\", \""+list[i].comp_nm+"\", \""+list[i].company_id+"\")'>"+residualQuantity+" 개</a></span></td>";
					str += "</tr>";
				}
			}
			else {
				str += "<tr>";
				str += "	<td colspan='6' style='text-align: center;'>등록된 글이 존재하지 않습니다.</td>";
				str += "</tr>";
			}
			
			$("#tbody").html(str);			
	//		$("#total_count").text(totalCount);		
			$("#pagination").html(pagination);
		}
	}
	
	function getSystemUseDetail(part_cd, part_name, year, comp_nm, company_id) {
		
		var frm = document.slightForm;
	    frm.part_cd.value = part_cd;
	    frm.part_name.value = part_name;	    
		frm.year.value = year;
		frm.comp_nm.value = comp_nm;
		frm.company_id.value = company_id;	
		frm.action = '/repair/systemUseView';
		frm.method ="post";
		frm.submit();
		
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
				<li><a href="#">보수이력관리</a>
					<ul>
						<li><a href="/repair/systemRepairList">보수이력관리</a></li>
						<li><a href="#" >신설현황</a></li>
						<li><a href="#">이설현황</a></li>
						<li><a href="#" >철거현황</a></li>
						<li><a href="#">자재관리</a></li>
						<li><a href="/repair/systemUseList" >자재입/출고관리</a></li>
					</ul>
				</li>				
			</ul>
		</div>
	</div>

	<div id="sub">
		<div id="sub_title"><h3>자재입/출고관리</h3></div>
		<form id="slightForm" name="slightForm" method="post" action="">
			<input type="hidden" id="function_name" name="function_name" value="Search" />
			<input type="hidden" id="current_page_no" name="current_page_no" value="1" />
			<input type="hidden" id="part_cd" name="part_cd" value="" />
			<input type="hidden" id="part_name" name="part_name" value="" />			
			<input type="hidden" id="year" name="year" value="" />			
			<input type="hidden" id="comp_nm" name="comp_nm" value="" />
			<input type="hidden" id="company_id" name="company_id" value="" />											
			<div id="toptxt">
				<ul>
					<li class="b_left">
						<select id ="searchYear" name="searchYear" class="sel01">
							<c:forEach items="${searchYearList}" var="year">
								<option value="${year.year }">${year.year }년</option>
							</c:forEach>
						</select>
					</li>
					<li class="b_left">
						<select id ="searchCom" name="searchCom" class="sel01">
						</select>
					</li>					
				</ul>
			</div>
		</form>
		<div id="board_list">
			<!--  사용자관리 리스트 -->
			<table summary="자재입/출고관리" cellpadding="0" cellspacing="0">

				<colgroup>
					<col width="10%">
					<col width="25%">
					<col width="25%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th>코드번호</th>
						<th>자재명</th>
						<th>제조사</th>
						<th>입고량</th>
						<th>출고량</th>
						<th>잔량</th>
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