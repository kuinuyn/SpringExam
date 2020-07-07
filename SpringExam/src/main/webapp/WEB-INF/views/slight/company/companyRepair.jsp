<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};
	var materialList = null;
	
	$(function(){
		var pageNo = "${param.current_page_no}";
		var repairCd = "${param.repair_cd}";
		var paramSDate = "${param.sDate}";
		var paramEDate = "${param.eDate}";
		
		//drawCodeData(리스트, 코드타입, 태그이름, 태그ID, 모드, 현재선택코드)
		drawCodeData(commonCd, "14", "select", "ALL", "", repairCd).then(function(resolvedData) {
			$("#sch_repair_cd").empty();
			$("#sch_repair_cd").append(resolvedData);
			
			var idx = $("#sch_repair_cd").children("option").size()-1;
			var optText = "";
			while(idx > 0) {
				optText = $("#sch_repair_cd").children("option").eq(idx).text();
				
				if(optText == "신설") {
					$("#sch_repair_cd").children("option").eq(idx).remove();
				}
				else if(optText == "이설") {
					$("#sch_repair_cd").children("option").eq(idx).remove();
				}
				else if(optText == "철거") {
					$("#sch_repair_cd").children("option").eq(idx).remove();
				}
				idx--;
			}
		})
		.then(function() {
			drawCodeData(commonCd, "03", "select", "", "", repairCd).then(function(resolvedData) {
				$("#progress_status").empty();
				$("#progress_status").append(resolvedData);
				
				var idx = $("#progress_status").children("option").size()-1;
				var optVal = "";
				while(idx >= 0) {
					optVal = $("#progress_status").children("option").eq(idx).val();
					
					if(optVal < "03") {
						$("#progress_status").children("option").eq(idx).remove();
					}
					else if(optVal == "") {
						$("#progress_status").children("option").eq(idx).remove();
					}
					
					idx--;
				}
			})
		})
		.then(function() {
			drawCodeData(commonCd, "26", "select", "", "", repairCd).then(function(resolvedData) {
				$("#repair_gubun").empty();
				$("#repair_gubun").append(resolvedData);
			})
		})
		.then(function() {
			if(pageNo != "" && pageNo != null) {
				Search(pageNo);
			}
			else {
				Search();
			}
		});
		
		$("#sch_where2").hide();
		
		var today = new Date();
		var sDate = (paramSDate == "" || paramSDate == null) ? new Date(today.getFullYear(), today.getMonth(), today.getDate()-100) : paramSDate;
		var eDate = (paramEDate == "" || paramEDate == null) ? new Date(today.getFullYear(), today.getMonth(), today.getDate()) : paramEDate;
		
		$("#sDate").datepicker({
			showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시 ^ both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시 
			, maxDate : eDate
			, dateFormat: 'yy-mm-dd'
			, buttonImage : "/resources/css/images/icon/calendar.gif"
		});
		$('#sDate').datepicker('setDate', sDate);
		
		$("#eDate").datepicker({
			showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시 ^ both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시 
			, maxDate : eDate
			, dateFormat: 'yy-mm-dd'
			, buttonImage : "/resources/css/images/icon/calendar.gif"
		});
		$('#eDate').datepicker('setDate', eDate);
		
		//$(".ui-datepicker-trigger").css("display", "none");
		
		$(".ui-datepicker-trigger").attr("style", "margin-left:4px; vertical-align:middle;");
		
	});
	
	function Search(currentPageNo, orderNm, order) {
		if(currentPageNo === undefined){
			currentPageNo = "1";
		}
		
		$("#current_page_no").val(currentPageNo);
		
		$.ajax({
			type : "POST"			
			, url : "/company/getCompanyRepairList"
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
			//접수번호,민원종류,관리번호,신고인,전화번호,접수일,보수일,처리상황
			if(listLen > 0) {
				for(i=0; i<listLen; i++) {
					str += "<tr>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].repair_no2+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].repair_name+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].light_no+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].notice_name+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+formatContactNumber(list[i].phone)+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].notice_date+" </a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")'>"+list[i].repair_date+" </a></span></td>";
					if(list[i].progress_status == "01") {
						btnStr = "<span><a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")' class='btn_red02'>신고접수</a></span>";
					}
					else if(list[i].progress_status == "02" || list[i].progress_status == "03") {
						btnStr = "<span><a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")' class='btn_orange02'>처리중</a></span>";
					}
					else if(list[i].progress_status == "04" || list[i].progress_status == "05") {
						btnStr = "<span><a href='javascript:getRepairDetail(\""+list[i].repair_no+"\")' class='btn_blue04'>처리완료</a></span>";
					}
					str += "	<td style='text-align: center;'> "+btnStr+" </td>";
					str += "</a></tr>";
				}
			}
			else {
				str += "<tr>";
				str += "	<td colspan='9' style='text-align: center;'>등록된 글이 존재하지 않습니다.</td>";
				str += "</tr>";
			}
			
			$("#tbody").html(str);
			$("#toptxt .black03").text("총개수: "+totalCount+"개");
			$("#pagination").html(pagination);
		}
	}
	
	function getRepairDetail(repairNo) {
		$("#repairNo").val(repairNo.trim());
		$.ajax({
			type : "POST"			
			, url : "/company/getCompanyRepairDetail"
			, data : {"repairNo":repairNo}
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
				//console.log("key : "+key +"      data : "+ data);
				element = "det_"+key;
				if($("#"+element).length > 0) {
					if(key == "phone" || key == "mobile") {
						$("#"+element).text(formatContactNumber(data[key]));
					}
					else {
						$("#"+element).text(data[key]);
					}
				}
				
				if($("#"+key).length > 0) {
					$("#"+key).val(data[key].trim());
				}
				
			}
			
			$("#delete_file").val('');
		}
		
		if(data['downLoadFiles'] != null && data['downLoadFiles'] != "") {
			var downLoadFiles = data['downLoadFiles'];
			var filePah = "";
			
			var str1 = "";
			var str2 = "";
			var str3 = "";
			for(i = 0; i<downLoadFiles.length; i++) {
				filePah = "/display?name="+downLoadFiles[i].file_name_key;
				
				$("#detail_slight"+(downLoadFiles[i].file_no-1)).attr("src", filePah)
				if($("#photo1").val() == downLoadFiles[i].file_no) {
					str1 = "<div><a href=/board/fileDownload?fileNameKey="+encodeURI( downLoadFiles[i].file_name_key) + "&fileName=" + encodeURI(downLoadFiles[i].file_name) + "&filePath="+encodeURI(downLoadFiles[i].file_path)+">"+ downLoadFiles[i].file_name +"</a>";
					str1 += "<input type='hidden' id='file_no_1' name='file_no_1' value='"+downLoadFiles[i].file_no+"'>";
					str1 += "<button class='btn black ml10 mr5' style='padding:3px 5px 6px 5px;' onclick='javascript:setDeleteFile(\""+$("#repairNo").val()+"\", "+downLoadFiles[i].file_no+", this,1)' /></div>";
				}
				
				if($("#photo2").val() == downLoadFiles[i].file_no) {
					str2 = "<div><a href=/board/fileDownload?fileNameKey="+encodeURI( downLoadFiles[i].file_name_key) + "&fileName=" + encodeURI(downLoadFiles[i].file_name) + "&filePath="+encodeURI(downLoadFiles[i].file_path)+">"+ downLoadFiles[i].file_name +"</a>";
					str2 += "<input type='hidden' id='file_no_2' name='file_no_2' value='"+downLoadFiles[i].file_no+"'>";
					str2 += "<button class='btn black ml10 mr5' style='padding:3px 5px 6px 5px;' onclick='javascript:setDeleteFile(\""+$("#repairNo").val()+"\", "+downLoadFiles[i].file_no+", this,2)' /></div>";
				}
				
				if($("#photo3").val() == downLoadFiles[i].file_no) {
					str3 = "<div><a href=/board/fileDownload?fileNameKey="+encodeURI( downLoadFiles[i].file_name_key) + "&fileName=" + encodeURI(downLoadFiles[i].file_name) + "&filePath="+encodeURI(downLoadFiles[i].file_path)+">"+ downLoadFiles[i].file_name +"</a>";
					str3 += "<input type='hidden' id='file_no_3' name='file_no_3' value='"+downLoadFiles[i].file_no+"'>";
					str3 += "<button class='btn black ml10 mr5' style='padding:3px 5px 6px 5px;' onclick='javascript:setDeleteFile(\""+$("#repairNo").val()+"\", "+downLoadFiles[i].file_no+", this,3)' /></div>";
				}
				
			}
			
			if($("#photo1").val() == null || $("#photo1").val() == "") {
				$("#detail_slight0").attr("src", "/resources/css/images/sub/slight_noimg.gif")
				str1 = "<div><input type='file' id='files[1]' name='files' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
			}
			
			if($("#photo2").val() == null || $("#photo2").val() == "") {
				$("#detail_slight1").attr("src", "/resources/css/images/sub/slight_noimg.gif")
				str2 = "<div><input type='file' id='files[2]' name='files' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
			}
			
			if($("#photo3").val() == null || $("#photo3").val() == "") {
				$("#detail_slight2").attr("src", "/resources/css/images/sub/slight_noimg.gif")
				str3 = "<div><input type='file' id='files[3]' name='files' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
			}
			
			if($("#detail_slight").find("img").eq(0).parent().find("div").length > 0) {
				$("#detail_slight").find("img").eq(0).parent().find("div").empty();
			}
			if($("#detail_slight").find("img").eq(1).parent().find("div").length > 0) {
				$("#detail_slight").find("img").eq(1).parent().find("div").empty();
			}
			if($("#detail_slight").find("img").eq(2).parent().find("div").length > 0) {
				$("#detail_slight").find("img").eq(2).parent().find("div").empty();
			}
			
			if(data["progress_status"] != "04") {
				$("#detail_slight").find("img").eq(0).parent().append(str1);
				$("#detail_slight").find("img").eq(1).parent().append(str2);
				$("#detail_slight").find("img").eq(2).parent().append(str3);
			}
		}
		else {
			for(i = 0; i<$("#detail_slight").find("img").size(); i++) {
				$("#detail_slight").find("img").eq(i).parent().find("div").empty();
				$("#detail_slight").find("img").eq(i).attr("src", "/resources/css/images/sub/slight_noimg.gif");
				
				if(data["progress_status"] != "04") {
					$("#detail_slight").find("img").eq(i).parent().append("<div><input type='file' id='files["+(i+1)+"]' name='files' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>");
				}
			}
		}
		
		var materiaUsedList = null;
		$("#tdPartCd").empty();
		
		if(data['materialList'] != null && data['materialList'] != "") {
			materialList = data['materialList'];
			
			messageTag = "<span class='red01'>※사용부품 삭제 시 0개를 입력하시면 됩니다.</span>";
			if(data['materiaUsedList'] != null && data['materiaUsedList'] != "") {
				materiaUsedList = data['materiaUsedList'];
				var options = "";
				var partCd = "";
				var dataCd = "";
				var dataCdNm = "";
				var removeIdx = 0;
				
				$("#tdPartCd").append(messageTag);
				for(i=0; i<materiaUsedList.length; i++) {
					partCd = materiaUsedList[i].part_cd;
					
					options = "<option value=''>자재선택</option>";
					selectTag = "<p><span><select id='part_cd_"+i+"' name='part_cd_"+i+"' class='sel04' onchange='changePartCd(this)' onfocus='focusPartCd(this)'>";
					for(j=0; j<materialList.length; j++) {
						dataCd = materialList[j].data_code;
						dataCdNm = materialList[j].data_code_name;
						if(dataCd != partCd) {
							options += "<option value='"+dataCd+"'>"+dataCdNm+"</option>"
						}
						else {
							removeIdx = j;
							options += "<option value='"+dataCd+"' selected>"+dataCdNm+"</option>"
						}
					}
					selectTag += options+"</select></span>";
					selectTag += "<span class=''><input type='number' pattern='[0-9]*' onkeydown='onlyNumber(this)' oninput='maxLengthCheck(this)' style='ime-mode:disabled;' maxlength='10' id='part_cnt_"+i+"' name='part_cnt_"+i+"' class='tbox10' placeholder='0' value='"+materiaUsedList[i].inout_cnt+"'>개</span></p>";
					
					$("#tdPartCd").append(selectTag);
					
					materialList.splice(removeIdx, 1);
				}
				
				if(materiaUsedList.length < 10) {
					options = "<option value=''>자재선택</option>";
					selectTag = "<p><span><select id='part_cd_"+materiaUsedList.length+"' name='part_cd_"+materiaUsedList.length+"' class='sel04' onchange='changePartCd(this)' onfocus='focusPartCd(this)'>";
					for(j=0; j<materialList.length; j++) {
						options += "<option value='"+materialList[j].data_code+"'>"+materialList[j].data_code_name+"</option>"
					}
					selectTag += options+"</select></span>";
					selectTag += "<span class=''><input type='number' pattern='[0-9]*' onkeydown='onlyNumber(this)' oninput='maxLengthCheck(this)' style='ime-mode:disabled;' maxlength='10' id='part_cnt_"+materiaUsedList.length+"' name='part_cnt_"+materiaUsedList.length+"' class='tbox10' placeholder='0'>개</span></p>";
				
					$("#tdPartCd").append(selectTag);
				}
			}
			else if(materiaUsedList == null) {
				options = "<option value=''>자재선택</option>";
				selectTag = "<p><span><select id='part_cd_0' name='part_cd_0' class='sel04' onchange='changePartCd(this)' onfocus='focusPartCd(this)'>";
				for(j=0; j<materialList.length; j++) {
					options += "<option value='"+materialList[j].data_code+"'>"+materialList[j].data_code_name+"</option>"
				}
				selectTag += options+"</select></span>";
				selectTag += "<span class=''><input type='number' pattern='[0-9]*' onkeydown='onlyNumber(this)' oninput='maxLengthCheck(this)' style='ime-mode:disabled;' maxlength='10' id='part_cnt_0' name='part_cnt_0' class='tbox10' placeholder='0'>개</span></p>";
			
				$("#tdPartCd").append(messageTag+selectTag);
			}
			
			if(data["progress_status"] == "04") {
				$("input[name^=part_cnt_]").removeClass("tbox10");
				$("input[name^=part_cnt_]").addClass("tbox10_gray");
				$("input[name^=part_cnt_]").attr("readonly", true);
				
				for(i=0; i<$("#detail_slight").find("select").size(); i++) {
					$("#detail_slight").find("select").eq(i).attr("disabled", true);
				}
				
				$("#repair_desc").attr("readonly", true);
			}
			else {
				for(i=0; i<$("#detail_slight").find("select").size(); i++) {
					$("#detail_slight").find("select").eq(i).attr("disabled", false);
				}
			}
		}
		
		modalPopupCallback( function() {
			modal_popup2('messagePop2');
		});
		
	}
	
	function modalPopupCallback(fnNm) {
		fnNm();
	}

	
	function excelDownload() {
		var currentRow = $("#board_list > table > thead> tr > th").length;
		var headerArr = new Array();
		for(i=0; i<currentRow; i++) {
			headerArr.push($("#board_list > table > thead> tr").find("th:eq("+i+")").text());
		}
		
		var f = document.slightForm;
		f.method = "POST";
		f.action = "${contextPath}/company/downloadExcel";
		f.excelHeader.value = headerArr;
		f.submit();
	}
	
	function onDisplay(val) {
			
		if(val == "" ||val == "0" || val=="1" || val=="3" || val=="5") {

			$("#sch_where2").hide();
			$("#sch_where3").show();
			
		}
		else if (val=="4") {
			$("#sch_where2").show();
			$("#sch_where3").hide();
			
			drawCodeData(commonCd, "03", "select", "ALL", "", "").then(function(resolvedData) {
				$("#sch_where2").empty();
				$("#sch_where2").append(resolvedData);
				
			})
			
		}
		else if (val=="6") {
			$("#sch_where2").show();
			$("#sch_where3").hide();
			
			drawCodeData(commonCd, "06", "select", "ALL", "", "").then(function(resolvedData) {
				$("#sch_where2").empty();
				$("#sch_where2").append(resolvedData);
			});
		}
		else if(val=="2") {			
			$("#sch_where2").show();
			$("#sch_where3").hide();
			
			$("#sch_where2").empty();
		}
			
	}
	
	/* function goToMod() {
		var frm = document.slightForm;
		frm.action = '/company/companyRepairMod';
		frm.method ="post";
		frm.submit();
	}; */
	
	function setDeleteFile(boardSeq, fileSeq, element,Seq) {
		//alert(boardSeq);
		var deleteFile = $("#delete_file").val();
		if(deleteFile != null && deleteFile != "") {
			deleteFile += "|"+boardSeq+"!"+fileSeq;
		}
		else {
			deleteFile += boardSeq+"!"+fileSeq;
		}
		$("#delete_file").val(deleteFile);
		$(element).parent().empty();
		//$(element).prev().remove();
		//$(element).remove();
		
		var fileStr = "";
		
		if(Seq == "1") {
			fileStr = "<div><input type='file' id='files[1]' name='files' value='' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
			$("#photo1").val('');
		}
		
		if(Seq == "2" ) {
			fileStr = "<div><input type='file' id='files[2]' name='files' value='' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
			$("#photo2").val('');
		}
		
		if(Seq == "3") {
			fileStr = "<div><input type='file' id='files[3]' name='files' value='' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>";
			$("#photo3").val('');
		}
		
		$("#detail_slight").find("img").parent().eq(Seq-1).append(fileStr);
		$("#detail_slight").find("img").eq(Seq-1).attr("src", "/resources/css/images/sub/slight_noimg.gif");
	}
	
	function fnFile(element) {

		var fileCnt = $("img[id^=detail_slight]").length;
		
		var key = "";
		for(i = 1; i <= fileCnt; i++) {
			key = "files["+i+"]";
			if($(element).attr("id") == key) {
				$("#photo"+i).val(i);
			}
		}
		
		fileTypeCheck(element);
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
	
	function Save() {
		if($("#progress_status").val() == "" || $("#progress_status").val() == null) {
			alert("진행상황을 선택하세요.");
			$("#progress_status").focus();
			return;
		}
		else {
			if($("#progress_status").val() == "01") {
				alert("작업지시 후 입력할 수 있습니다.");
				return;
			}
		}
		
		if($("#repair_gubun").val() == "" || $("#repair_gubun").val() == null) {
			alert("작업구분을 선택하세요.");
			$("#repair_gubun").focus();
			return;
		}
		
		
		var yn = confirm("보수내역 정보를 수정하시겠습니까?");
		if(yn){
			$("#slightDetailForm").ajaxForm({
				url : "/company/updateCompanyRepair"
				, enctype : "multipart/form-data"
				, cache : false
				, async : true
				, type	: "POST"
				, beforeSubmit : function(data, form, option) {
					var partCdIdx = "";
					var removeIdx = new Array();
					var partCdArr = new Array();
					var partCntArr = new Array();
					for(var idx in data) {
						
						if(data[idx].name.indexOf("part_cnt_") > -1) {
							partCdIdx = data[idx].name.substring("part_cnt_".length, data[idx].name.length);
							
							if($("#part_cd_"+partCdIdx).val() != null && $("#part_cd_"+partCdIdx).val() != "") {
								if(data[idx].value == null || data[idx].value == "") {
									alert("사용부품을 입력하세요.");
									$("#"+data[idx].name).focus();
									return false;
								}
								else {
									if(data[parseInt(idx-1)].name == ("part_cd_"+partCdIdx)) {
										removeIdx.push(parseInt(idx)-1);
										removeIdx.push(parseInt(idx));
										partCdArr.push($("#part_cd_"+partCdIdx).val());
										partCntArr.push(parseInt(data[idx].value));
									}
								}
							}
							else {
								data.splice(parseInt(idx-1), 1);
								data.splice(parseInt(idx-1), 1);
							}
						}
					}
					
					var idx = 0;
					for(var i=0; i<removeIdx.length; i++) {
						idx = parseInt(removeIdx[i])-i;
						
						data.splice(idx, 1);
					}
					
					data.push({"name" : "part_cd", "value" : partCdArr});
					data.push({"name" : "part_cnt", "value" : partCntArr});
					
				}
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
				$('.modal-popup2 .bg').trigger("click");
				Search();
			}
			else if(obj.resultCnt == -1) { 
				alert("수정을 실패하였습니다.");
				return;
			}
			else if(obj.resultCnt == -2) { 
				alert("보수완료 후 수정이 불가능합니다.");
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

	function focusPartCd(ele){
	    $(ele).data('val', $(ele).val());
	    $(ele).data('text', $(ele).children("option:selected").text());
	};

	function changePartCd(ele){
		var current = $(ele).val();
		var idx = $("#tdPartCd").find("p").size();
		var eleSelect = null;
		
		if(idx > 0 && idx < 10) {
			var eleId = $(ele).attr("id");
			var element = "part_cd_"+idx;
			
			for(var i=0; i<materialList.length; i++) {
				if(materialList[i].data_code == current) {
					materialList.splice(i, 1);
					break;
				}
			}
			
			if(idx < 2 || eleId == "part_cd_"+(idx-1)) {
				var selectTag = "<p><span><select id='"+element+"' name='"+element+"' class='sel04' onchange='changePartCd(this)' onfocus='focusPartCd(this)'>";
				var options = "<option value=''>자재선택</option>";
				var dataCd = "";
				var dataCdNm = "";
				for(i=0; i<materialList.length; i++) {
					dataCd = materialList[i].data_code;
					dataCdNm = materialList[i].data_code_name;
					options += "<option value='"+dataCd+"'>"+dataCdNm+"</option>"
				}
				selectTag += options+"</select></span>";
				selectTag += "<span class=''><input type='number' pattern='[0-9]*' onkeydown='onlyNumber(this)' oninput='maxLengthCheck(this)' style='ime-mode:disabled;' maxlength='10' id='part_cnt_"+idx+"' name='part_cnt_"+idx+"' class='tbox10' placeholder='0'>개</span></p>";
				$("#tdPartCd").append(selectTag);
				
				eleSelect = $("#tdPartCd").find("select");
				for(i=0; i<idx; i++) {
					if($("#tdPartCd").find("select").eq(i).attr("id") != eleId) {
						eleSelect.eq(i).children("option[value="+current+"]").remove();
					}
				}
			}
			else {
				var prevVal = $(ele).data('val');
				var prevText = $(ele).data('text');
				var jsonAdd = null;
				eleSelect = $("#tdPartCd").find("select");
				$(ele).parent().next().find("input[type=text]").val('')
				
				for(i=0; i<idx; i++) {
					if(prevVal != "" && prevVal != null) {
						if($("#tdPartCd").find("select").eq(i).attr("id") != eleId) {
							if(eleSelect.eq(i).children("option[value="+prevVal+"]").size() < 1) {
								eleSelect.eq(i).append("<option value='"+prevVal+"'>"+prevText+"</option> ");
							}
								
							if(current != null && current != "") {
								eleSelect.eq(i).children("option[value="+current+"]").remove();
							}
						}
						else {
							jsonAdd = {"data_code" : prevVal, "data_code_name" : prevText};
						}
					}
					else {
						if($("#tdPartCd").find("select").eq(i).attr("id") != eleId) {
							eleSelect.eq(i).children("option[value="+current+"]").remove();
						}
					}
				}
				
				var cnt = 0;
				if(jsonAdd != null) {
					for(i=0; i<materialList.length; i++) {
						if(materialList[i].data_code == jsonAdd.data_code) {
							cnt++;
						}
					}

					if(cnt < 1) {
						materialList.push(jsonAdd);
					}
				}
				
			}
			
		}
	};
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
				<li><a href="#">보수내역관리 <img src="/resources/css/images/sub/icon_down.png" class="pdl5"/></a>
					<ul>
						<li><a href="/company/companyRepair">보수내역관리</a></li>
						<li><a href="/company/companyInfo">정보변경</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="sub">
		<div id="sub_title"><h3>보수내역입력</h3></div>
		<!-- 검색박스 -->
		<form id="slightForm" name="slightForm" method="post" action="">
		<input type="hidden" id="excelHeader" name="excelHeader" value="" />
		<input type="hidden" id="repairNo" name="repairNo" value="">
		<input type="hidden" id="function_name" name="function_name" value="Search" />
		<input type="hidden" id="current_page_no" name="current_page_no" value="1" />
		<input type="hidden" id="order" name="order" value="" />
		<input type="hidden" id="orderNm" name="orderNm" value="" />
		<div id="search_box">
			<ul>
				<li class="title">접수일</li>
				<li>
					<input type="text" id="sDate" name="sDate" class="tbox02" readonly="readonly">
					~ 
					<input type="text" id="eDate" name="eDate" class="tbox02" readonly="readonly">
				</li>
				<li class="pdl10">
					<select class="sel01" id="sch_repair_cd" name="sch_repair_cd">
					</select>
				</li>
				<li>
					<select class="sel01" id="sch_where1" name="sch_where1" onchange="onDisplay(this.value)">
						<option value = "0">전체</option>
						<option value = "5">신고인</option>
						<option value = "1">관리번호</option>
						<option value = "4">처리상황</option>
						<option value = "6">동명</option>
						<option value = "2">시공업체</option>
					</select>
				</li>
				<li class="pdl10">
					<select class="sel01" id="sch_where2" name="sch_where2"  >
					</select>
				</li>
				<li><input type="text" id="sch_where3" name="sch_where3" class="tbox03"></li>
				<li><a href="javascript:Search()"  class="btn_search01">검 색</a></li>
			</ul>
		</div>
		</form>
			<div id="toptxt">
			<ul>
				<li><span class="black03">총개수: 0개</span></li>
				<li class="b_right"><span ><a href="javascript:excelDownload()" class="btn_gray03">엑셀 다운로드</a></span></li>
			</ul>
		</div>
		<div id="board_list">
			<table summary="보수이력관리목록" cellpadding="0" cellspacing="0">
				<caption>접수번호,민원종류,관리번호,신고인,전화번호,접수일,보수일,처리상황</caption>
				<colgroup>
					<col width="10%">
					<col width="11%">
					<col width="12%">
					<col width="11%">
					<col width="11%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th class="sortable" onclick="sortEvent(this)"><p class="tt"><span>접수번호</span> <span class="tt-text">클릭 시 접수번호에 따라 정렬순서 변경</span></p></th>
						<th>민원종류</th>
						<th>관리번호</th>
						<th>신고인</th>
						<th>전화번호</th>
						<th class="sortable" onclick="sortEvent(this)"><p class="tt"><span>접수일</span> <span class="tt-text">클릭 시 접수일에 따라 정렬순서 변경</span></p></th>
						<th>보수일</th>
						<th>처리상황</th>
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

<!--결과조회 상세 Popup-->
<form id="slightDetailForm" name="slightDetailForm" method="post" action="">
	<input type="hidden" id="delete_file" name="delete_file" value=""/><!-- 삭제할 파일 -->
	<input type="hidden" id="photo1" name="photo1" >
	<input type="hidden" id="photo2" name="photo2" >
	<input type="hidden" id="photo3" name="photo3" >
	<input type="hidden" id="repair_date" name="repair_date" >
	<input type="hidden" id="repair_no" name="repair_no" value="">
	<div class="modal-popup2">
		<div class="bg"></div>
		<div id="messagePop2" class="pop-layer">
			<div class="pop-container">
				<div class="pop-conts">
					<div class="btn-r">
						<a href="#" class="cbtn"><i class="fa fa-times " aria-hidden="true"></i><span class="hide">Close</span></a>
					</div>
					<div class="pop_detail2 ">
						<h3>보수내역 상세조회</h3>
						<div id="board_view">
							<!-- 텍스트컬러- 고장신고-blue 고장상태-red -->
							<h4>민원신고내역</h4>
							<table summary="보수내역현황목록" cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="14%">
									<col width="36%">
									<col width="14%">
									<col width="36%">
								</colgroup>
								<tbody>
									<tr>
										<th>관리번호</th>
										<td colspan="3"><span id="det_light_no"></span></td>
									</tr>
									<tr>
										<th>주소</th>
										<td colspan="3"><span id="det_location"></span></td>
									</tr>
									<tr>
										<th>지지방식</th>
										<td><span id="det_stand_cd_nm"></span></td>
										<th>등기구 형태</th>
										<td><span id="det_lamp1_cd_etc"></span></td>
									</tr>
									<tr>
										<th>광원종류</th>
										<td><span id="det_lamp2_cd_nm"></span></td>
										<th>꽝원용량</th>
										<td><span id="det_lamp3_cd_nm"></span></td>
									</tr>
									<tr>
										<th>점 멸 기</th>
										<td colspan="3"><span id="det_onoff_cd_nm"></span></td>
									</tr>
									<tr>
										<th>신고구분</th>
										<td colspan="3"><span id="det_repair_nm"></span></td>
									</tr>
									<tr>
										<th>고장상태</th>
										<td><span id="det_trouble_nm"></span></td>
										<th>상태설명</th>
										<td><span id="det_trouble_detail"></span></td>
									</tr>
									<tr>
										<th>접 수 일</th>
										<td><span id="det_notice_date"></span></td>
										<th>작업지시일</th>
										<td><span id="det_repair_date"></span></td>
									</tr>
									<tr>
										<th>보 수 일</th>
										<td><span id="det_repair_date_2"></span></td>
										<th>처리상황</th>
										<td><span id="det_progress_status_nm"></span></td>
									</tr>
									<tr>
										<th>신 고 인</th>
										<td><span id="det_notice_name"></span></td>
										<th>전화번호</th>
										<td><span id="det_phone"></span></td>
									</tr>
									<tr>
										<th>이 메 일</th>
										<td><span id="det_email"></span></td>
										<th>휴대폰번호</th>
										<td><span id="det_mobile"></span></td>
									</tr>
									<tr>
										<th>처리결과 회신</th>
										<td><span id="det_inform_nm"></span></td>
										<th>공사업자</th>
										<td><span id="det_com_name"></span></td>
									</tr>
									<tr>
										<th>작업지시사항</th>
										<td colspan="3"><span id="det_remark_etc"></span></td>
									</tr>
									<tr>
										<th>비고</th>
										<td colspan="3"><span id="det_repair_bigo"></span> </td>
									</tr>
								</tbody>
							</table>
						</div>
						<div id="board_view">
							<h4>보수내역입력</h4>
							<table id = "detail_slight">
								<colgroup>
									<col width="14%">
									<col width="86%">
								</colgroup>
								<tbody >
									<tr>
										<th>진행상황</th>
										<td><!-- <span id="det_progress_status_nm"> </span>	 -->
											<select id="progress_status" name="progress_status" class="sel04">
											</select>
										</td>
									</tr>
									<tr>
										<th>작업구분</th>
										<td>
											<select id="repair_gubun" name="repair_gubun" class="sel04">
											</select>
										</td>
									</tr>
									<tr>
										<th>사용부품</th>
										<td id="tdPartCd">
											<p>
												<span>
													<select id="part_cd_0" name="part_cd_0" class="sel04" onchange="changePartCd(this)" onfocus="focusPartCd(this)">
													</select>
												</span>
												<span class=""><input type="number" pattern="[0-9]*" onkeydown="onlyNumber(this)" oninput="maxLengthCheck(this)" style="ime-mode:disabled;" maxlength="10" id="part_cnt_0" name="part_cnt_0" class="tbox10" placeholder="0" >개</span>
											</p>
										</td>
									</tr>
									<tr>
										<th>보수내역</th>
										<td>
										<!-- 
											<span id="det_repair_desc"> </span> 
										-->
											<input type="text" id="repair_desc" name="repair_desc" class="tbox06" maxlength="500">
										</td>
									</tr>
									<tr>
										<th>보수전사진</th>
										<td><img id = "detail_slight0" src="/resources/css/images/sub/slight_noimg.gif" width="250" height="200"></td>
									</tr>
									<tr>
										<th>보수중사진</th>
										<td><img id = "detail_slight1" src="/resources/css/images/sub/slight_noimg.gif" width="250" height="200"></td>
									</tr>
									<tr>
										<th>보수후사진</th>
										<td><img id = "detail_slight2" src="/resources/css/images/sub/slight_noimg.gif" width="250" height="200"></td>
									</tr>
								</tbody>
							</table>
						</div>
						<div id="btn">
							<p>
								<span><a href="#"  class="btn_gray02">닫기</a></span>
								<span><a href="javascript:Save()"  class="btn_gray02">수정</a></span>
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
<!--//결과조회 상세 Popup-->

