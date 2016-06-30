<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个公共的增加或者编辑地址Address的对话框,作为一个组件嵌入到其他页面 ,需要Jquery,easyUI的支持-->
<!-- 通过调用相关函数,并传入相关参数可以完成相应的功能 -->  
<script type="text/javascript">
var common_add_edit_addressDialog;
var common_add_edit_addressForm;

$(function(){
	   common_add_edit_addressDialog=$("#common_add_edit_addressDialog");
	   common_add_edit_addressForm=$("#common_add_edit_addressForm");
	   
	   common_add_edit_addressDialogInit("增加地址","增加","icon-add");
	   common_add_editAddress_keyEvent();
});
/**
 *仅当isAdmin为true的时候,是管理员调用 
 *@param data 加载到表单中的一个json数据,键值对名称和表单input中name对应
 *@param url 编辑用户的url,绝对路径
 *@param isAdmin 仅当isAdmin为true的时候,是管理员调用 
 *@param successFunction 后台操作数据成功的时候,执行的函数,传回两个参数,分别是表单数据和后台返回的数据
 *@param falseFunction 后台操作失败的时候执行的函数,传回两个参数,分别是表单数据和后台返回的数据
 */
function common_addAddress(url,data,successFunction,falseFunction)
{     
	common_add_edit_addressDialogInit("增加地址","增加","icon-add");
	common_add_edit_addressFormInit(url,successFunction,falseFunction);
	$("#common_add_edit_addressForm input").val('');
	$("#common_addressForm_pName").html("<th id=\"common_addressForm_idThing\">父地址名称:</th><td><input readonly=\"readonly\" id=\"pName\" name=\"pName\"/></td>");
	common_add_edit_addressForm.form('load',data);
	$("#common_addressForm_idThing").html("父地址编号:");
	common_add_edit_addressDialog.dialog("open");
};
/**
 * @param data 加载到表单中的一个json数据,键值对名称和表单input中name对应
 * @param url 编辑用户的url,绝对路径
 * @param successFunction 后台操作数据成功的时候,执行的函数,同时传入当前表单的数据,传回两个参数,分别是表单数据和后台返回的数据
 * @param falseFunction 后台操作失败的时候执行的函数,同时传入当前表单的数据,传回两个参数,分别是表单数据和后台返回的数据
 */
function common_editAddress(data,url,successFunction,falseFunction)
{//将表单内容填充,然后打开对话框
	common_add_edit_addressDialogInit("编辑地址","保存","icon-save");
	common_add_edit_addressFormInit(url,successFunction,falseFunction);	
	$("#common_add_edit_addressForm input").val('');
	$("#common_addressForm_pName").html("");
	common_add_edit_addressForm.form('load',data);
	$("#common_addressForm_idThing").html("地址编号:");
	common_add_edit_addressDialog.dialog("open");   
};
/**
 *对话框初始化,标题,按钮名称,按钮图标
*/
function common_add_edit_addressDialogInit(title,btnName,icon)
{
	common_add_edit_addressDialog.dialog({
		title: title,
	    //width: 400,
	    //height: 200,
	    closed:true,
	    cache: false,
	    //href: 'get_content.php',
	    modal: true,
	    buttons:[{
             text:btnName,
            iconCls:icon,
            handler:function(){
            	common_add_edit_addressForm.submit();
             }}] 
	                         
	});
};
/**
 *用户增加表单的初始化
*/
function common_add_edit_addressFormInit(url,successFunction,falseFunction)
{
	common_add_edit_addressForm.form({
	    url:'<%=request.getContextPath()%>'+url,
	    contentType:"application/x-www-form-Urlencoded; charset=utf-8",
	    method:"post",
	    ajax:true,
	    dataType:'json',
	    onSubmit: function(){
	        return common_add_edit_addressForm.form('validate');
	    },
	    success:function(data){       	    	
	    	//console.info("data:");
	    	//console.info(data);
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
	    		 successFunction(wgUtils.serializeObject(common_add_edit_addressForm),data);	    		    		 
	    		} else if(!data.success&&typeof falseFunction=='function')
	    	{
	    			falseFunction(wgUtils.serializeObject(common_add_edit_addressForm),data);
	    	}	    
	    	if(data.success){
	    		//添加成功后关闭对话框并刷新单签datagrid
	    		common_add_edit_addressDialog.dialog("close");
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
function common_add_editAddress_keyEvent(){//表单的回车提交功能
	$("#common_add_edit_addressForm input").bind('keyup',function(event){
		if(event.keyCode=='13'){//enter键的编号是13
			common_add_edit_addressForm.submit();
		}
	});
}
</script>

<!-- 增加或者编辑用户的对话框 -->
<div id="common_add_edit_addressDialog">
		    <form id="common_add_edit_addressForm" method="post">
			<table>			
				<tr><th id="common_addressForm_idThing">父地址编号:</th><td><input readonly="readonly" id="id" name="id"/></td></tr>
				<tr id="common_addressForm_pName"></tr>
				<tr><th>地址名称:</th><td><input class="easyui-validatebox"  data-options="required:true" id="text" name="text" /></td></tr>
			</table>
			</form>
		</div>