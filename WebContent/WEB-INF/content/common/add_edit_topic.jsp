<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个公共的增加或者编辑主题的对话框,作为一个组件嵌入到其他页面 ,需要Jquery,easyUI的支持-->
<!-- 通过调用相关函数,并传入相关参数可以完成相应的功能 -->  
<script type="text/javascript">
var common_add_edit_topicDialog;
var common_add_edit_topicForm;
var add_edit_topic_adressTreeId=-1;
var add_edit_topic_thingSortTreeId=-1;
$(function(){
	   common_add_edit_topicDialog=$("#common_add_edit_topicDialog");
	   common_add_edit_topicForm=$("#common_add_edit_topicForm");
	   
	   common_add_edit_topicDialogInit("增加","增加","icon-add");
	   common_add_editTopic_keyEvent();
});
/**
 *仅当isTopic为true的时候,是管理员调用 
 *@param data 加载到表单中的一个json数据,键值对名称和表单input中name对应
 *@param url 编辑用户的url,绝对路径
 *@param isTopic 仅当isTopic为true的时候,是管理员调用 
 *@param successFunction 后台操作数据成功的时候,执行的函数
 *@param falseFunction 后台操作失败的时候执行的函数
 */
function common_addTopic(url,isTopic,successFunction,falseFunction)
{   add_edit_topic_adressTreeId=-1;
add_edit_topic_thingSortTreeId=-1;
	if(!wgUtils.isUsed(isTopic)||!isTopic){
			//alert("已经执行!");
			$("#common_add_edit_topicForm #user").attr({'editable':false,"readonly":"readonly"});
			$("#common_add_edit_topicForm #userId").attr({'editable':false,"readonly":"readonly"});
		} else {
			$("#common_add_edit_topicForm #user").attr({'editable':true,"readonly":false});
			$("#common_add_edit_topicForm #userId").attr({'editable':true,"readonly":false});
		}
	common_add_edit_topicDialogInit("增加","增加","icon-add");
	common_add_edit_topicFormInit(url,successFunction,falseFunction);
	$("#common_add_edit_topicForm input").val('');
	$("#common_add_edit_topicForm #phone").numberbox('clear');
	$('#common_add_edit_topicForm #describe').textbox('clear');
	$("#common_add_edit_topicForm #upload_img_input").val("上传图片");
	common_add_edit_topicDialog.dialog("open");
};
/**
 * @param data 加载到表单中的一个json数据,键值对名称和表单input中name对应
 * @param url 编辑用户的url,绝对路径
 * @param isTopic 仅当isTopic为true的时候,是管理员调用 
 * @param successFunction 后台操作数据成功的时候,执行的函数
 * @param falseFunction 后台操作失败的时候执行的函数
 */
