<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个公共验证码组件,作为一个form的组件嵌入到其他页面的form的table中 ,需要Jquery以及easyUI的支持-->
<!-- 通过调用相关函数,并传入相关参数可以完成相应的功能 -->  
<script type="text/javascript">

//刷新验证码
function common_refresh(img) { 
	//alert("即将刷新验证码");
    img.children[0].src= "<%=request.getContextPath()%>/getVCode.do?"+Math.random();  
    <%System.out.println("contextPath="+request.getContextPath());%>
} 
</script>

			<tr>
				<td align="right" >验证码:</td>
				<td align="left">
				<a href="javascript:void(0);" onclick="common_refresh(this);">
				<img src="<%=request.getContextPath()%>/getVCode.do?\"+Math.random()" id="common_authImg" name="common_authImg"/>
				看不清
				</a><br>
			    
			<tr>
				<td align="right">请输入4位字符的验证码:</td>
				<td align="left" ><input name="vcode" id="vcode" class="easyui-validatebox" value="" data-options="validType:'length[4,4]',required: true"/></td>		
			</tr>