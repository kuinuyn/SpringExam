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
		});
	});
	
	
	function init() {
		
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
		var state = obj.state;
		if(state == "SUCCESS"){
			var data = obj.data;			
			var list = data.list;
			var listLen = list.length;		
			var totalCount = data.totalCount;
			var pagination = data.pagination;
			
			var str = "";
			if(listLen > 0) {
				for(i=0; i<listLen; i++) {
					str += "<tr>";
					str += "	<td><span>"+list[i].light_no+"</span></td>";
					str += "	<td><span>"+((list[i].address.trim()=="" || list[i].address == null)?"":list[i].address)+"</span></td>";
					str += "	<td><span>"+list[i].new_address+"</span></td>";
					str += "	<td><span>"+list[i].stand_nm+"</span> </td>";
					str += "	<td><span>"+list[i].lamp1_nm+"</span> </td>";
					str += "	<td><span>"+list[i].lamp2_nm+"</span> </td>";
					str += "</tr>";
				}
			}
			else {
				str += "<tr>";
				str += "	<td colspan='6'><span>등록된 글이 존재하지 않습니다.</span></td>";
				str += "</tr>";
			}
			
			$("#tbody").html(str);
			$("#pagination").html(pagination);
		}
	}
	
	function headerNm() {
		var searchGubun = $("#searchGubun").val();
		
		if(searchGubun == 0) {
			$("#thead").empty();
			$("#headerGroup").empty();
			
			$("#thead").html("<th>번호</th><th>구분</th><th>등주</th><th>신설</th><th>이설</th><th>합계</th>");
			$("#headerGroup").html("<col width='10%'><col width='18%'><col width='18%'><col width='18%'><col width='18%'><col width='18%'>");
		}
		else if(searchGubun == 1) {
			$("#thead").empty();
			$("#headerGroup").empty();
			
			$("#thead").html("<th>번호</th><th>구분</th><th>한전주</th><th>건축물</th><th>통신주</th><th>보조인입주</th><th>합계</th>")
			$("#headerGroup").html("<col width='10%'><col width='15%'><col width='15%'><col width='15%'><col width='15%'><col width='15%'><col width='15%'>");
		}
		else if(searchGubun == 2) {
			$("#thead").empty();
			$("#headerGroup").empty();
			
			$("#thead").html("<th>번호</th><th>구분</th><th>나트륨</th><th>메탈</th><th>LED</th><th>UCD</th><th>CDM</th><th>삼파장</th><th>합계</th>");
			$("#headerGroup").html("<col width='10%'><col width='13%'><col width='11%'><col width='11%'><col width='11%'><col width='11%'><col width='11%'><col width='11%'><col width='11%'>");
		}
		else if(searchGubun == 3) {
			$("#thead").empty();
			$("#headerGroup").empty();
			
			$("#thead").html("<th>번호</th><th>구분</th><th>25W</th><th>50W</th><th>70W</th><th>250W</th><th>합계</th>");
			$("#headerGroup").html("<col width='10%'><col width='15%'><col width='15%'><col width='15%'><col width='15%'><col width='15%'><col width='15%'>");
		}
	}
	
	function openTab(ele, num) {
		$(".tab_on").removeClass();
		var nodes = ele.childNodes;
		nodes.item(0).setAttribute('class', 'tab_on');
		
		if(num != 0) {
			$("#lightType").val(num);
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
						<li><a href="#">고장신고</a></li>
						<li><a href="#" >민원처리결과조회</a></li>
						<li><a href="#" >기본정보관리</a></li>
						<li><a href="#">보수이력관리</a></li>
						<li><a href="#" >보수내역관리</a></li>
						<li><a href="#">이용안내</a></li>
					</ul>
				</li>
				<li><a href="#">통계관리 <img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
					<ul>
						<li><a href="#">보안등관리</a></li>
						<li><a href="#">가로등관리</a></li>
						<li><a href="#">분점함관리</a></li>
						<li><a href="#">GIS관리</a></li>
						<li><a href="#">통계관리</a></li>
						<li><a href="#">사용자관리</a></li>
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
					<li onclick="openTab(this, 0)"><a href="#"  class="tab_on">전체</a></li>
					<li onclick="openTab(this, 1)"><a href="#" >보안등</a></li>
					<li onclick="openTab(this, 2)"><a href="#" >가로등</a></li>
					<li onclick="openTab(this, 3)"><a href="#" >분전함</a></li>
					<li onclick="openTab(this, 0)"><a href="#" >민원신고내역</a></li>
					<li onclick="openTab(this, 0)"><a href="#" >엑셀다운로드</a></li>
				</ul>
			</div>
		<!-- 검색박스 -->
		<form id="slightForm" name="slightForm" method="post">
			<input type="hidden" id="lightType" name="lightType">
			
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
				<li><span class="black05">전체 동별 현황</span></li>
				<li class="b_right"><span ><a href="#" class="btn_gray03">엑셀 다운로드</a></span></li>
			</ul>
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
		<div id="pagination">
		</div>
	</div>
</div>
