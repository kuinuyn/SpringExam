<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="${contextPath }/resources/js/prototype.js"></script>
<link rel="stylesheet" type="text/css" rel="stylesheet" href="/resources/css/mobile/contents.css" />
<style>
	#container {overflow:hidden;height:100%;position:relative;}
	#container.view_map #mapWrapper {z-index: 10;}
	#container.view_map #btnMap {display: none;}
	#container.view_roadview #mapWrapper {z-index: 0;}
	#container.view_roadview #btnRoadview {display: none;}

	.customoverlay {vertical-align: top;}
	.customoverlay:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}
	.customoverlay .title {display:block;display: inline-block;text-align:center;background:#fff;padding:10px 15px;font-size:20px;font-weight:bold;}
	.customoverlay:after {content:'';position:absolute;margin-left:-12px;left:50%;bottom:-12px;width:22px;height:12px;background:url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
	
	#roadviewControl {position:absolute;top:38px;right:55px;width:38px;height:55px;z-index: 1;cursor: pointer;
	background: url(https://uljin.slight.co.kr/html/images/map/roadview.png) no-repeat; }
	#roadviewControl.active {background: url(https://uljin.slight.co.kr/html/images/map/roadview_r.png) no-repeat; }

	#close {position: absolute;padding: 10px;top: 10px;right: 100px;cursor: pointer;background: #fff;border-radius: 4px;border: 1px solid #c8c8c8;box-shadow: 0px 1px #888;}
	#close .img {position:relative; display:block;background: url(//i1.daumcdn.net/localimg/localimages/07/mapapidoc/rv_close.png) no-repeat;width: 14px;height: 14px;z-index: 1}
	
	/* 인쇄버튼 추가를 위한 CSS 추가 */
	.radius_border{border:1px solid #919191;border-radius:5px;}
	.custom_typecontrol {position:absolute;top:7px;right:55px;overflow:hidden;width:148px;height:25px;margin:0;padding:0;font-size:12px;font-family:'Malgun Gothic', '맑은 고딕', sans-serif;}
	.custom_typecontrol span {display:block;width:43px;height:30px;float:left;text-align:center;line-height:22px;cursor:pointer;}
	.custom_typecontrol #btnSkyview {display:block;width:60px;height:30px;float:left;text-align:center;line-height:22px;cursor:pointer;}
	.custom_typecontrol .btn {background:#fff;}
	.custom_typecontrol .btn:hover {background:#f5f5f5;}
	.custom_typecontrol .btn:active {background:#e6e6e6;}
	.custom_typecontrol .selected_btn {color:#fff;background:#425470;}
	.custom_typecontrol .selected_btn:hover {color:#fff;}
</style>
<body onload="onInit()">
	<div id="container" class="view_map" >
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
			<div id="roadview" style="height:100%"></div> <!-- 로드뷰를 표시할 div 입니다 -->
			<div id="close" title="로드뷰닫기" onclick="toggleMap1()"><span class="img"></span></div>
		</div>
	</div>

	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c5a71e08bd2dc04d789a6dc8b64bcad2&libraries=services"></script>
	<script type="text/javascript">
		var container;
		var mapWrapper;
		
		//로드뷰관련
		var btnRoadview; //로드뷰버튼 (클릭하면 지도로 변경)
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
		
		function toggleMap() {
			var control = document.getElementById('roadviewControl');
		
			if (road=="road") {
				// 지도가 보이도록 지도와 로드뷰를 감싸고 있는 div의 class 변경
				map.removeOverlayMapTypeId(kakao.maps.MapTypeId.ROADVIEW); //지도 위에 로드뷰 도로 없애기
				control.className = '';
				container.className = "view_map"
				road = "non_road";
			} else {
				map.addOverlayMapTypeId(kakao.maps.MapTypeId.ROADVIEW); //지도 위에 로드뷰 도로 표시
				control.className = 'active';
				road = "road";
			}
		}
		
		//로드뷰 닫기
		function toggleMap1() {
			map.removeOverlayMapTypeId(kakao.maps.MapTypeId.ROADVIEW); //지도 위에 로드뷰 도로 없애기
			map.addOverlayMapTypeId(kakao.maps.MapTypeId.ROADVIEW); //지도 위에 로드뷰 도로 표시
			container.className = "view_map"
			road = "road";
			parent.searchbox.style.display = 'block';
			parent.searchbox.style.visibility = 'visible';
		}
		
		// 지도타입 컨트롤의 지도 또는 스카이뷰 버튼을 클릭하면 호출되어 지도타입을 바꾸는 함수입니다
		function setMapType(maptype) { 
			var roadmapControl = document.getElementById('btnRoadmap');
			var skyviewControl = document.getElementById('btnSkyview'); 
			if (maptype === 'roadmap') {
				map.setMapTypeId(kakao.maps.MapTypeId.ROADMAP);    
				roadmapControl.className = 'selected_btn';
				skyviewControl.className = 'btn';
			} else {
				map.setMapTypeId(kakao.maps.MapTypeId.HYBRID);    
				skyviewControl.className = 'selected_btn';
				roadmapControl.className = 'btn';
			}
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
		}
		
		function onHideWindow(close_num){
			infowindow[close_num].close();
			info_window = "";
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
		
			var bounds = map.getBounds();
			var sw = bounds.getSouthWest();
			var ne = bounds.getNorthEast();
			//var url = "./mapdata_daum.jsp?center_x="+center_x+"&center_y="+center_y+"&level="+map.getLevel();
			var url = "/common/map/mapMobileDataKakao?center_x="+center_x+"&center_y="+center_y+"&level="+map.getLevel()+"&max_y="+ne.getLng()+"&min_y="+sw.getLng()+"&max_x="+ne.getLat()+"&min_x="+sw.getLat();
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
							var latlng = new kakao.maps.LatLng(arrList[k][3], arrList[k][4]);
							var lightSatndCd = arrList[k][6];
							var light_type_nm = "";
							var hj_dong_cd = arrList[k][16];
							var light_img_seq = arrList[k][19];
							
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
							else if(light_type == 4){
								imageSrc = "/common/images/map/bora.png";
							}
							else if(light_type == 5){
								imageSrc = "/common/images/map/bora_1.png";
							}
							else if(light_type == 6){
								imageSrc = "/common/images/map/black.png";
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
		
							var iwContent = "<div class='customoverlay'><a href='javascript:cl("+k+");'><span class='title'>"+light_no+"</span></a></div>";
							//var iwContent = "<div class ='label'><a href='javascript:cl("+k+");'><span class='left'></span><span class='center'>"+light_no+"</span><span class='right'></span></a></div>";
							var light_img = light_img_seq == "" || light_img_seq == null ? "/resources/css/img/noimg.png" : "/display?name="+arrList[k][20];
							var iwContent2 = "<div id='area_inform_pop'><div id='area_inform_close'><a href='javascript:onHideWindow("+k+")' class='mpop_close'>닫기</a></div><p class='area_title'>"+light_no+"</p><p class='photo'><img src='"+light_img+"'></p><div id='area_inform_btn'><a href='javascript:goToTrbList(\""+light_no+"\",\""+light_type+"\",\""+arrList[k][2]+"\",\""+hj_dong_cd+"\")'>고장신고</a></div></div>";
							//var iwContent2 = "<div class=\"sc2\"><h1><img src=\"/common/images/map/nuj_simg.gif\" width=\"18\" height=\"18\"></h1><h2>"+light_no+"</h2><div><table class=\"tic\"> <colgroup><col width=\"80\" /> <col width=\"170\" /> </colgroup><tbody><tr> <td id=\"nb\">종류</td> <td>  | "+light_type_nm+"</td></tr><tr><td id=\"nb\">주소</td> <td>  | "+arrList[k][2]+"</td></tr><tr><td id=\"nb\">새주소</td><td>  | "+arrList[k][12]+"</td></tr><tr><td id=\"nb\">인입주번호</td><td> | "+arrList[k][5]+"</td></tr> </tbody> </table></div><br><p style=\"margin: 1px\"></p><div class=\"ftf\"><p class=\"ft4\"><A class=\"lk2\" href=\"javascript:goToTrbList(\'"+light_no+"\',\'"+light_type+"\',\'"+arrList[k][2]+"\',\'"+hj_dong_cd+"\')\" ></A><A class=\"lk1\" href=\"javascript:onHideWindow("+k+")\"></A></p> </div></div>"
							
							//좌표에 해당하는 데이터 Set
							positions[k] = {
								light_no: light_no, 
								latlng: latlng,
								iwContent : iwContent,
								iwContent2 : iwContent2
							};
		
							imageSize = new kakao.maps.Size(img, img);  // 마커 이미지 크기
							markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); // 마커 이미지 생성
		
							marker[k] = new kakao.maps.Marker({   // 마커를 생성
								map: map, // 마커를 표시할 지도 (div명)
								title : light_no, // 마커 타이틀
								position: latlng, // 마커를 표시할 위치
								image : markerImage // 마커 이미지
							});
		
							infowindow[k] = new kakao.maps.InfoWindow({//인포윈도우 생성
								position : latlng
								, content :  iwContent2
								//, removable : iwRemoveable
							});
							
							customOverlay[k] = new kakao.maps.CustomOverlay({
								position : latlng,
								content :  positions[k].iwContent,
								yAnchor : 1.8
							});
							
							customOverlay[k].setMap(map);
		
							if(light_no2 == light_no){
								infowindow[k] = new kakao.maps.InfoWindow({//인포윈도우 생성
									position : latlng,
									content : iwContent2
								});
								
								infowindow[k].open(map, marker[k]);  //윈도우 표시
							}
		
							(function(k){
								kakao.maps.event.addListener(marker[k], "click", function(){		//마커 클릭 이벤트
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
		
		//leftMenu에서 사용
		function map_move(center_x, center_y, light_no){
			var moveLatLon = new kakao.maps.LatLng(center_x, center_y);
			map.panTo(moveLatLon);
			//onAjaxData(center_x, center_y, light_no);
		}
		
		//leftMenu에서 사용
		function searchDetailAddrSearch(keyword) {
			geocoder.addressSearch(keyword, function(result, status) {
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
	
	
		function setVal(){
			var center_x = "${param.center_x}";
			var center_y = "${param.center_y}";
			
			if(center_x == null || center_x == "") {
				center_x = "36.11957798170278";
			}
			
			if(center_y == null || center_y == "") {
				center_y = "128.34425314675426";
			}
			
			container = document.getElementById('container');
			mapWrapper = document.getElementById('mapWrapper');
		
			//로드뷰관련
			btnRoadview = document.getElementById('btnRoadview'); //로드뷰버튼 (클릭하면 지도로 변경)
			btnMap = document.getElementById('btnMap'); //지도에 로드뷰 표시
			rvContainer = document.getElementById('roadview'); // 로드뷰 표시
			rvClient = new kakao.maps.RoadviewClient();
			road = "non_road";
		
			//지도
			mapContainer = document.getElementById('map'); // 지도 표시		
			//placePosition = new kakao.maps.LatLng("${param.center_x}", "${param.center_y}");
			placePosition = new kakao.maps.LatLng(center_x, center_y);
			searchLightNo = "${param.lightNo}";
		
			//지도옵션(표시 위치 및 레벨)
			options = {
				//center: new kakao.maps.LatLng("${param.center_x}", "${param.center_y}"),
				center: new kakao.maps.LatLng(center_x, center_y),
				level: 1
			};
		
			map = new kakao.maps.Map(mapContainer, options);  //지도생성
			roadview = new kakao.maps.Roadview(rvContainer);
		
			//ajax용	
			httpRequest = null; 	
			info_window = "";
		
			//지도 확대축소 컨트롤러 보이기
			zoomControl = new kakao.maps.ZoomControl();
			map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
		
			center = map.getCenter(); //지도 중심좌표
			center_x ="";
			center_y ="";
			level = map.getLevel();	  //지도 레벨	
		
			img = "13"; //마커이미지 크기
			imageSrc = ""; //마커이미지 경로
			imageSize = ""; //마커 이미지 사이즈
		
			iwRemoveable = true; //인포윈도우를 닫을 수 있는 x버튼이 표시		
		
			 mapCenter = new kakao.maps.LatLng(center.getLat(), center.getLng());  //추후수정
		
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
			
			markers = new kakao.maps.Marker({
				position: mapCenter,
				draggable: true
			});
			
			kakao.maps.event.addListener(map, 'click', function(e){ //로드뷰 도로에 표시 후 클릭 이벤트
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
				parent.searchbox.style.display = 'block';
				parent.searchbox.style.visibility = 'hidden';
			});
		
			kakao.maps.event.addListener(map, 'dragend', function() {      //이동이벤트  			
				// 지도 중심좌표
				level = map.getLevel();
				center = map.getCenter();	
				center_x = center.getLat();
				center_y = center.getLng();
		
				//데이터 조회
				onAjaxData(center_x, center_y,"");
			});
		
			kakao.maps.event.addListener(map, 'zoom_changed', function() { //확대,축소이벤트       			
				// 지도의 현재 레벨
				level = map.getLevel();
				center = map.getCenter();	
				center_x = center.getLat();
				center_y = center.getLng();
		
				//데이터 조회
				onAjaxData(center_x, center_y,"");	
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
	</script>
</body>
