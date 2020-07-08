<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0" />
	<title>도로조명정보시스템</title>
	<%@ include file="/WEB-INF/include/include-mobile-header.jspf"%>

	<script type="text/javascript">
		$(document).ready(function (){
		});
		
		function searchMap() {
			var num = 0;
			var childNodes = $("#side_tab").find('li')
			
			for(var i=0; i<childNodes.size(); i++) {
				if(childNodes.eq(i).find('.tab_on').size() > 0) {
					num = i+1;
				}
			}
			
			var searchGubun = $("input[type=radio][name=searchGubun]:checked").val();
			
			if($("#keyword").val() == null || $("#keyword").val() == "") {
				alert("검색어를 입력하세요.");
				return;
			}
			
			$.ajax({
				type : "POST"			
				, url : "/common/map/mapMobileDataKakao"
				, data : {"keyword" : $("#keyword").val(), "keytype" : $("#keytype").val()}
				, dataType : "JSON"
				, success : function(obj) {
					getSearchMapCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});
		}
		
		function getSearchMapCallback(obj) {
			var state = obj.returnMsg;
			var dataSet = new Array();
			var arrList = new Array();
			var resArrd = "";
			var arrListVal = 2;
			
			if(state != false) {
				dataSet = state.split("^");
				var dataList = new Array();
				if(dataSet.length > 1) {
					var keyword = "경북 구미시 "+$("#keyword").val();
					var ifra = document.getElementById('mapContentDaum').contentWindow;
					ifra.searchDetailAddrSearch(keyword);
				}
				else {
					for(var i = 0;i < dataSet.length; i++) {
						dataList = dataSet[i].split("|");
						arrList[i] = new Array(dataList.length);
						
						for(var j = 0;j < dataList.length; j++) {
							arrList[i][j] = toTrim(dataList[j]);
						}
					}
					
					
					if(arrList[0][1] != "" && arrList[0][1] != undefined) {	
						if(arrList[0][3] != "" && arrList[0][3] != undefined && arrList[0][4] != "" && arrList[0][4] != undefined) {
							var ifra = document.getElementById('mapContentDaum').contentWindow; 
							
							ifra.map_move(arrList[0][3], arrList[0][4], $("#keyword").val());
							ifra.onAjaxData(arrList[0][3], arrList[0][4], $("#keyword").val());
						}
					}
					
				}
			}
			else {
				if($("#keytype").val() == "1") {
					var keyword = "경북 구미시 "+$("#keyword").val();
					var ifra = document.getElementById('mapContentDaum').contentWindow;
					ifra.searchDetailAddrSearch(keyword);
				}
				else {
					alert("검색결과가 없습니다.");
				}
			}
			
		}
		
		function goToTrbList(lightNo, light_type, address, hj_dong_cd, file_name) {
			$("#light_no").val(lightNo);
			$("#lightType").val(light_type);
			$("#address").val(address);
			$("#hj_dong_cd").val(hj_dong_cd);
			$("#file_name").val(file_name);
			$("#troubleForm").attr({action:'/mobile/trouble/troubleReport'}).submit();
		}
	</script>
</head>
<body>
	<!-- 고장신고 -->
	<form id="troubleForm" name="troubleForm" method="post" action="">
		<input type="hidden" id="light_no" name="light_no" value="">
		<input type="hidden" id="lightType" name="lightType" value="">
		<input type="hidden" id="address" name="address" value="">
		<input type="hidden" id="hj_dong_cd" name="hj_dong_cd" value="">
		<input type="hidden" id="file_name" name="file_name" value="">
	</form>
	<%@ include file="../sidebar.jsp" %>
	
	<!-- content -->
	<!-- List -->
	<section id="content">
	    <div id="mobileMap">
	        <h3 class="hide">고장신고</h3>
	        <iframe id="mapContentDaum" name="mapContentDaum" src="/common/map/mapMobileContentDaum" class="mapbg"></iframe>
	        <div id="searchbox">
				<ul>
					<li>
						<select id="keytype" name="keytype" class="select_s">
							<option value="2" selected>관리번호 </option>
							<option value="1">주소</option>
						</select>
					</li>
					<li><input type="text" id="keyword" name="keyword" class="stxtbox" placeholder="관리번호" ></li>
					<li><a href="javascript:searchMap()" class="sbtn"></a></li>
				</ul>
			</div>
	    </div>
	    
	</section>
	<!-- // List -->
	<!-- //content -->
</body>
</html>