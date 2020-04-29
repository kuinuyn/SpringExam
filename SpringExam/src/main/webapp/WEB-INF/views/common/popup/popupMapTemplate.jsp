<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<body>
	<iframe src="${contextPath}/common/map/mapContentDaum2?searchLightNo=<c:out value="${resultData.light_no}" />&center_x=<c:out value="${resultData.map_x_pos_gl}" />&center_y=<c:out value="${resultData.map_y_pos_gl}" />" width="100%" height="429"  frameborder="0"></iframe>
</body>
