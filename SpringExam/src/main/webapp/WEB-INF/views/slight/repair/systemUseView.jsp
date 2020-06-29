<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};
	var part_cd = "${param.part_cd}";
	var part_name = "${param.part_name}"; 
	var year = "${param.year}";
	var comp_nm = "${param.comp_nm}";
	var company_id = "${param.company_id}";
	
//	alert("part_cd1111:::"+"${param.part_cd}");
//	alert("company_id1111:::"+company_id);
//	alert("company_id2222:::"+"${param.company_id}");

		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth()+1; //January is 0!
		var yyyy = today.getFullYear();

		if(dd<10) {
		    dd='0'+dd
		} 

		if(mm<10) {
		    mm='0'+mm
		}
		
		today = yyyy+mm+dd;
		
//		alert("today:::"+today);

	$(function(){		
		
//		if(year == "" ||year == Null ){
//			year = today.getFullYear();
//		}
	
		$("#searchYear").val(year);		
		searchCompany($("#searchYear").val(), $("#searchCom"), company_id);
//		alert("11111");
//		console.log("searchCom:::"+ $("#searchCom").val());		
//		alert("1111:::"+$("#searchCom").val());
//		alert("#searchCom:::"+$("#searchCom option:selected").val());

//		alert("1111:::"+$("#searchPart").val());
		searchRepairPart($("#searchYear").val(), $("#searchCom").val(), $("#searchPart"), part_cd);
//		alert("2222:::"+$("#searchPart").val());	

		Search();
		
		$("#searchYear").change(function() {

			Search();
		});
		
		$("#searchCom").change(function() {
			
			Search();			
		});
		
		$("#searchPart").change(function() {

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
			, url : "/repair/getSystemUseView"
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
			var btnStr1 = "";			
			//입출고일,자재명, 제조사, 입고량, 출고량, 비고, 수정/삭제    
			if(listLen > 0) {
				for(i=0; i<listLen; i++) {
					
					
					str += "<tr>";
					str += "	<td><span> "+list[i].inout_day+"</span></td>";
					str += "	<td><span> "+list[i].part_name+"</span></td>";
					str += "	<td><span> "+list[i].company_name+"</span></td>";
					if(list[i].inout_flag == "1") {					
						str += "	<td><span> "+list[i].inout_cnt+" 개</span></td>";
						str += "	<td><span> 0 개 </a></span></td>";
					} else {
						str += "	<td><span> 0 개</a></span></td>";
						str += "	<td><span> "+list[i].inout_cnt+" 개</span></td>";						
					}
					str += "	<td><span> "+list[i].bigo1+"</span></td>";					
					btnStr =   "<span><a href='javascript:getSystemUseDetail1(\""+list[i].seq_no+"\")' class='btn_orange'>수정</a></span>";					
					btnStr1 =  "<span><a href='javascript:Delete(\""+list[i].seq_no+"\")' class='btn_orange'>삭제</a></span>";	
					if(list[i].repair_no == "" || list[i].repair_no == null ) {					
						str += "	<td style='text-align: center;'> "+btnStr+""+btnStr1+" </td>";	
					} else {
						str += "	<td style='text-align: center;'> </td>";						
					}
					str += "</tr>";
				}
			}
			else {
				str += "<tr>";
				str += "	<td colspan='7' style='text-align: center;'>등록된 글이 존재하지 않습니다.</td>";
				str += "</tr>";
			}
			
			$("#tbody").html(str);
		//	$("#total_count").text(totalCount);
			$("#pagination").html(pagination);
		}
	}
	
	function getSystemUseDetail1(seq_no) {
		
		searchCompany($("#searchYear").val(), $("#company_id"), $("#searchCom").val());
		searchRepairPart($("#searchYear").val(), $("#searchCom").val(), $("#part_cd"), $("#searchPart").val());		
		
		if(seq_no == null || seq_no == ""){
			
			$("#saveFlag").val("I");
//			$("#company_id").val(company_id);				
//			$("#part_cd").val(part_cd);
			$("#inout_day").val(today);
			$("#inout_cnt").val(0);
			$("#bigo1").val("");
			$("input[type=radio][name=inout_flag]").prop("checked", false);			
			modal_popup2('messagePop2');
			
			return;			
			
		}
		
		$.ajax({
			type : "POST"			
			, url : "/repair/getSystemUseDetail1"
			, data : {"seq_no":seq_no}
			, dataType : "JSON"
			, success : function(obj) {
				getDetailSearchCallback(obj);
			}
			, error : function(xhr, status, error) {
				
			}
		}); 
	}
	
	function getDetailSearchCallback(obj) {
		var data = obj.resultData;
		
		if(data != null){
			for(var key in data){
				$("#"+key).val(data[key]);
			}
			
			if(data['inout_flag'] != "" && data['inout_flag'] != null) {
				$("input[type=radio][name=inout_flag][value="+data['inout_flag']+"]").prop("checked", true);
			}
			
		}
		modalPopupCallback( function() {
			$("#saveFlag").val("U");
//			$("#seq_no").val(seq_no);			
			modal_popup2('messagePop2');
			
		});
		
	}
	
	function modalPopupCallback(fnNm) {
		fnNm();
	}
	
	function Save() {
	
		if($("input[type=radio][name=inout_flag]:checked").val()  == "" || $("input[type=radio][name=inout_flag]:checked").val() == null) {
			alert("입출고 구분을 선택하세요.");
			$("input[type=radio][name=inout_flag]").focus();
			return;
		}		
		
		if($("#inout_day").val() == "" || $("#inout_day").val() == null) {
			$("#inout_day").focus();
			alert("입출고일을 입력하세요.");
			return;
		}
		
		if($("#inout_cnt").val() == "" || $("#inout_cnt").val() == null) {
			$("#inout_cnt").focus();
			alert("수량을 입력하세요.");
			return;
		}
		
		var obj = $("#frm").serializeArray();
		var json = {};
		
		for(i=0; i<obj.length; i++) {
			json[obj[i].name] = obj[i].value;
		}
		
		var yn = confirm("자재 입출고 정보를 저장 하시겠습니까?");
		if(yn){
			$.ajax({
				type : "POST"			
				, url : "/repair/updateSystemUse"
				, data : json
				, dataType : "JSON"
				, success : function(obj) {
					getUpdateMemberCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});
		}
	}
	
	function getUpdateMemberCallback(obj) {
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("저장 되었습니다.");
				$('.modal-popup2 .bg').trigger("click");
				Search();
			}
		}
	}
	
	function Delete(seq_no) {
		
		var yn = confirm("자재입출고 정보를 삭제 하시겠습니까?");
		if(yn){
			$.ajax({
				type : "POST"			
				, url : "/repair/deleteSystemUse"
				, data : {"seq_no":seq_no}
				, dataType : "JSON"
				, success : function(obj) {
					getDeleteMemberCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});
		}
	}
	
	function getDeleteMemberCallback(obj) {
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("삭제 되었습니다.");
			//	$('.modal-popup2 .bg').trigger("click");
				Search();
			}
			else {
				alert("삭제 실패했습니다.");
				return;
			}
		}
	}
	
	function onlyNumber(obj) {		
	     obj.value = obj.value.replace(/\D/g, '');
	      
	 }
	
	function maxLengthCheck(obj){
	    if (obj.value.length > obj.maxLength){
	    	obj.value = obj.value.slice(0, obj.maxLength);
	    }    
	  }
	
	
	function goToList() {
		var frm = document.slightForm;
		frm.action = '/repair/systemUseList';
		frm.method ="post";
		frm.submit();
		//$("#slightForm").attr({action:'/repair/systemUseList'}).submit();
	}
	
	function popupClose() {
		
		$('.modal-popup2').fadeOut();
	}
	
	function searchCompany(st_yy, ele, sel) {
//	alert("st_yy:::"+st_yy);
//	alert("sel:::"+sel);

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
						// alert("selected sel:::"+obj.resultData[i].data_code);
						
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
	
	function searchRepairPart(st_yy, companyId, ele, sel) {
//		alert("st_yy:::"+st_yy);
//		alert("companyId:::"+companyId);
//		alert("sel:::"+sel);

		$.ajax({
			type : "POST"			
			, url : "/repair/getRepairPartId"
			, data : {"searchYear" : st_yy, "searchCom" : companyId}
			, dataType : "JSON"
			, success : function(obj) {
				var option = "<option value=''>선택</option>";
				for(i=0; i<obj.resultData.length; i++) {
					
					if(obj.resultData[i].part_cd == sel) {
						option += "<option value='"+obj.resultData[i].part_cd+"' selected>"+obj.resultData[i].data_code_name+"</option>";
//						alert("selected sel:::"+obj.resultData[i].part_cd);
						
					}
					else {
						option += "<option value='"+obj.resultData[i].part_cd+"'>"+obj.resultData[i].data_code_name+"</option>";
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
			<input type="hidden" name="seq_no" value="" />
			<input type="hidden" name="cmd" value="" />
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
							<option value="${param.company_id}">${param.comp_nm }</option>						
						</select>
					</li>
					<li class="b_left">
						<select id ="searchPart" name="searchPart" class="sel02">
							<option value="${param.part_cd}">${param.part_name }</option>
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
					<col width="15%">
					<col width="10%">
					<col width="10%">
					<col width="15%">
					<col width="15%">					
				</colgroup>
				<thead>
					<tr>
						<th>입출고일</th>
						<th>자재명</th>
						<th>제조사</th>
						<th>입고량</th>
						<th>출고량</th>
						<th>비고</th>
						<th>수정/삭제</th>						
					</tr>
				</thead>
				<tbody id="tbody">
				
				</tbody>
			</table>
		</div>
		<div style="width:1160px;margin:0 auto;text-align:center;overflow:hidden;margin-top: 10px;">
		    <span style="float: right;"><a href="javascript:goToList();"  class="btn_blue03">목록</a></span>		
			<span style="float: right;"><a href="javascript:getSystemUseDetail1()" class="btn_blue03">등록</a></span>		
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
					<h3>자재 입출고현황</h3>
					<form name="frm" id="frm" method="post">
						<input type="hidden" id="saveFlag" name="saveFlag" value="">
						<input type="hidden" id="seq_no" name="seq_no" value="" />						
						<div id="board_view">
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
										<th>해당년도</th>
										<td>
											<span>
											<select name="year" id="year" class="sel03">
												<c:forEach items="${searchYearList}" var="year">
													<option value="${year.year }">${year.year }년</option>
												</c:forEach>												
											</select>
											</span>
										</td>
									</tr>
									<tr>    	
										<th>제조사</th>
										<td>
											<span>										
											<select name="company_id" id="company_id" class="sel03">
											</select>
											</span>
										</td>
									</tr>
									<tr>
										<th>자재명/자재규격</th>
										<td>
											<span>
											<select name="part_cd" id="part_cd" class="sel02">
											</select>
											</span>
										</td>
									</tr>
									<tr>
										<th>입출고 구분</th>
										<td>
											<span class="pdr10"><input type="radio" name="inout_flag" value="1" checked="checked" > 입고</span>
											<span class="pdr10"><input type="radio" name="inout_flag" value="2"> 출고</span></td>
										</td>	
									</tr>
									<tr>
										<th>입출고일</th>
										<td><input type="number" pattern="[0-9]*" onkeydown="onlyNumber(this)" oninput="maxLengthCheck(this)" style="ime-mode:disabled;" maxlength="8" id="inout_day" name="inout_day" class="tbox02" >
										</td>
									</tr>
									<tr>	
										<th>수량</th>
										<td><span><input type="number" pattern="[0-9]*" onkeydown="onlyNumber(this)" oninput="maxLengthCheck(this)" style="ime-mode:disabled;" maxlength="10" name="inout_cnt" id="inout_cnt" class="tbox07" value="">개</span>
										</td>
									</tr>
									<tr>	
										<th>비고</th>
										<td><textarea id="bigo1" name="bigo1" cols="55" rows="3" maxlength="100" ></textarea>
										</td>
									</tr>
									
								</tbody>
							</table>
						</div>
					</form>				
					<div id="btn">
						<p>
						<span><a href="javascript:popupClose()"  class="btn_gray02">닫기</a></span>					
						<span><a href="javascript:Save()" class="btn_gray02">등록</a></span>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--//상세 Popup-->