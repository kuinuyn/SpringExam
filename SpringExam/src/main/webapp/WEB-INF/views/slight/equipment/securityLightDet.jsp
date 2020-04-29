<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};

	$(function(){
		
	});
	
	function goToMod() {
		var frm = document.slightForm;
		frm.action = '/equipment/securityLightMod';
		frm.method ="post";
		frm.submit();
	};
	
	function goToList() {
		var frm = document.slightForm;
		frm.action = '/equipment/securityLight';
		frm.method ="post";
		frm.submit();
		//$("#slightForm").attr({action:'/equipment/securityLight'}).submit();
	}
	
</script>
<body>
	<div id="wrap">
		<div id="container">
			<div class="inner">
				<form id="slightForm" name="slightForm">
					<input type="hidden" id="light_no" name="light_no" value="${param.light_no}">
					<input type="hidden" id="par_hj_dong" name="par_hj_dong" value="${param.par_hj_dong}">
					<input type="hidden" id="current_page_no" name="current_page_no" value="${param.current_page_no }" />
					<input type="hidden" id="searchLampGubun" name="searchLampGubun" value="${param.searchLampGubun }" />
					<input type="hidden" id="delete_file" 		name="delete_file" value=""/><!-- 삭제할 파일 -->
					<table class="table01">
						<caption><strong><span class="t_red">*</span> 표시는 필수입력 항목입니다.</strong></caption>
						<colgroup>
							<col width="20%">
							<col width="40%">
							<col width="20%">
							<col width="*">
						</colgroup>
						<tbody id="tbody">
							<tr>
								<th>관리번호<span class="t_red">*</span></th>
								<td><c:out value="${param.light_no }" /></td>
								<th>구관리번호</th>
								<td>
									<c:out value="${resultData.old_light_no }" />
								</td>
							</tr>
							<tr>
								<th>행정동<span class="t_red">*</span></th>
								<td colspan="3">
									<c:out value="${resultData.hj_dong_nm}" />
								</td>
							</tr>
							<tr>
								<th>회사</th>
								<td>
									<c:out value="${resultData.mgmt_no}" />
								</td>
								<th>점멸기</th>
								<td>
									<c:out value="${resultData.auto_jum_type1_nm}" />
								</td>
							</tr>
							<tr>
								<th>도엽번호</th>
								<td>
									<c:out value="${resultData.doyep_no}" />
								</td>
								<th>공사번호</th>
								<td>
									<c:out value="${resultData.bgs_no}" />
								</td>
							</tr>
							<tr>
								<th>변대주</th>
								<td>
									<c:out value="${resultData.bdj}" />
								</td>
								<th>인입주</th>
								<td>
									<c:out value="${resultData.pole_no}" />
								</td>
							</tr>
							<tr>
								<th>등상태</th>
								<td>
									<c:out value="${resultData.lamp1_gubun_nm}" />
								</td>
								<th>쌍등여부</th>
								<td>
									<c:out value="${resultData.twin_light_nm}" />
								</td>
							</tr>
							<tr>
								<th>등기구모형1</th>
								<td>
									<c:out value="${resultData.lamp1_nm}" />
								</td>
								<th>등기구모형2</th>
								<td>
									<c:out value="${resultData.lamp1_nm}" />
								</td>
							</tr>
							<tr>
								<th>광원종류1</th>
								<td>
									<c:out value="${resultData.lamp2_nm}" />
								</td>
								<th>광원종류2</th>
								<td>
									<c:out value="${resultData.lamp2_nm}" />
								</td>
							</tr>
							<tr>
								<th>광원용량1</th>
								<td>
									<c:out value="${resultData.lamp3_nm}" />
								</td>
								<th>광원용량2</th>
								<td>
									<c:out value="${resultData.lamp3_nm}" />
								</td>
							</tr>
							<tr>
								<th>스위치종류</th>
								<td>
									<c:out value="${resultData.onoff_nm}" />
								</td>
								<th>지지방식</th>
								<td>
									<c:out value="${resultData.stand_nm}" />
								</td>
							</tr>
							<tr>
								<th>한전고객번호</th>
								<td>
									<c:out value="${resultData.kepco_cust_no}" />
								</td>
								<th>한전계약전력</th>
								<td>
									<c:out value="${resultData.kepco_nm}" />
								</td>
							</tr>
							<tr>
								<th>작업진행현황</th>
								<td>
									<c:out value="${resultData.work_nm}" />
								</td>
								<th>설치일자</th>
								<td>
									<c:out value="${resultData.set_ymd}" />
								</td>
							</tr>
							<tr>
								<th>사용량</th>
								<td colspan="3">
									<c:out value="${resultData.use_light}" />
								</td>
							</tr>
							<tr>
								<th>구주소</th>
								<td colspan="3">
									<c:out value="${resultData.address}" />
								</td>
							</tr>
							<tr>
								<th>신주소</th>
								<td colspan="3">
									<c:out value="${resultData.new_address}" />
								</td>
							</tr>
							<tr>
								<th colspan="4">지도</th>
							</tr>
							<tr>
								<td colspan="4">
									<iframe src="${contextPath}/common/map/mapContentDaum2?searchLightNo=<c:out value="${resultData.light_no}" />&center_x=<c:out value="${resultData.map_x_pos_gl}" />&center_y=<c:out value="${resultData.map_y_pos_gl}" />" width="100%" height="429"  frameborder="0"></iframe>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				<div class="btn_right mt15">
					<input type="button" class="btn black mr5" onclick="javascript:goToList();" value="목록으로">
					<input type="button" class="btn black" onclick="javascript:goToMod();" value="수정하기">
				</div>
			</div>
		</div>
	</div>
</body>
</html>