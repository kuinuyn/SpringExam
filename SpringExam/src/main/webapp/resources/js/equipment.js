
function searchArea(code) {
		$("#searchArea").val(code);
		drawCodeData(commonCd, "06", "", "ALL", code).then(function(resolvedData) {
			$("#tagInsert").empty();
			$("#tagInsert").html(resolvedData);
		})
		.then(function() {
			Search();
		});
	}
	
	function Search(currentPageNo) {
		if(currentPageNo === undefined){
			currentPageNo = "1";
		}
		
		$("#current_page_no").val(currentPageNo);
		
		var searchType = $("#searchType").val();
		if(searchType == 4) {
			if($("#stand_cd").val() == "" || $("#stand_cd").val() == null) {
				$("#stand_cd").focus();
				alert("검색조건을 선택하세요.");
				return;
			}
		}
		if(searchType == 5) {
			if($("#lamp2_cd").val() == "" || $("#lamp2_cd").val() == null) {
				$("#lamp2_cd").focus();
				alert("검색조건을 선택하세요.");
				return;
			}
		}
		if(searchType == 6) {
			if($("#lamp3_cd").val() == "" || $("#lamp3_cd").val() == null) {
				$("#lamp3_cd").focus();
				alert("검색조건을 선택하세요.");
				return;
			}
		}
		
		$.ajax({
			type : "POST"			
			, url : "/equipment/getEquipmentList"
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
					str += "	<td><span><a href='javascript:goGisMap(\""+list[i].light_no+"\", \""+list[i].map_x_pos_gl+"\", \""+list[i].map_y_pos_gl+"\")'>"+list[i].light_no+"</a></span></td>";
					str += "	<td><span><a href='javascript:getEquipmentDetail(\""+list[i].light_no+"\")'>"+((list[i].address.trim()=="" || list[i].address == null)?"":list[i].address)+"</a></span></td>";
					str += "	<td><span><a href='javascript:getEquipmentDetail(\""+list[i].light_no+"\")'>"+list[i].new_address+"</a></span></td>";
					str += "	<td><span>"+list[i].stand_nm+"</span> </td>";
					str += "	<td><span>"+list[i].lamp2_nm+"</span> </td>";
					str += "	<td><span>"+list[i].lamp3_nm+"</span> </td>";
					str += "	<td><span>"+list[i].kepco_cust_no+"</span> </td>";
					str += "	<td><span><a href='javascript:excelDownload(\""+list[i].light_no+"\")' class='btn_more'>수리내역</a></span> </td>";
					str += "</tr>";
				}
			}
			else {
				str += "<tr>";
				str += "	<td colspan='8'><span>등록된 글이 존재하지 않습니다.</span></td>";
				str += "</tr>";
			}
			
			$("#tbody").html(str);
			$("#toptxt .black03").text("총개수: "+totalCount+"개");
			$("#pagination").html(pagination);
		}
	}
	
	function getEquipmentDetail(lightNo) {
		$.ajax({
			type : "POST"			
			, url : "/equipment/equipmentDet"
			, data : {"light_no" : lightNo, "light_type" : $("#lightType").val()}
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
				element = "det_"+key;
				if($("#"+element).length > 0) {
					$("#"+element).text(data[key]);
				}
				if($("#"+key).length > 0) {
					$("#"+key).val(data[key]);
				}
				
				$("#hj_dong_cd").val($("#searchArea").val())
			}
			
			var frm = document.frmDet;
			frm.action =  "/common/map/mapContentDaum2?searchLightNo="+data['light_no']+"&center_x="+data['map_x_pos_gl']+"&center_y="+data['map_y_pos_gl'];
			frm.target = 'mapDet';
			frm.submit();
			
			if(data['downLoadFiles'] != null && data['downLoadFiles'] != "") {
				var downLoadFiles = data['downLoadFiles'];
				var filePah = "";
				
				for(i = 0; i<downLoadFiles.length; i++) {
					filePah = "/display?name="+downLoadFiles[i].file_name_key;
					$("#detail_slight").children().eq(i).children("img").attr("src", filePah)
				}
			}
			else {
				
				for(i = 0; i<$("#detail_slight").children().size(); i++) {
					$("#detail_slight").children().eq(i).children("img").attr("src", "/resources/css/images/sub/slight_noimg.gif");
				}
			}
			
			if(data['detRepirList'] != null && data['detRepirList'] != "") {
				repairList = data['detRepirList'];
				repairRst = "<tr>";
				for(i=0; i<repairList.length; i++) {
					repairRst += "<td><span>"+repairList[i].repair_no+"</span></td>";
					repairRst += "<td><span>"+repairList[i].repair_date+"</span></td>";
					repairRst += "<td><span>"+repairList[i].trouble_type_nm+"</span></td>";
					repairRst += "<td><span>"+repairList[i].repair_desc+"</span></td>";
					repairRst += "<td><span>"+repairList[i].progress_name+"</span></td>";
				}
				repairRst += "</tr>";
				
			}
			else {
				repairRst = "<tr>";
				repairRst += "<td colspan='5'><span>보수이력이 없습니다.</span></td>";
				repairRst += "</tr>";
			}
			$("#repair_list").html(repairRst);
			
			modalPopupCallback( function() {
				modal_popup2('messagePop2');
			});
		}
		
	}
	
	function modalPopupCallback(fnNm) {
		fnNm();
	}
	
	function deleteEquipment() {
		var yn = confirm("기본 정보를 삭제 하시겠습니까?");
		
		if(yn){
			$.ajax({
				type : "POST"			
				, url : "/equipment/deleteEquipment"
				, data : {"light_no" : $("#det_light_no").text(), "light_type" : $("#lightType").val()}
				, dataType : "JSON"
				, success : function(obj) {
					deleteEquipmentCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});
		}
	}
	
	function deleteEquipmentCallback(obj) {
		if(obj != null) {
			if(obj.resultCnt > -1) {
				alert("삭제를 성공하였습니다.");
				$('.modal-popup2 .bg').trigger("click");
				Search();
			}
			else {
				alert("삭제를 실패하였습니다.");	
				return;
			}
		}
	}
	
	function goGisMap(light_no, center_x, center_y) {
		var width, height;
		width = parseInt(document.body.scrollWidth);
		height = parseInt(document.body.scrollHeight);
		
		var frm = document.frm;
		frm.searchLightNo.value = light_no;
		frm.center_x.value = center_x;
		frm.center_y.value = center_y;
		frm.action =  "/common/map/mapContentDaum2";
		frm.target = 'mapContentDaum';
		frm.submit();
		
		modal_popup3("messagePop3");
		
		/* var url = "/common/map/mapContentDaum2?center_x="+center_x+"&center_y="+center_y;
		var oriAction = $("#slightForm").attr("action");
		detailPrintPopup = window.open("", "mapContentDaum2", "left=250, top=20, width=850, height=750, menubar=no, location=no, status=no, scrollbars=yes");
		$("#slightForm").attr("action", url);
		$("#slightForm").attr("target", "mapContentDaum2");
		$("#slightForm").attr("method", "post");
		$("#slightForm").submit();
		$("#slightForm").attr("target", "");
		$("#slightForm").attr("action", oriAction); */
	}
	
	function goToMod() {
		var url = "";
		
		if($("#lightType").val() == "1") {
			url = "/equipment/securityLightMod";
		}
		else if($("#lightType").val() == "2") {
			url = "/equipment/streetLightMod";
		}
		else if($("#lightType").val() == "3") {
			url = "/equipment/distributionBoxMod";
		}
		var frm = document.slightForm;
		frm.action = url;
		frm.method ="post";
		frm.submit();
	};
	
	function goToTrbList(lightNo, light_type, address, hj_dong_cd) {
		$("#light_no").val(lightNo);
		$("#lightType").val(light_type);
		$("#address").val(address);
		$("#hj_dong_cd").val(hj_dong_cd);
		$("#slightForm").attr({action:'/trouble/trblReportList'}).submit();
	}
	
	function excelDownload(light_no) {
		var headerArr = ['접수번호', '보수일자', '고장상태', '보수내역', '진행상태'];
		
		var f = document.slightForm;
		f.method = "POST";
		f.action = "/equipment/downloadExcel";
		f.light_no.value = light_no;
		f.excelHeader.value = headerArr;
		f.submit();
	}