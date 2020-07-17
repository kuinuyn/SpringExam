/**
 * 
 */

$.ajax({
	url : "/resources/daumeditor/editor.html",
	success : function(data) {
		$("#editor_frame").html(data);
		// 에디터UI load
		var config = {
			/* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) http://xxx.xxx.com */
			txHost : '',
			/* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) /xxx/xxx/ */
			txPath : '',
			/* 수정필요없음. */
			txService : 'sample',
			/* 수정필요없음. 프로젝트가 여러개일 경우만 수정한다. */
			txProject : 'sample',
			/* 대부분의 경우에 빈문자열 */
			initializedId : "",
			/* 에디터를 둘러싸고 있는 레이어 이름(에디터 컨테이너) */
			wrapper : "tx_trex_container",
			/* 등록하기 위한 Form 이름 */
			form : "slightForm",
			/*에디터에 사용되는 이미지 디렉터리, 필요에 따라 수정한다. */
			txIconPath : "/resources/daumeditor/images/icon/editor/",
			/*본문에 사용되는 이미지 디렉터리, 서비스에서 사용할 때는 완성된 컨텐츠로 배포되기 위해 절대경로로 수정한다. */
			txDecoPath : "/resources/daumeditor/images/deco/contents/",
			canvas : {
				styles : {
					/* 기본 글자색 */
					color : "#123456",
					/* 기본 글자체 */
					fontFamily : "굴림",
					/* 기본 글자크기 */
					fontSize : "10pt",
					/*기본 배경색 */
					backgroundColor : "#fff",
					/*기본 줄간격 */
					lineHeight : "1.5",
					/* 위지윅 영역의 여백 */
					padding : "8px"
				},
				showGuideArea : false
			},
			events : {
				preventUnload : false
			},
			sidebar : {
				attachbox : {
					show : true,
					confirmForDeleteAll : true
				},
				attacher : {
					image : {
						objattr: {
							width: 200
						}
					}
				}
			},
			size : {
				/* 지정된 본문영역의 넓이가 있을 경우에 설정 */
				contentWidth : 700
			}
		};

		//에디터내에 환경설정 적용하기
		new Editor(config);
	}
});

function validation(callback) {
	//다음에디터가 포함된 form submit
	if($("#subject").val() == "" || $("#subject").val() == null) {
		alert("제목을 입력하세요");
		$("#subject").focus();
		return;
	}
	//Editor.save();
	
	var validator = new Trex.Validator();
	var content = Editor.getContent();
	if (!validator.exists(content)) {
		alert('내용을 입력하세요');
		return false;
	}
	else {
		$("#content").val(content)
	}
	
	callback(function(){});
	
}

//Editor.save() 호출 한 다음에 validation 검증을 위한 함수
//validation 체크해줄 입력폼들을 이 함수에 추가 지정해줍니다.
function validForm(editor) {
	var validator = new Trex.Validator();
	var content = editor.getContent();
	if (!validator.exists(content)) {
		alert('내용을 입력하세요');
		return false;
	}
	return true;
}

//validForm 함수까지 true값을 받으면 이어서 form submit을 시켜주는  setForm함수
function setForm(editor) {
	var content = editor.getContent();
	$("#content").val(content)
	return true;
}
/*다음에디터 끝 */