<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	var commonCd = ${MAXRESULT};
	var frm;
	var httpRequest = null;
	
	function onLeftMenu() {
		frm = document.equipmentForm;
		//onTab("2");
		initTag();
	}
	
	function initTag() {
		var target = document.getElementById('searchDong');
		var target_new = document.getElementById('searchDong_new');
		var option = "";
		var option_new = "";
		var listCnt = commonCd.length;
		
		if(listCnt > 0) {
			while(target.hasChildNodes()) {
				target.removeChild(target.firstChild);
			}
			
			while(target_new.hasChildNodes()) {
				target_new.removeChild(target_new.firstChild);
			}
			
			option = document.createElement("option");
			option.text = "선택";
			option.value = "";
			option_new = document.createElement("option");
			option_new.text = "선택";
			option_new.value = "";
			target.appendChild(option, target.lastChild);
			target_new.appendChild(option_new, target_new.lastChild);
			
			for(i=0; i<listCnt; i++) {
				if(commonCd[i].code_type == "06") {
					option = document.createElement("option");
					option.value = commonCd[i].data_code;
					option.text = commonCd[i].data_code_name;
					option_new = document.createElement("option");
					option_new.value = commonCd[i].data_code;
					option_new.text = commonCd[i].data_code_name;
					
					target.appendChild(option, target.lastChild);
					target_new.appendChild(option_new, target_new.lastChild);
				}
			}
		}
	}
	
	function onSearch(searchGubun) {
		var dongCode = "";
		var dongName = "";
		var keyword = "";
		var lightGn = "";
		var keytype = 1;
		if(searchGubun == "") {
			dongCode = frm.searchDong.value;
			dongName = frm.searchDong.options[frm.searchDong.selectedIndex].text;
			keyword = frm.keyword.value;
			lightGn = frm.lightGn.value;
		}
		else if(searchGubun == "light_no") {
			keyword = frm.keyword_no.value;
		}
		else {
			dongCode = frm.searchDong_new.value;
			dongName = frm.searchDong_new.options[frm.searchDong_new.selectedIndex].text;
			keyword = frm.keyword_new.value;
			lightGn = frm.lightGn_new.value;
		}
		var url = "";
		var formData = new FormData();
		
		if(dongCode == "" && keyword == "" && searchGubun != "light_no") {
			alert("세부주소를 입력해 주세요.");
			return;
		}
		else {
			if(searchGubun == "light_no") {
				if(keyword == "") {
					alert("검색어를 입력해 주세요.");
					return;
				}
				
				keytype = 2;
			}
			
			formData.append("keytype", keytype);
			formData.append("searchGubun", searchGubun);
			formData.append("area", dongCode);
			formData.append("dongNm", dongName);
			formData.append("keyword", keyword);
			formData.append("lightGn", lightGn);
			
			url = "/common/map/mapDataKakao";

			//주소 검색시 영역 표시
			var searchVal = "경상북도 구미시 "+dongName;

			if(searchVal){
				searchVal += " "+keyword;
			}else{
				searchVal = keyword;
			}
			searchAddress(searchVal);
		}
		
		resArrd = "<ul>";
		resArrd += "<li> - 처 리 중 - </li>";
		resArrd += "</ul>";
		
		if(searchGubun == "") {
			document.getElementById("resultAddr").innerHTML = resArrd;
		}
		else if(searchGubun == "light_no") {
			document.getElementById("resultAddr_no").innerHTML = resArrd;
		}
		else {
			document.getElementById("resultAddr_new").innerHTML = resArrd;
		}
		
		httpRequest = getXMLHttpRequest(); // xmlhttp 객체를 생성      
		httpRequest.open("POST", url, true);  // GET방식으로 동기식으로호출
		httpRequest.onreadystatechange = function(){searchDongHttpResponse(searchGubun);};
		httpRequest.send(formData);  // 호출
	}
	
	function searchDongHttpResponse(searchGubun) { // 호출 완료후 콜백함수정의
		if (httpRequest.readyState == 4) {
			if (httpRequest.status == 200) { // 잘넘어왔음
				arrList = new Array();
				var resArrd = "";
				var dataSet = JSON.parse(httpRequest.responseText);
				var arrListVal;
				
				if(dataSet.returnMsg != false) {
					dataSet = eval(dataSet.returnMsg.split("^"));

					for(var i = 0;i < dataSet.size(); i++) {
						var dataList = dataSet[i].split("|");
						arrList[i] = new Array(dataList.size());
						for(var j = 0;j < dataList.size(); j++) {
							arrList[i][j] = toTrim(dataList[j]);
						}						
					}				
					
					resArrd = "<ul>";
					if(arrList[0][1] != "" && arrList[0][1] != undefined) {			
						for(var k = 0;k < arrList.size(); k++) {
							if(arrList[k][3] != "" && arrList[k][3] != undefined && arrList[k][4] != "" && arrList[k][4] != undefined) {						
								if(searchGubun == "new") arrListVal = 8;
								else arrListVal = 2;
								
								resArrd += "<li style=\"text-align:left;\"><a href=\"javascript:onBodyUrl('"+arrList[k][3]+"', '"+arrList[k][4]+"', '"+arrList[k][1]+"');\"  >["+[arrList[k][1]]+"]"+arrList[k][arrListVal]+"</a></li>";					
							}

						}
					} else {
						resArrd += "<li>검색결과가 없습니다.</li>";
					}
					
					resArrd += "</ul>";
				} else {
					resArrd = "<ul>";
					resArrd += "<li>검색결과가 없습니다.</li>";
					resArrd += "</ul>";
				}

				if(searchGubun == "") {
					document.getElementById("resultAddr").innerHTML = resArrd;
				}
				else if(searchGubun == "light_no") {
					document.getElementById("resultAddr_no").innerHTML = resArrd;
				}
				else {
					document.getElementById("resultAddr_new").innerHTML = resArrd;
				}
			} else {
				
				alert("실패: "+httpRequest.status); // 실패메시지
			}
		}
	}

	function onBodyUrl(xPos, yPos, searchLightNo) {	
		map_move(xPos, yPos, searchLightNo);
		onAjaxData(xPos, yPos, searchLightNo);
	}
	
	function openTab(evt, tabName) { 
		var i, tabcontent, tablinks; 
		var tab = document.getElementById("inner");
		var nodes = tab.childNodes;
		for(i=0; i<nodes.length; i++) {
			tabcontent = nodes.item(i); // 컨텐츠를 불러옵니다. 
			if (tabcontent.nodeType == 1) {
				tabcontent.style.display = "none";
			}
		}
		
		var btnTab = document.getElementById("btnTab");
		var tabNodes = btnTab.childNodes;
		for(i=0; i<tabNodes.length; i++) {
			tablinks = tabNodes.item(i); // 컨텐츠를 불러옵니다. 
			if (tablinks.nodeType == 1) {
				tablinks.className = tablinks.className.replace(" active", ""); //탭을 초기화시킵니다. 
			}
		}

		document.getElementById(tabName).style.display = "block"; //해당되는 컨텐츠만 보여줍니다. 
		evt.currentTarget.className += " active"; //클릭한 탭을 활성화시킵니다. 
	}

