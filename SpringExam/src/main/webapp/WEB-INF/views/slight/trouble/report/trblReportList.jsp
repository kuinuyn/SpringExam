<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	var lightType = "${param.lightType}" != "" && "${param.lightType}" != null ? "${param.lightType}" : "${param.light_type}";
	var address = "${param.address}";
	var hj_dong_cd = "${param.hj_dong_cd}";
	var lightGubunlDefault;
	
	$(function(){
		drawCodeData(commonCd, "01", "select", "").then(function(resolvedData) {
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
			drawCodeData(commonCd, "14", "select", "").then(function(resolvedData) {
				$("#repair_cd").empty();
				$("#repair_cd").append(resolvedData);
				
				$("#repair_cd option[value=6]").remove();
				$("#repair_cd option[value=7]").remove();
				$("#repair_cd option[value=8]").remove();
			})
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
		
		//light_gubun 선택값 변경 시 selected 인덱스 번호를 초기 값으로 재설정
		$( '#light_gubun' ).change(function() {
			if($("#light_no").val() != null && $("#light_no").val() != "") {
				$(this)[0].selectedIndex = lightGubunlDefault;
			}
		});
		
		$("#keyword").keypress(function (e) {
			if (e.which == 13){
				searchMap();  // 실행할 이벤트
			}
		});
		
		$("#map_open").click(function() {
			$("#side_list").attr("style", "display:block;");
			$("#side_title2").attr("style", "display:none;");
			$("#map_open").attr("style", "display:none;");
		});
		
		$("#map_close").click(function() {
			$("#side_list").attr("style", "display:none;");
			$("#side_title2").attr("style", "display:block;");
			$("#map_open").attr("style", "display:block;")
		});
	});
	
	
	function goGisMap() {
		var frm = document.troubleForm;
		
		frm.action =  "${contextPath}/common/map/mapContentDaum2";
		frm.target = 'mapContentDaum';
		frm.submit();
		
		$("#keyword").val("");
		$("#side_title .red02").text("총 0건");
		$("#side_title2 .red02").text("총 0건");
		var resArrd = "";
		resArrd = "<ul>";
		resArrd += "<li>검색결과가 없습니다.</li>";
		resArrd += "</ul>";
		$("#side_search_list").html(resArrd);
		
		modal_popup3("messagePop3");
		$("#keyword").focus();
		/* var width, height;
		width = parseInt(document.body.scrollWidth);
		height = parseInt(document.body.scrollHeight);

		var url = "${contextPath}/common/map/mapContentDaum";
		var oriAction = $("#troubleForm").attr("action");
		detailPrintPopup = window.open("", "popupMapSearchTemplate", "left=250, top=20, width=1100, height=900, menubar=no, location=no, status=no, scrollbars=yes");
		$("#troubleForm").attr("action", url);
		$("#troubleForm").attr("target", "popupMapSearchTemplate");
		$("#troubleForm").attr("method", "post");
		$("#troubleForm").submit();
		$("#troubleForm").attr("target", "");
		$("#troubleForm").attr("action", oriAction); */
	}
	
	function Save() {
		if($("#light_gubun").val() == "" || $("#light_gubun").val() == null) {
			alert("민원종류를 입력하세요");
			$("#light_gubun").focus();
			return;
		}
		
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
		
		if($("#trouble_cd").val() == "" || $("#trouble_cd").val() == null) {
			alert("고장상태를 선택하세요");
			$("#trouble_cd").focus();
			return;
		}
		
		var inform_method = $('input:radio[name=inform_method]:checked').val();
		if(inform_method == "01") {
			var mobile = $("#phone").val();
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
				clearInput();
				location.reload();
			}
			else {
				alert("신고를 실패하였습니다.");	
				return;
			}
		}
	}
	
	function clearInput() {
		if($("#light_no").val() != "" && $("#light_no").val() != null) {
			$("#light_no").val('');
			$("#address").val('');
			$("#address").attr("readonly", false);
			$("#address").css('background-color', '');
			
			$(".lightimg").children("img").attr("src", "/resources/css/images/noimg.gif");
		}
	}
	
	function goToTrbList(light_no, light_type, address, hj_dong_cd) {
		$("#light_no").val(light_no);
		$("#light_gubun").val(light_type);
		$("#address").val(address);
		$("#address").attr("readonly", true);
		$("#address").css('background-color', '#ddd');
		$("#dong").val(hj_dong_cd);
		
		//핸드폰 번호 선택값 저장용 변수 선언, 셀렉트 박스 selected 인덱스번호 저장
		 lightGubunlDefault = $( '#light_gubun' )[0].selectedIndex;
		
		var temp = $('#messagePop3');
		var bg = temp.prev().hasClass('bg');    //dimmed 레이어를 감지하기 위한 boolean 변수
		
		if(bg){
			$('.modal-popup3').fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다. 
		}else{
			temp.fadeOut();
		}
		
		showImg(light_no);
	}
	
	function showImg(light_no) {
		$.ajax({
			type : "POST"			
			, url : "/filesList"
			, data : {"seq" : light_no}
			, dataType : "JSON"
			, success : function(obj) {
				/* getInsertTrobleCallback(obj); */
				if(obj.resultData != null) {
					var filePah = "/display?name="+encodeURI(obj.resultData[0].file_name_key);
					$(".lightimg").children("img").attr("src", filePah);
				}
			}
			, error : function(xhr, status, error) {
				
			}
		});
	}
	
	function searchMap() {
		var num = 0;
		var childNodes = $("#side_tab").find('li')
		
		for(var i=0; i<childNodes.size(); i++) {
			if(childNodes.eq(i).find('.tab_on').size() > 0) {
				num = i+1;
			}
		}
		
		var searchGubun = $("input[type=radio][name=searchGubun]:checked").val();
		
		if($("#keyword").val() == null || $("#keyword").val() == "") {
			alert("검색어를 입력하세요.");
			return;
		}
		
		resArrd = "<ul>";
		resArrd += "<li>처리중</li>";
		resArrd += "</ul>";
	
		$("#side_search_list").html(resArrd);
		
		$.ajax({
			type : "POST"			
			, url : "/common/map/mapDataKakao"
			, data : {"keyword" : $("#keyword").val(), "keytype" : num, "searchGubun" : searchGubun}
			, dataType : "JSON"
			, success : function(obj) {
				getSearchMapCallback(obj);
			}
			, error : function(xhr, status, error) {
				
			}
		});
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
		var ifra = document.getElementById('mapContentDaum').contentWindow; 
		
		ifra.map_move(xPos, yPos, searchLightNo);
		ifra.onAjaxData(xPos, yPos, searchLightNo);
	}
	
	function openTab(ele, num) {
		$(".tab_on").removeClass();
		var nodes = ele.childNodes;
		nodes.item(0).setAttribute('class', 'tab_on');
		
		if(num == 1) {
			$("#sbox_adr").show();
			$("#searchbox_btn").css("top", "22px");
			$("#sidebox01").css("height", "125px");
		}
		else {
			$("#sbox_adr").hide();
			$("#searchbox_btn").css("top", "0");
			$("#sidebox01").css("height", "120px");
		}
	}
</script>
<div id="container">
	<!-- local_nav -->
	<div id="local_nav_area">
		<div id="local_nav">
			<ul class="smenu">
				<li><a href="#" ><img src="/resources/css/images/sub/icon_home.png" alt="HOME" /></a></li>
				<li><a href="#" >고장신고 <img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
					<ul>
						<li><a href="/trouble/trblReportList">고장신고</a></li>
						<li><a href="/complaint/complaintList" >민원처리결과조회</a></li>
						<li><a href="/equipment/securityLightList" >기본정보관리</a></li>
						<li><a href="/repair/systemRepairList">보수이력관리</a></li>
						<li><a href="/company/companyRepair" >보수내역관리</a></li>
						<li><a href="/info/infoServicesList">이용안내</a></li>
					</ul>
				</li>
				<li><a href="#">고장신고  <img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
					<ul>
						<li><a href="/trouble/trblReportList">고장신고</a></li>
						<li><a href="/trouble/trblCreateList">기타사항</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	<!-- //local_nav -->

	<div id="sub">
		<div id="sub_title"><h3>고장신고</h3></div>
		<form id="troubleForm" name="troubleForm">
			<input type="hidden" name="dong" id="dong">
			<div id="board_view2">
				<table summary="고장신고목록" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="20%">
						<col width="45%">
						<col width="35%">
					</colgroup>
					<tbody>
						<tr>
							<th>민원종류</th>
							<td>
								<select class="sel01" id="light_gubun" name="light_gubun">
								</select>
							</td>
							<th rowspan="11"><p class="lightimg"><img src="/resources/css/images/noimg.gif"></p></th>
						</tr>
						<tr>
							<th>신고종류</th>
							<td>
								<select class="sel01" id="repair_cd" name="repair_cd">
								</select>
							</td>
						</tr>
						<tr>
							<th>신고인</th>
							<td><input type="text" id="notice_name" name="notice_name" class="tbox03" maxlength ="20"></td>
						</tr>
						<tr>
							<th>관리번호</th>
							<td>
								<input type="text" class="tbox03_gray" id="light_no" name="light_no" readonly="readonly">
								<span>
									<a href="#"  class="btn_blue03" onclick="goGisMap()">관리번호 검색</a>
								</span>
								<span ><a href="javascript:clearInput()" class="btn_refresh">새로고침</a></span>
							</td>
						</tr>
						<tr>
							<th>주소</th>
							<td id="addr">
								<div style="margin-bottom: 5px;"><input type="text" class="tbox06" id="address" name="address" maxlength="100"></div>
								<p class="gray02">※관리번호를 모르시고 GIS로도 못찾으실 경우 시설물 근처의 주소를 입력</p>
							</td>
						</tr>
						<tr>
							<th>비밀번호</th>
							<td><input type="password" class="tbox03" id="password" name="password" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" size="8" maxlength="8"></td>
						</tr>
						<tr>
							<th>연락처</th>
							<td><input type="text" name="phone" id="phone" class="tbox03"  onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="13" ></td>
						</tr>
						<tr>
							<th height="28">이메일</th>
							<td>
								<input name="email" type="text" class="tbox03" id="email" size="35" maxlength="40">
							</td>
						</tr>
						<tr>
							<th>고장상태</th>
							<td>
								<select class="sel02" name="trouble_cd" size="1" id="trouble_cd">
								</select>
							</td>
						</tr>
						<tr>
							<th>상태설명</th>
							<td><textarea name="trouble_detail" id="trouble_detail" cols="55" rows="3" maxlength="500" ></textarea></td>
						</tr>
						<tr>
							<th>회신처리결과</th>
							<td>
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
					<span ><a href="javascript:Save()" class="btn_blue">등록</a></span>
					<span><a href="/"  class="btn_gray">취소</a></span>
				</p>
			</div>
		</form>
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
						<%-- <div class="p_map">
							<iframe src="${contextPath}/common/map/mapContentDaum2" scrolling="no" style="width: 100%; height: auto;" class="p_map"/>
							<%@ include file="/WEB-INF/views/common/map/mapContentDaum2.jsp"%>
						</div> --%>
						<iframe id="mapContentDaum" name="mapContentDaum" scrolling="no" style="width: 100%; height: 100%;" class="p_map"></iframe>
						<form name="frm" id="frm" method="post">
							<input type="hidden" id="searchLightNo" name="searchLightNo">
						</form>
					</div>
					<div id="sidebox01">
						<div id="side_tab">
							<ul>
								<li onclick="openTab(this, 1)"><a href="#" >주소선택</a></li>
								<li onclick="openTab(this, 2)"><a href="#" class="tab_on">관리번호</a></li>
							</ul>
						</div>
						<div id="sidebox_search">
							<div id="sbox_adr" style="display: none;">
								<span><input type="radio" name="searchGubun" value="new" checked="checked">도로명</span>
								<span><input type="radio" name="searchGubun" value="">지번</span>
							</div>
							<div id="searchbox"><input type="text" name="keyword" id="keyword" class="tbox05"></div>
							<a href="javascript:searchMap();"><div id="searchbox_btn"><span class="hide">검색</span></div></a>
						</div>
					</div>
					<div id="sidebox02">
						<!-- 검색창을 펼쳤을때 -->
						<div id="side_list">
							<div id="side_title">
								<span>검색결과</span>
								<span class="red02">총 0건</span>
							</div>
							<div id="side_search_list" >
								<ul>
									<li>검색결과가 없습니다.</li>
								</ul>
							</div>
							<a href="#"><div id="map_close"><span class="hide">축소버튼</span></div></a>
						</div>
						
						<!-- 검색창을 축소했을때 -->
						<div id="side_title2" style="display: none;">
							<span>검색결과</span>
							<span class="red02">총 0건</span>
						</div>
						<a href="#"><div id="map_open" style="display: none;"><span class="hide">확대버튼</span></div></a>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--//고장신고 지도 Popup-->
