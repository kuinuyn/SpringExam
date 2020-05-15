<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};

	$(function(){
		var searchArea = "${param.par_hj_dong}";
		var pageNo = "${param.current_page_no}";
		var searchLampGubun = "${param.searchLampGubun}";
		
		$("#searchGubun").change(function() {
			headerNm();
			$("#board_list4").scrollTop(0);
			Search();
		});
		
		Search();
	});
	
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
			//var list = data.list;
			var listLen = data.length;		
			//var pagination = data.pagination;
			
			var str = "";
			if(listLen > 0) {
				for(i=0; i<listLen; i++) {
					str += "<tr>";
					for(var key in data[i]) {
						str += "	<td><span>"+data[i][key]+"</span></td>";
					}
					str += "</tr>";
					/* str += "<tr>";
					str += "	<td><span>"+list[i].light_no+"</span></td>";
					str += "	<td><span>"+((list[i].address.trim()=="" || list[i].address == null)?"":list[i].address)+"</span></td>";
					str += "	<td><span>"+list[i].new_address+"</span></td>";
					str += "	<td><span>"+list[i].stand_nm+"</span> </td>";
					str += "	<td><span>"+list[i].lamp1_nm+"</span> </td>";
					str += "	<td><span>"+list[i].lamp2_nm+"</span> </td>";
					str += "</tr>"; */
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
			
			$('#searchGubun').trigger("change");
		}
		else if(num == 4) {
			$(".black05").text("민원신고내역");
			$("#search_box").css("display", "none");
			$("#board_list4").css("display", "none");
			$("#board_list").css("display", "none");
			$(".b_right").css("display", "block");
		}
		else if(num == 5) {
			$(".black05").text("엑셀 다운로드");
			$("#search_box").css("display", "none");
			$("#board_list4").css("display", "none");
			$("#board_list").css("display", "block");
			$(".b_right").css("display", "none");
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
						<li><a href="#" >보수내역관리</a></li>
						<li><a href="#">이용안내</a></li>
					</ul>
				</li>
				<li><a href="#">통계관리 <img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
					<ul>
						<li><a href="/equipment/securityLightList">보안등관리</a></li>
						<li><a href="/equipment/streetLightList">가로등관리</a></li>
						<li><a href="/equipment/distributionBoxList">분전함관리</a></li>
						<li><a href="#">GIS관리</a></li>
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
			
			<div id="search_box">
				<ul>
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
			</div>
		</form>
		<div id="toptxt">
			<ul>
				<li><span class="black05">읍면별 현황</span></li>
				<li class="b_right"><span ><a href="#" class="btn_gray03">엑셀 다운로드</a></span></li>
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
						<td class="ex_down"><a onclick="modal_popup4('messagePop4');return false;" class="downbtn">DOWNLOAD</a></td>
					</tr>
					<tr>
						<td class="ex_title"><span>보안등현황</span></td>
						<td class="ex_down"><a href="#" class="downbtn">DOWNLOAD</a></td>
					</tr>
					<tr>
						<td class="ex_title"><span>가로등현황</span></td>
						<td class="ex_down"><a href="#" class="downbtn">DOWNLOAD</a></td>
					</tr>
					<tr>
						<td class="ex_title"><span>분전함현황</span></td>
						<td class="ex_down"><a href="#" class="downbtn">DOWNLOAD</a></td>
					</tr>
					<tr>
						<td class="ex_title"><span>자재입/출고내역</span></td>
						<td class="ex_down"><a href="#" class="downbtn">DOWNLOAD</a></td>
					</tr>
					<tr>
						<td class="ex_title"><span>보수처리내역</span></td>
						<td class="ex_down"><a href="#" class="downbtn">DOWNLOAD</a></td>
					</tr>
					<tr>
						<td class="ex_title"><span>자재사용현황</span></td>
						<td class="ex_down"><a href="#" class="downbtn">DOWNLOAD</a></td>
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
						<table  cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="27%">
								<col width="73%">
							</colgroup>
							<tbody>
								<tr>
									<th>행정동</th>
									<td>
										<span class="">
											<select class="sel06" id="" name="">
											</select>
										</span>
									</td>
								</tr>
								<tr>
									<th>빌링등록상태</th>
									<td>
										<span class="">
											<select id="" name="" class="sel06">
											<option selected>전체</option>
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
												<select class="sel06" id="" name="">
												</select>
											</span>
											<span class="">
												<select class="sel03" id="" name="">
												</select>
											</span>
										</p>
										<p>
											<span class="">
												<select class="sel03" id="" name="">
												</select>
											</span>
											<span class="">
												<select class="sel03" id="" name="">
												</select>
											</span>
										</p>
										<p>
											<span class="">
												<select class="sel03" id="" name="">
												</select>
											</span>
											<span class="">
												<select class="sel03" id="" name="">
												</select>
											</span>
										</p>
									</td>
								</tr>
								<tr>
									<td colspan="2" class="bnone">
										<a href="#"  class="btn_sky03"><span class="">엑셀다운로드</span></a>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--//엑셀다운로드_Popup-->
