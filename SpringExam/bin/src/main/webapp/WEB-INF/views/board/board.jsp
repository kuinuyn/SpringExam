<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		getBoardList();
	});
	
	function getBoardDetail(boardSeq) {
		location.href = "/board/boardDetail?boardSeq="+boardSeq;
	}
	
	function goBoardWrite() {
		location.href = "/board/boardWrite";
	}
	
	function getBoardList(currentPageNo) {
		if(currentPageNo === undefined){
			currentPageNo = "1";
		}
		
		$("#current_page_no").val(currentPageNo);
		
		$.ajax({
			type : "POST"
			, url : "/board/getBoardList"
			, data : $("#boardForm").serialize()
			, dataType : "JSON"
			, success : function(obj) {
				getBoardListCallback(obj);
			}
			, error : function(xhr, status, error) {}
		});
	}
	
	function getBoardListCallback(obj) {
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
					str += "	<td>"+list[i].board_seq+"</td>";
					str += "	<td onclick='javascript:getBoardDetail("+list[i].board_seq+");' style='cursor:Pointer'>"+list[i].board_subject+"</td>";
					str += "	<td>"+list[i].board_hits+"</td>";
					str += "	<td>"+list[i].board_writer+"</td>";
					str += "	<td>"+list[i].ins_date+"</td>";
					str += "</tr>";
				}
			}
			else {
				str += "<tr>";
				str += "	<td colspan='5'>등록된 글이 존재하지 않습니다.</td>";
				str += "</tr>";
			}
			$("#tbody").html(str);
			$("#total_count").text(totalCount);
			$("#pagination").html(pagination);
		}
		else {
			alert("관리자에게 문의하세요.");
			return;
		}
	}
	
	function excelDownload() {
		var currentRow = $("#boardList > thead> tr > th").length;
		var headerArr = new Array();
		
		for(i=0; i<currentRow; i++) {
			headerArr.push($("#boardList > thead> tr").find("th:eq("+i+")").text());
		}
		
		var f = document.boardForm;
		f.method = "POST";
		f.action = "downloadExcel";
		f.excelHeader.value = headerArr;
		f.submit();
	}
</script>
<body>
	<div id="wrap">
		<div id="container">
			<div class="inner">
				<h2>게시글 목록</h2>
				<div class="btn_right mt15">
					<button class="btn black mb10" onclick="javascript:excelDownload();">엑셀다운로드</button>
				</div>
				<form id="boardForm" name="boardForm" action="/">
					<input type="hidden" id="excelHeader" name="excelHeader" value="" />
					<input type="hidden" id="function_name" name="function_name" value="getBoardList" />
					<input type="hidden" id="current_page_no" name="current_page_no" value="1" />
					<table width="100%" class="table01" id="boardList">
						<colgroup>
							<col width="10%" />
							<col width="25%" />
							<col width="10%" />
							<col width="15%" />
							<col width="20%" />
						</colgroup>
						<thead>
							<tr>
								<th>글번호</th>
								<th>제목</th>
								<th>조회수</th>
								<th>작성자</th>
								<th>작성일</th>
							</tr>
						</thead>
						<tbody id="tbody">
						</tbody>
					</table>
				</form>
				<div class="btn_right mt15">
					<button class="btn black mr5" onclick="javascript:goBoardWrite();">작성하기</button>
				</div>
			</div>
			<div id="pagination">
			</div>
		</div>
	</div>
</body>