</script>
<style>
	.tab {
	  width: 100%;
	  height: 50px;
	}
	
	.tablinks {
	  float: left;
	  width: 50%;
	  height: 100%;
	  border: none;
	  outline: none;
	  font-size: 16px;
	  font-weight: bold;
	  color: #fff;
	  background-color: #a6a6a6;
	}
	
	.tablinks.active {
	  color: #000;
	  background-color: #fff;
	}
</style>
<div id="btnTab" class="tab">
  <button class="tablinks active" onclick="openTab(event, 'tab1')">탭1</button>
  <button class="tablinks" onclick="openTab(event, 'tab2')">탭2</button>
</div>
<div id="wrap" style="overflow:hidden;">
	<form id="equipmentForm" name="equipmentForm" method="post">
		<div id="inner" class="inner">
			<div class="tabcontent" id="tab1"  style="display: block;">
				<table>
					<tr>
						<td>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<table class="table02">
											<tbody id="tbody">
												<tr>
													<th colspan="2">지번</th>
												</tr>
												<tr>
													<th>등구분</th>
													<td>
														<select id="lightGn" name="lightGn">
															<option value="1">보안등</option>
															<option value="2">가로등</option>
														</select>
													</td>
												</tr>
												<tr>
													<th>동/면/읍</th>
													<td>
														<select id="searchDong" name="searchDong">
															<option value="">선택</option>
														</select>
													</td>
												</tr>
												<tr>
													<th>검색어</th>
													<td>
														<input type="text" id="keyword" name="keyword" style="width:80px;">
														<input type="button" value="검색" onclick="javascript:onSearch('')" />
													</td>
												</tr>
											</tbody>
										</table>
									</td>
								</tr>
								<tr>
									<th>검색결과</th>
								</tr>
								<tr>
									<td>
										<div id="resultAddr" style="overflow:auto;width:100%;height:150px;line-height:150%;">
											<ul>
												<li>검색결과가 없습니다.</li>
											</ul>
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<table class="table02">
											<tbody id="tbody">
												<tr>
													<th colspan="2">새주소</th>
												</tr>
												<tr>
													<th>등구분</th>
													<td>
														<select id="lightGn_new" name="lightGn_new">
															<option value="1">보안등</option>
															<option value="2">가로등</option>
														</select>
													</td>
												</tr>
												<tr>
													<th>동/면/읍</th>
													<td>
														<select id="searchDong_new" name="searchDong_new">
															<option value="">선택</option>
														</select>
													</td>
												</tr>
												<tr>
													<th>리</th>
													<td>
														<select id="bjDong_new" name="bjDong_new">
															<option value="">선택</option>
														</select>
													</td>
												</tr>
												<tr>
													<th>상세주소</th>
													<td>
														<input type="text" id="keyword_new" name="keyword_new" style="width:80px;">
														<input type="button" value="검색" onclick="javascript:onSearch('new')" />
													</td>
												</tr>
											</tbody>
										</table>
									</td>
								</tr>
								<tr>
									<th>검색결과</th>
								</tr>
								<tr>
									<td>
										<div id="resultAddr_new" style="overflow:auto;width:100%;height:150px;line-height:150%;">
											<ul>
												<li>검색결과가 없습니다.</li>
											</ul>
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div id="tab2" class="tabcontent" style="display: none;"> 
				<table>
					<tr>
						<td>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<table class="table02">
											<tbody id="tbody">
												<tr>
													<th colspan="2">관리번호</th>
												</tr>
												<tr>
													<th>검색어</th>
													<td>
														<input type="text" id="keyword_no" name="keyword_no" style="width:80px;">
														<input type="button" value="검색" onclick="javascript:onSearch('light_no')" />
													</td>
												</tr>
											</tbody>
										</table>
									</td>
								</tr>
								<tr>
									<th>검색결과</th>
								</tr>
								<tr>
									<td>
										<div id="resultAddr_no" style="overflow:auto;width:100%;height:300px;line-height:150%;">
											<ul>
												<li>검색결과가 없습니다.</li>
											</ul>
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</div>
