<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个公共的增加或者编辑用户的对话框,作为一个组件嵌入到其他页面 ,需要Jquery,easyUI的支持-->
<!-- 通过调用相关函数,并传入相关参数可以完成相应的功能 -->  
<style type="text/css">
#common_add_edit_userTable th{
  width: 85px;
  text-align: right;
  padding-right: 5px;
  line-height: 22px;
}
</style>
<script type="text/javascript">
var common_add_edit_userDialog;
var common_add_edit_userForm;
//var common_add_edit_userFormSubmit=-1;
$(function(){
	   common_add_edit_userDialog=$("#common_add_edit_userDialog");
	   common_add_edit_userForm=$("#common_add_edit_userForm");
	   
	   common_add_edit_userDialogInit("编辑用户","编辑","icon-add");
	   common_add_editUser_keyEvent();
});
/**
 *仅当isAdmin为true的时候,是管理员调用 
 *@param data 加载到表单中的一个json数据,键值对名称和表单input中name对应
 *@param url 编辑用户的url,绝对路径
 *@param isAdmin 仅当isAdmin为true的时候,是管理员调用 
 *@param successFunction 后台操作数据成功的时候,执行的函数
 *@param falseFunction 后台操作失败的时候执行的函数
 */
function common_addUser(url,isAdmin,successFunction,falseFunction)
{   if(!wgUtils.isUsed(isAdmin)||!isAdmin){
			//alert("已经执行!");
			$("#common_add_edit_userForm #passwordT").attr({'editable':false,"readonly":"readonly"});
		} else {
			$("#common_add_edit_userForm #passwordT").attr({'editable':true,"readonly":false});
		}
	common_add_edit_userDialogInit("增加用户","增加","icon-add");
	common_add_edit_userFormInit(url,successFunction,falseFunction);
	$("#common_add_edit_userForm input").val('');
	common_add_edit_userDialog.dialog("open");
};
/**
 * @param data 加载到表单中的一个json数据,键值对名称和表单input中name对应
 * @param url 编辑用户的url,绝对路径
 * @param isAdmin 仅当isAdmin为true的时候,是管理员调用 
 * @param successFunction 后台操作数据成功的时候,执行的函数
 * @param falseFunction 后台操作失败的时候执行的函数
 */
function common_editUser(data,url,isAdmin,successFunction,falseFunction)
{//将表单内容填充,然后打开对话框
	if(!wgUtils.isUsed(isAdmin)||!isAdmin){
		$("#common_add_edit_userForm #passwordT").attr({'editable':false,"readonly":"readonly"});
	} else {
		$("#common_add_edit_userForm #passwordT").attr({'editable':true,"readonly":false});
	}
	common_add_edit_userDialogInit("编辑用户","保存","icon-save");
	common_add_edit_userFormInit(url,successFunction,falseFunction);	
	$("#common_add_edit_userForm input").val('');
	common_add_edit_userForm.form('load',data);            
	if(!wgUtils.isUsed(isAdmin)||!isAdmin)
	{
		$("#common_add_edit_userForm #passwordT").val("***");
	}
	common_add_edit_userDialog.dialog("open");   
};
/**
 *对话框初始化,标题,按钮名称,按钮图标
*/
function common_add_edit_userDialogInit(title,btnName,icon)
{
	common_add_edit_userDialog.dialog({
		title: title,
	     width: 310,
	    //height: 200,
	    closed:true,
	    cache: false,
	    //href: 'get_content.php',
	    modal: true,
	    buttons:[{
             text:btnName,
            iconCls:icon,
            handler:function(){
            	common_add_edit_userForm.submit();
            	//common_add_edit_userFormSubmit=1;
             }}] 
	                         
	});
};
/**
 *用户增加表单的初始化
*/
function common_add_edit_userFormInit(url,successFunction,falseFunction)
{
	common_add_edit_userForm.form({
	    url:'<%=request.getContextPath()%>'+url,
	    contentType:"application/x-www-form-Urlencoded; charset=utf-8",
	    method:"post",
	    onSubmit: function(){	    
	    var pT=$("#common_add_edit_userForm #passwordT").val();
	    if(typeof pT!='undefined'&&pT.length>=1)
	    $("#common_add_edit_userForm #password").val(wgUtils.MD5(pT));	    
	    return common_add_edit_userForm.form('validate');
	    },
	    success:function(data){       	    	
	    	//alert(data);
	    	if(typeof data!='object')
	    		{//如果不是Json数据,那么转换成为JSON
	    		try{
	    		data=jQuery.parseJSON(data);}
	    		catch(e){
	    		alert("由于某些系统原因增加失败!请稍后再试!");
	    			return; 
	    		 }
	    		}
	    	
	    	if(data.success&&typeof successFunction=='function')
    		{
    		 successFunction(data);
    		//添加成功后关闭对话框并刷新单签datagrid
	    		common_add_edit_userDialog.dialog("close"); 
    		 
    		} else if(!data.success&&typeof falseFunction=='function')
    	{
    			falseFunction(data);
    	}	    	
	    	if(typeof data.msg!="undefined"){
	    		       	    		
	    		$.messager.show({
    	        	title:"提示",
    	        	msg:data.msg,
    	        	timeout:5000,
    	        	showType:'slide'
    	        }); }
	    	 else if(typeof data.success=="undefined"){
	    		$.messager.show({
    	        	title:"提示",
    	        	msg:"对不起,信息提交失败!请稍后再试!",
    	        	timeout:5000,
    	        	showType:'slide'
    	        });
	    	}
	        
	    },
	    onLoadError:function(){
	    	$.messager.show({
	        	title:"提示",
	        	msg:"对不起,信息提交失败!请稍后再试!",
	        	timeout:5000,
	        	showType:'slide'
	        });
	    }
	});
}
function common_add_editUser_keyEvent(){//表单的回车提交功能
	$("#common_add_edit_userForm input").bind('keyup',function(event){
		if(event.keyCode=='13'){//enter键的编号是13
			common_add_edit_userForm.submit();
		}
	});
}
</script>

