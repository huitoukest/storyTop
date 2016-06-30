<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 本页面主要是引入相关的js文件和css文件 -->
<%  
String path = request.getContextPath();  
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";  
%> 
<script type="text/javascript" src="<%=basePath%>js/jquery/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/jquery.form3.46.js"></script>
<script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/wgUtilsJs/easyui/wg_easyuiUtils.js"></script>
<script type="text/javascript" src="<%=basePath%>js/wgUtilsJs/wg_commonsUtils/wgUtils.js"></script>
<script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=basePath%>js/wgUtilsJs/wg_commonsUtils/wgValidate_1.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">

