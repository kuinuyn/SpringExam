<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript" src="${contextPath }/resources/js/equipment.js"></script>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};

	$(function(){
		var searchArea = "${param.par_hj_dong}";
		var pageNo = "${param.current_page_no}";
		var searchLampGubun = "${param.searchLampGubun}";
		
		//drawCodeData(리스트, 코드타입, 태그이름, 태그ID, 모드, 현재선택코드)
		drawCodeData(commonCd, "06", "", "ALL", searchArea).then(function(resolvedData) {
			$("#tagInsert").empty();
			$("#tagInsert").append(resolvedData);
			
			if(searchArea != "" && searchArea != null) {
				$("#searchArea").val(searchArea);
			}
		})
		.then(function() {
			drawCodeData(commonCd, "08", "select", "").then(function(resolvedData) {
				$("#stand_cd").empty();
				$("#stand_cd").append(resolvedData);
				$("#stand_cd").parents("li").hide();
			})
		})
		.then(function() {
			drawCodeData(commonCd, "10", "select", "").then(function(resolvedData) {
				$("#lamp2_cd").empty();
				$("#lamp2_cd").append(resolvedData);
				$("#lamp2_cd").parents("li").hide();
			})
		})
		.then(function() {
			drawCodeData(commonCd, "11", "select", "").then(function(resolvedData) {
				$("#lamp3_cd").empty();
				$("#lamp3_cd").append(resolvedData);
				$("#lamp3_cd").parents("li").hide();
			})
		})
		.then(function() {
			$("input:radio[name=searchLampGubun]:input[value='"+searchLampGubun+"']").attr("checked", true);
		})
		.then(function() {
			if(pageNo != "" && pageNo != null) {
				Search(pageNo);
			}
			else {
				Search();
			}
		});
		
		$("input[type='radio'][name='searchLampGubun']").click(function() {
			Search();
		});
		
		$("#searchType").change(function() {
			var searchType = $(this).val();
			
			if(searchType == "") {
				$("#keyword").val("");
				$("#keyword").show();
				$("#keyword").addClass("tbox03_gray");
				$("#keyword").attr("readonly", true);
				$("#stand_cd").parents("li").hide();
				$("#lamp2_cd").parents("li").hide();
				$("#lamp3_cd").parents("li").hide();
			}
			else if(searchType == 1 || searchType == 2 || searchType == 3 || searchType == 7) {
				$("#keyword").val("");
				$("#keyword").show();
				$("#keyword").removeClass("tbox03_gray");
				$("#keyword").addClass("tbox03");
				$("#keyword").attr("readonly", false);
				$("#stand_cd").parents("li").hide();
				$("#lamp2_cd").parents("li").hide();
				$("#lamp3_cd").parents("li").hide();
			}
			else if(searchType == 4) {
				$("#keyword").val("");
				$("#keyword").hide();
				$("#stand_cd").parents("li").show();
				$("#lamp2_cd").parents("li").hide();
				$("#lamp3_cd").parents("li").hide();
			}
			else if(searchType == 5) {
				$("#keyword").val("");
				$("#keyword").hide();
				$("#stand_cd").parents("li").hide();
				$("#lamp2_cd").parents("li").show();
				$("#lamp3_cd").parents("li").hide();
			}
			else if(searchType == 6) {
				$("#keyword").val("");
				$("#keyword").hide();
				$("#stand_cd").parents("li").hide();
				$("#lamp2_cd").parents("li").hide();
				$("#lamp3_cd").parents("li").show();
			}
		});
	});
	
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
						<li><a href="/info/infoServicesList">이용안내</a></li>
					</ul>
				</li>
				<li><a href="#">분전함관리 <img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
					<ul>
						<li><a href="/equipment/securityLightList">보안등관리</a></li>
						<li><a href="/equipment/streetLightList">가로등관리</a></li>
						<li><a href="/equipment/distributionBoxList">분전함관리</a></li>
						<li><a href="/equipment/gisLightList">GIS관리</a></li>
						<li><a href="/equipment/equipStaitstice" >통계관리</a></li>
						<li><a href="/system/systemMemberList">사용자관리</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>

	<div id="sub">
		<div id="sub_title"><h3>분전함 관리</h3></div>
		<!-- 검색박스 -->
		<form id="slightForm" name="slightForm" method="post" action="/">
			<input type="hidden" name="searchArea" id="searchArea">
			<input type="hidden" name="lightType" id="lightType" value="3">
			<input type="hidden" name="address" id="address" value="">
			<input type="hidden" name="hj_dong_cd" id="hj_dong_cd" value="">
			<input type="hidden" name="codeType" value="">
			<input type="hidden" id="light_no" name="light_no" value="">
			<input type="hidden" id="function_name" name="function_name" value="Search" />
			<input type="hidden" id="excelHeader" name="excelHeader">
			<input type="hidden" id="current_page_no" name="current_page_no" value="1" />
			<!-- 지역선택box -->
			<div id="area_box">
				<table summary="분전함관리 지역목록"  cellpadding="0" cellspacing="0" >
					<colgroup>
						<col width="16%">
						<col width="17%">
						<col width="17%">
						<col width="17%">
						<col width="16%">
						<col width="17%">
					</colgroup>
					<tbody id="tagInsert">
					</tbody>
				</table>
			</div>
			
			<div id="search_box">
				<ul>
					<li class="title">등상태</li>
					<li class="sel_radio">
						<span><input type="radio" name="searchLampGubun" checked="checked" value="">전체</span>
						<span><input type="radio" name="searchLampGubun" value="1">신설</span>
						<span><input type="radio" name="searchLampGubun" value="3">철거</span>
					</li>
					<li class="pdl350">
						<select id="searchType" name="searchType" size="1" class="sel01">
							<option value="">전체</option>
							<option value="1">관리번호</option>
							<option value="2">주소검색</option>
							<option value="3">새주소</option>
							<option value="4">지지방식</option>
							<option value="5">광원종류</option>
							<option value="6">광원용량</option>
							<option value="7">한전고객번호</option>
						</select>
					</li>
					<li><input type="text" name="keyword" id="keyword" class="tbox03_gray" readonly="readonly"></li>
					<li>
						<select id="stand_cd" name="stand_cd" class="sel01">
						</select>
					</li>
					<li>
						<select id="lamp2_cd" name="lamp2_cd" class="sel01">
						</select>
					</li>
					<li>
						<select id="lamp3_cd" name="lamp3_cd" class="sel01">
						</select>
					</li>
					<li><a href="javascript:Search();"  class="btn_search01">검 색</a></li>
				</ul>
			</div>
		</form>
		<div id="board_list">
			<!-- 분전함관리 리스트 -->
			<table summary="분전함관리" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="12%">
					<col width="20%">
					<col width="20%">
					<col width="9%">
					<col width="9%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th>관리번호</th>
						<th>주소</th>
						<th>도로명주소</th>
						<th>지지방식</th>
						<th>광원종류</th>
						<th>광원용량</th>
						<th>한전고객번호</th>
						<th>수리내역</th>
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
					<h3>분전함 상세내역</h3>
					<div id="board_view">
						<!-- 보안등상세내역-->
						<table summary="분전함상세" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="14%">
								<col width="36%">
								<col width="14%">
								<col width="36%">
							</colgroup>
							<tbody>
								<tr>
									<th>관리번호</th>
									<td><span id="det_light_no"></span></td>
									<th>구관리번호</th>
									<td><span id="det_old_light_no"></span></td>
								</tr>
								<tr>
									<th>행정동</th>
									<td colspan="3"><span id="det_hj_dong_nm"></span></td>
								</tr>
								<tr>
									<th>회사</th>
									<td><span id="det_mgmt_no"></span></td>
									<th>점멸기</th>
									<td><span id="det_auto_jum_type1_nm"></span></td>
								</tr>
								<tr>
									<th>도엽번호</th>
									<td><span id="det_doyep_no"></span></td>
									<th>공사번호</th>
									<td><span id="det_bgs_no"></span></td>
								</tr>
								<tr>
									<th>변대주</th>
									<td><span id="det_bdj"></span></td>
									<th>인입주</th>
									<td><span id="det_pole_no"></span></td>
								</tr>
								<tr>
									<th>등상태</th>
									<td><span id="det_light_gubun_nm"></span></td>
									<th>쌍등여부</th>
									<td><span id="det_twin_light_nm"></span></td>
								</tr>
								<tr>
									<th>등기구모형1</th>
									<td><span id="det_lamp1_nm"></span></td>
									<th>등기구모형2</th>
									<td><span id="det_lamp1_nm"></span></td>
								</tr>
								<tr>
									<th>광원종류1</th>
									<td><span id="det_lamp2_nm"></span></td>
									<th>광원종류2</th>
									<td><span id="det_lamp2_nm"></span></td>
								</tr>
								<tr>
									<th>광원용량1</th>
									<td><span id="det_lamp3_nm"></span></td>
									<th>광원용량2</th>
									<td><span id="det_lamp3_nm"></span></td>
								</tr>
								<tr>
									<th>스위치종류</th>
									<td><span id="det_onoff_nm"></span></td>
									<th>지지방식</th>
									<td><span id="det_stand_nm"></span></td>
								</tr>
								<tr>
									<th>한전고객번호</th>
									<td><span id="det_kepco_cust_no"></span></td>
									<th>한전계약전력</th>
									<td><span id="det_kepco_nm"></span></td>
								</tr>
								<tr>
									<th>작업진행현황</th>
									<td><span id="det_work_nm"></span></td>
									<th>설치일자</th>
									<td><span id="det_set_ymd"></span></td>
								</tr>
								<tr>
									<th>사용량</th>
									<td colspan="3"><span id="det_use_light"></span></td>
								</tr>
								<tr>
									<th>구주소</th>
									<td colspan="3"><span id="det_address"></span></td>
								</tr>
								<tr>
									<th>신주소</th>
									<td colspan="3"><span id="det_new_address"></span></td>
								</tr>
							</tbody>
						</table>
					</div>
					<!--지도,분전함사진 -->
					<div id="detail_mimg">
						<div id="detail_map">
							<iframe id="mapDet" name="mapDet" scrolling="no" style="width: 100%; height: 100%;" class="p_map"></iframe>
							<form name="frmDet" id="frmDet" method="post">
							</form>
						</div>
						<div id="detail_slight">
							<p><img src="/resources/css/images/sub/slight_noimg.gif"></p>
							<p><img src="/resources/css/images/sub/slight_noimg.gif"></p>
						</div>
						<!-- 신고리스트 -->
						<div id="board_list3">
							<table  cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="15%">
									<col width="15%">
									<col width="30%">
									<col width="20%">
									<col width="20%">
								</colgroup>
								<thead>
									<tr>
										<th>접수번호</th>
										<th>보수일자</th>
										<th>고장상태</th>
										<th>보수내역</th>
										<th>진행상태</th>
									</tr>
								</thead>
								<tbody id="repair_list">
								</tbody>
							</table>
							<div id="btn">
								<p>
								<span><a href="javascript:deleteEquipment()"  class="btn_gray02"> 삭제</a></span>
								<span><a href="javascript:goToMod()"  class="btn_gray02">수정</a></span>
								</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<!--고장신고 지도 Popup-->
<div class="modal-popup3">
	<div class="bg"></div>
	<div id="messagePop3" class="pop-layer2">
		<div class="pop-container">
			<div class="pop-conts">
				<div class="btn-r">
					<a href="#" class="cbtn"><i class="fa fa-times " aria-hidden="true"></i><span class="hide">Close</span></a>
				</div>
				<div class="pop_map ">
					<h3 class="hide">고장신고</h3>
					<div id="mapbg">
						<iframe id="mapContentDaum" name="mapContentDaum" scrolling="no" style="width: 100%; height: 100%;" class="p_map"></iframe>
						<form name="frm" id="frm" method="post">
							<input type="hidden" id="searchLightNo" name="searchLightNo">
							<input type="hidden" id="center_x" name="center_x">
							<input type="hidden" id="center_y" name="center_y">
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--//고장신고 지도 Popup-->