<!-- 增加或者编辑用户的对话框 -->
<div id="common_add_edit_userDialog">
		    <form id="common_add_edit_userForm" method="post">
			<table id="common_add_edit_userTable">
				<tr><th></th><td><input id="id" name="id" type="hidden" readonly="readonly"/></td></tr>				
				<tr><th>用&emsp;&emsp;户&emsp;名:</th><td><input class="easyui-validatebox" data-options="required:true" id="userName" name="userName"/></td></tr>												
				<tr id="passwordTr"><th>密&emsp;&emsp;&emsp;&emsp;码:</th><td><input class="easyui-validatebox"  data-options="required:false" id="passwordT" name="passwordT" type="password"/></td></tr>
				<tr><td><input class="easyui-validatebox"  data-options="required:true" type="hidden"  id="password" name="password" /></td></tr>				
				<tr><th>年&emsp;&emsp;&emsp;&emsp;龄:</th><td><input class="easyui-numberspinner" data-options="required:false,min:1,max:127,editable:true" id="age" name="age" /></td></tr>
				<tr><th>&emsp;&emsp;&emsp;Email:</th><td><input class="easyui-validatebox" data-options="required:false,validType:'email'" id="email" name="email" /></td></tr>
				<tr><th>手&emsp;&emsp;&emsp;&emsp;机:</th><td><input class="easyui-validatebox" data-options="required:false" id="phone" name="phone" /></td></tr>
				<tr><th>&emsp;&emsp;&emsp;&emsp;q&emsp;q:</th><td><input class="easyui-validatebox" data-options="required:false" id="qq" name="qq" /></td></tr>
				<tr><th>性&emsp;&emsp;&emsp;&emsp;别:</th><td>
				 <input class="easyui-combobox" id="sex" name="sex" data-options="
				                                editable:false,
												valueField: 'value',
												textField: 'label',
												data: [{
													label: '女',
													value:0
												},{
													label: '男',
													value: 1
												}]" />
				</td></tr>
			<tr><th>最近登录时间:</th><td><input id="lastLoginTime" name="lastLoginTime" readonly="readonly"/></td></tr>
			<tr><th>可评分&emsp;次数:</th><td><input id="markTicketCount" name="markTicketCount" readonly="readonly"/></td></tr>
			<tr><th>注册&emsp;&emsp;时间:</th><td><input id="createTime" name="createTime" readonly="readonly"/></td></tr>
			</table>
			</form>
		</div>