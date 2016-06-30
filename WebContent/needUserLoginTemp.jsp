<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- 此页面的作用只是为了提醒用户需要登录，在登陆之后方可以方位原来的页面 -->
<jsp:include page="./WEB-INF/content/include.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>school_ebay网站登录</title>

</head>
<body>
<div align="center">
	<div id="sendToIndexDiv"><span style="color:red; font-size:180%;">您必须登录后才能继续访问！</span></div>
	<br/>
	<a href="javascript:history.go(-1);">返回</a>
	<a href="<%=request.getParameter("reqUrl")%>">继续访问</a>
	</div>
</body>
</html>