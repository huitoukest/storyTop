<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个用户注册对话框,作为一个组件嵌入到其他页面 ,需要Jquery,easyUI的支持-->    
<script type="text/javascript">
var common_regist_dialog;
var common_indexTop_regForm;//注册表单

$(function(){
	   common_regist_dialog=$("#common_regist_dialog");
	   common_indexTop_regForm=$("#common_indexTop_regForm");
	   
	   common_regist_dialogInit();
	   common_indexTop_regFormInit();
	   common_regist_keyEvent();
	   
	   window.setTimeout(function(){
		   $("#common_indexTop_regForm input[name='userName']").focus();//获取焦点
	   },100);
});
//注册对话框的初始化
function common_regist_dialogInit(){
	common_regist_dialog.dialog({
		title: '注册',
	    //width: 400,
	    //height: 200,
	    closed:true,
	    cache: false,
	    //href: 'get_content.php',
	    closable:true,
	    modal: true,
	    buttons:[{
             text:'注册',
            iconCls:'icon-help',
            handler:function(){
            	common_indexTop_regForm.submit();
             }}] 
	                         
	});
};
// 注册表单的初始化
function common_indexTop_regFormInit(){
	common_indexTop_regForm.form({
	    url:'<%=request.getContextPath()%>/userRegister.json',
	    //contentType:"application/x-www-form-Urlencoded; charset=utf-8",
	    //method:"post",
	    onSubmit: function(){
	    	
	    	 var pT=$("#common_indexTop_regForm #passwordT").val();
	    	 $("#common_indexTop_regForm #password").val(wgUtils.MD5(pT));

	    	   var rpT=$("#common_indexTop_regForm #rPasswordT").val();
	    	   $("#common_indexTop_regForm #rPassword").val(wgUtils.MD5(rpT));
	    	
	    	   var k=common_indexTop_regForm.form('validate');
		       return k;
	    },
	    success:function(data){  	   	    	
	    	if(typeof data!='object')
	    		{//如果不是Json数据,那么转换成为JSON
	    		try{
	    		data=jQuery.parseJSON(data);
	    		} catch(e){
    	    		alert("由于某些系统原因注册失败!请稍后再试!");
	    			return; 
	    		 }
	    		}
	    	//console.info(data);
	    	if(data.success){
	        	common_regist_dialog.dialog("close");
	        }else{
	        	$("#common_indexTop_regForm #common_authImg").attr("src", "<%=request.getContextPath()%>/getVCode.do?"+Math.random());
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

function common_regist_keyEvent(){//表单的回车提交功能
	$("#common_indexTop_regForm input").bind('keyup',function(event){
		if(event.keyCode=='13'){//enter键的编号是13
			common_indexTop_regForm.submit();
		}
	});
}
</script>

<div id="common_regist_dialog">
	<form id="common_indexTop_regForm" method="post">
	<table>
		<tr><th align="right">用户名:&nbsp;</th><td><input class="easyui-validatebox" data-options="required:true" id="userName" name="userName"/></td></tr>
		<tr><th align="right">密码:&nbsp;</th><td>
		<input class="easyui-validatebox" data-options="required:true" id="passwordT" type="password" name="passwordT" /></td></tr>
		<tr><th align="right">重复密码:&nbsp;</th><td>
		<input class="easyui-validatebox" id="rPasswordT" name="rPasswordT" type="password" data-options="required:true,validType:'eqPwd[\'#common_indexTop_regForm #passwordT\']'" />		</td></tr>
	    
	    <tr><th><input class="easyui-validatebox" data-options="required:true" id="password" type="hidden" name="password" /></th><td>
				<input class="easyui-validatebox" id="rPassword" name="rPassword" type="hidden" data-options="required:true" />	</td></tr>	
	<jsp:include page="../common/getVcode.jsp"></jsp:include>
	</table>
	</form>
</div>