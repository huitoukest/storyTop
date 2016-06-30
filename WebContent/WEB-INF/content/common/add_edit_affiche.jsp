<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个公共的增加或者编辑网站攻啊工的对话框,作为一个组件嵌入到其他页面 ,需要Jquery,easyUI的支持-->
<!-- 通过调用相关函数,并传入相关参数可以完成相应的功能 -->  
<script type="text/javascript">
var common_add_edit_afficheDialog;
var common_add_edit_afficheForm;
//var common_add_edit_afficheFormSubmit=-1;
$(function(){
	   common_add_edit_afficheDialog=$("#common_add_edit_afficheDialog");
	   common_add_edit_afficheForm=$("#common_add_edit_afficheForm");
	   
	   common_add_edit_afficheDialogInit("增加用户","增加","icon-add");
	   common_add_editAffiche_keyEvent();
});
/**
 *仅当isAdmin为true的时候,是管理员调用 
 *@param data 加载到表单中的一个json数据,键值对名称和表单input中name对应
 *@param url 编辑用户的url,绝对路径
 *@param isAdmin 仅当isAdmin为true的时候,是管理员调用 
 *@param successFunction 后台操作数据成功的时候,执行的函数
 *@param falseFunction 后台操作失败的时候执行的函数
 */
function common_addAffiche(url,isAdmin,successFunction,falseFunction)
{  
	$("#afficheId_tr").html('');
	$("#publishTime_tr").html('');
	
	common_add_edit_afficheDialogInit("增加公告","增加","icon-add");
	common_add_edit_afficheFormInit(url,successFunction,falseFunction);
	$("#common_add_edit_afficheForm input").val('');
	common_add_edit_afficheDialog.dialog("open");
};
/**
 * @param data 加载到表单中的一个json数据,键值对名称和表单input中name对应
 * @param url 编辑用户的url,绝对路径
 * @param isAdmin 仅当isAdmin为true的时候,是管理员调用 
 * @param successFunction 后台操作数据成功的时候,执行的函数
 * @param falseFunction 后台操作失败的时候执行的函数
 */
function common_editAffiche(data,url,isAdmin,successFunction,falseFunction)
{//将表单内容填充,然后打开对话框
	
	$("#afficheId_tr").html('<th>公告编号:</th><td><input id=\"id\" name=\"id\" readonly=\"readonly\"/></td>');
	$("#publishTime_tr").html('<th>发布时间:</th><td><input id=\"publishTime\" name=\"publishTime\" readonly=\"readonly\"/></td>'); 
	
	
	common_add_edit_afficheDialogInit("编辑公告","保存","icon-save");
	common_add_edit_afficheFormInit(url,successFunction,falseFunction);	
	$("#common_add_edit_afficheForm input").val('');
	
	data.publishTime=wgUtils.getTime(data.publishTime, 0);
	common_add_edit_afficheForm.form('load',data);
	common_add_edit_afficheDialog.dialog("open");   
};
/**
 *对话框初始化,标题,按钮名称,按钮图标
*/
function common_add_edit_afficheDialogInit(title,btnName,icon)
{
	common_add_edit_afficheDialog.dialog({
		title: title,
	     width: 390,
	    //height: 200,
	    closed:true,
	    cache: false,
	    //href: 'get_content.php',
	    modal: true,
	    buttons:[{
             text:btnName,
            iconCls:icon,
            handler:function(){
            	common_add_edit_afficheForm.submit();
            	//common_add_edit_afficheFormSubmit=1;
             }}] 
	                         
	});
};
/**
 *用户增加表单的初始化
*/
function common_add_edit_afficheFormInit(url,successFunction,falseFunction)
{
	common_add_edit_afficheForm.form({
	    url:'<%=request.getContextPath()%>'+url,
	    contentType:"application/x-www-form-Urlencoded; charset=utf-8",
	    method:"post",
	    onSubmit: function(){
	    return common_add_edit_afficheForm.form('validate');
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
	    		common_add_edit_afficheDialog.dialog("close"); 
    		 
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
function common_add_editAffiche_keyEvent(){//表单的回车提交功能
	$("#common_add_edit_afficheForm input").bind('keyup',function(event){
		if(event.keyCode=='13'){//enter键的编号是13
			common_add_edit_afficheForm.submit();
		}
	});
}
</script>

<!-- 增加或者编辑用户的对话框 -->
<div id="common_add_edit_afficheDialog">
		    <form id="common_add_edit_afficheForm" method="post">
			<table>
				<tr id="afficheId_tr"></tr>				
				<tr><th width="60px">公告内容:</th><td><input class="easyui-textbox" data-options="required:true,validType:'length[2,500]',type:'text',multiline:true," style="width:300px;height:90px" id="affiche" name="affiche"/></td></tr>
				<tr><th>是否启用:</th><td>
				 <input class="easyui-combobox" id="isUsing" name="isUsing" data-options="
				                                editable:false,
												valueField: 'value',
												textField: 'label',
												data: [{
													label: '是',
													value:true
												},{
													label: '否',
													value: false
												}]" />
				</td></tr>
			<tr id="publishTime_tr"></tr>
			</table>
			</form>
		</div>