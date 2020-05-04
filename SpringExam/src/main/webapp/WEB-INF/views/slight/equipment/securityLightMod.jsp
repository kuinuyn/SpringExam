<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};

	$(function(){
		var searchAreaStr = "";
		//drawCodeData(리스트, 코드타입, 태그이름, 모드, 현재선택코드)
		drawCodeData(commonCd, "05", "select", "").then(function(resolvedData) {
			$("#mgmt_no").empty();
			$("#mgmt_no").append(resolvedData);
			
			$("#light_no").val("${param.light_no}");
			$("#par_hj_dong").val("${param.hj_dong_cd}");
		})
		.then(function() {
			drawCodeData(commonCd, "06", "select", "", "${param.par_hj_dong}").then(function(resolvedData) {
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
			drawCodeData(commonCd, "09", "select", "").then(function(resolvedData) {
				$("#lamp1_cd").empty();
				$("#lamp1_cd").append(resolvedData);
				$("#lamp1_cd2").empty();
				$("#lamp1_cd2").append(resolvedData);
			})
		})
		.then(function() {
			drawCodeData(commonCd, "10", "select", "").then(function(resolvedData) {
				$("#lamp2_cd").empty();
				$("#lamp2_cd").append(resolvedData);
				$("#lamp2_cd2").empty();
				$("#lamp2_cd2").append(resolvedData);
			})
		})
		.then(function() {
			drawCodeData(commonCd, "11", "select", "").then(function(resolvedData) {
				$("#lamp3_cd").empty();
				$("#lamp3_cd").append(resolvedData);
				$("#lamp3_cd2").empty();
				$("#lamp3_cd2").append(resolvedData);
			})
		})
		.then(function() {
			drawCodeData(commonCd, "12", "select", "").then(function(resolvedData) {
				$("#kepco_cd").empty();
				$("#kepco_cd").append(resolvedData);
			})
		})
		.then(function() {
			drawCodeData(commonCd, "15", "select", "").then(function(resolvedData) {
				$("#onoff_cd").empty();
				$("#onoff_cd").append(resolvedData);
			})
		})
		.then(function() {
			drawCodeData(commonCd, "16", "select", "").then(function(resolvedData) {
				$("#work_cd").empty();
				$("#work_cd").append(resolvedData);
			})
		})
		.then(function() {
			drawCodeData(commonCd, "29", "select", "").then(function(resolvedData) {
				$("#auto_jum_type1_cd").empty();
				$("#auto_jum_type1_cd").append(resolvedData);
			})
		})
		.then(function() {
			drawCodeData(commonCd, "30", "select", "").then(function(resolvedData) {
				$("#lamp1_gubun").empty();
				$("#lamp1_gubun").append(resolvedData);
			})
		})
		.then(function() {
			getEquipmentMod();
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
		var yn = confirm("보안등 정보를 수정하시겠습니까?");
		if(yn){
			$("#slightForm").ajaxForm({
				url : "/equipment/updateEquipment"
				, enctype : "multipart/form-data"
				, cache : false
				, async : true
				, type	: "POST"
				, success : function(obj) {
					updateEquipmentCallback(obj);
				}
				, error 	: function(xhr, status, error) {}
			}).submit();
		}
	}
	
	function updateEquipmentCallback(obj) {
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
	
	function getEquipmentMod() {
		$("#slightForm").attr("enctype", "")
		
		$.ajax({
			type : "POST"			
			, url : "/equipment/getEquipmentMod"
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
			
			var str = "";
			if(filesLen > 0) {
				for(i = 0; i<filesLen; i++) {
					str += "<a href=/board/fileDownload?fileNameKey="+encodeURI( files[i].file_name_key) + "&fileName=" + files[i].file_name + "&filePath=" + files[i].file_path + ">"+ files[i].file_name +"</a>";
					str += "<button class='btn black ml10 mr5' style='padding:3px 5px 6px 5px;' onclick='javascript:setDeleteFile(\""+$("#light_no").val()+"\", "+files[i].file_no+", this)' />";
				}
			}
			else {
				str += "<input type='file' id='files[0]' name='files' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'>";
			}
			
			$("#file_td").html(str);
			
			if(filesLen == 1) {
				$("#file_td").append("<div><input type='file' id='files[0]' name='files' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>");
			}
		}
		else {			
			alert("등록된 글이 존재하지 않습니다.");
			return;
		}
	}
	
	function setDeleteFile(boardSeq, fileSeq, element) {
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
		
		if($("#file_td > button").length == 1) {
			fileStr = "<div><input type='file' id='files[0]' name='files' value='' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
			$("#file_td").append(fileStr);
		}
		else if($("#file_td > button").length == 0) {
			fileStr = "<div><input type='file' id='files[1]' name='files' value='' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
			$("#file_td").append(fileStr);
		}
		
	}
	
	function fnFile(element) {
		var fileStr = "";
		var fileCnt = $("#file_td > a").length + $("input[name=files]").length;
		
		if(fileCnt == 1) {
			fileStr = "<div><input type='file' id='files[1]' name='files' value='' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
		}
		$("#file_td").append(fileStr);
		fileTypeCheck(element);
	}
	
	function goToList() {
		var frm = document.slightForm;
		frm.action = '/equipment/securityLightList';
		frm.method ="post";
		frm.submit();
		//$("#slightForm").attr({action:'/equipment/securityLight'}).submit();
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
				<li><a href="#">보안등관리<img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
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
		<div id="sub_title"><h3>보안등관리</h3></div>
		<form id="slightForm" name="slightForm">
			<input type="hidden" id="light_no" name="light_no" >
			<input type="hidden" id="par_hj_dong" name="par_hj_dong" >
			<input type="hidden" id="current_page_no" name="current_page_no" value="${param.current_page_no }" />
			<input type="hidden" id="searchLampGubun" name="searchLampGubun" value="${param.searchLampGubun }" />
			<input type="hidden" id="delete_file" 		name="delete_file" value=""/><!-- 삭제할 파일 -->
			<div id="board_view2">
				<table summary="보안등" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="20%">
						<col width="30%">
						<col width="20%">
						<col width="30%">
					</colgroup>
					<tbody id="tbody">
						<tr>
							<th>관리번호</th>
							<td><c:out value="${param.light_no }" /></td>
							<th>구관리번호</th>
							<td>
								<input id="old_light_no" name="old_light_no" value="" class="tbox01"/>
							</td>
						</tr>
						<tr>
							<th>행정동</th>
							<td colspan="3">
								<select class="sel01" id="hj_dong_cd" name="hj_dong_cd">
								</select>
							</td>
						</tr>
						<tr>
							<th>회사</th>
							<td>
								<select class="sel01" id="mgmt_no" name="mgmt_no">
								</select>
							</td>
							<th>점멸기</th>
							<td>
								<select class="sel01" id="auto_jum_type1_cd" name="auto_jum_type1_cd">
								</select>
							</td>
						</tr>
						<tr>
							<th>도엽번호</th>
							<td>
								<input id="doyep_no" name="doyep_no" value="" class="tbox03"/>
							</td>
							<th>공사번호</th>
							<td>
								<input id="bgs_no" name="bgs_no" value="" class="tbox03"/>
							</td>
						</tr>
						<tr>
							<th>변대주</th>
							<td>
								<input id="bdj" name="bdj" value="" class="tbox03"/>
							</td>
							<th>인입주</th>
							<td>
								<input id="pole_no" name="pole_no" value="" class="tbox03"/>
							</td>
						</tr>
						<tr>
							<th>등상태</th>
							<td>
								<select class="sel01" id="lamp1_gubun" name="lamp1_gubun">
								</select>
							</td>
							<th>쌍등여부</th>
							<td>
								<select class="sel01" id="twin_light" name="twin_light">
									<option value="Y">예</option>
									<option value="N">아니오</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>등기구모형1</th>
							<td>
								<select class="sel01" id="lamp1_cd" name="lamp1_cd">
								</select>
							</td>
							<th>등기구모형2</th>
							<td>
								<select class="sel01" id="lamp1_cd2" name="lamp1_cd2">
								</select>
							</td>
						</tr>
						<tr>
							<th>광원종류1</th>
							<td>
								<select class="sel01" id="lamp2_cd" name="lamp2_cd">
								</select>
							</td>
							<th>광원종류2</th>
							<td>
								<select class="sel01" id="lamp2_cd2" name="lamp2_cd2">
								</select>
							</td>
						</tr>
						<tr>
							<th>광원용량1</th>
							<td>
								<select class="sel01" id="lamp3_cd" name="lamp3_cd">
								</select>
							</td>
							<th>광원용량2</th>
							<td>
								<select class="sel01" id="lamp3_cd2" name="lamp3_cd2">
								</select>
							</td>
						</tr>
						<tr>
							<th>스위치종류</th>
							<td>
								<select class="sel01" id="onoff_cd" name="onoff_cd">
								</select>
							</td>
							<th>지지방식</th>
							<td>
								<select class="sel01" id="stand_cd" name="stand_cd">
								</select>
							</td>
						</tr>
						<tr>
							<th>한전고객번호</th>
							<td>
								<input id="kepco_cust_no" name="kepco_cust_no" value="" class="tbox03"/>
							</td>
							<th>한전계약전력</th>
							<td>
								<select class="sel01" id="kepco_cd" name="kepco_cd">
								</select>
							</td>
						</tr>
						<tr>
							<th>작업진행현황</th>
							<td>
								<select class="sel01" id="work_cd" name="work_cd">
								</select>
							</td>
							<th>설치일자</th>
							<td>
								<input id="set_ymd" name="set_ymd" value="" class="tbox03"/>
							</td>
						</tr>
						<tr>
							<th>사용량</th>
							<td colspan="3">
								<input id="use_light" name="use_light" value="" class="tbox03"/>
							</td>
						</tr>
						<tr>
							<th>구주소</th>
							<td colspan="3">
								<input id="address" name="address" value="" class="tbox03"/>
							</td>
						</tr>
						<tr>
							<th>신주소</th>
							<td colspan="3">
								<input id="new_address" name="new_address" value="" class="tbox03"/>
							</td>
						</tr>
						<tr>
							<th>첨부사진</th>
							<td colspan="3">
								<div id="file_td">
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
