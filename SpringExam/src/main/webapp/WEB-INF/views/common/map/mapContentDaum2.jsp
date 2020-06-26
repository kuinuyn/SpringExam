<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=c5a71e08bd2dc04d789a6dc8b64bcad2&libraries=services"></script>
<link rel="stylesheet" type="text/css" rel="stylesheet" href="/resources/css/map/map.css" />
<script type="text/javascript" src="${contextPath }/resources/js/prototype.js"></script>
<link rel="stylesheet" type="text/css" href="/resources/css/common/common.css" /> 
<link rel="stylesheet" type="text/css" href="/resources/css/common/sub.css" /> 

<style>
	#mapContainer {overflow:hidden;height:100%;position:relative;}
	#mapContainer.view_map #mapWrapper {z-index: 10;}
	#mapContainer.view_map #btnMap {display: none;}
	#mapContainer.view_roadview #mapWrapper {z-index: 0;}

	.label * {display: inline-block;vertical-align: top;}
	.label .left {background: url("//i1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_l.png") no-repeat;display: inline-block;height: 24px;overflow: hidden;vertical-align: top;width: 7px;}
	.label .center {background: url(//i1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_bg.png) repeat-x;display: inline-block;height: 24px;font-size: 12px;line-height: 24px;}
	.label .right {background: url("//i1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_r.png") -1px 0  no-repeat;display: inline-block;height: 24px;overflow: hidden;width: 6px;}

	#roadviewControl {position:absolute;top:38px;right:55px;width:38px;height:55px;z-index: 1;cursor: pointer;
	background: url(https://uljin.slight.co.kr/html/images/map/roadview.png) no-repeat; }
	#roadviewControl.active {background: url(https://uljin.slight.co.kr/html/images/map/roadview_r.png) no-repeat; }

	#close {position: absolute;padding: 4px;top: 5px;right: 100px;cursor: pointer;background: #fff;border-radius: 4px;border: 1px solid #c8c8c8;box-shadow: 0px 1px #888;}
	#close .img {display: block;background: url(//i1.daumcdn.net/localimg/localimages/07/mapapidoc/rv_close.png) no-repeat;width: 14px;height: 14px;}

	/* 인쇄버튼 추가를 위한 CSS 추가 */
	/* .radius_border{border:1px solid #919191;border-radius:5px;}
	.custom_typecontrol {position:absolute;top:7px;right:55px;overflow:hidden;width:148px;height:25px;margin:0;padding:0;font-size:12px;font-family:'Malgun Gothic', '맑은 고딕', sans-serif;}
	.custom_typecontrol span {display:block;width:43px;height:30px;float:left;text-align:center;line-height:22px;cursor:pointer;}
	.custom_typecontrol #btnSkyview {display:block;width:60px;height:30px;float:left;text-align:center;line-height:22px;cursor:pointer;}
	.custom_typecontrol .btn {background:#fff;}
	.custom_typecontrol .btn:hover {background:#f5f5f5;}
	.custom_typecontrol .btn:active {background:#e6e6e6;}
	.custom_typecontrol .selected_btn {color:#fff;background:#425470;}
	.custom_typecontrol .selected_btn:hover {color:#fff;} */
	
	.radius_border{border:1px solid #919191;border-radius:5px;}     
	.custom_typecontrol {position:absolute;top:7px;right:55px;overflow:hidden;height:25px;margin:0;padding:0;z-index:1;font-size:12px;font-family:'Malgun Gothic', '맑은 고딕', sans-serif;}
	.custom_typecontrol span {display:block;width:43px;height:30px;float:left;text-align:center;line-height:22px;cursor:pointer;}
	.custom_typecontrol .btn {background:#fff;background:linear-gradient(#fff,  #e6e6e6);}       
	.custom_typecontrol .btn:hover {background:#f5f5f5;background:linear-gradient(#f5f5f5,#e3e3e3);}
	.custom_typecontrol .btn:active {background:#e6e6e6;background:linear-gradient(#e6e6e6, #fff);}    
	.custom_typecontrol .selected_btn {color:#fff;background:#425470;background:linear-gradient(#425470, #5b6d8a);}
	.custom_typecontrol .selected_btn:hover {color:#fff;}   
	.custom_zoomcontrol {position:absolute;top:50px;right:10px;width:36px;height:80px;overflow:hidden;z-index:1;background-color:#f5f5f5;} 
	.custom_zoomcontrol span {display:block;width:36px;height:40px;text-align:center;cursor:pointer;}     
	.custom_zoomcontrol span img {width:15px;height:15px;padding:12px 0;border:none;}             
	.custom_zoomcontrol span:first-child{border-bottom:1px solid #bfbfbf;} 
</style>

<div id="mapContainer" class="view_map">
	<div id="mapWrapper" style="width:100%;height:100%;position:relative;">
		<div id="map" style="width:100%;height:100%;"></div> <!-- 지도를 표시할 div 입니다 -->
		<div class="custom_typecontrol radius_border">
			<span id="btnRoadmap" class="selected_btn" onclick="setMapType('roadmap')">지도</span>
			<span id="btnSkyview" class="btn" onclick="setMapType('skyview')">스카이뷰</span>
			<span id="btnPrint" class="btn" onclick="mapPrint()">인쇄</span>
		</div>
		<div id="roadviewControl" onclick="toggleMap()"></div>
	</div>

	<div id="rvWrapper" style="width:100%;height:100%;position:absolute;top:0;left:0;">
		<div id="roadview" style="height: 100%;"></div> <!-- 로드뷰를 표시할 div 입니다 -->
		<div id="close" title="로드뷰닫기" onclick="toggleMap1()"><span class="img"></span></div>
	</div>
</div>

<script type="text/javascript">
	var container;
	var mapWrapper;
	
	//로드뷰관련
	var btnMap; //지도에 로드뷰 표시
	var rvContainer; // 로드뷰 표시
	var rvClient;
	var road;
	
	//지도
	var mapContainer; // 지도 표시		
	var placePosition;
	var searchLightNo;
	
	//지도옵션(표시 위치 및 레벨)
	var options = {};
	
	var map = "";  //지도생성
	var roadview;
	
	var positions = new Array(); //마커정보입력
	var marker = new Array();  //마커 배열
	var customOverlay = new Array(); //인포윈도우 배열	
	var infowindow = new Array(); //인포윈도우 배열	
	var mark_chk;
	
	var drag_marker;
	var drag_markers = [];
	
	//ajax용	
	var httpRequest;
	var arrList;
	var info_window;
	
	//지도 확대축소 컨트롤러 보이기
	var zoomControl;
	var center; //지도 중심좌표
	var center_x;
	var center_y;
	var level;	  //지도 레벨	
	
	var img; //마커이미지 크기
	var imageSrc; //마커이미지 경로
	var imageSize; //마커 이미지 사이즈
	
	var iwRemoveable; //인포윈도우를 닫을 수 있는 x버튼이 표시		
	var mapCenter;  //추후수정
	var panoId;
	
	var markers;
	var marker2;	//주소검색시 찍힌 마커 관리
	var circle2;	//주소검색시 영역표시
	
	var geocoder = new kakao.maps.services.Geocoder(); //검색기능
	var defaultAddress = "";
	
	document.addEventListener("DOMContentLoaded", function(){
		onInit();
	});

	function infoWindowClose() {
		for(var i=0; i<infowindow.length; i++){
			if(infowindow[i]){
				infowindow[i].close();
			}
		}
	}
	
	function toggleMap() {
		var control = document.getElementById('roadviewControl');
	
		if (road=="road") {
			// 지도가 보이도록 지도와 로드뷰를 감싸고 있는 div의 class 변경
			map.removeOverlayMapTypeId(daum.maps.MapTypeId.ROADVIEW); //지도 위에 로드뷰 도로 없애기
			control.className = '';
			container.className = "view_map"
			road = "non_road";
		} else {
			map.addOverlayMapTypeId(daum.maps.MapTypeId.ROADVIEW); //지도 위에 로드뷰 도로 표시
			control.className = 'active';
			road = "road";
		}
	}
	
	//로드뷰 닫기
	function toggleMap1() {
		map.removeOverlayMapTypeId(daum.maps.MapTypeId.ROADVIEW); //지도 위에 로드뷰 도로 없애기
		map.addOverlayMapTypeId(daum.maps.MapTypeId.ROADVIEW); //지도 위에 로드뷰 도로 표시
		container.className = "view_map"
		road = "road";
	}
	
	// 지도타입 컨트롤의 지도 또는 스카이뷰 버튼을 클릭하면 호출되어 지도타입을 바꾸는 함수입니다
	function setMapType(maptype) { 
		var roadmapControl = document.getElementById('btnRoadmap');
		var skyviewControl = document.getElementById('btnSkyview'); 
		if (maptype == 'roadmap') {
			map.setMapTypeId(daum.maps.MapTypeId.ROADMAP);    
			roadmapControl.className = 'selected_btn';
			skyviewControl.className = 'btn';
		} else {
			map.setMapTypeId(daum.maps.MapTypeId.HYBRID);    
			skyviewControl.className = 'selected_btn';
			roadmapControl.className = 'btn';
		}
	}
	
	//leftMenu에서 사용
	function map_move(center_x, center_y, light_no) {
		var moveLatLon = new daum.maps.LatLng(center_x, center_y);
		map.panTo(moveLatLon);
		//onAjaxData(center_x, center_y, light_no);
	}
	
	//지도 인쇄
	function mapPrint(){
		//로드뷰인 경우 인쇄버튼 없으므로 hidden 처리 후 view
		document.getElementById("rvWrapper").style.visibility = "hidden";
		parent.mapContentDaum.focus();
		window.print();
		document.getElementById("rvWrapper").style.visibility = "visible";
	}
	
	function cl(a){
		mark_chk = "N";
		
		for(var i=0; i<infowindow.length; i++){
			if(infowindow[i]){
				infowindow[i].close();
			}
		}
		infowindow[a].open(map, marker[a]);  //윈도우 표시
	
		var latlng = positions[a].latlng;
		center_x = latlng.getLat();
		center_y = latlng.getLng();
		map_move(center_x, center_y, positions[a].light_no);
		
		callbackLeftMenu(a);
	}
	
	function callbackLeftMenu(a) {
		var parentFrame = parent.document.getElementById('gisMap');
		if(parentFrame != null) {
			parent.document.slightForm.light_type.value = positions[a].light_type;
			parent.document.slightForm.light_no.value = positions[a].light_no;
			parent.document.slightForm.hj_dong_cd.value = positions[a].hj_dong_cd;
			parent.document.slightForm.lamp2_cd.value = positions[a].lamp2_cd;
			parent.document.slightForm.lamp3_cd.value = positions[a].lamp3_cd;
			parent.document.slightForm.pole_no.value = positions[a].pole_no;
			parent.document.slightForm.kepco_cust_no.value = positions[a].kepco_cust_no;
			parent.document.slightForm.kepco_cd.value = positions[a].kepco_cd;
			parent.document.slightForm.mapPosX.value = center_x;
			parent.document.slightForm.mapPosY.value = center_y;
			parent.document.slightForm.address.value = positions[a].address;
			parent.document.slightForm.new_address.value = (positions[a].new_address != null && positions[a].new_address != "") ? positions[a].new_address : "";
			parent.document.slightForm.use_light.value = positions[a].use_light;
			parent.document.slightForm.flag.value = "U";
			parent.changeMapInfo();
			parent.chkEquipment();
		}
	}
	
	function onHideWindow(close_num){
		infowindow[close_num].close();
		info_window = "";
	}
	
	function onAddIcon(){
		mark_chk = "Y";
		drag_center = map.getCenter(); //지도 중심좌표
		drag_center_x = center.getLng();
		drag_center_y = center.getLat();
		drag_markerPosition = new daum.maps.LatLng(center_x, center_y); 

		setMarkers(null);  
		
		drag_marker = new daum.maps.Marker({
			position: drag_markerPosition //마커위치
		});

		drag_marker.setMap(map);
		
		drag_markers.push(drag_marker);
	}
	
	function setMarkers(map){
		for (var i = 0; i < drag_markers.length; i++) {
			drag_markers[i].setMap(map);
		}
	}

	function getMapInfo() {
		var mapInfo = new Array();
		var mapInfoCenter = map.getCenter();
		mapInfo[0] = mapInfoCenter.getLat();
		mapInfo[1] = mapInfoCenter.getLng();
		return mapInfo;	
	}

	function setVal(){
		var center_x = "${param.center_x}";
		var center_y = "${param.center_y}";
		
		if(center_x == null || center_x == "") {
			center_x = "36.11957798170278";
		}
		
		if(center_y == null || center_y == "") {
			center_y = "128.34425314675426";
		}
		
		mark_chk = "N";
		drag_marker = new Array();
		
		container = document.getElementById('mapContainer');
		mapWrapper = document.getElementById('mapWrapper');
	
		//로드뷰관련
		btnMap = document.getElementById('btnMap'); //지도에 로드뷰 표시
		rvContainer = document.getElementById('roadview'); // 로드뷰 표시
		rvClient = new daum.maps.RoadviewClient();
		road = "non_road";
	
		//지도
		mapContainer = document.getElementById('map'); // 지도 표시		
		//placePosition = new daum.maps.LatLng("${param.center_x}", "${param.center_y}");
		placePosition = new daum.maps.LatLng(center_x, center_y);
		searchLightNo = "${param.searchLightNo}";
		
		//지도옵션(표시 위치 및 레벨)
		options = {
			//center: new daum.maps.LatLng("${param.center_x}", "${param.center_y}"),
			center: new daum.maps.LatLng(center_x, center_y),
			level: 1
		};
	
		map = new daum.maps.Map(mapContainer, options);  //지도생성
		roadview = new daum.maps.Roadview(rvContainer);
	
		//ajax용	
		httpRequest = null; 	
		info_window = "";
	
		//지도 확대축소 컨트롤러 보이기
		zoomControl = new daum.maps.ZoomControl();
		map.addControl(zoomControl, daum.maps.ControlPosition.RIGHT);
		
		center = map.getCenter(); //지도 중심좌표
		center_x ="";
		center_y ="";
		level = map.getLevel();	  //지도 레벨	
	
		img = "13"; //마커이미지 크기
		imageSrc = ""; //마커이미지 경로
		imageSize = ""; //마커 이미지 사이즈
	
		iwRemoveable = true; //인포윈도우를 닫을 수 있는 x버튼이 표시		
	
		mapCenter = new daum.maps.LatLng(center.getLat(), center.getLng());  //추후수정
	
		panoId  = "";
		rvClient.getNearestPanoId(mapCenter, 50, function(panoId) {
			//panoId = 지역ID, placePosition = 좌표
			roadview.setPanoId(panoId, placePosition); // panoId와 중심좌표를 통해 로드뷰 실행
		});
	
		//로드뷰 초기화면 표시
		roadview.setViewpoint({
			pan: 10,
			tilt: -1,
			zoom: -1
		});
	
		markers = new daum.maps.Marker({
			position: mapCenter,
			draggable: true
		});
		
		searchDetailAddrFromCoords(mapCenter, function(result, status) {
			if (status === kakao.maps.services.Status.OK) {
				
				var detailAddr = !!result[0].road_address ? result[0].road_address.address_name : result[0].address.address_name;
				var defaultAddr = detailAddr.split(/\s/g);
				
				defaultAddress = defaultAddr[0]+" "+defaultAddr[1];
			}
		});
	
		daum.maps.event.addListener(map, 'click', function(e){ //로드뷰 도로에 표시 후 클릭 이벤트
			// 지도 위에 로드뷰 도로 오버레이가 추가된 상태가 아니면 클릭이벤트를 무시 
			if(road=="non_road") {
				return;
			}
			// 클릭한 위치의 좌표입니다
			var position = e.latLng;
			// 마커를 클릭한 위치로 옮깁니다
			roadview.setPanoId(panoId, position);
			// 클락한 위치를 기준으로 로드뷰를 설정합니다			
			container.className = "view_roadview"   
		});
	
		daum.maps.event.addListener(map, 'dragend', function() {      //이동이벤트  			
			// 지도 중심좌표
			level = map.getLevel();
			center = map.getCenter();	
			center_x = center.getLat();
			center_y = center.getLng();
	
			//데이터 조회
			onAjaxData(center_x, center_y,"");
		});
	
		daum.maps.event.addListener(map, 'zoom_changed', function() { //확대,축소이벤트       			
			// 지도의 현재 레벨
			level = map.getLevel();
			center = map.getCenter();	
			center_x = center.getLat();
			center_y = center.getLng();
	
			//데이터 조회
			onAjaxData(center_x, center_y,"");	
		});
		
		daum.maps.event.addListener(map, 'click', function(mouseEvent) {
			if(mark_chk=="Y"){
				for(var i=0; i<infowindow.length; i++){
					if(infowindow[i]){
						infowindow[i].close();
					}
				}
				
				// 클릭한 위도, 경도 정보를 가져옵니다 
				var latlng = mouseEvent.latLng; 
				
				// 마커 위치를 클릭한 위치로 옮깁니다
				drag_marker.setPosition(latlng);
				
				parent.document.slightForm.mapPosX.value = latlng.getLat();
				parent.document.slightForm.mapPosY.value  = latlng.getLng();
				
				searchDetailAddrFromCoords(mouseEvent.latLng, function(result, status) {
					if (status === kakao.maps.services.Status.OK) {
						
						parent.document.slightForm.new_address.value = !!result[0].road_address ? result[0].road_address.address_name : "";
						parent.document.slightForm.address.value  = result[0].address.address_name;
					}
				});
			}
		});
	}
	
	function searchDetailAddrFromCoords(coords, callback) {
		geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
	}
	
	// 주소로 좌표를 검색합니다
	function searchDetailAddrSearch(keyword) {
		var searchAddress = defaultAddress+" "+keyword
		geocoder.addressSearch(searchAddress, function(result, status) {
			// 정상적으로 검색이 완료됐으면 
			if (status === kakao.maps.services.Status.OK) {
				var center_x = result[0].x;
				var center_y = result[0].y;
				var coords = new kakao.maps.LatLng(center_y, center_x);
		
				// 결과값으로 받은 위치를 마커로 표시합니다
				var marker = new kakao.maps.Marker({
					map: map,
					position: coords
				});
		
				// 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
				map.setCenter(coords);
				
				onAjaxData(center_x, center_y, "");
			}
			else if(status == kakao.maps.services.Status.ZERO_RESULT){
				alert("주소를 정확히 입력하여 주세요.")
			}
		});
	}
	
	function createMap(){
		level = map.getLevel();
		center = map.getCenter();	
		center_x = center.getLat();
		center_y = center.getLng();
	
		//데이터 조회
		onAjaxData(center_x, center_y, searchLightNo);
	}
	
	function onInit(){
		setVal();
		createMap();
		setMapType('skyview');
	}
	
	function goToTrbList(light_no, light_type, address, hj_dong_cd) {
		parent.goToTrbList(light_no, light_type, address, hj_dong_cd);
	}
	
	function getXMLHttpRequest() {
		if (window.ActiveXObject) {
			try {
				return new ActiveXObject("Msxml2.XMLHTTP"); 
			} catch(e) {
				try {
					return new ActiveXObject("Microsoft.XMLHTTP");
				} catch(e1) {
					return null;
				}
			}
		} else if (window.XMLHttpRequest) {
			return new XMLHttpRequest();
		} else {
			return null;
		}
	}
	
	function onAjaxData(center_x, center_y,light_no) {
		for (var i = 0; i < positions.length; i++) {
			marker[i].setMap(null);
			customOverlay[i].setMap(null);
			if(infowindow[i]){
				infowindow[i].close();
			}
		}
	
		level = map.getLevel();	  //지도 레벨	
		if(level > 3){
			return;
		}
		
		var keytype = 3;
		var keyword = "";
		if(light_no != "" && light_no != null) {
			keytype = 2;
			keyword = light_no;
		}
		var bounds = map.getBounds();
		var sw = bounds.getSouthWest();
		var ne = bounds.getNorthEast();
		var url = "/common/map/mapDataKakao?center_x="+center_x+"&center_y="+center_y+"&level="+map.getLevel()+"&max_y="+ne.getLng()+"&min_y="+sw.getLng()+"&max_x="+ne.getLat()+"&min_x="+sw.getLat()+"&keytype="+keytype+"&keyword="+encodeURI(encodeURIComponent(keyword));
		httpRequest = getXMLHttpRequest(); // xmlhttp 객체를 생성      
		httpRequest.open("POST", url, true);  // GET방식으로 동기식으로호출
		httpRequest.onreadystatechange = function(){
			useHttpResponse(light_no);
		};
		httpRequest.send(null);  // 호출
	}
	
	function useHttpResponse(light_no2) { // 호출 완료후 콜백함수정의
		if (httpRequest.readyState == 4) {
			if (httpRequest.status == 200) { // 잘넘어왔음
				arrList = new Array();
	
				var dataSet = JSON.parse(httpRequest.responseText);
				if(dataSet.returnMsg != false) {
					dataSet = eval(dataSet.returnMsg.split("^"));
					for(var i = 0;i < dataSet.length; i++) {
						var dataList = dataSet[i].split("|");
						arrList[i] = new Array(dataList.length);
						for(var j = 0;j < dataList.length; j++) {
							arrList[i][j] = dataList[j];
						}						
					}
	
					positions = new Array(); //마커정보입력
					marker = new Array();  //마커 배열
					customOverlay = new Array(); //인포윈도우 배열
					infowindow = new Array();
	
					for(var k = 0;k < arrList.length; k++) {
						var light_no = arrList[k][1];
						var light_type = arrList[k][14];
						var latlng = new daum.maps.LatLng(arrList[k][3], arrList[k][4]);
						var lightSatndCd = arrList[k][6];
						var light_type_nm = "";
						var hj_dong_cd = arrList[k][16];
						var address = arrList[k][2];
						var new_address = arrList[k][12];
						var lamp2_cd = arrList[k][7];
						var lamp3_cd = arrList[k][8];
						var pole_no = arrList[k][5];
						var kepco_cust_no = arrList[k][15];
						var kepco_cd = arrList[k][17];
						var use_light = arrList[k][18];
						
						if(light_type == 1){
							if(lightSatndCd == "01"){
								imageSrc = "/common/images/map/red.png";
							}
							else if(lightSatndCd == "02"){
								imageSrc = "/common/images/map/yellow.png";
							}
							else if(lightSatndCd == "03"){
								imageSrc = "/common/images/map/orange.png";
							}
							else{
								imageSrc = "/common/images/map/purple.png";
							}
						}
						else if(light_type == 2){
							imageSrc = "/common/images/map/ga.png";
						}
						else if(light_type == 3){
							imageSrc = "/common/images/map/bun.png";
						}
	
						if(light_type=="1"){
							if(lightSatndCd == "01"){
								light_type_nm = "한전주";
							}
							else if(lightSatndCd == "02"){
								light_type_nm = "전용주";
							}
							else if(lightSatndCd == "03"){
								light_type_nm = "건축물";
							}
							else{
								light_type_nm = "통신주";
							}
						}else if(light_type=="2"){
							light_type_nm = "가로등";
						}else if(light_type=="3"){
							light_type_nm = "분전함";
						}
	
						var light_no = arrList[k][1];
						var light_type = arrList[k][14];
						var latlng = new daum.maps.LatLng(arrList[k][3], arrList[k][4]);
						var hj_dong_cd = arrList[k][16];
						var address = arrList[k][2];
						var new_address = arrList[k][12];
						var lamp2_cd = arrList[k][7];
						var lamp3_cd = arrList[k][8];
						var pole_no = arrList[k][5];
						var kepco_cust_no = arrList[k][15];
						var kepco_cd = arrList[k][17];
						var use_light = arrList[k][18];
						
						var iwContent = "<div class ='label'><a href='javascript:cl("+k+");'><span class='left'></span><span class='center'>"+light_no+"</span><span class='right'></span></a></div>";
						//var iwContent2 = "<div class=\"sc2\"><h1><img src=\"/common/images/map/nuj_simg.gif\" width=\"18\" height=\"18\"></h1><h2>"+light_no+"</h2><div><table class=\"tic\"> <colgroup><col width=\"80\" /> <col width=\"170\" /> </colgroup><tbody><tr> <td id=\"nb\">종류</td> <td>  | "+light_type_nm+"</td></tr><tr><td id=\"nb\">주소</td> <td>  | "+arrList[k][2]+"</td></tr><tr><td id=\"nb\">새주소</td><td>  | "+arrList[k][12]+"</td></tr><tr><td id=\"nb\">인입주번호</td><td> | "+arrList[k][5]+"</td></tr> </tbody> </table></div><br><p style=\"margin: 1px\"></p><div class=\"ftf\"><p class=\"ft4\"><A class=\"lk2\" href=\"javascript:goToTrbList(\'"+light_no+"\',\'"+light_type+"\',\'"+arrList[k][2]+"\',\'"+hj_dong_cd+"\')\" ></A><A class=\"lk1\" href=\"javascript:onHideWindow("+k+")\"></A></p> </div></div>"
						var iwContent2 = "<div id='area_informbox'><h4 class='hide'>고장신고상세 정보</h4><div id='area_inform_pop'><div id='area_inform_close' onclick='javascript:infoWindowClose()'></div><p class='area_title'>"+light_no+"</p><ul><li class='ai_title'>종류</li><li>"+light_type_nm+"</li></ul><ul><li class='ai_title'>주소</li><li>"+arrList[k][2]+"</li></ul><ul><li class='ai_title'>도로명주소</li><li>"+arrList[k][12]+"</li></ul></div><div id='area_inform_btn'><a href=\"javascript:goToTrbList(\'"+light_no+"\',\'"+light_type+"\',\'"+arrList[k][2]+"\',\'"+hj_dong_cd+"\')\">고장신고</a></div></div>"
						//좌표에 해당하는 데이터 Set
						positions[k] = {
							light_no: light_no, 
							latlng: latlng,
							light_type: light_type,
							address: address,
							new_address: new_address,
							lamp2_cd: lamp2_cd,
							lamp3_cd: lamp3_cd,
							pole_no: pole_no,
							kepco_cust_no: kepco_cust_no,
							kepco_cd: kepco_cd,
							use_light: use_light,
							hj_dong_cd: hj_dong_cd,
							iwContent : iwContent,
							iwContent2 : iwContent2
						};
	
						imageSize = new daum.maps.Size(img, img);  // 마커 이미지 크기
						markerImage = new daum.maps.MarkerImage(imageSrc, imageSize); // 마커 이미지 생성
	
						marker[k] = new daum.maps.Marker({   // 마커를 생성
							map: map, // 마커를 표시할 지도 (div명)
							title : light_no, // 마커 타이틀
							position: latlng, // 마커를 표시할 위치
							image : markerImage // 마커 이미지
						});
	
						infowindow[k] = new daum.maps.InfoWindow({//인포윈도우 생성
							position : latlng,
							content :  iwContent2//,
							//removable : iwRemoveable
						});
						
						customOverlay[k] = new daum.maps.CustomOverlay({
							position : latlng,
							content :  positions[k].iwContent,
							yAnchor : 1.8
						});
						
						customOverlay[k].setMap(map);
	
						if(light_no2 == light_no){
							//지도옵션(표시 위치 및 레벨)
							map.setCenter(latlng);
							
							infowindow[k] = new daum.maps.InfoWindow({//인포윈도우 생성
								position : latlng,
								content : iwContent2
							});
							
							infowindow[k].open(map, marker[k]);  //윈도우 표시
							
							callbackLeftMenu(k);
							
						}
	
						(function(k){
							daum.maps.event.addListener(marker[k], "click", function(){		//마커 클릭 이벤트
								cl(k);
							});
						})(k);
					}	//end for
				}	//end dataSet
			} else {
				alert("실패: "+httpRequest.status); // 실패메시지
			}
		}
	
	}
</script>

