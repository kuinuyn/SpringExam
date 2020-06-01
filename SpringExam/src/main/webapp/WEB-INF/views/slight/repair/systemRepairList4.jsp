<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};

	$(function(){
		var searchArea = "${param.par_hj_dong}";
		var pageNo = "${param.current_page_no}";
		var lightGubun = "${param.light_gubun}";
		var paramSDate = "${param.sDate}";
		var paramEDate = "${param.eDate}";
		
		//drawCodeData(리스트, 코드타입, 태그이름, 모드, 현재선택코드)
		drawCodeData(commonCd, "13", "select", "ALL", lightGubun).then(function(resolvedData) {
			$("#light_gubun").empty();
			$("#light_gubun").append(resolvedData);
			
		})
		.then(function() {
			drawCodeData(commonCd, "03", "select", "", "").then(function(resolvedData) {
				$("#progress_status").empty();
				$("#progress_status").append(resolvedData);
			})
		})
		.then(function() {
			drawCodeData(commonCd, "26", "select", "", "").then(function(resolvedData) {
				$("#repair_gubun").empty();
				$("#repair_gubun").append(resolvedData);
			})
		})
		.then(function() {
			drawCodeData(commonCd, "14", "select", "ALL").then(function(resolvedData) {
				$("#repair_cd").empty();
				$("#repair_cd").append(resolvedData);
				
				var idx = $("#repair_cd").children("option").size()-1;
				var optText = "";
				while(idx >= 0) {
					optText = $("#repair_cd").children("option").eq(idx).text();
					
					if(optText != "철거") {
						$("#repair_cd").children("option").eq(idx).remove();
					}
					idx--;
				}
			});
		})
		.then(function() {
			
			$("#searchCom").parents("li").hide();
			
			if(pageNo != "" && pageNo != null) {
				Search(pageNo);
			}
			else {
				Search();
			}
		});
		
		$("#searchType").change(function() {
			var searchType = $(this).val();
			
			if(searchType == "") {
				$("#keyword").val("");
				$("#keyword").show();
				$("#keyword").addClass("tbox03_gray");
				$("#keyword").attr("readonly", true);
				$("#searchCom").parents("li").hide();
			}
			else if(searchType == 1 || searchType == 2 || searchType == 3 || searchType == 4) {
				$("#keyword").val("");
				$("#keyword").show();
				$("#keyword").removeClass("tbox03_gray");
				$("#keyword").addClass("tbox03");
				$("#keyword").attr("readonly", false);
				$("#searchCom").parents("li").hide();
			}
			else if(searchType == 5) {
				$("#keyword").val("");
				$("#keyword").hide();
				$("#searchCom").parents("li").show();
			}
		});	
		
		$("#searchCom").change(function() {
			Search();
		});		
		
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
		
		$("#searchYear").change(function() {
			searchCompany($(this).val(), $("#searchCom1"));
		});
	});
	
	function Search(currentPageNo) {
		if(currentPageNo === undefined){
			currentPageNo = "1";
		}
		
		$("#current_page_no").val(currentPageNo);
		
		$.ajax({
			type : "POST"			
			, url : "/repair/getSystemRepairList"
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
				var btnStr = "";
				var btnStr1 = "";
				var btnStr2 = "";
				var btnText = "";
				var btnClass = "";
				for(i=0; i<listLen; i++) {
					str += "<tr>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\", \"Detail\")'>"+list[i].repair_no+"</a></span></td>";
					str += "	<td><span> <a href='javascript:getRepairDetail(\""+list[i].repair_no+"\", \"Detail\")'>"+list[i].light_gubun+"</a></span></td>";
					str += "	<td><span> <a href='javascript:goGisMap(\""+list[i].light_no+"\")'>"+list[i].light_no+"</a></span></td>";
					//str += "	<td><span> <a href='javascript:modal_popup3(\"messagePop3\")'>"+list[i].light_no+"</a></span></td>";
					str += "	<td><span> "+list[i].notice_name+" </span></td>";
					str += "	<td><span> "+list[i].contact+" </span></td>";
					str += "	<td><span> "+list[i].notice_date+" </span></td>";
					str += "	<td><span> "+list[i].modify_date+" </span></td>";
					str += "	<td><span> "+list[i].repair_date+" </span></td>";
					str += "	<td style='text-align: center;'><span> "+list[i].progress_name+" </span></td>";	
					btnFn = "getRepairDetail(\""+list[i].repair_no+"\", \"Process\" )";
					if(list[i].progress_status == "01") {
						btnClass = "btn_orange";
						btnText = "작업지시";
					}
					else if(list[i].progress_status == "02" || list[i].progress_status == "03") {
						btnClass = "btn_red";
						btnText = "작업지시취소";
						btnFn = "updateRepairCancel(\""+list[i].repair_no+"\")";
					}
					else if(list[i].progress_status == "04" || list[i].progress_status == "05") {
						btnClass = "btn_blue02";
						btnText = "재작업지시";
					}
					btnStr = "<span><a href='javascript:"+btnFn+"' class='"+btnClass+"'>"+btnText+"</a></span>";
					
					str += "	<td style='text-align: center;'> "+btnStr+" </td>";
					if(list[i].progress_status == "04") {
						btnStr1 = "<span><a onclick=\"modal_popup4('messagePop4');return false;\" class='"+btnClass+"'>수리내역</a></span>";						
					}
					else {
						btnStr1 = "";
					}
					str += "	<td style='text-align: center;'> "+btnStr1+" </td>"; //					
					if(list[i].progress_status == "04") {
						btnStr2 = "<span><a onclick=\"modal_popup4('messagePop4');return false;\" class='"+btnClass+"'>사진대지</a></span>";					
					}
					else {
						btnStr2 = "";
					}
					str += "	<td style='text-align: center;'> "+btnStr2+" </td>"; //					
					str += "</tr>";
				}
			}
			else {
				str += "<tr>";
				str += "	<td colspan='12' style='text-align: center;'>등록된 글이 존재하지 않습니다.</td>";
				str += "</tr>";
			}
			
			$("#tbody").html(str);
			$("#toptxt .black03").text("총개수: "+totalCount+"개");
			$("#pagination").html(pagination);
		}
	}
	
	function getProcessPopup(obj) {
		var data = obj.resultData;
		
		if(data != null){
			for(var key in data){
				$("#"+key).val(data[key]);
			}

			slightDetailForm.repair_no.value = data['repair_no'];
			slightDetailForm.lightNo.value = data['light_no'];
			slightDetailForm.repair_date.value = data['repair_date'];
			
			$("#searchYear").trigger("change");
		}
		
		modalPopupCallback( function() {
			modal_popup4('messagePop4');
		});
	}
	
	function getRepairDetail(repairNo, flag) {
		
		$.ajax({
			type : "POST"			
			, url : "/repair/getSystemRepairDetail"
			, data : {"repairNo":repairNo}
			, dataType : "JSON"
			, success : function(obj) {
				if(flag == "Detail") {
					getDetailSearchCallback(obj);
				}
				else if(flag=="Process"){
					getProcessPopup(obj);
				}
			}
			, error : function(xhr, status, error) {
			}
		});
	}
	
	function getDetailSearchCallback(obj) {
		var data = obj.resultData;
		
		if(data != null) {
			var key, element, repairRst = "";
			var repairList = {};
			for(key in data) {
				//alert("key : "+key +"      data : "+ data);
				element = "det_"+key;
				if($("#"+element).length > 0) {
					$("#"+element).text(data[key]);
				}
				
				if($("#"+key).length > 0) {
					$("#"+key).val(data[key]);
				}
				
				if(key == "progress_status") {
					var cnt = 0;
					for(var i=0; i<$(".pop_detail2").children("div").size(); i++) {
						if($(".pop_detail2").children("div").eq(i).attr("id") == "board_view") {
							if(2 == ++cnt) {
								if(data[key] == "01") {
									$(".pop_detail2").children("div").eq(i).hide();
								}
								else {
									$(".pop_detail2").children("div").eq(i).show();
								}
							}
						}
					}
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
					str1 += "<button class='btn black ml10 mr5' style='padding:3px 5px 6px 5px;' onclick='javascript:setDeleteFile(\""+$("#repair_no").val()+"\", "+downLoadFiles[i].file_no+", this,1)' /></div>";
				}
				
				if($("#photo2").val() == downLoadFiles[i].file_no) {
					str2 = "<div><a href=/board/fileDownload?fileNameKey="+encodeURI( downLoadFiles[i].file_name_key) + "&fileName=" + encodeURI(downLoadFiles[i].file_name) + "&filePath="+encodeURI(downLoadFiles[i].file_path)+">"+ downLoadFiles[i].file_name +"</a>";
					str2 += "<input type='hidden' id='file_no_2' name='file_no_2' value='"+downLoadFiles[i].file_no+"'>";
					str2 += "<button class='btn black ml10 mr5' style='padding:3px 5px 6px 5px;' onclick='javascript:setDeleteFile(\""+$("#repair_no").val()+"\", "+downLoadFiles[i].file_no+", this,2)' /></div>";
				}
				
				if($("#photo3").val() == downLoadFiles[i].file_no) {
					str3 = "<div><a href=/board/fileDownload?fileNameKey="+encodeURI( downLoadFiles[i].file_name_key) + "&fileName=" + encodeURI(downLoadFiles[i].file_name) + "&filePath="+encodeURI(downLoadFiles[i].file_path)+">"+ downLoadFiles[i].file_name +"</a>";
					str3 += "<input type='hidden' id='file_no_3' name='file_no_3' value='"+downLoadFiles[i].file_no+"'>";
					str3 += "<button class='btn black ml10 mr5' style='padding:3px 5px 6px 5px;' onclick='javascript:setDeleteFile(\""+$("#repair_no").val()+"\", "+downLoadFiles[i].file_no+", this,3)' /></div>";
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
			
			$("#detail_slight").find("img").eq(0).parent().append(str1);
			$("#detail_slight").find("img").eq(1).parent().append(str2);
			$("#detail_slight").find("img").eq(2).parent().append(str3);
		}
		else {
			str1 = "<input type='file' id='files[1]' name='files' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'>";
			str2 = "<input type='file' id='files[2]' name='files' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'>";
			str3 = "<input type='file' id='files[3]' name='files' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'>";
			for(i = 0; i<$("#detail_slight").find("img").size(); i++) {
				$("#detail_slight").find("img").eq(i).parent().find("div").empty();
				$("#detail_slight").find("img").eq(i).attr("src", "/resources/css/images/sub/slight_noimg.gif");
				$("#detail_slight").find("img").eq(i).parent().append("<div><input type='file' id='files["+(i+1)+"]' name='files' accept='image/gif, image/jpeg, image/png' onchange='javascript:fnFile(this)'></div>");
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
					selectTag += "<span class=''><input type='text' id='part_cnt_"+i+"' name='part_cnt_"+i+"' class='tbox10' placeholder='0' value='"+materiaUsedList[i].inout_cnt+"'>개</span></p>";
					
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
					selectTag += "<span class=''><input type='text' id='part_cnt_"+materiaUsedList.length+"' name='part_cnt_"+materiaUsedList.length+"' class='tbox10' placeholder='0'>개</span></p>";
				
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
				selectTag += "<span class=''><input type='text' id='part_cnt_0' name='part_cnt_0' class='tbox10' placeholder='0'>개</span></p>";
			
				$("#tdPartCd").append(messageTag+selectTag);
			}
		}
		
		modalPopupCallback( function() {
			modal_popup2('messagePop2');
		});
					
	}
	
	function modalPopupCallback(fnNm) {
		fnNm();
	}
	
	function goGisMap(lightNo) {
		var frm = document.frm;
		
		frm.searchLightNo.value = lightNo;
		frm.action =  "${contextPath}/common/map/mapContentDaum2";
		frm.target = 'mapContentDaum';
		frm.submit();
		
		modal_popup3("messagePop3");
	}
	
	function goToTrbList(lightNo, light_type, address, hj_dong_cd) {
		$("#light_no").val(lightNo);
		$("#lightType").val(light_type);
		$("#address").val(address);
		$("#hj_dong_cd").val(hj_dong_cd);
		$("#slightForm").attr({action:'/trouble/trblReportList'}).submit();
		
	}
	
	function excelAllDownload() {
		var currentRow = $("#board_list_AllExcel > table > thead> tr > th").length;
		var headerArr = new Array();
		
		for(i=0; i<currentRow; i++) {
			headerArr.push($("#board_list_AllExcel > table > thead> tr").find("th:eq("+i+")").text());
		}
		
		var f = document.slightForm;
		f.method = "POST";
		f.action = "${contextPath}/repair/downloadExcel";
		f.excelHeader.value = headerArr;
		f.submit();
	}

	function excelAllDownload1() {
		var currentRow = $("#board_list > table > thead> tr > th").length;
		var headerArr = new Array();
		
		for(i=0; i<currentRow; i++) {
			headerArr.push($("#board_list > table > thead> tr").find("th:eq("+i+")").text());
		}
		
		var f = document.slightForm;
		f.method = "POST";
		f.action = "${contextPath}/repair/downloadExcel";
		f.excelHeader.value = headerArr;
		f.submit();
	}	
	
	function saveProcess() {
		if($("#searchCom1").val() == "" || $("#searchCom1").val() == null) {
			alert("업체를 선택하세요.");
			return;
		}
		
		var yn = confirm("작업지시를 하시겠습니까?");
		if(yn){
			
			$.ajax({
				type : "POST"			
				, url : "/repair/updateRepair"
				, data : $("#slightDetailForm").serialize()
				, dataType : "JSON"
				, success : function(obj) {
					if(obj != null) {
						if(obj.resultCnt > -1) {
							alert("작업지시가 완료되었습니다.");
							$('.modal-popup2 .bg').trigger("click");
							Search(); // goToList();
						}
						else {
							alert("오류가 발생했습니다.");	
							return;
						}
					}
				}
				, error : function(xhr, status, error) {
					
				}
			});			
			
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
				url : "/repair/updateRepairDatail"
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
										removeIdx.push(parseInt(idx)-1);
										removeIdx.push(parseInt(idx));
										partCdArr.push($("#part_cd_"+partCdIdx).val());
										partCntArr.push(parseInt(data[idx].value));
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
					updateRepairCallback(obj);
				}
				, error 	: function(xhr, status, error) {}
			}).submit();
			
		}
	}
	
	function updateRepairCallback(obj) {
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("작업지시가 완료되었습니다.");
				$('.modal-popup2 .bg').trigger("click");
				Search(); // goToList();
			}
			else {
				alert("오류가 발생했습니다.");	
				return;
			}
		}
	}

	function updateRepairCancel(repairNo){

		var yn = confirm("작업지시 취소를 하시겠습니까?");
		if(yn) {
			
			$.ajax({
				type : "POST"			
				, url : "/repair/updateRepairCancel"
				, data : {"repairNo":repairNo}
				, dataType : "JSON"
				, success : function(obj) {
					updateRepairCancelCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});						
		}			
	}
	
	function updateRepairCancelCallback(obj){
		
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("작업지시 취소가 완료되었습니다.");
				Search(); // goToList();
			}
			else {
				alert("오류가 발생했습니다.");	
				return;
			}
		}
		
	}
	
	function goToList() {
		var frm = document.slightForm;
		frm.action = '/repair/getSystemRepairList';
		frm.method ="post";
		frm.submit();
		//$("#slightForm").attr({action:'/equipment/securityLight'}).submit();
	}	
	
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
				selectTag += "<span class=''><input type='text' id='part_cnt_"+idx+"' name='part_cnt_"+idx+"' class='tbox10' placeholder='0'>개</span></p>";
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
	}
	
	function setDeleteFile(boardSeq, fileSeq, element,Seq) {
		var deleteFile = $("#delete_file").val();
		if(deleteFile != null && deleteFile != "") {
			deleteFile += "|"+boardSeq.trim()+"!"+fileSeq;
		}
		else {
			deleteFile += boardSeq.trim()+"!"+fileSeq;
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

		//var fileCnt = $("input[name=files]").length;
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
</script>
<div id="container">
	<!-- local_nav -->
	<div id="local_nav_area">
		<div id="local_nav">
			<ul class="smenu">
				<li><a href="#" ><img src="/resources/css/images/sub/icon_home.png" alt="HOME" /></a></li>
				<li><a href="#" >보수이력관리 <img src="/resources/css/images/sub/icon_down.png"/></a>
					<ul>
						<li><a href="/trouble/trblReportList">고장신고</a></li>
						<li><a href="/complaint/complaintList" >민원처리결과조회</a></li>
						<li><a href="/equipment/securityLightList" >기본정보관리</a></li>
						<li><a href="/repair/systemRepairList">보수이력관리</a></li>
						<li><a href="#" >보수내역관리</a></li>
						<li><a href="#">이용안내</a></li>
					</ul>
				</li>
				<li><a href="#">철거현황</a>
					<ul>
						<li><a href="/repair/systemRepairList">보수이력관리</a></li>
						<li><a href="/repair/systemRepairList2" >신설현황</a></li>
						<li><a href="/repair/systemRepairList3">이설현황</a></li>
						<li><a href="/repair/systemRepairList4" >철거현황</a></li>
						<li><a href="/repair/systemMaterialList">자재관리</a></li>
						<li><a href="#" >자재입/출고관리</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="sub">
		<div id="sub_title"><h3>보수이력관리</h3></div>
		<!-- 검색박스 -->
		<form id="slightForm" name="slightForm" method="post" action="">
			<input type="hidden" id="excelHeader" name="excelHeader" value="" />
			<input type="hidden" id="function_name" name="function_name" value="Search" />
			<input type="hidden" id="current_page_no" name="current_page_no" value="1" />
			<div id="search_box">
				<ul>
					<li class="title">등록일</li>
					<li>
						<input type="text" id="sDate" name="sDate" class="tbox02">
						~ 
						<input type="text" id="eDate" name="eDate" class="tbox02">
					</li>
					<!--<li class="pdl10">
						<select class="sel01" id="light_gubun" name="light_gubun">
						</select>
					</li>-->
					<li class="pdl10">
						<select class="sel01" id="repair_cd" name="repair_cd">						
						</select>
					</li>
					<li>
						<select class="sel01" id="searchType" name="searchType">
							<option selected value="">전체</option>
							<option value="1">신고인</option>
							<option value="2">주소</option>
							<option value="3">새주소</option>							
							<option value="4">관리번호</option>
							<option value="5">시공업체</option>
						</select>
					</li>
					<!-- <li>
						<select class="sel01">
							<option selected>검색조건</option>
							<option>관리번호</option>
							<option>이메일주소</option>
						</select>
					</li> -->
					<li><input type="text" name="keyword" id="keyword" class="tbox03_gray" readonly="readonly"></li>
					<li><!-- 시공업체 선택시 사용  -->
						<select id="searchCom" name="searchCom" class="sel01">
							<c:forEach items="${searchComInfo}" var="cominfo">
								<option value="">선택</option>							
								<option value="${cominfo.member_id }">${cominfo.com_name }</option>
							</c:forEach>
						</select>
					</li>					
					<li><a href="javascript:Search()"  class="btn_search01">검 색</a></li>
				</ul>
			</div>
		</form>
		<div id="toptxt">
			<ul>
				<li><span class="black03">총개수: 0개</span></li>
				<li class="b_right"><span ><a href="javascript:excelAllDownload1()" class="btn_gray03">전체수리내역</a></span></li>
			</ul>
		</div>
		
		<div id="board_list">
			<table summary="보수이력관리목록" cellpadding="0" cellspacing="0">
				<caption>접수번호,민원종류,관리번호,신고인,전화번호,접수일,지시일,보수일,처리상황,작업지시,수리내역,사진대지</caption>
				<colgroup>
					<col width="9%">
					<col width="10%">
					<col width="9%">
					<col width="8%">
					<col width="9%">
					<col width="8%">
					<col width="8%">
					<col width="8%">
					<col width="7%">
					<col width="8%">
					<col width="8%">
					<col width="8%">										
				</colgroup>
				<thead>
					<tr>
						<th>접수번호</th>
						<th>민원종류</th>
						<th>관리번호</th>
						<th>신고인</th>
						<th>전화번호</th>
						<th>접수일</th>
						<th>지시일</th>
						<th>보수일</th>
						<th>처리상황</th>
						<th>작업지시</th>
						<th>수리내역</th>
						<th>사진대지</th>						
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

<!-- 보수이력관리 전체수리내역 엑셀 -->
<div id="board_list_AllExcel" style="display: none;">
	<table summary="보수이력관리 전체수리내역 엑셀" cellpadding="0" cellspacing="0">
		<caption>접수번호,민원종류,관리번호,신고인,지번주소,도로명주소,전화번호,접수일,지시일,보수일,고장상태,처리상황,시공업체,수리내역</caption>
		<colgroup>
			<col width="7%">
			<col width="7%">
			<col width="7%">
			<col width="7%">
			<col width="8%">
			<col width="8%">			
			<col width="7%">					
			<col width="7%">
			<col width="7%">
			<col width="7%">			
			<col width="7%">
			<col width="7%">
			<col width="7%">
			<col width="7%">										
		</colgroup>
		<thead>
			<tr>
				<th>접수번호</th>
				<th>민원종류</th>
				<th>관리번호</th>
				<th>신고인</th>
				<th>지번주소</th>
				<th>도로명주소</th>				
				<th>전화번호</th>
				<th>접수일</th>
				<th>지시일</th>
				<th>보수일</th>
				<th>고장상태</th>				
				<th>처리상황</th>
				<th>시공업체</th> 
				<th>수리내역</th>
			</tr>
		</thead>
		<tbody id="tbody">
		</tbody>
	</table>
</div>

<!-- 작업지시 -->
<form id="slightDetailForm" name="slightDetailForm" method="post" action="">
	<div class="modal-popup4">
		<div class="bg"></div>
		<div id="messagePop4" class="pop-layer3">
			<div class="pop-container">
				<div class="pop-conts">
					<div class="btn-r">
						<a href="#" class="cbtn"><i class="fa fa-times " aria-hidden="true"></i><span class="hide">Close</span></a>
					</div>
					<div class="pop_system ">
						<div id="board_view3">
							<h3>보수이력관리 작업지시</h3>
								<input type="hidden" id="saveFlag" name="saveFlag" value="">
								<input type="hidden" name="repair_no" id="repair_no" value="">
								<input type="hidden" name="lightNo" name="lightNo" value="">
								<input type="hidden" name="repair_date" id="repair_date" value="">
								<!--결과조회 상세 Popup-->
								<input type="hidden" id="delete_file" name="delete_file" value=""/><!-- 삭제할 파일 -->
								<input type="hidden" id="photo1" name="photo1" >
								<input type="hidden" id="photo2" name="photo2" >
								<input type="hidden" id="photo3" name="photo3" >
								<input type="hidden" id="company_id" name="company_id">
								<!-- 텍스트컬러- 고장신고-blue 고장상태-red -->
								<table summary="보수이력관리 작업지시" cellpadding="0" cellspacing="0">
									<colgroup>
										<col width="14%">
										<col width="36%">
										<col width="14%">
										<col width="36%">
									</colgroup>
									<tbody>
										<tr>
											<th>업체</th>
											<td colspan="3"><span class="">
											<select id ="searchYear" name="searchYear" class="sel01">
											<c:forEach items="${searchYearList}" var="year">
												<option value="${year }">${year }년</option>
											</c:forEach>
											</select>
											<select id="searchCom1" name="searchCom1" class="sel01">
											</select>
											</span></td>
										</tr>
										<tr>
											<th>작업지시사항</th>
											<td colspan="3">
												<span><input type="text" name="remark_etc" id="remark_etc" class="tbox07_gray"></span>
												<span><a href="javascript:saveProcess()" class="btn_gray04">지시 </a></span>											
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
	<!--//작업지시 -->

	<!--결과조회 상세 Popup-->
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
										<td><span id="det_repair_date"></span></td>
										<th>작업지시일</th>
										<td><span id="det_modify_date"></span></td>
									</tr>
									<tr>
										<th>보 수 일</th>
										<td><span id="det_last_update"></span></td>
										<th>처리상황</th>
										<td><span id="det_remark"></span></td>
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
										<td>
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
												<span class=""><input type="text" id="part_cnt_0" name="part_cnt_0" class="tbox10" placeholder="0">개</span>
											</p>
										</td>
									</tr>
									<tr>
										<th>보수내역</th>
										<td>
											<input type="text" id="repair_desc" name="repair_desc" class="tbox06">
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
						<iframe id="mapContentDaum" name="mapContentDaum" scrolling="no" style="width: 100%; height: 100%;" class="p_map"></iframe>
						<form name="frm" id="frm" method="post">
							<input type="hidden" id="searchLightNo" name="searchLightNo">
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--//고장신고 지도 Popup-->
