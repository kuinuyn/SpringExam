<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시판 작성</title>

<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script src="http://malsup.github.com/jquery.form.js"></script>
<script type="text/javascript">
	var newEditor;
	
	$(document).ready(function() {
		ClassicEditor 
	    .create( document.querySelector( '#board_content' ) ) 
	    .then( editor => { 
	        console.log( editor ); 
	        newEditor = editor;
	    } ) 
	    .catch( error => { 
	        console.error( error ); 
	    } );

	});

	function goBoardList() {
		location.href = "/board/board";
	}
	
	function insertBoard() {
		if($("#board_subject").val() == "") {
			alert("제목을 입력하세요");
			$("#board_subject").focus();
			return;
		}
		
		var boardContent = newEditor.getData();
		if(newEditor.getData() == "") {
			alert("내용을 입력하세요");
			$("#board_content").focus();
			return;
		}
		else {
			$("#board_content").val(boardContent);
		}
		
		if(confirm("게시글을 등록하시겠습니까?")	) {
			var filesChk = $("input[name=files]").val();
			if(filesChk == "") {
				$("input[name=files]").remove();
			}
			
			$("#boardForm").ajaxForm({
				type : "POST"
				, url : "/board/insertBoard"
				, enctype : "multipart/form-data"
				, cache : false
				, async : true
				, success : function(obj) {
					insertBoardBallback(obj);
				}
				, error : function(xhr, status, error) {}
			}).submit();
		}
		
		function insertBoardBallback(obj) {
			if(obj != null) {
				var result = obj.result;
				
				if(result == "SUCCESS") {
					alert("등록이 완료되었습니다.");
					goBoardList();
				}
				else {
					alert("등록이 실패되었습니다.");
					return;
				}
			}
		}
	}
</script>

</head>
<body>
	<div id="wrap">
		<div id="container">
			<div class="inner">
				<h2>게시글 목록</h2>
				<form id="boardForm" name="boardForm" enctype="multipart/form-data">
					<table width="100%" class="table02">
						<caption><strong><span class="t_red">*</span>표시는 필수입력 항목입니다.</strong></caption>
						<colgroup>
							<col width="10%" />
							<col width="*" />
						</colgroup>
						<tbody id="tbody">
							<tr>
								<th>제목<span class="t_red">*</span></th>
								<td><input id="board_subject" name="board_subject" class="tbox01"></td>
							</tr>
							<tr>
								<th>작성자<span class="t_red">*</span></th>
								<td><input id="board_writer" name="board_writer" class="tbox01"></td>
							</tr>
							<tr>
								<th>내용<span class="t_red">*</span></th>
								<td><textarea id="board_content" name="board_content" rows="5" cols="10" class="textarea01"></textarea></td>
							</tr>
							<tr>
								<th>첨부파일</th>
								<td><input type="file" id="files" name="files" ></td>
							</tr>
						</tbody>
					</table>
				</form>
				<div class="btn_right mt15">
					<button class="btn black mr5" onclick="javascript:goBoardList();">목록으로</button>
					<button class="btn black" onclick="javascript:insertBoard();">등록하기</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>