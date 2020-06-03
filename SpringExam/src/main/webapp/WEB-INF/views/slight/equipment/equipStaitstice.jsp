<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};

	$(function(){
		var today = new Date();
		var sDate = new Date(today.getFullYear(), today.getMonth(), today.getDate()-100);
		var eDate = new Date(today.getFullYear(), today.getMonth(), today.getDate());
		
		var datepicker_default = {
				closeText : "닫기",
				prevText : "이전달",
				nextText : "다음달",
				currentText : "오늘",
				changeMonth: true, // 월을 바꿀 수 있는 셀렉트 박스
				changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스
				monthNames : [ "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월" ],
				monthNamesShort : [ "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월",	"9월", "10월", "11월", "12월" ],
				dayNames : [ "일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일" ],
				dayNamesShort : [ "일", "월", "화", "수", "목", "금", "토" ],
				dayNamesMin : [ "일", "월", "화", "수", "목", "금", "토" ],
				weekHeader : "주",
				firstDay : 0,
				isRTL : false,
				showMonthAfterYear : true, // 연,월,일 순으로
				yearSuffix : '',
				
				showOn: 'both'// 텍스트와 버튼을 함께 보여준다
		}
		
		datepicker_default.closeText = "선택";
		datepicker_default.maxDate = eDate;
		datepicker_default.dateFormat = "yy-mm-dd";
		datepicker_default.buttonImage = "/resources/css/images/icon/calendar.gif";
		datepicker_default.onClose = function (dateText, inst) {
			var curDate = dateText.split("-");
			var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
			var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
			var yymm = curDate[0]+"-"+curDate[1];
			var selYyMm = year+"-0"+(Number(month)+1);
			
			if(yymm != selYyMm) {
				$(this).datepicker( "option", "defaultDate", new Date(year, month, 1) );
				$(this).datepicker('setDate', new Date(year, month, 1));
			}

			$(".ui-datepicker-trigger").attr("style", "margin-left:4px; vertical-align:middle;");
		}
		
		datepicker_default.beforeShow = function () {
			setTimeout(function () {
				$('.ui-datepicker').css('z-index', 99999);
			}, 0);
			$(".ui-datepicker-trigger").attr("style", "margin-left:4px; vertical-align:middle;");
		}
		
		$("#sDate").datepicker(datepicker_default);
		$('#sDate').datepicker('setDate', sDate);
		
		$("#eDate").datepicker(datepicker_default);
		$('#eDate').datepicker('setDate', eDate);
		
		$("#sDate2").datepicker(datepicker_default);
		$('#sDate2').datepicker('setDate', sDate);
		
		$("#eDate2").datepicker(datepicker_default);
		$('#eDate2').datepicker('setDate', eDate);
		
		$("#sDate3").datepicker(datepicker_default);
		$('#sDate3').datepicker('setDate', sDate);
		
		$("#eDate3").datepicker(datepicker_default);
		$('#eDate3').datepicker('setDate', eDate);
		
		$(".ui-datepicker-trigger").attr("style", "margin-left:4px; vertical-align:middle;");
		
		$("#searchGubun").change(function() {
			headerNm();
			$("#board_list4").scrollTop(0);
			Search();
		});
		
		$("#searchType").change(function() {
			var searchType = $(this).val();
			
			if(searchType == "") {
				$("#keyword").val("");
				$("#keyword").show();
				$("#keyword").addClass("tbox03_gray");
				$("#keyword").attr("readonly", true);
				$("#trouble_cd").parents("li").hide();
				$("#progress_status").parents("li").hide();
			}
			else if(searchType == 1 || searchType == 2 || searchType == 3 || searchType == 7) {
				$("#keyword").val("");
				$("#keyword").show();
				$("#keyword").removeClass("tbox03_gray");
				$("#keyword").addClass("tbox03");
				$("#keyword").attr("readonly", false);
				$("#trouble_cd").parents("li").hide();
				$("#progress_status").parents("li").hide();
			}
			else if(searchType == 4) {
				$("#keyword").val("");
				$("#keyword").hide();
				$("#trouble_cd").parents("li").show();
				$("#progress_status").parents("li").hide();
			}
			else if(searchType == 5) {
				$("#keyword").val("");
				$("#keyword").hide();
				$("#trouble_cd").parents("li").hide();
				$("#progress_status").parents("li").show();
			}
		});
		
		$("#gubun").change(function() {
			if($("#gubun :selected").text() == "기간") {
				$("#tbody3 span").eq(1).show();
				$("#tbody3 span").eq(2).hide();
				$("#company_id2").val("");
			}
			else {
				$("#tbody3 span").eq(1).hide();
				$("#tbody3 span").eq(2).show();
				
				searchCompany('', $("#company_id2"));
			}
		});
		
		$("#st_yy").change(function() {
			var option = "<option value=''>자재</option>";
			for(i=0; i<commonCd.length; i++) {
				if(commonCd[i].code_type == "24") {
					if($(this).val() == commonCd[i].year) {
						option += "<option value='"+commonCd[i].data_code+"'>"+commonCd[i].data_code_name+"</option>";
					}
				}
			}
			
			$("#material_cd").html(option);
			
			searchCompany($(this).val(), $("#company_id"));
		});
		
		
		Search();
	});
	
	function searchCompany(st_yy, ele) {
		
		$.ajax({
			type : "POST"			
			, url : "/equipment/getCompanyId"
			, data : {"searchYear" : st_yy}
			, dataType : "JSON"
			, success : function(obj) {
				var option = "<option value=''>시공업체</option>";
				for(i=0; i<obj.resultData.length; i++) {
					option += "<option value='"+obj.resultData[i].data_code+"'>"+obj.resultData[i].data_code_name+"</option>";
				}
				
				$(ele).html(option);
			}
			, error : function(xhr, status, error) {
				
			}
		});
	}
	
	function Search() {
		
		$.ajax({
			type : "POST"			
			, url : "/equipment/getEquipStaitsticeList"
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
		var data = obj.resultData;			
		if(data != null){
			var listLen = data.length;		
			
			var str = "";
			if(listLen > 0) {
				for(i=0; i<listLen; i++) {
					str += "<tr>";
					for(var key in data[i]) {
						str += "	<td><span>"+data[i][key]+"</span></td>";
					}
					str += "</tr>";
				}
			}
			else {
				/* str += "<tr>";
				str += "	<td colspan='6'><span>등록된 글이 존재하지 않습니다.</span></td>";
				str += "</tr>"; */
			}
			
			$("#tbody").html(str);
			//$("#pagination").html(pagination);
		}
	}
	
	function excelSummaryDownload() {
		var currentRow = $("#board_list4 > table > thead> tr > th").length;
		var headerArr = new Array();
		
		for(i=0; i<currentRow; i++) {
			headerArr.push($("#board_list4 > table > thead> tr").find("th:eq("+i+")").text());
		}
		
		var f = document.slightForm;
		f.method = "POST";
		f.action = "/equipment/excelSummaryDownload";
		f.excelHeader.value = headerArr;
		f.submit();
	}
	
	function excelListPopup(excelGubun, excelLightType) {
		if(excelGubun == "LIGHT") {
			$("#tbody1").show();
			$("#tbody1").find("select").val("");
			$("#tbody2").hide();
			$("#tbody2").find("select").val("");
			$("#tbody3").hide();
		}
		else if(excelGubun == "MATERIAL" || excelGubun == "USE") {
			$("#tbody1").hide();
			$("#tbody1").find("select").val("");
			$("#tbody2").show();
			$("#tbody2").find("select").val("");
			var today = new Date();
			$("#st_yy").val(today.getFullYear());
			$("#st_yy").trigger("change");
			$("#tbody3").hide();
		}
		else if(excelGubun == "REPAIR") {
			$("#tbody1").hide();
			$("#tbody1").find("select").val("");
			$("#tbody2").hide();
			$("#tbody2").find("select").val("");
			$("#tbody3").show();
		}
		
		var f = document.excelForm;
		f.excelGubun.value = excelGubun;
		f.excelLightType.value = excelLightType;
		
		modal_popup4('messagePop4');
	}
	
	function excelListDownLoad() {
		var f = document.excelForm;
		f.method = "POST";
		f.action = "/equipment/excelListDownLoad";
		//f.excelHeader.value = headerArr;
		f.submit();
	}
	
	function headerNm() {
		var searchGubun = $("#searchGubun").val();
		var title = "";
		
		if(searchGubun == 0) {
			$("#thead").empty();
			$("#headerGroup").empty();
			title = "읍면별 현황";
			
			$("#thead").html("<th>번호</th><th>구분</th><th>등주</th><th>신설</th><th>이설</th><th>철거</th>");
			$("#headerGroup").html("<col width='10%'><col width='18%'><col width='18%'><col width='18%'><col width='18%'><col width='18%'>");
		}
		else if(searchGubun == 1) {
			$("#thead").empty();
			$("#headerGroup").empty();
			title = "설치형태별 현황";
			
			$("#thead").html("<th>번호</th><th>구분</th><th>한전주</th><th>강관주</th><th>테파주</th><th>기타주</th><th>벽부등</th><th>터널주</th><th>팔각주</th><th>통신주</th><th>스텐주</th><th>촐주</th><th>주물주</th><th>주철주</th><th>합계</th>")
			$("#headerGroup").html("<col width='7%'><col width='15%'><col width='6%'><col width='6%'><col width='6%'><col width='6%'><col width='6%'><col width='6%'><col width='6%'><col width='6%'><col width='6%'><col width='6%'><col width='6%'><col width='6%'><col width='6%'>");
		}
		else if(searchGubun == 2) {
			$("#thead").empty();
			$("#headerGroup").empty();
			title = "광원별 현황";
			
			$("#thead").html("<th>번호</th><th>구분</th><th>나트륨</th><th>CDM</th><th>무전극</th><th>LED</th><th>합계</th>");
			$("#headerGroup").html("<col width='10%'><col width='15%'><col width='15%'><col width='15%'><col width='15%'><col width='15%'><col width='15%'><col width='15%'><col width='15%'>");
		}
		else if(searchGubun == 3) {
			$("#thead").empty();
			$("#headerGroup").empty();
			title = "소비전력별 현황";
			
			$("#thead").html("<th>번호</th><th>구분</th><th>25W</th><th>40W</th><th>50W</th><th>60W</th><th>70W</th><th>80W</th><th>100W</th><th>120W</th><th>150W</th><th>250W</th><th>합계</th>");
			$("#headerGroup").html("<col width='7%'><col width='7%'><col width='7%'><col width='7%'><col width='7%'><col width='7%'><col width='7%'><col width='7%'><col width='7%'><col width='7%'><col width='7%'><col width='7%'><col width='7%'>");
		}
		
		$(".black05").text(title);
	}
	
	function openTab(ele, num) {
		$(".tab_on").removeClass();
		var nodes = ele.childNodes;
		nodes.item(0).setAttribute('class', 'tab_on');
		
		var title = "";
		if(num < 4) {
			$(".btn_gray03").show();
			if(num != 0) {
				$("#light_type").val(num);
			}
			else {
				$("#light_type").val('');
			}
			$("#search_box").css("display", "block");
			$("#board_list4").attr("style", "overflow-y: auto; display: block;");
			$("#board_list").css("display", "none");
			$(".b_right").css("display", "block");
			$("#ulGubun1").css("display", "block");
			$("#ulGubun2").css("display", "none");
			$("#tabGubun").val("RIGHT");
			
			$('#searchGubun').trigger("change");
		}
		else if(num == 4) {
			$(".black05").text("민원신고내역");
			$("#search_box").css("display", "block");
			$("#ulGubun1").css("display", "none");
			$("#ulGubun2").css("display", "block");
			$("#board_list4").css("display", "block");
			excelParamReset(num);
			$("#thead").empty();
			$("#headerGroup").empty();
			$("#thead").html("<th>접수번호</th><th>접수일</th><th>고장상태</th><th>관리번호</th><th>주소</th>><th>신고인</th><th>전화번호</th><th>처리상황</th><th>보수업체</th>");
			$("#headerGroup").html("<col width='10%'><col width='10%'><col width='12%'><col width='10%'><col width='15%'><col width='8%'><col width='10%'><col width='8%'><col width='10%'>");
			$("#board_list4").scrollTop(0);
			
			$("#board_list").css("display", "none");
			$(".b_right").css("display", "block");
			$("#tabGubun").val("REPAIR");
			
			Search();
		}
		else if(num == 5) {
			$(".black05").text("엑셀 다운로드");
			$("#search_box").css("display", "none");
			$("#board_list4").css("display", "none");
			$("#board_list").css("display", "block");
			$(".b_right").css("display", "none");
			
			excelParamReset(num);
		}
		
	}
	
	function excelParamReset(num) {
		var searchAreaStr = "";
		//drawCodeData(리스트, 코드타입, 태그이름, 모드, 현재선택코드)
		drawCodeData(commonCd, "06", "select", "").then(function(resolvedData) {
			//행정동
			$("#hj_dong_cd").empty();
			$("#hj_dong_cd").append(resolvedData);
			$("#hj_dong_cd > option").eq(0).text("행정동");
		})
		.then(function() {
			drawCodeData(commonCd, "08", "select", "").then(function(resolvedData) {
				//지지방식
				$("#stand_cd").empty();
				$("#stand_cd").append(resolvedData);
				$("#stand_cd > option").eq(0).text("지지방식");
			})
		})
		.then(function() {
			drawCodeData(commonCd, "09", "select", "").then(function(resolvedData) {
				//등기구모형
				$("#lamp1_cd").empty();
				$("#lamp1_cd").append(resolvedData);
				$("#lamp1_cd > option").eq(0).text("등기구모형");
			})
		})
		.then(function() {
			drawCodeData(commonCd, "10", "select", "").then(function(resolvedData) {
				//광원종류
				$("#lamp2_cd").empty();
				$("#lamp2_cd").append(resolvedData);
				$("#lamp2_cd > option").eq(0).text("광원종류");
			})
		})
		.then(function() {
			drawCodeData(commonCd, "11", "select", "").then(function(resolvedData) {
				//광원용량
				$("#lamp3_cd").empty();
				$("#lamp3_cd").append(resolvedData);
				$("#lamp3_cd > option").eq(0).text("광원용량");
			})
		})
		.then(function() {
			drawCodeData(commonCd, "15", "select", "").then(function(resolvedData) {
				//스위치종류
				$("#onoff_cd").empty();
				$("#onoff_cd").append(resolvedData);
				$("#onoff_cd > option").eq(0).text("점멸기");
			})
		})
		.then(function() {
			drawCodeData(commonCd, "01", "select", "").then(function(resolvedData) {
				$("#trouble_cd").empty();
				$("#trouble_cd").append(resolvedData);
				$("#trouble_cd").parents("li").hide();
			})
		})
		.then(function() {
			drawCodeData(commonCd, "03", "select", "").then(function(resolvedData) {
				$("#progress_status").empty();
				$("#progress_status").append(resolvedData);
				$("#progress_status").parents("li").hide();
			})
		})
		.then(function() {
			drawCodeData(commonCd, "13", "select", "").then(function(resolvedData) {
				$("#light_gubun").empty();
				$("#light_gubun").append(resolvedData);
			})
		})
		.then(function() {
			if(num == 4) {
				
			}
		})
	}
</script>
<!-- <style>
	table.ui-datepicker-calendar { display:none; }
</style> -->
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
				<li><a href="#">통계관리 <img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
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
		<div id="sub_title"><h3>통계관리</h3></div>
		<!-- 탭메뉴 -->
			<div id="list_tab2">
				<ul>
					<li onclick="openTab(this, '')"><a href="#"  class="tab_on">전체</a></li>
					<li onclick="openTab(this, 1)"><a href="#" >보안등</a></li>
					<li onclick="openTab(this, 2)"><a href="#" >가로등</a></li>
					<li onclick="openTab(this, 3)"><a href="#" >분전함</a></li>
					<li onclick="openTab(this, 4)"><a href="#" >민원신고내역</a></li>
					<li onclick="openTab(this, 5)"><a href="#" >엑셀다운로드</a></li>
				</ul>
			</div>
		<!-- 검색박스 -->
		<form id="slightForm" name="slightForm" method="post">
			<input type="hidden" id="light_type" name="light_type">
			<input type="hidden" id="excelHeader" name="excelHeader">
			<input type="hidden" id="tabGubun" name="tabGubun" value="RIGHT">
			
			<div id="search_box">
				<ul id="ulGubun1">
					<li class="title">검색조건</li>
					<li class="pdl30">
						<select id="searchGubun" name="searchGubun" class="sel01">
							<option value="0">읍면별 현황</option>
							<option value="1">설치형태별 현황</option>
							<option value="2">광원별 현황</option>
							<option value="3">소비전력별 현황</option>
						</select>
					</li>
				</ul>
				<ul id="ulGubun2" style="display: none;">
					<li class="title">기간</li>
					<li class="pdl30">
						<input type="text" id="sDate" name="sDate" class="tbox02" readonly="readonly"> ~
						<input type="text" id="eDate" name="eDate" class="tbox02" readonly="readonly">
					</li>
					<li class="pdl10">
						<select class="sel01" id="light_gubun" name="light_gubun">
						</select>
					</li>
					<li>
						<select class="sel01" id="searchType" name="searchType">
							<option selected value="">전체</option>
							<option value="1">신고인</option>
							<option value="2">주소</option>
							<option value="3">관리번호</option>
							<option value="4">고장상태</option>
							<option value="5">처리상태</option>
						</select>
					</li>
					<li><input type="text" name="keyword" id="keyword" class="tbox03_gray" readonly="readonly"></li>
					<li>
						<select id="trouble_cd" name="trouble_cd" class="sel01">
						</select>
					</li>
					<li>
						<select id="progress_status" name="progress_status" class="sel01">
						</select>
					</li>
					<li><a href="javascript:Search()"  class="btn_search01">검 색</a></li>
				</ul>
			</div>
		</form>
		<div id="toptxt">
			<ul>
				<li><span class="black05">읍면별 현황</span></li>
				<li class="b_right"><span ><a href="javascript:excelSummaryDownload()" class="btn_gray03">엑셀 다운로드</a></span></li>
			</ul>
		</div>
		<div id="board_list" style="display:none;">
			<table summary=" 현황목록" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="70%">
					<col width="30%">
				</colgroup>
				
				<tbody>
					<tr>
						<td class="ex_title"><span>전체현황</span></td>
						<td class="ex_down"><a onclick="excelListPopup('LIGHT', '')" class="downbtn">DOWNLOAD</a></td>
					</tr>
					<tr>
						<td class="ex_title"><span>보안등현황</span></td>
						<td class="ex_down"><a onclick="excelListPopup('LIGHT', '1');" class="downbtn">DOWNLOAD</a></td>
					</tr>
					<tr>
						<td class="ex_title"><span>가로등현황</span></td>
						<td class="ex_down"><a onclick="excelListPopup('LIGHT', '2');" class="downbtn">DOWNLOAD</a></td>
					</tr>
					<tr>
						<td class="ex_title"><span>분전함현황</span></td>
						<td class="ex_down"><a onclick="excelListPopup('LIGHT', '3');" class="downbtn">DOWNLOAD</a></td>
					</tr>
					<tr>
						<td class="ex_title"><span>자재입/출고내역</span></td>
						<td class="ex_down"><a onclick="excelListPopup('USE');" class="downbtn">DOWNLOAD</a></td>
					</tr>
					<tr>
						<td class="ex_title"><span>보수처리내역</span></td>
						<td class="ex_down"><a onclick="excelListPopup('REPAIR');" class="downbtn">DOWNLOAD</a></td>
					</tr>
					<tr>
						<td class="ex_title"><span>자재사용현황</span></td>
						<td class="ex_down"><a onclick="excelListPopup('MATERIAL')" class="downbtn">DOWNLOAD</a></td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div id="board_list4" style="overflow-y:auto;">
			<!-- 가로등관리 리스트 -->
			<table summary="현황목록" cellpadding="0" cellspacing="0">
				<colgroup id="headerGroup">
					<col width="10%">
					<col width="18%">
					<col width="18%">
					<col width="18%">
					<col width="18%">
					<col width="18%">
				</colgroup>
				<thead>
					<tr id="thead">
						<th>번호</th>
						<th>구분</th>
						<th>등주</th>
						<th>신설</th>
						<th>이설</th>
						<th>철거</th>
					</tr>
				</thead>
				<tbody id="tbody">
				</tbody>
			</table>
		</div>
		<!-- <div id="pagination">
		</div> -->
	</div>
</div>

<!--엑셀다운로드 Popup-->
<div class="modal-popup4">
	<div class="bg"></div>
	<div id="messagePop4" class="pop-layer3">
		<div class="pop-container">
			<div class="pop-conts">
				<div class="btn-r">
					<a href="#" class="cbtn"><i class="fa fa-times" aria-hidden="true"></i><span class="hide">Close</span></a>
				</div>
				<div class="pop_system">
					<div id="board_view3">
						<h3>엑셀다운로드</h3>
						<form id="excelForm" name="excelForm">
							<input type="hidden" id="excelGubun" name="excelGubun">
							<input type="hidden" id="excelLightType" name="excelLightType">
							<table  cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="20%">
									<col width="30%">
									<col width="20%">
									<col width="30%">
								</colgroup>
								<tbody id="tbody1">
									<tr>
										<th>행정동</th>
										<td>
											<span class="">
												<select class="sel06" id="hj_dong_cd" name="hj_dong_cd">
													<option value="">행정동</option>
												</select>
											</span>
										</td>
									</tr>
									<tr>
										<th>빌링등록상태</th>
										<td>
											<span class="">
												<select id="kepco_cd" name="kepco_cd" class="sel06">
												<option selected value="">전체</option>
												<option value="Y">등록</option>
												<option value="N">미등록</option>
												</select>
											</span>
										</td>
									</tr>
									<tr>
										<th>시설현황</th>
										<td>
											<p>
												<span class="">
													<select class="sel06" id="stand_cd" name="stand_cd">
														<option value="">지지방식</option>
													</select>
												</span>
												<span class="">
													<select class="sel03" id="lamp1_cd" name="lamp1_cd">
														<option value="">등기구모형</option>
													</select>
												</span>
											</p>
											<p>
												<span class="">
													<select class="sel03" id="lamp2_cd" name="lamp2_cd">
														<option value="">광원종류</option>
													</select>
												</span>
												<span class="">
													<select class="sel03" id="lamp3_cd" name="lamp3_cd">
														<option value="">광원용량</option>
													</select>
												</span>
											</p>
											<p>
												<span class="">
													<select class="sel03" id="onoff_cd" name="onoff_cd">
														<option value="">점멸기</option>
													</select>
												</span>
											</p>
										</td>
									</tr>
									<tr>
										<td colspan="2" class="bnone">
											<a onclick="excelListDownLoad()"  class="btn_sky03"><span class="">엑셀다운로드</span></a>
										</td>
									</tr>
								</tbody>
								<tbody id="tbody2" style="display: none;">
									<tr>
										<th>해당연도</th>
										<td>
											<span class="">
												<select class="sel03" id="st_yy" name="st_yy">
													<c:forEach items="${searchYearList}" var="year">
														<option value="${year }">${year }년</option>
													</c:forEach>
												</select>
											</span>
										</td>
										<th>자재선택</th>
										<td>
											<span class="">
												<select class="sel03" id="material_cd" name="material_cd">
													<option value="">자재</option>
												</select>
											</span>
										</td>
									</tr>
									<tr>
										<th>시공업체</th>
										<td colspan="3">
											<span class="">
												<select class="sel03" id="company_id" name="company_id">
													<option value="">시공업체</option>
												</select>
											</span>
										</td>
									</tr>
									<tr>
										<th>기간</th>
										<td colspan="3">
											<span class="">
												<input type="text" class="tbox13" id="sDate2" name="sDate2" readonly="readonly"> ~
												<input type="text" class="tbox13" id="eDate2" name="eDate2" readonly="readonly">
											</span>
										</td>
									</tr>
									<tr>
										<td colspan="4" class="bnone">
											<a onclick="excelListDownLoad()"  class="btn_sky03"><span class="">엑셀다운로드</span></a>
										</td>
									</tr>
								</tbody>
								<tbody id="tbody3" style="display: none;">
									<tr>
										<td>
											<span class="">
												<select class="sel03" id="gubun" name="gubun">
													<option value="period">기간</option>
													<option value="company">시공업체</option>
												</select>
											</span>
											<span class="">
												<input type="text" class="tbox13" id="sDate3" name="sDate3" readonly="readonly" > ~
												<input type="text" class="tbox13" id="eDate3" name="eDate3" readonly="readonly" >
											</span>
											<span class="" style="display: none;">
												<select class="sel03" id="company_id2" name="company_id2">
													<option value="">전체</option>
												</select>
											</span>
										</td>
									</tr>
									<tr>
										<td class="bnone">
											<a onclick="excelListDownLoad()"  class="btn_sky03"><span class="">엑셀다운로드</span></a>
										</td>
									</tr>
								</tbody>
							</table>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--//엑셀다운로드_Popup-->
