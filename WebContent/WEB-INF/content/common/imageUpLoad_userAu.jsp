<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个个人用户认证图片的文件上传的对话框,作为一个组件嵌入到其他页面的中 ,需要Jquery,easyUI的支持-->
<!-- 用户可以通过 common_userAu_fileUpLoadDialogInitFunction(successFunction,failFunction)来调用此对话框 
其中successFunction会传回一个json数据data，data.object.urls表示每个图片的url；其中图片的urls用于前台图片的显示
-->
<script type="text/javascript">
var common_userAu_fileUpLoadDialog;
var common_userAu_fileUpLoadForm;
var common_userAu_fileUpLoad_options;

$(function(){
	   common_userAu_fileUpLoadDialog=$("#common_userAu_fileUpLoadDialog");
	   common_userAu_fileUpLoadForm=$("#common_userAu_fileUpLoadForm");
	   common_userAu_fileUpLoadDialogInit('上传图片','上传','icon-save');	   
});
/**
 * 供外部调用的函数，对successFunction将会传入一个data参数
 */
function common_userAu_fileUpLoadDialogInitFunction(successFunction,failFunction){
	 common_userAu_fileUpLoadDialogInit(successFunction,failFunction);
	 common_userAu_fileUpLoadDialog.dialog('open');
}

/**
 *对话框初始化,标题,按钮名称,按钮图标
*/
function common_userAu_fileUpLoadDialogInit(successFunction,failFunction)
{  common_userAu_fileUpLoadFormSubmitInit(successFunction,failFunction);
	
	common_userAu_fileUpLoadDialog.dialog({
		title: '上传',
	    width: 600,
	    //height: 200,
	    closed:true,
	    cache: false,
	    //href: 'get_content.php',
	    modal: true,
	    buttons:[{
             text:'上传',
            iconCls:'icon-save',
            handler:function(){
            	common_userAu_fileUpLoadFormSumit2();
             }}] 
	                         
	});
};

function common_userAu_fileUpLoadFormSubmitInit(successFunction,failFunction){
	//alert("文件上传表单提交了！");
	common_userAu_fileUpLoad_options={
		url:"<%=request.getContextPath()%>/user/uploadUserAuImage.json",
		type : 'post',
		dataType : 'json',
		success : function(data) {
			console.info(data);
			
			if(data.success&&typeof successFunction=='function')
    		{
    		 successFunction(data);    		     		 
    		} else if(!data.success&&typeof failFunction=='function')
    	{
    			failFunction(data);
    	};
    	
    	if(data.success){
   		 //添加成功后关闭对话框并刷新单签datagrid
	    		common_userAu_fileUpLoadDialog.dialog("close");}
   	
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
		timeout:10000,
		error: function(XMLHttpRequest, textStatus, errorThrown){
		         },
	};
	
}

function common_userAu_fileUpLoadFormSumit2()
{  
		common_userAu_fileUpLoadForm.ajaxSubmit(common_userAu_fileUpLoad_options);
	}





function common_userAu_fileUpload(data) {
	var filepath = data;
	var extStart = filepath.lastIndexOf(".");
	var ext = filepath.substring(extStart, filepath.length).toUpperCase();
	if (ext != ".BMP" && ext != ".PNG" && ext != ".JPG"&& ext != ".JPEG") {
    alert("图片限于bmp,png,jpeg,jpg格式");
    return false;
	}  
	return true;
}


function addNewUploadFile(e){
	
	var data=e.value;
	if(!wgUtils.isUsed(data))
		{
		//$("#fileUpload").val('');
		return;
		}
	if(!common_userAu_fileUpload(data))
	{	//$("#fileUpload").val('');
		return;
	
	}//console.info(data);
	//$("#fileDiv_"+common_userAu_j).append("");
	
}

function resetForm(){
	
	$("#newUpload2").html('');
	$("#fileUpload_1").val('');
}


</script>

<!-- 增加或者编辑用户的对话框 -->
<div id="common_userAu_fileUpLoadDialog">
    <form name="common_userAu_fileUpLoadForm" id="common_userAu_fileUpLoadForm" onsubmit="beforeSubmitTest();" action="<%=request.getContextPath()%>/file/uploadImages.do" enctype="multipart/form-data" method="post" >
		<div id="fileDiv_1">
			<input type="file" name="file" id="fileUpload_1" onchange="addNewUploadFile(this);">
			</div>
	</form>
</div>