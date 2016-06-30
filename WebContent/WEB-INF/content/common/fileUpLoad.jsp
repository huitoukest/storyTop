<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个公共的文件上传的对话框,作为一个组件嵌入到其他页面的中 ,需要Jquery,easyUI的支持-->
<!-- 用户可以通过 common_fileUpLoadDialogInitFunction(successFunction,failFunction)来调用此对话框 
其中successFunction会传回一个json数据data，data.object.urls表示每个图片的url；其中图片的urls用于前台图片的显示
-->
<%response.setHeader("Cache-Control","no-cache");%>
<style type="text/css">
.uploadBigFont{
font-size: 15pt;
}

</style>
<script type="text/javascript">
var common_fileUpLoadDialog;
var common_fileUpLoadForm;
var common_j=1;
var common_fileUpLoad_options;
var htmls;

$(function(){
	   common_fileUpLoadDialog=$("#common_fileUpLoadDialog");
	   common_fileUpLoadForm=$("#common_fileUpLoadForm");
	   common_fileUpLoadDialogInit();	   
       //htmls=$("#common_fileUpLoadDialog").html(); 
});
/**
 * 供外部调用的函数，对successFunction将会传入一个data参数
 */
function common_fileUpLoadDialogInitFunction(successFunction,failFunction){
	 common_fileUpLoadDialogInit(successFunction,failFunction); 
	 document.getElementById("common_fileUpLoadForm").reset();
	 common_fileUpLoadDialog.dialog('open');
}

function common_del_2(o){  
    document.getElementById("newUpload2").removeChild(document.getElementById("div_"+o));  
}
/**
 *对话框初始化,标题,按钮名称,按钮图标
*/
function common_fileUpLoadDialogInit(successFunction,failFunction)
{  common_fileUpLoadFormSubmitInit(successFunction,failFunction);
	
	common_fileUpLoadDialog.dialog({
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
            	common_fileUpLoadFormSumit2();
             }}] 
	                         
	});
};

function common_fileUpLoadFormSubmitInit(successFunction,failFunction){
	//alert("文件上传表单提交了！");
	common_fileUpLoad_options={
		url:"<%=request.getContextPath()%>/file/uploadImages.json",
		type : 'post',
		dataType : 'json',
		async:true,
		processData: false,// 防止 data 被预处理
		success : function(data) {
			console.info(data);
			
			if(data.success&&typeof successFunction=='function')
    		{
    		 successFunction(data);
    		//$("#common_fileUpLoadDialog").html(htmls);
    		} else if(!data.success&&typeof failFunction=='function')
    	{
    			failFunction(data);
    	};
    	
    	if(data.success){
   		 //添加成功后关闭对话框并刷新单签datagrid
	    		common_fileUpLoadDialog.dialog("close");}
   	
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
		         //TODO: 处理status， http status code，超时 408		  
		         // 注意：如果发生了错误，错误信息（第二个参数）除了得到null之外，还可能		  
		               //是"timeout", "error", "notmodified" 和 "parsererror"。
		  
		         },
	};
	
}

function common_fileUpLoadFormSumit2()
{    //console.info("common_fileUpLoad_options:");
    // console.info(common_fileUpLoad_options);
	//if (common_fileUpload())
		//alert("表单异步提交了！");
		common_fileUpLoadForm.ajaxSubmit(common_fileUpLoad_options);
	}





function common_fileUpload(data) {
	var filepath = data;
	var extStart = filepath.lastIndexOf(".");
	var ext = filepath.substring(extStart, filepath.length).toUpperCase();
	if (ext != ".BMP" && ext != ".PNG" && ext != ".JPG"&& ext != ".JPEG") {
    alert("图片限于bmp,png,jpeg,jpg格式");
    return false;
	}  //var img = new Image();
	   //img.src = filepath;
	  //while (true) {
		//if (img.fileSize > 0) {
			//if (img.fileSize > 3 * 1024) {
				//alert("图片不大于300KB。");
				//return false;
			//}
			//break;
		//}
	//}
	return true;
}


function addNewUploadFile(e){
	
	var data=e.value;
	if(!wgUtils.isUsed(data))
		{
		//$("#fileUpload").val('');
		return;
		}
	if(!common_fileUpload(data))
	{	//$("#fileUpload").val('');
		return;
	
	}//console.info(data);
	//$("#fileDiv_"+common_j).append("");
	
}

function deleteFileDiv(j){
   //document.getElementById("newUpload2").removeChild(document.getElementById("fileDiv_"+j));
   var newUpload2=$("#newUpload2");
   var fileDiv=$("#fileDiv_"+j);
   console.info(newUpload2);
   console.info(fileDiv);
   
   
}

function beforeSubmitTest(){
	//alert("beforeSubmitTest");
	//return false;
}
function resetForm(){
	
	$("#newUpload2").html('');
	$("#fileUpload_1").val('');
}

function addNewLine(){
    common_j++;
	var html="<br/><div id=\"fileDiv_"+common_j+" \"><input type=\"file\" name=\"file_"+common_j+"\" id=\"fileUpload_"+common_j+"\" onchange=\"addNewUploadFile(this);\"></div>";
    $("#newUpload2").append(html);
}


</script>

<!-- 增加或者编辑用户的对话框 -->
<div id="common_fileUpLoadDialog">
    <form name="common_fileUpLoadForm" id="common_fileUpLoadForm" onsubmit="beforeSubmitTest();" action="<%=request.getContextPath()%>/file/uploadImages.do" enctype="multipart/form-data" method="post" >
		<div id="fileDiv_1">
			<input type="file" name="file" id="fileUpload_1" onchange="addNewUploadFile(this);">
			</div>
		<div id="newUpload2">
						
		</div>
		<div align="center" class="uploadBigFont">
		<label onclick="addNewLine();">增加一行</label>
		&nbsp;&nbsp;<label onclick="resetForm();">重置</label>
		</div>
	</form>
</div>