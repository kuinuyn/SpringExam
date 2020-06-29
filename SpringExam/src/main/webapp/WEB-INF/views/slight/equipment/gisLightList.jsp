<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript" src="${contextPath }/resources/js/equipment.js"></script>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};
	var ifra;

	$(function(){
		drawCodeData(commonCd, "13", "select", "").then(function(resolvedData) {
			$("#light_type").empty();
			$("#light_type").append(resolvedData);
			
		})
		.then(function() {
			drawCodeData(commonCd, "06", "select", "").then(function(resolvedData) {
				$("#hj_dong_cd").empty();
				$("#hj_dong_cd").append(resolvedData);
			})
		})
		.then(function() {
			drawCodeData(commonCd, "08", "select", "").then(function(resolvedData) {
				$("#stand_cd").empty();
				$("#stand_cd").append(resolvedData);
			})
		})
		.then(function() {
			drawCodeData(commonCd, "10", "select", "").then(function(resolvedData) {
				$("#lamp2_cd").empty();
				$("#lamp2_cd").append(resolvedData);
			})
		})
		.then(function() {
			drawCodeData(commonCd, "11", "select", "").then(function(resolvedData) {
				$("#lamp3_cd").empty();
				$("#lamp3_cd").append(resolvedData);
			})
		})
		/* .then(function() {
			drawCodeData(commonCd, "12", "select", "").then(function(resolvedData) {
				$("#kepco_cd").empty();
				$("#kepco_cd").append(resolvedData);
			})
		}) */
		.then(function() {
			ifra = document.getElementById('gisMap').contentWindow; 
		});
		
		$("#keyword").keypress(function (e) {
			if (e.which == 13){
				searchMap();  // 실행할 이벤트
			}
		});
		
		$("#light_no").keyup(function (e) {
			if (e.which == 32){
				alert("관리번호 입력 시 공백을 제거하여 주십시오.");
				var light_no = $(this).val().replace(/\s/g, '');
				$("#light_no").val(light_no);
				$(this).focus();
			}
		});
	});
	
	function saveGisEquipment() {
		if($("#light_type").val() == "" || $("#light_type").val() == null) {
			alert("설치구분을 선택하세요.");
			return;
		}
		else if($("#light_no").val() == "" || $("#light_no").val() == null) {
			alert("관리번호를 입력하세요.");
			return;
		}
		else if($("#hj_dong_cd").val() == "" || $("#hj_dong_cd").val() == null) {
			alert("지역을 선택하세요.");
			return;
		}
		else if($("#mapPosX").val() == "" || $("#mapPosX").val() == null) {
			alert("X좌표를 입력하세요.");
			return;
		}
		else if($("#mapPosY").val() == "" || $("#mapPosY").val() == null) {
			alert("Y좌표를 입력하세요.");
			return;
		}
		
		var yn = confirm("기본 정보를 저장 하시겠습니까?");
		if(yn){
			$.ajax({
				type : "POST"			
				, url : "/equipment/saveGisEquipment"
				, data : $("#slightForm").serialize()
				, dataType : "JSON"
				, success : function(obj) {
					getSaveGisEquipmentCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});
		}
	}
	
	function getSaveGisEquipmentCallback(obj) {
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("저장을 성공하였습니다.");
				mapReload();
				return;
			}
			else if(obj.resultCnt == -2){
				alert("중복된 관리번호가 있습니다.");
				return;
			}
			else {
				alert("저장을 실패하였습니다.");	
				return;
			}
		}
	}
	
	function deleteEquipment() {
		if($("#flag").val() != "U") {
			alert("대상을 선택하세요.");
			return;
		}
		
		if($("#light_type").val() == "" || $("#light_type").val() == null) {
			alert("설치구분을 선택하세요.");
			return;
		}
		else if($("#light_no").val() == "" || $("#light_no").val() == null) {
			alert("관리번호를 선택하세요.");
			return;
		}
		
		var yn = confirm("기본 정보를 삭제 하시겠습니까?");
		
		if(yn){
			$.ajax({
				type : "POST"			
				, url : "/equipment/deleteEquipment"
				, data : {"light_no" : $("#light_no").val(), "light_type" : $("#light_type").val()}
				, dataType : "JSON"
				, success : function(obj) {
					deleteEquipmentCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});
		}
	}
	
	function deleteEquipmentCallback(obj) {
		
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("삭제를 성공하였습니다.");
				mapReload();
				return;
			}
			else {
				alert("삭제를 실패하였습니다.");	
				return;
			}
		}
	}
	
	function changeMapInfo() {
		var children = $("#side_tab2").find('li');
		var nodes = children.get(0);
		openTab(nodes, 0);
		return;
		
	}
	
	function openTab(ele, num) {
		$(".tab_on").removeClass();
		var nodes = ele.childNodes;
		nodes.item(0).setAttribute('class', 'tab_on');
		
		if(num == 0) {
			$("#gis_system").attr("style", "display:block;");
			$("#btn3").attr("style", "display:block;");
			$("#sidebox_search").attr("style", "display:none;");
			$("#side_search_list").attr("style", "display:none;");
			$(".gisbtn03").attr("style", "display:block;");
		}
		else if(num == 1) {
			$("#sidebox_search").attr("style", "display:block;");
			$("#btn3").attr("style", "display:none;");
			$("#gis_system").attr("style", "display:none;");
			$("#side_search_list").attr("style", "display:none;");
			$(".gisbtn03").attr("style", "display:none;");
		}
		else if(num == 2) {
			$("#sidebox_search").attr("style", "display:block;");
			$("#btn3").attr("style", "display:none;");
			$("#gis_system").attr("style", "display:none;");
			$("#side_search_list").attr("style", "display:block;");
			$(".gisbtn03").attr("style", "display:none;");
		}
	}
	
	function setCancelInfo() {
		var childNodesInput = $("#slightForm").find("input");
		var childNodesSelect = $("#slightForm").find("select");
		var tagId = "";
		
		for(var i=0; i<childNodesInput.size(); i++) {
			tagId = childNodesInput.eq(i).attr("id")
			
			if(tagId == "light_no") {
				$("#light_no").prop("readonly", false);
				$("#light_no").removeClass("tbox11_grey");
				$("#light_no").addClass("tbox11");
				$("#"+tagId).val('');
			}else if(tagId == "light_no") {
				$("#"+tagId).val('I');
			}
			else {
				$("#"+tagId).val('');
			}
		}
		
		for(var i=0; i<childNodesSelect.size(); i++) {
			tagId = childNodesSelect.eq(i).attr("id")
			$("#"+tagId).val('');
		}
		
		ifra.setMarkers(null);
	}
	
	function onNewPos(flag) {
		if(flag == "I"){
			slightForm.flag.value = flag;
			slightForm.reset();
			$("#light_no").prop("readonly", false);
			$("#light_no").removeClass("tbox11_grey");
			$("#light_no").addClass("tbox11");
		}else{
			if($("#light_no").val() == "" || $("#light_no").val() == null) {
				alert("수정대상을 선택하세요.");
				
				return;
			}
			
			slightForm.flag.value = "U";
		}
		
		alert("지도내에 원하는 위치를 마우스로 클릭하세요.");
		
		changeMapInfo();
		
		/* if(flag == ""){
			if(slightForm.lightNo.value==""){
				alert("수정대상을 선택해주세요.");
				return;
			}else{			
				alert("지도내에 원하는 위치를 마우스로 클릭하세요.");
			}
		} */
		
		ifra.onAddIcon();
	}
	
	function mapReload() {
		var mapInfo = ifra.getMapInfo();
		$("#gisMap").attr("src", "/common/map/mapContentDaum2?center_x="+mapInfo[0]+"&center_y="+mapInfo[1]);
		setCancelInfo();
	}
	
	function chkEquipment() {
		$("#light_no").prop("readonly", true);
		$("#light_no").removeClass("tbox11");
		$("#light_no").addClass("tbox11_grey");
	}
	
	function searchMap() {
		var num = 0;
		var childNodes = $("#side_tab2").find('li');
		
		for(var i=0; i<childNodes.size(); i++) {
			if(childNodes.eq(i).find('.tab_on').size() > 0) {
				num = i;
			}
		}
		
		if($("#keyword").val() == null || $("#keyword").val() == "") {
			alert("검색어를 입력하세요.");
			return;
		}
		
		if(num == 1) {
			ifra.searchDetailAddrSearch($("#keyword").val());
		}
		else if(num == 2) {
			resArrd = "<ul>";
			resArrd += "<li>처리중</li>";
			resArrd += "</ul>";
		
			$("#side_search_list").html(resArrd);
			
			$.ajax({
				type : "POST"			
				, url : "/common/map/mapDataKakao"
				, data : {"keyword" : $("#keyword").val(), "keytype" : num}
				, dataType : "JSON"
				, success : function(obj) {
					getSearchMapCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});
		}
	}
	
	function getSearchMapCallback(obj) {
		var state = obj.returnMsg;
		var dataSet = new Array();
		var arrList = new Array();
		var resArrd = "";
		var arrListVal = 2;
		
		if(state != false) {
			dataSet = state.split("^");
			var dataList = new Array();
			$("#side_title .red02").text("총 "+dataSet.length+"건");
			$("#side_title2 .red02").text("총 "+dataSet.length+"건");
			
			for(var i = 0;i < dataSet.length; i++) {
				dataList = dataSet[i].split("|");
				arrList[i] = new Array(dataList.length);
				
				for(var j = 0;j < dataList.length; j++) {
					arrList[i][j] = toTrim(dataList[j]);
				}
			}
			
			resArrd = "<ul>";
			if(arrList[0][1] != "" && arrList[0][1] != undefined) {	
				for(var k = 0;k < arrList.length; k++) {
					if(arrList[k][3] != "" && arrList[k][3] != undefined && arrList[k][4] != "" && arrList[k][4] != undefined) {
						/* if(searchGubun == "new") arrListVal = 8;
						else arrListVal = 2; */
						
						resArrd += "<li style=\"text-align:left;\"><a href=\"javascript:onBodyUrl('"+arrList[k][3]+"', '"+arrList[k][4]+"', '"+arrList[k][1]+"');\"  >["+[arrList[k][1]]+"]"+arrList[k][arrListVal]+"</a></li>";
					}
				}
			}
			resArrd += "</ul>";
		}
		else {
			$("#side_title .red02").text("총 0건");
			$("#side_title2 .red02").text("총 0건");
			
			resArrd = "<ul>";
			resArrd += "<li>검색결과가 없습니다.</li>";
			resArrd += "</ul>";
		}
		
		$("#side_search_list").html(resArrd);
	}
	
	function onBodyUrl(xPos, yPos, searchLightNo) {	
		ifra.map_move(xPos, yPos, searchLightNo);
		ifra.onAjaxData(xPos, yPos, searchLightNo);
	}
	
	function getEquipmentDetail() {

		if($("#light_no").val() == "" || $("#light_no").val() == null || $("#light_type").val() == "" || $("#light_type").val() == null) {
			alert("도로조명을 선택하세요.");
			return;
		}
		
		
		$.ajax({
			type : "POST"			
			, url : "/equipment/equipmentDet"
			, data : {"light_no" : $("#light_no").val() , "light_type" : $("#light_type").val()  }
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
		if(data != null) {
			var key, element, repairRst = "";
			var repairList = {};
			for(key in data) {
				element = "det_"+key;
				if($("#"+element).length > 0) {
					$("#"+element).text(data[key]);
				}
				if($("#"+key).length > 0) {
					$("#"+key).val(data[key]);
				}
				
				$("#hj_dong_cd").val($("#searchArea").val())
			}
			
			var frm = document.frmDet;
			frm.action =  "/common/map/mapContentDaum2?searchLightNo="+data['light_no']+"&center_x="+data['map_x_pos_gl']+"&center_y="+data['map_y_pos_gl'];
			frm.target = 'mapDet';
			frm.submit();


			if(data['downLoadFiles'] != null && data['downLoadFiles'] != "") {
				var downLoadFiles = data['downLoadFiles'];
				var filePah = "";
				
				for(i = 0; i<downLoadFiles.length; i++) {
					filePah = "/display?name="+downLoadFiles[i].file_name_key;
					$("#detail_slight").children().eq(i).children("img").attr("src", filePah)
				}
			}
			else {
				
				for(i = 0; i<$("#detail_slight").children().size(); i++) {
					$("#detail_slight").children().eq(i).children("img").attr("src", "/resources/css/images/sub/slight_noimg.gif");
				}
			}
			
			if(data['detRepirList'] != null && data['detRepirList'] != "") {
				repairList = data['detRepirList'];
				repairRst = "<tr>";
				for(i=0; i<repairList.length; i++) {
					repairRst += "<td><span>"+repairList[i].repair_no+"</span></td>";
					repairRst += "<td><span>"+repairList[i].repair_date+"</span></td>";
					repairRst += "<td><span>"+repairList[i].trouble_type_nm+"</span></td>";
					repairRst += "<td><span>"+repairList[i].repair_desc+"</span></td>";
					repairRst += "<td><span>"+repairList[i].progress_name+"</span></td>";
				}
				repairRst += "</tr>";
				
			}
			else {
				repairRst = "<tr>";
				repairRst += "<td colspan='5'><span>보수이력이 없습니다.</span></td>";
				repairRst += "</tr>";
			}
			
			$("#repair_list").html(repairRst);
			
			modalPopupCallback( function() {
				modal_popup2('messagePop2');
			});
			
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
						<li><a href="/info/infoServicesList">이용안내</a></li>
					</ul>
				</li>
				<li><a href="#">GIS관리 <img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
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

	<div id="sub" style="padding-top: 130px;">
		<div id="s_map">
			<!-- <img src="/resources/css/images/sub/map.gif" class="mapbg"> -->
			<iframe id="gisMap" name="gisMap" src="/common/map/mapContentDaum2" style="width: 100%;height:840px;" class="mapbg"></iframe>
			<form id="slightForm" name="slightForm" method="post">
				<input type="hidden" id="flag" name="flag" value="I">
				<div id="side_map03">
					<div id="side_tab2">
					<ul>
						<li onclick="javascript:openTab(this, 0)"><a href="#"  class="tab_on">지도관리</a></li>
						<li onclick="javascript:openTab(this, 1)"><a href="#" >주소검색</a></li>
						<li onclick="javascript:openTab(this, 2)"><a href="#" >관리번호</a></li>
					</ul>
					</div>
					
					<!-- 지도관리 tab-->
					<div id="sidebox_gis">
						<div id="gis_system">
							<ul>
								<li class="gis_tit">설치구분</li>
								<li>
									<select class="sel05" id="light_type" name="light_type">
									</select>
								</li>
							</ul>
							<ul>
								<li class="gis_tit">관리번호</li>
								<li><input type="text" id="light_no" name="light_no" class="tbox11" maxlength="20"></li>
							</ul>
							<ul>
								<li class="gis_tit">지역선택</li>
								<li>
									<select class="sel05" id="hj_dong_cd" name="hj_dong_cd">
									</select>
								</li>
							</ul>
							<ul>
								<li class="gis_tit">광원종류</li>
								<li>
									<select class="sel05" id="lamp2_cd" name="lamp2_cd">
									</select>
								</li>
							</ul>
							<ul>
								<li class="gis_tit">광원용량</li>
								<li>
									<select class="sel05" id="lamp3_cd" name="lamp3_cd">
									</select>
								</li>
							</ul>
							<!-- <ul>
								<li class="gis_tit">쌍등</li>
								<li>
									<select class="sel05" id="" name="">
										<option selected>N</option>
										<option >Y</option>
									</select>
								</li>
							</ul> -->
							<ul>
								<li class="gis_tit">인입주번호</li>
								<li><input type="text" name="pole_no" id="pole_no" class="tbox11" maxlength="50" ></li>
							</ul>
							<ul>
								<li class="gis_tit">고객번호</li>
								<li><input type="text" name="kepco_cust_no" id="kepco_cust_no" class="tbox11" maxlength="15" ></li>
							</ul>
							<ul>
								<li class="gis_tit">계약전력</li>
								<li><input type="text" name="kepco_cd" id="kepco_cd" class="tbox11" maxlength="10"></li>
							</ul>
							<ul>
								<li class="gis_tit">사용량</li>
								<li><input type="text" name="use_light" id="use_light" class="tbox11" maxlength="10"></li>
							</ul>
							<!-- <ul>
								<li class="gis_tit">사용량</li>
								<li><input type="text" name="" class="tbox11"></li>
							</ul>
							<ul>
								<li class="gis_tit">전기요금</li>
								<li><input type="text" name="" class="tbox11"></li>
							</ul> -->
							<!-- <ul>
								<li class="gis_tit">납기일</li>
								<li><input type="text" name="" class="tbox11"></li>
							</ul> -->
							<ul>
								<li class="gis_tit">X좌표</li>
								<li><input type="text" name="mapPosX" id="mapPosX" class="tbox11_grey" readonly="readonly"></li>
							</ul>
							<ul>
								<li class="gis_tit">Y좌표</li>
								<li><input type="text" name="mapPosY" id="mapPosY" class="tbox11_grey" readonly="readonly"></li>
							</ul>
							<ul>
								<li class="gis_tit">구주소</li>
								<li><input type="text" name="address" id="address" class="tbox11" maxlength="100"></li>
							</ul>
							<ul>
								<li class="gis_tit">신주소</li>
								<li><input type="text" name="new_address" id="new_address" class="tbox11" maxlength="100"></li>
							</ul>
						</div>
						<div id="sidebox_search" style="display: none;">
							<div id="searchbox"><input type="text" name="keyword" id="keyword" class="tbox05"></div>
							<a href="javascript:searchMap();"><div id="searchbox_btn"><span class="hide">검색</span></div></a>
							<div id="side_search_list" >
								<ul>
									<li>검색결과가 없습니다.</li>
								</ul>
							</div>
						</div>
						<div id="btn3">
							<p>
								<span><a href="javascript:setCancelInfo()"  class="btn_gray">입력취소</a></span>
								<span><a href="javascript:deleteEquipment()"  class="btn_gray">삭제</a></span>
								<span ><a href="javascript:saveGisEquipment()" class="btn_black">저장</a></span>
							</p>
						</div>
						<div id="gis_icon"></div>
						<div id="btm_gisbtn">
							<ul>
								<li><a href="javascript:onNewPos('I')" class="gisbtn01">신규등록</a></li>
								<li><a href="javascript:onNewPos('')" class="gisbtn02">위치정보 등록 및 수정</a></li>
								<li><a href="javascript:getEquipmentDetail()" class="gisbtn03">보안등 이력관리</a></li>
							</ul>
						</div>
						
					
					</div>
				</div>
			</form>
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
					<h3>도로조명 상세내역</h3>
					<div id="board_view">
						<!-- 보안등상세내역-->
						<table summary="도로조명 상세" cellpadding="0" cellspacing="0">
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
									<td><span id="det_lamp1_nm2"></span></td>
								</tr>
								<tr>
									<th>광원종류1</th>
									<td><span id="det_lamp2_nm"></span></td>
									<th>광원종류2</th>
									<td><span id="det_lamp2_nm2"></span></td>
								</tr>
								<tr>
									<th>광원용량1</th>
									<td><span id="det_lamp3_nm"></span></td>
									<th>광원용량2</th>
									<td><span id="det_lamp3_nm2"></span></td>
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
					<!--지도,보안등사진 -->
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
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
