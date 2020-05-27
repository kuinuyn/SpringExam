<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};

	$(function(){
		var searchAreaStr = "";
		
				
		$("#repairNo").val("${param.repairNo}".trim());
				
		//drawCodeData(리스트, 코드타입, 태그이름, 모드, 현재선택코드)		
		drawCodeData(commonCd, "03", "select", "", "","").then(function(resolvedData) {
			$("#progress_status").empty();
			$("#progress_status").append(resolvedData);
			
		})	
		
		.then(function() {
			getCompanyRepairMod();
		});
		
	});
	
	
	function Save() {
		validation(saveSubmit);
	};
	
	function validation(callback) {
		var value = "";
		var header = "";
		var msg = " 항목을 입력하세요.";
		var chk = true;
		
		$("th > span.t_red").each(function(index, item) {
			header = $(item).parent().text();
			header = header.substring(0, (header.length - 1));
			value = $(item).parent().next().children().val();
			if(typeof value == "undefined") {
				value = $(item).parent().next().text();
			}
			
			if(value == "" || value == null) {
				alert(header+msg);
				chk = false;
				return;
			}
			
		});
		
		/* var filesChk = $("input[name=files]").val();
		if(filesChk == "") {
			$("input[name=files]").remove();
		} */
		
		if(chk) {
			callback(function(){});
		}
		
	}
	
	function saveSubmit() {
		var yn = confirm("보수내역 정보를 수정하시겠습니까?");
		if(yn){
			$("#slightForm").ajaxForm({
				url : "/company/updateCompanyRepair"
				, enctype : "multipart/form-data"
				, cache : false
				, async : true
				, type	: "POST"
				, success : function(obj) {
					updateCompanyRepairCallback(obj);
				}
				, error 	: function(xhr, status, error) {}
			}).submit();
		}
	}
	
	function updateCompanyRepairCallback(obj) {
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("수정을 성공하였습니다.");
				goToList();
			}
			else {
				alert("수정을 실패하였습니다.");	
				return;
			}
		}
	}
	
	function getCompanyRepairMod() {
		$("#slightForm").attr("enctype", "")
		
		$.ajax({
			type : "POST"			
			, url : "/company/getCompanyRepairMod"
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
			var obj1 = $("#slightForm").serializeArray();
			var files = {};
			var filesLen = 0;
			
			if(data['downLoadFiles'] != null && data['downLoadFiles'] != "") {
				files = data["downLoadFiles"];
				filesLen = files.length;
			}
			
			for(i=0; i<obj1.length; i++) {
				for(var key in data){
					if(key == obj1[i].name) {
					
						$("#"+key).val(data[key]);
						//console.log(key+" : "+data[key]);
																		
					} 
				}
			}
			
			
			var str1 = "";
			var str2 = "";
			var str3 = "";
			if(filesLen > 0) {
				for(i = 0; i<filesLen; i++) {
					
					if($("#photo1").val() == files[i].file_no) {
						str1 += "<a href=/board/fileDownload?fileNameKey="+encodeURI( files[i].file_name_key) + "&fileName=" + encodeURI(files[i].file_name) + "&filePath="+encodeURI(files[i].file_path)+">"+ files[i].file_name +"</a>";
						str1 += "<button class='btn black ml10 mr5' style='padding:3px 5px 6px 5px;' onclick='javascript:setDeleteFile(\""+$("#repairNo").val()+"\", "+files[i].file_no+", this,1)' />";
					}
					
					if($("#photo2").val() == files[i].file_no) {
						str2 += "<a href=/board/fileDownload?fileNameKey="+encodeURI( files[i].file_name_key) + "&fileName=" + encodeURI(files[i].file_name) + "&filePath="+encodeURI(files[i].file_path)+">"+ files[i].file_name +"</a>";
						str2 += "<button class='btn black ml10 mr5' style='padding:3px 5px 6px 5px;' onclick='javascript:setDeleteFile(\""+$("#repairNo").val()+"\", "+files[i].file_no+", this,2)' />";
					}
					
					if($("#photo3").val() == files[i].file_no) {
						str3 += "<a href=/board/fileDownload?fileNameKey="+encodeURI( files[i].file_name_key) + "&fileName=" + encodeURI(files[i].file_name) + "&filePath="+encodeURI(files[i].file_path)+">"+ files[i].file_name +"</a>";
						str3 += "<button class='btn black ml10 mr5' style='padding:3px 5px 6px 5px;' onclick='javascript:setDeleteFile(\""+$("#repairNo").val()+"\", "+files[i].file_no+", this,3)' />";
					}
					
				}
			}
			
			if($("#photo1").val() == null || $("#photo1").val() == "") {
				str1 += "<input type='file' id='files[1]' name='files' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'>";
			}
			
			if($("#photo2").val() == null || $("#photo2").val() == "") {
				str2 += "<input type='file' id='files[2]' name='files' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'>";
			}
			
			if($("#photo3").val() == null || $("#photo3").val() == "") {
				str3 += "<input type='file' id='files[3]' name='files' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'>";
			}		
			
			
			$("#file_td1").html(str1);
			$("#file_td2").html(str2);
			$("#file_td3").html(str3);
			
		}
		else {			
			alert("등록된 글이 존재하지 않습니다.");
			return;
		}
	}
	
	function setDeleteFile(boardSeq, fileSeq, element,Seq) {
		var deleteFile = $("#delete_file").val();
		if(deleteFile != null && deleteFile != "") {
			deleteFile += "|"+boardSeq+"!"+fileSeq;
		}
		else {
			deleteFile += boardSeq+"!"+fileSeq;
		}
		$("#delete_file").val(deleteFile);
		$(element).prev().remove();
		$(element).remove();
		
		var fileStr = "";
		if(Seq == "1") {
			fileStr = "<div><input type='file' id='files[1]' name='files' value='' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
			$("#file_td1").append(fileStr);
			$("#photo1").val('');
		}
		
		if(Seq == "2" ) {
			fileStr = "<div><input type='file' id='files[2]' name='files' value='' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
			$("#file_td2").append(fileStr);
			$("#photo2").val('');
		}
		
		if(Seq == "3") {
			fileStr = "<div><input type='file' id='files[3]' name='files' value='' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
			$("#file_td3").append(fileStr);
			$("#photo3").val('');
		}
		
	}
	
	function fnFile(element) {

		/*
		var fileStr = "";
		
		var fileCnt = $("#file_td > a").length + $("input[name=files]").length;
		
		if(fileCnt == 1) {
			fileStr = "<div><input type='file' id='files[1]' name='files' value='' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
			$("#file_td2").append(fileStr);
		}
		if(fileCnt == 2) {
			fileStr = "<div><input type='file' id='files[2]' name='files' value='' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
		}
		$("#file_td1").append(fileStr);
		*/
		
		var fileCnt = $("input[name=files]").length;
		
		var key = "";
		for(i = 1; i <= fileCnt; i++) {
			key = "files["+i+"]";
			if($(element).attr("id") == key) {
				alert(key+" : "+i);
				$("#photo"+i).val(i);
			}
		}
		
		fileTypeCheck(element);
	}
	
	function goToList() {
		var frm = document.slightForm;
		frm.action = '/company/companyRepair';
		frm.method ="post";
		frm.submit();
		
	}
	
	function fileTypeCheck(obj) {
		pathpoint = obj.value.lastIndexOf('.');
		
		filepoint = obj.value.substring(pathpoint+1,obj.length);
		filetype = filepoint.toLowerCase();
		if(filetype=='jpg' || filetype=='gif' || filetype=='png' || filetype=='jpeg' || filetype=='bmp') {
			// 정상적인 이미지 확장자 파일인 경우
		} else {
			alert('이미지 파일만 업로드 가능합니다.');
			obj.value = '';
			return false;
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
				<li><a href="#">분전함관리<img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
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
	<!-- //local_nav -->
	
	<div id="sub">
		<div id="sub_title"><h3>보수내역 입력</h3></div>
		<form id="slightForm" name="slightForm">
			<input type="hidden" id="repairNo" name="repairNo" >
			<input type="hidden" id="photo1" name="photo1" >
			<input type="hidden" id="photo2" name="photo2" >
			<input type="hidden" id="photo3" name="photo3" >
			<input type="hidden" id="current_page_no" name="current_page_no" value="${param.current_page_no }" />
			<input type="hidden" id="searchLampGubun" name="searchLampGubun" value="${param.searchLampGubun }" />
			<input type="hidden" id="delete_file" 		name="delete_file" value=""/><!-- 삭제할 파일 -->
			<div id="board_view2">
			
				<table summary="보수내역현황목록" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="14%">
								<col width="36%">
								<col width="14%">
								<col width="36%">
							</colgroup>
						
							<tbody>
							<tr>
							</tr>
							
							<tr>
									<th>관리번호</th>
									<td colspan="3"><input id="light_no" name="light_no" value="" class="tbox01"/> </td>
								</tr>
								<tr>
									<th>주소</th>
									<td colspan="3"><input id="location" name="location" value="" class="tbox01"/></td>
								</tr>
								
								<tr>
								<th>지지방식</th>
								<td> <input id="stand_cd_nm" name="stand_cd_nm" value="" class="tbox01"/> </td>
								<th>등기구 형태</th>
								<td> <input id="lamp1_cd_etc" name="lamp1_cd_etc" value="" class="tbox01"/> </td>
								</tr>
								
								<tr>
								<th>광원종류</th>
								<td> <input id="lamp2_cd_nm" name="lamp2_cd_nm" value="" class="tbox01"/> </td>
								<th>꽝원용량</th>
								<td> <input id="lamp3_cd_nm" name="lamp3_cd_nm" value="" class="tbox01"/> </td>
								</tr>
								
								<tr>
								<th>점 멸 기</th>
								<td colspan="3"> <input id="onoff_cd_nm" name="onoff_cd_nm" value="" class="tbox01"/> </td>
								</tr>
								
								<tr>
								<th>신고구분</th>
								<td> <input id="repair_nm" name="repair_nm" value="" class="tbox01"/> </td>
								<th>작업구분</th>
								<td><select class="sel01" id="repair_gubun" name="repair_gubun" >
								<option value= "">선택</option>
								<option value= "1">교체(변경)</option>
								<option value= "2">이설</option>
								<option value= "3">철거</option>
								<option value= "4">보수</option>
								<option value= "5">신설</option>
						</select></td>
								</tr>
								
								<tr>
								<th>고장상태</th>
								<td> <input id="trouble_nm" name="trouble_nm" value="" class="tbox01"/> </td>
								<th>상태설명</th>
								<td> <input id="trouble_detail" name="trouble_detail" value="" class="tbox01"/> </td>
								</tr>
								
								<tr>
								<th>접 수 일</th>
								<td> <input id="repair_date" name="repair_date" value="" class="tbox01"/> </td>
								<th>작업지시일</th>
								<td> <input id="modify_date" name="modify_date" value="" class="tbox01"/> </td>
								</tr>
								
								<tr>
								<th>보 수 일</th>
								<td> <input id="last_update" name="last_update" value="" class="tbox01"/> </td>
								<th>처리상황</th>
								<td> <input id="remark" name="remark" value="" class="tbox01"/> </td>
								</tr>
								
								<tr>
								<th>신 고 인</th>
								<td> <input id="notice_name" name="notice_name" value="" class="tbox01"/> </td>
								<th>전화번호</th>
								<td> <input id="phone" name="phone" value="" class="tbox01"/> </td>
								</tr>
								
								<tr>
								<th>이 메 일</th>
								<td> <input id="email" name="email" value="" class="tbox01"/> </td>
								<th>휴대폰번호</th>
								<td> <input id="mobile" name="mobile" value="" class="tbox01"/> </td>
								</tr>
								
								<tr>
								<th>처리결과 회신</th>
								<td> <input id="inform_nm" name="inform_nm" value="" class="tbox01"/> </td>
								<th>공사업자</th>
								<td> <input id="com_name" name="com_name" value="" class="tbox01"/> </td>
								</tr>
								
								<tr>
								<th>작업지시사항</th>
								<td colspan="3"><input id="remark_etc" name="remark_etc" value="" class="tbox01"/> </td>
								</tr>
								<tr>
								<th>비고</th>
								<td colspan="3"><input id="repair_bigo" name="repair_bigo" value="" class="tbox03"/></td>
								
								</tr>
								
								
								
								<tr>
									<th>진행상황</th>
									<td colspan="3"><select class="sel01" id="progress_status" name="progress_status" >
									<option value= "03">처리중</option>
								<option value= "04">보수완료</option>
						</select></td>
						
						
								</tr>
								
								<tr>
								<th>보수내역</th>
								<td colspan="3"><input id="repair_desc" name="repair_desc" value="" class="tbox03"/></td>
								</tr>
								
							
								
								<tr>
							<th>보수전사진</th>
							<td colspan="3">
								<div id="file_td1">
								</div>
							</td>
						</tr>
						<tr>
							<th>보수중사진</th>
							<td colspan="3">
								<div id="file_td2">
								</div>
							</td>
						</tr>
						<tr>
							<th>보수후사진</th>
							<td colspan="3">
								<div id="file_td3">
								</div>
							</td>
						</tr>						
							</tbody>
						</table>
			</div>
			<div id="btn2">
				<p>
					<span><a href="javascript:goToList();"  class="btn_gray"> 목록으로</a></span>
					<span><a href="javascript:Save();"  class="btn_blue">저장</a></span>
				</p>
			</div>
		</form>
	</div>
</div>
