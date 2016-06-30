<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个用户登录对话框,作为一个组件嵌入到其他页面 ,需要Jquery,easyUI以及注册对话框的支持-->  
<script type="text/javascript">

var common_login_dialog;
var common_login_form;

$(function(){
	   common_login_dialog=$("#common_login_dialog");
	   common_login_form=$("#common_login_form");
	   
	   common_loginDialogInit();
	   common_login_formInit();
	   common_login_form_keyEvent();
	   
	   window.setTimeout(function(){
		   $("#common_login_form input[name='userName']").focus();//获取焦点
	   },100);
});


//登录对话框的初始化
function common_loginDialogInit()
{   //console.info(common_login_dialog);
      common_login_dialog.dialog({
		title: '登录',
	    //width: 400,
	    //height: 200,
	    closed:true,
	    cache: false,
	    closable:true,
	    //href: 'get_content.php',
	    modal: true,
	    buttons:[{
            text:'登录',
            iconCls:'icon-help',
            handler:function(){
            	common_login_form.submit();
            }},{
             text:'注册',
            iconCls:'icon-edit',
            handler:function(){//初始化并且打开注册对话框
            	common_login_form.form('reset');
            	common_regist_dialog.dialog('open');
            	window.setTimeout(function(){
         		   $("#common_indexTop_regForm input[name='userName']").focus();//获取焦点
         	   },100);
             }}] 
	                         
	});
};

function common_login_formInit(){
	common_login_form.form({
	    url:'<%=request.getContextPath()%>/userLogin.json',
	    //contentType:"application/x-www-form-Urlencoded; charset=utf-8",
	    //method:"post",
	    onSubmit: function(){	    	
	    	 var p=$("#common_login_form #passwordT");
	    	   var v=p.val();
	    	   var rp=wgUtils.MD5(v);
	    	   $("#common_login_form #password").val(rp);
	    	var k=common_login_form.form('validate');    
		       return k;
	    },
	    success:function(data){	    	   
	    	if(typeof data!='object')
	    		{//如果不是Json数据,那么转换成为JSON
	    		 data=jQuery.parseJSON(data);
	    		}
	    	//console.info(data);
	    	if(data.success){
	    		checkWheatherUserLogin();
	    		common_login_dialog.dialog("close");
	        }else{	        	
	        $("#common_login_form #common_authImg").attr("src", "<%=request.getContextPath()%>/getVCode.do?"+Math.random());
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

function common_login_form_keyEvent(){//表单的回车提交功能
	$("#common_login_form input").bind('keyup',function(event){
		if(event.keyCode=='13'){//enter键的编号是13
			common_login_form.submit();
		}
	});
}

</script>
<!-- 注册和登陆的对话框 -->
<div id="common_login_dialog">
	<form method="post" id="common_login_form">
		<table class="loginTablecss">
			<tr><th align="right">用户名:&nbsp;</th><td><input class="easyui-validatebox" data-options="required:true" id="userName" name="userName"/></td></tr>
			<tr><th align="right">密码:&nbsp;</th><td><input class="easyui-validatebox" data-options="required:true" type="password" id="passwordT" name="passwordT" /></td></tr>
			<tr><td><input class="easyui-validatebox" data-options="required:true" type="hidden" id="password" name="password" /></td></tr>
		<jsp:include page="../common/getVcode.jsp"></jsp:include>
		</table>
	</form>
</div>