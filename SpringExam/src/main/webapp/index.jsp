<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<%@ include file="/WEB-INF/include/include-header.jspf"%>
	<script type="text/javascript">
		$(document).ready(function(){
			/* if("${pageContext.request.requestURL}".indexOf("m.") > -1) {
				location.href="http://m.dev.slight.co.kr/mobile/index";
			}
			else {
				location.href="/main";
			} */
			location.href="/main";
		});
	</script>
</head>
</html>