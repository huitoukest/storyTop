<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个用户更新密码的对话框,作为一个组件嵌入到其他页面 ,需要Jquery,easyUI的支持-->    
<script type="text/javascript">
var common_userUpdateP_dialog;
var common_userUpdateP_regForm;//注册表单

$(function(){
	   common_userUpdateP_dialog=$("#common_userUpdateP_dialog");
	   common_userUpdateP_regForm=$("#common_userUpdateP_regForm");
	   
	   common_userUpdateP_dialogInit();
	   common_userUpdateP_regFormInit();
	   common_userUpdateP_keyEvent();
	   
	   window.setTimeout(function(){
		   $("#common_userUpdateP_regForm input[name='name']").focus();//获取焦点
	   },100);
});
//注册对话框的初始化
function common_userUpdateP_dialogInit(){
	common_userUpdateP_dialog.dialog({
		title: '更新密码',
	    width: 350,
	    //height: 200,
	    closed:true,
	    cache: false,
	    //href: 'get_content.php',
	    closable:true,
	    modal: true,
	    buttons:[{
             text:'确定',
            iconCls:'icon-help',
            handler:function(){
            	common_userUpdateP_regForm.submit();
             }}] 
	                         
	});
};
// 注册表单的初始化
function common_userUpdateP_regFormInit(){
	common_userUpdateP_regForm.form({
	    url:'<%=request.getContextPath()%>/user/updatePassword.json',
	    //contentType:"application/x-www-form-Urlencoded; charset=utf-8",
	    //method:"post",
	    onSubmit: function(){
	    	
	    	 var pT=$("#common_userUpdateP_regForm #oldPasswordT").val();
	    	 $("#common_userUpdateP_regForm #oldPassword").val(wgUtils.MD5(pT));

	    	   var rpT=$("#common_userUpdateP_regForm #rNewPasswordT").val();
	    	   $("#common_userUpdateP_regForm #rNewPassword").val(wgUtils.MD5(rpT));
	    	   
	    	   var rpT=$("#common_userUpdateP_regForm #newPasswordT").val();
	    	   $("#common_userUpdateP_regForm #newPassword").val(wgUtils.MD5(rpT));
	    	
	    	   var k=common_userUpdateP_regForm.form('validate');
		       return k;
	    },
	    success:function(data){  	   	    	
	    	if(typeof data!='object')
	    		{//如果不是Json数据,那么转换成为JSON
	    		try{
	    		data=jQuery.parseJSON(data);
	    		} catch(e){
    	    		alert("由于某些系统原因更新密码失败!请稍后再试!");
	    			return; 
	    		 }
	    		}
	    	//console.info(data);
	    	if(data.success){
	        	common_userUpdateP_dialog.dialog("close");
	        }
	        $.messager.show({
	        	title:"提示",
	        	msg:data.msg,
	        	timeout:5000,
	        	showType:'slide'
	        });
	    }
	});
};

function common_userUpdateP_keyEvent(){//表单的回车提交功能
	$("#common_userUpdateP_regForm input").bind('keyup',function(event){
		if(event.keyCode=='13'){//enter键的编号是13
			common_userUpdateP_regForm.submit();
		}
	});
}
</script>

<div id="common_userUpdateP_dialog">
	<form id="common_userUpdateP_regForm" method="post">
	<table>
		<tr><th align="right">旧密码:</th><td><input class="easyui-validatebox" data-options="required:true" id="oldPasswordT" type="password" name="oldPasswordT" /></td></tr>
		<tr><th align="right">新密码:</th><td><input class="easyui-validatebox" data-options="required:true" id="newPasswordT" type="password" name="newPasswordT" /></td></tr>
		<tr><th align="right">重复新密码:</th><td><input class="easyui-validatebox" data-options="required:true,validType:'eqPwd[\'#common_userUpdateP_regForm #newPasswordT\']'" id="rNewPasswordT" type="password" name="rNnewPasswordT" /></td></tr>
         <tr><td>
         <input class="easyui-validatebox" data-options="required:true" id="oldPassword" type="hidden" name="oldPassword" />
         <input class="easyui-validatebox" data-options="required:true" id="newPassword" type="hidden" name="newPassword" />
         <input class="easyui-validatebox" data-options="required:true" id="rNewPassword" type="hidden" name="rNewPassword" />
         </td></tr>
	<jsp:include page="../common/getVcode.jsp"></jsp:include>
	</table>
	</form>
</div>