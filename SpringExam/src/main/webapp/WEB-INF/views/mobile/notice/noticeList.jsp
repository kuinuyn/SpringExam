<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
	<meta charset="utf-8" />
	<title>도로조명정보시스템</title>
	<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0" />
	<%@ include file="/WEB-INF/include/include-mobile-header.jspf"%>
	<script type="text/javascript">
		$(function() {
		});
		
		function tabClick(ele) {
			if($(ele).hasClass('active')) {
		        // Remove active classes
		        $(ele).removeClass('active');
		    } else {
		        // Remove active classes
		        $(ele).removeClass('active');
		
		        // Add the active class
		        $(ele).addClass('active');
		    }
			
			var content = $(ele).find(".content");
			content.slideToggle(100);
			$('.accordion-item .content').not(content).slideUp('fast');
		}
	
		function moreSearch() {
			alert("sdfk");
			$("#current_page_no").val(parseInt($("#current_page_no").val())+1);
			
			$.ajax({
				type : "POST"			
				, url : "/info/getInfoNoticeList"
				, data : {"current_page_no":$("#current_page_no").val()}
				, dataType : "JSON"
				, success : function(obj) {
					getMoreSearchCallback(obj);
				}
				, error : function(xhr, status, error) {
					
				}
			});
		}
		
		function getMoreSearchCallback(obj) {
			var state = obj.state;
			if(state == "SUCCESS"){
				var data = obj.data;			
				var list = data.list;
				var listLen = list.length;		
				
				var str = "";
				var btnStr = "";
				var content = '';
				//접수번호
				if(listLen > 0) {
					for(i=0; i<listLen; i++) {
						str += '<div class="accordion-item" onclick="javascript:tabClick(this)">';
						str += '		<a href="#" class="heading">';
						str += '			<div class="title">'+list[i].subject+'<span class="ico_ar"></span></div>';
						str += '		</a>';
						str += '		<div class="content">';
						str += '			<p class="aco_tbox"><span class="txt-gray2">'+list[i].content.replace(/<(\/p|p)([^>]*)>/gi,"");+'</span></p>';
						str += '		</div>';
						str += '</div>';
					}
					
				}
				else {
					str += '<div class="accordion-item">';
					str += '	<div class="title">등록된 글이 존재하지 않습니다.</div>';
				}
				//$("#notice_js").remove();
				//str += '<script id="notice_js" type="text/javascript" src="${contextPath }/resources/js/mobile/jquery_notice.js?ver="'+data.current_page_no+'/>';
				
				$("#content").append(str);
				//$.getScript( '${contextPath }/resources/js/mobile/jquery_notice.js?ver='+data.current_page_no );
			}
			
			var pageNo = parseInt($("#current_page_no").val());
			if(pageNo == Math.ceil((data.totalCount / 10))) {
				$(".group").hide();
			}
			else {
				$(".group").show();
			}
		}
	</script>
	
</head>
<body>
	<%@ include file="../sidebar.jsp" %>
	
<!-- content -->
<form id="slightForm" name="slightForm" method="post" action="">
	<input type="hidden" id="current_page_no" name="current_page_no" value="${resultList.data.current_page_no}" />
</form>
<!-- List -->
<section id="content">
	<h2 class="hide">공지사항 리스트</h2>
	<c:forEach items="${resultList.data.list}" var="list" varStatus="status">
		<div class="accordion-item" onclick="javascript:tabClick(this)">
			<a href="#" class="heading">
				<div class="title"> <c:out value="${list.subject }"></c:out><span class="ico_ar"></span></div>
			</a>
			<div class="content">
				<p class="aco_tbox">
					<span class="txt-gray2">
						<c:out value='${list.content }' escapeXml="false"/>
					</span>
				</p>
			</div>
		</div>
	</c:forEach>
</section>


<c:set var="total" value="${resultList.data.totalCount/10}"/>
<%-- <c:set var="totalCount" value="${total+(1-(total%1))%1}"/> --%>
<fmt:parseNumber var="totalCount" value="${total+(1-(total%1))%1}" integerOnly="true" />
<c:set var="currentNo" value="${resultList.data.current_page_no}" />
<input type="hidden" value="${resultList.data.totalCount/10}"/>
<input type="hidden" value="${total+(1-(total%1))%1}" />
<input type="hidden" value="${resultList.data.current_page_no}" />
<input type="hidden" value="${currentNo ne totalCount}" />
<c:if test="${totalCount ne currentNo}">
	<div class="group">
		<div class="btn-area"><a href="javascript:moreSearch()" class="btn btn-large btn-white2"><i class="fa fa-plus"></i> 더보기</a></div>
	</div>
</c:if>
<!-- // List -->
<!-- //content -->
</body>
</html>