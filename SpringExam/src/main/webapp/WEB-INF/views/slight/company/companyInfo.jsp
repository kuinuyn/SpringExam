<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};
	
	$(function() {
		areaTag("${searchYearList}");
	});
	
	function areaTag(searchYearList) {
		var list = commonCd;
		var listCnt = list.length;
		var restr = "<p>";
		var cnt = 0;
		
		for(i=0; i < listCnt; i++) {
			if(list[i].code_type == "06") {
				cnt++;
				restr += "<span style='display: inline-block;width: 20%;'><input type='checkbox' name='area' value='"+list[i].data_code+"'>"+list[i].data_code_name+"</span>";
				if(cnt % 5 == 0) {
					restr += "</p><p>";
				}
				else {
					if(listCnt == (i+1)) {
						restr += "</p>";
					}
				}
			}
		}
		
		$("#tdArea").empty();
		$("#tdArea").html(restr);
		
		initCallback( function() {
			Search();
		});
	}
	
	function initCallback(fnNm) {
		fnNm();
	}
	
	function Search() {
		$.ajax({
			type : "POST"			
			, url : "/company/getCompanyInfo"
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
		var data = obj.resultMap;
		if(data != null){
			for(var key in data){
				$("#"+key).val(data[key]);
			}
			
			var areaArr = new Array();
			if(data['grade'] != "" && data['grade'] != null) {
				if(data['grade'] != '01') {
					areaArr = data['area'].split(";");
					$("input[type=checkbox][name=area]").prop("checked", false);
					
					for(i = 0; i<areaArr.length; i++) {
						$("input[type=checkbox][name=area][value="+areaArr[i]+"]").prop("checked", true);
					}
					$("#trArea").show();
				}
				else {
					$("input[type=checkbox][name=area]").prop("checked", false);
					$("#trArea").hide();
				}
				
				$("input[type=radio][name=grade][value="+data['grade']+"]").prop("checked", true);
			}
		}
	}
	
	function Save() {
		
		if($("#password").val() == "" || $("#password").val() == null) {
			$("#password").focus();
			alert("비밀번호를 입력하세요.");
			return;
		}
		else {
			if($("#password").val() != $("#passwordChk").val()) {
				$("#passwordChk").focus();
				alert("비밀번호를 확인하세요.");
				return;
			}
		}
		
		if($("#member_name").val() == "" || $("#member_name").val() == null) {
			$("#member_name").focus();
			alert("담당자를 입력하세요.");
			return;
		}
		
		if($("#phone").val() == "" || $("#phone").val() == null) {
			$("#phone").focus();
			alert("전화번호를 입력하세요.");
			return;
		}
		
		if($("#mobile").val() == "" || $("#mobile").val() == null) {
			$("#mobile").focus();
			alert("휴대폰번호를 입력하세요.");
			return;
		}
		
		if($("input[type=radio][name=grade]:checked").val() != "01") {
			if(!$("input[type=checkbox][name=area]").is(":checked")) {
				alert("담당지역을 선택하세요.");
				$("input[type=checkbox][name=area]").focus();
				return;
			}
		}
		
		var obj = $("#slightForm").serializeArray();
		var json = {};
		var area = "";
		for(i=0; i<obj.length; i++) {
			json[obj[i].name] = obj[i].value;
			if(obj[i].name == "area") {
				area += obj[i].value+";";
			}
		}
		
		json['area'] = area.substring(0, (area.length-1));
		
		var yn = confirm("사용자 정보를 저장 하시겠습니까?");
		if(yn){
			$.ajax({
				type : "POST"			
				, url : "/company/updateCompanyInfo"
				, data : json
				, dataType : "JSON"
				, success : function(obj) {
					getUpdateMemberCallback(obj);
				}
				, error : function(xhr, status, error) {
					alert("저장에 실패하였습니다.");	
					return;
				}
			});
		}
	}
	
	function getUpdateMemberCallback(obj) {
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("저장 되었습니다.");
				Search();
			}
			else {
				alert("저장에 실패하였습니다.");	
				return;
			}
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
						<li><a href="#">이용안내</a></li>
					</ul>
				</li>
				<li><a href="#">정보변경 <img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
					<ul>
						<li><a href="/company/companyRepair">보수내역관리</a></li>
						<li><a href="/company/companyInfo">정보변경</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
		
	<div id="sub">
		<div id="sub_title"><h3>사용자정보</h3></div>
		
		<form id="slightForm" name="slightForm" method="post" action="">
			<div id="board_view2">
				<!-- 사용자내역-->
				<table  cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="14%">
						<col width="36%">
						<col width="14%">
						<col width="36%">
					</colgroup>
					<tbody>
						
						<tr>
							<th>아이디</th>
							<td><span><input type="text" id="member_id" name="member_id" class="tbox07_gray" readonly="readonly" placeholder=""></span></td>
							<th>년도</th>
							<td>
								<span>
								<select id="year" name="year" class="sel01">
									<c:forEach items="${searchYearList}" var="year">
										<option value="${year.year }">${year.year }년</option>
									</c:forEach>
								</select>
								</span>
							</td>
						</tr>
						
						<tr>
							<th>비밀번호</th>
							<td><span><input type="password" id="password" name="password" class="tbox07" placeholder="******"></span></td>
							<th>비밀번호확인</th>
							<td><span><input type="password" id="passwordChk" name="passwordChk" class="tbox07" placeholder="******"></span></td>
						</tr>
					</tbody>
				</table>
			</div>
	
			<div id="board_view2" class="pdt40">
				<!-- 사용자내역-->
				<table  cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="14%">
						<col width="36%">
						<col width="14%">
						<col width="36%">
					</colgroup>
					<tbody>
						
						<tr>
							<th>부서명</th>
							<td colspan="3"><span><input type="text" id="com_name" name="com_name" class="tbox07" placeholder=""></span></td>
						</tr>
						
						<tr>
							<th>담당자</th>
							<td><span><input type="text" id="member_name" name="member_name" class="tbox07" placeholder=""></span></td>
							<th>이메일주소</th>
							<td><span><input type="text" id="email" name="email" class="tbox07" placeholder=""></span></td>
						</tr>
						<tr>
							<th>전화번호</th>
							<td><span><input type="text" id="phone" name="phone" class="tbox07" placeholder=""></span></td>
							<th>휴대폰번호</th>
							<td><span><input type="text" id="mobile" name="mobile" class="tbox07" placeholder=""></span></td>
						</tr>
						<tr id="trArea">
							<th>담당지역</th>
							<td id="tdArea" colspan="3">
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</form>
			
		<div id="btn2">
			<p>
				<span><a href="javascript:Save()"  class="btn_blue"> 저장</a></span>
			</p>
		</div>
	</div>
</div>