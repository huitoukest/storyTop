<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个管理员登录对话框,作为一个组件嵌入到其他页面 ,需要Jquery,easyUI的支持-->  
<style type="text/css">
.adminLogin th{
text-align: right;
padding-right: 3px;
}

</style>
<script type="text/javascript">

var admin_login_dialog;
var admin_login_form;

$(function(){
	   admin_login_dialog=$("#admin_login_dialog");
	   admin_login_form=$("#admin_login_form");
	   
	   admin_loginDialogInit();
	   admin_login_formInit();
	   admin_login_form_keyEvent();
	   
	   window.setTimeout(function(){
		   $("#admin_login_form input[name='name']").focus();//获取焦点
	   },100);
});


//登录对话框的初始化
function admin_loginDialogInit()
{   //console.info(admin_login_dialog);
      admin_login_dialog.dialog({
		title: '登录',
	    //width: 400,
	    //height: 200,
	    closed:false,
	    cache: false,
	    closable:false,
	    //href: 'get_content.php',
	    modal: true,
	    buttons:[{
            text:'登录',
            iconCls:'icon-help',
            handler:function(){
            	admin_login_form.submit();
            }}] 
	                         
	});
};
/**
 * 无论提交成功否，先将密码清空，防止密码前台的多次加密。
 */
function admin_login_formInit(){
	admin_login_form.form({
	    url:'admin/adminLogin.json',
	    //contentType:"application/x-www-form-Urlencoded; charset=utf-8",
	    //method:"post",
	    onSubmit: function(){
	    	 var p=$("#admin_login_form #passwordT").val();
	    	 $("#admin_login_form #password").val(wgUtils.MD5(p));
	    	
	    	var k=admin_login_form.form('validate');
	       return k;
	    },
	    success:function(data){   	
	    	if(typeof data!='object')
	    		{//如果不是Json数据,那么转换成为JSON
	    		 data=jQuery.parseJSON(data);
	    		}
	    	//console.info(data);
	    	if(data.success){
	    		admin_login_dialog.dialog("close");
	    		//同时检查是否登录以及改变界面
	    		admin_north_showAdminInfo();
	        }else{
	        	$("#admin_login_form #common_authImg").attr("src", "<%=request.getContextPath()%>/getVCode.do?"+Math.random());
	        }
	        $.messager.show({
	        	title:"提示",
	        	msg:data.msg,
	        	timeout:5000,
	        	showType:'slide'
	        });
	    }
	});
}

function admin_login_form_keyEvent(){//表单的回车提交功能
	$("#admin_login_form input").bind('keyup',function(event){
		if(event.keyCode=='13'){//enter键的编号是13
			admin_login_form.submit();
		}
	});
}
</script>
<!-- 注册和登陆的对话框 -->
<div id="admin_login_dialog">
	<form method="post" id="admin_login_form">
		<table class="adminLogin">
			<tr><th>用户名:</th><td><input class="easyui-validatebox" data-options="required:true" id="name" name="name"/></td></tr>
			<tr><th>密码:</th><td>
			<input class="easyui-validatebox" type="password" data-options="required:true" id="passwordT" name="passwordT" />
			<input class="easyui-validatebox" type="hidden" data-options="required:true" id="password" name="password" />
			</td></tr>
		    <jsp:include page="../common/getVcode.jsp"></jsp:include>
		</table>
	</form>
</div>