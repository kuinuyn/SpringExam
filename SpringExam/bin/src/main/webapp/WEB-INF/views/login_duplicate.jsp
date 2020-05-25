<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" contentType="text/html; charset=utf-8" %>
<html>
	<head>
		<script src="<c:url value="/resources/js/jquery/jquery-1.9.1.min.js" />"></script>
		<script type="text/javascript">
		      $(document).ready(function(){
		            
		            alert("[동시접속 발생] 다른 브라우저에서 해당 계정의 접속이 감지되어 로그아웃 됩니다.");
		            location.href= "/";
		      });
		      
		</script>
	</head>
	<body>
	
	</body>
</html>