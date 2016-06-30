<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%  
String path = request.getContextPath();  
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";  
%>  
<html>
<head>
<jsp:include page="../include.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
.thright th{
text-align: right;
}
</style>
<Script language="JavaScript" type="text/javascript">
var userAdd_topicForm;
	
$(function (){
	userAdd_topicForm=$("#userAdd_topicForm");
	
	userAdd_topicFormInit();
});

function common_getAddress(){
	common_treeDialogInit("选择","确定","icon-add",search_getAddressTreeIdAndName);
	common_treeDialog_treeInit("/getAddress.json");
	common_treeDialog.dialog('open');	
}

function common_getThingSort(){
	common_treeDialogInit("选择","确定","icon-add",search_getThingSortTreeIdAndName);
	common_treeDialog_treeInit("/getThingSort.json");
	common_treeDialog.dialog('open');	
}

function search_getThingSortTreeIdAndName(){
	$("#userAdd_topicForm #thingSort").val(treeTreeName);
	$("#userAdd_topicForm input[name=thingSortId]").val(treeTreeId);
	
}

function search_getAddressTreeIdAndName(){
	$("#userAdd_topicForm #address").val(treeTreeName);
	$("#userAdd_topicForm input[name=addressId]").val(treeTreeId);        	
}

function submintUserAddTopicForm()
{   //alert("提交表单中!");
	userAdd_topicForm.submit();
	}


function userAddTopic_keyEvent(){//表单的回车提交功能
	$("#userAdd_topicForm input").bind('keyup',function(event){
		if(event.keyCode=='13'){//enter键的编号是13
			userAdd_topicForm.submit();
		}
	});
}

/**
 *用户增加表单的初始化
*/
function userAdd_topicFormInit()
{   var url="<%=request.getContextPath()%>/user/addTopic.json";
	userAdd_topicForm.form({
	    url:url,
	    contentType:"application/x-www-form-Urlencoded; charset=utf-8",
	    method:"post",
	    onSubmit: function(){
	        if(!userAdd_topicForm.form('validate'))
	    	{  alert("请输入完整且符合要求的主题信息！");
	        	return false;
	        	}
	        return true;
	    },
	    success:function(data){       	    	
	    	if(typeof data!='object')
	    		{//如果不是Json数据,那么转换成为JSON
	    		try{
	    		data=jQuery.parseJSON(data);}
	    		catch(e){
	    		alert("发布失败！请检查您的登录状态！");
	    			return; 
	    		 }
	    		}	        	
	    	if(typeof data.msg!="undefined"){
	    	alert(data.msg);	       	    		
	    	if(data.success){
	    		window.top.location.href="<%=request.getContextPath()%>/topic/showTopicDeteils.do?id="+data.object;
	    	}
	    	}
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
       		   var html="<img height=\"300px\" width=\"300px\" src=\" "+img+ " \"  alt=\"图片加载失败了！\" /> ";
       		   //alert(html);
       		   userAddTopic_img_div.append(html);
       		   }
       	   }
         
       }
        
        </Script>
<title>发布主题</title>
</head>
<body>
<div style="width:1280px;" align="left">
    <form id="userAdd_topicForm" method="post" >
	<table class="thright">
		<tr><th></th><td><input id="id" name="id" type="hidden" readonly="readonly"/></td></tr>				
		<tr><th style="width:100px">主题名:</th><td><input class="easyui-validatebox" data-options="required:true" id="name" name="name"/></td></tr>
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
		<tr><th>交易详情:</th><td><input  class="easyui-textbox" data-options="required:true,validType:'length[20,500]',type:'text',multiline:true," style="width:500px;height:200px" id="describe" name="describe" /></td></tr>
	<tr align="center"><td>
	<input type="button" onclick="userAddTopic_upLoadFile();" value="上传图片"/></td>
	<td><input type="button" value="提交" onclick="submintUserAddTopicForm()"></td>
	</tr>
	</table>
	</form>
	<div style="padding-left: 20px;" id="userAddTopic_img_div">
	
	</div>
		<jsp:include page="../common/tree_dialog.jsp"></jsp:include>
		<jsp:include page="../common/fileUpLoad.jsp"></jsp:include>
		</div>
</body>
</html>