function common_editTopic(data,url,isTopic,successFunction,falseFunction)
{    add_edit_topic_adressTreeId=data.addressId;
     add_edit_topic_thingSortTreeId=data.thingSortId;
	//将表单内容填充,然后打开对话框
     if(!wgUtils.isUsed(isTopic)||!isTopic){
			//alert("已经执行!");
			$("#common_add_edit_topicForm #user").attr({'editable':false,"readonly":"readonly"});
			$("#common_add_edit_topicForm #userId").attr({'editable':false,"readonly":"readonly"});
		} else {
			$("#common_add_edit_topicForm #user").attr({'editable':true,"readonly":false});
			$("#common_add_edit_topicForm #userId").attr({'editable':true,"readonly":false});
		}
	common_add_edit_topicDialogInit("编辑","保存","icon-save");
	common_add_edit_topicFormInit(url,successFunction,falseFunction);	
	$("#common_add_edit_topicForm input").val('');
	$("#common_add_edit_topicForm #upload_img_input").val("上传图片");
	common_add_edit_topicForm.form('load',data);            
	common_add_edit_topicDialog.dialog("open");   
};
/**
 *对话框初始化,标题,按钮名称,按钮图标
*/
function common_add_edit_topicDialogInit(title,btnName,icon)
{
	common_add_edit_topicDialog.dialog({
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
            	common_add_edit_topicForm.submit();
             }}] 
	                         
	});
};
/**
 *用户增加表单的初始化
*/
function common_add_edit_topicFormInit(url,successFunction,falseFunction)
{
	common_add_edit_topicForm.form({
	    url:'<%=request.getContextPath()%>'+url,
	    contentType:"application/x-www-form-Urlencoded; charset=utf-8",
	    method:"post",
	    onSubmit: function(){
	        return common_add_edit_topicForm.form('validate');
	    },
	    success:function(data){       	    	
	    	if(typeof data!='object')
	    		{//如果不是Json数据,那么转换成为JSON
	    		try{
	    		data=jQuery.parseJSON(data);}
	    		catch(e){
	    		alert("由于某些系统原因增加失败!请稍后再试!");
	    			return; 
	    		 }
	    		}	    
	    	
	    	if(data.success){
	    		//添加成功后关闭对话框并刷新单签datagrid
	    		common_add_edit_topicDialog.dialog("close"); 
	    	}
	    	
	    	if(data.success&&typeof successFunction=='function')
    		{
    		 successFunction();
    		 
    		} else if(!data.success&&typeof falseFunction=='function')
    	{
    			falseFunction();
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

function common_add_editTopic_keyEvent(){//表单的回车提交功能
	$("#common_add_edit_topicForm input").bind('keyup',function(event){
		if(event.keyCode=='13'){//enter键的编号是13
			common_add_edit_topicForm.submit();
		}
	});
}

function getAdressTreeIdAndName(){
	$("#common_add_edit_topicForm #address").val(treeTreeName);
	$("#common_add_edit_topicForm #addressId").val(treeTreeId);
}

function common_getAddress(){
	common_treeDialogInit("选择","确定","icon-add",getAdressTreeIdAndName);
	common_treeDialog_treeInit("/getAddress.json",add_edit_topic_adressTreeId);
	common_treeDialog.dialog('open');	
}

function getThingSortTreeIdAndName(){
	$("#common_add_edit_topicForm #thingSort").val(treeTreeName);
	$("#common_add_edit_topicForm #thingSortId").val(treeTreeId);
}

function common_getThingSort(){
	common_treeDialogInit("选择","确定","icon-add",getThingSortTreeIdAndName);
	common_treeDialog_treeInit("/getThingSort.json",add_edit_topic_thingSortTreeId);
	common_treeDialog.dialog('open');	
}


function userAddSuccessFunction(data){
	//console.info("data");
	//console.info(data);
	userAddTopicImg(data);
}

function userAddfailFunction(){
	//alert("fail");
}

function userAddTopic_upLoadFile()
{
	common_fileUpLoadDialogInitFunction(userAddSuccessFunction,userAddfailFunction);
}


function userAddTopicImg(data)
{ var userAddTopic_img_div=$("#userAddTopic_img_div");
   userAddTopic_img_div.html('');
 
	   data=data.object.urls;
      //console.info(data);  	   
	   for(var i=0;i<data.length;i++){    	   
		   var img=data[i];
	   //alert(img);
	   //img="http://localhost:8087/school_eaby/images/b7cb06d94d795f92d7440b8c5a9804ec9c16fdfaaf51f3de4096105595eef01f3a2979df.jpg";
	   if(wgUtils.isUsed(img))
		   {
		   var html="<img height=\"100px\" width=\"100px\" src=\" "+img+ " \"  alt=\"图片加载失败了！\" /> ";
		   //alert(html);
		   userAddTopic_img_div.append(html);
		   }
	   }
 
}

</script>

<!-- 增加或者编辑用户的对话框 -->
<div id="common_add_edit_topicDialog">
    <form id="common_add_edit_topicForm" method="post">
	<table>
		<tr><th></th><td><input id="id" name="id" type="hidden" readonly="readonly"/></td></tr>				
		<tr><th>主题名:</th><td><input class="easyui-validatebox" data-options="required:true" id="name" name="name"/></td></tr>
		<tr><th>主题分类:</th><td>
				 <input class="easyui-combobox" id="type" name="type" data-options="
				                                editable:false,
				                                required:true,
												valueField: 'value',
												textField: 'label',
												data: [{
													label: '出售',
													value:1
												},{
													label: '求购',
													value: 2
												},{
													label: '赠送',
													value: 3
												},{
													label: '交换',
													value: 4
												}]" />
				</td></tr>
		
		<tr><th>发布人:</th><td><input class="easyui-validatebox"  data-options="required:false,editable:false" readonly="readonly" id="user " name="user" /></td></tr>
		<tr><th>发布人编号:</th><td><input class="easyui-validatebox"  data-options="required:true" id="userId" name="userId"  readonly="readonly"/></td></tr>
		
		<tr><th>地点:</th><td><input class="easyui-validatebox" onclick="common_getAddress();"  data-options="required:false,editable:false" readonly="readonly"  id="address" name="address"/></td></tr>
		<tr><th></th><td><input class="easyui-validatebox" type="hidden" data-options="required:true" id="addressId" name="addressId" /></td></tr>
		
		<tr><th>物品分类:</th><td><input class="easyui-validatebox"  onclick="common_getThingSort();" data-options="required:false,editable:false" readonly="readonly" id="thingSort" name="thingSort" /></td></tr>
		<tr><td><input class="easyui-validatebox"  type="hidden" data-options="required:true" id="thingSortId" name="thingSortId" /></td></tr>
		
		<tr><th>交易方式:</th><td>
				 <input class="easyui-combobox" id="buyWay" name="buyWay" data-options="
				                                editable:false,
				                                required:true,
												valueField: 'value',
												textField: 'label',
												data: [{
													label: '面交',
													value:1
												},{
													label: '远程交易',
													value: 2
												},{
													label: '可商议',
													value: 3
												}]" />
				</td></tr>
				
		<tr><th>物品成色:</th><td>
				 <input class="easyui-combobox" id="oldLevel" name="oldLevel" data-options="
				                                 required:true,
				                                editable:false,
												valueField: 'value',
												textField: 'label',
												data: [{
													label: '全新',
													value:10
												},{
													label: '9新',
													value: 9
												},{
													label: '8新',
													value: 8
												},{
													label: '7新',
													value: 7
												},{
													label: '7新以下',
													value: 6
												}]" />
				</td></tr>
		<tr><th>交易价格:</th><td><input class="easyui-numberspinner" data-options="required:true,min:0,max:100000000,editable:true" id="price" name="price" /></td></tr>
		<tr><th>联系手机:</th><td><input type="text" class="easyui-numberbox" data-options="min:13000000000,max:18999999999,precision:0,decimalSeparator:''," id="phone" name="phone" /></td></tr>
		<tr><th>交易详情:</th><td><input  class="easyui-textbox" data-options="required:true,validType:'length[20,500]',type:'text',multiline:true," style="width:400px;height:150px" id="describe" name="describe" /></td></tr>
	<tr><td><input id="upload_img_input" type="button" onclick="userAddTopic_upLoadFile();" value="上传图片" /></td></tr>
	</table>
	</form>
	<jsp:include page="../common/fileUpLoad.jsp"></jsp:include>
    <div id="userAddTopic_img_div">
	
	</div>
</div>