<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.tingfeng.staticThing.UploadFolder" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个公共的管理员认证图片显示对话框,并且只会显示,作为一个组件嵌入到其他页面 ,需要Jquery,easyUI的支持-->
<script type="text/javascript">
var common_img_topic_Dialog;
var isNeedRefresh=false;
$(function(){
	   common_img_topic_Dialog=$("#common_img_topic_Dialog");	   
	   common_img_topic_DialogInit();
});

/**
 *对话框初始化,标题,按钮名称,按钮图标
*/
function common_img_topic_DialogInit()
{
	common_img_topic_Dialog.dialog({
		title: "图片",
	    width: 750,
	    height: 700,
	    closed:true,
	    cache: false,
	    //href: 'get_content.php',
	    modal: true,
	    buttons:[{
             text:"确定",
            handler:function(){
            	common_img_topic_Dialog.dialog('close');
            	if(isNeedRefresh){
            		topicManage_table_datagrid.datagrid('reload');
            	}
     	   }
             }]});	              
};
/**
 * 删除的图片与主题,然后向后台发送请求
 */
function deleteTopicImg(imageId,topicId){
	//var imgDiv=$("#common_topic_imageSDiv_"+imageId).html(''); 
	//imgDiv=document.getElementById("#common_topic_imageSDiv_"+imageId);
	//console.info(imgDiv);
	//return;
	if(window.confirm("确定要删除主题的此张图片吗？"))
	{
		 //console.info(imageId+"--"+topicId);
		 $.ajax({
				url:'<%=request.getContextPath()%>/admin/deleteTopicImage.json?imageId='+imageId+'&topicId='+topicId,
				async:true,
		        cache:false,
		        type:"post",
		        contentType:"application/x-www-form-urlencoded; charset=utf-8",
		        dataType:"json",
		        success:function(msg)
		            {
		               if(wgUtils.isUsed(msg)){
		            	   $.messager.show({
		       	        	title:"提示",
		       	        	msg:msg.msg,
		       	        	timeout:5000,
		       	        	showType:'slide'
		       	        });
		               
		               if(msg.success){
		            	$("#common_topic_imageSDiv_"+imageId).html('');   
		            	isNeedRefresh=true;
		               }
		               }
		            },
		       complete:function(XMLHttpRequest,textStatus)
		            {},
		      error:function()
		           {}							
			});
	}
}

/**
 * 传入一个用户认证的图片
 */
function img_topic_dialog_setUserAuImg(w,idString,topicId)
{ //alert(w);
//console.info(ids);
//return;
var images=w.split(";");
var ids=idString.split(";");
var html='';
//console.info(images);
	//return;
	if(wgUtils.isUsed(images))
 {	$("#common_topic_imagesDiv").html('');
		//$("#common_userAu_img_topic").src=images[0];
    
 for(var i=0;i<images.length;i++){
	 html=html+"<div id=\"common_topic_imageSDiv_"+ids[i]+"\">图片"+i+":<br/>";
	 html=html+"<img src=\"<%=UploadFolder.getImageDisPlayFolder(request)%>/"+images[i]+"\" id=\"common_userAu_img_topic_"+i+"\" width=\"700px\" alt=\"未找到相关图片!\"/>\"";
	 html=html+"<br/><a href=\"javascript:void(0);\" onclick=\"deleteTopicImg("+ids[i]+","+topicId+") \"><span style=\"color:red\">删除此图片</span></a>";
	 html=html+"<br/><br/></div>";
 }
 
 //alert(html);
 $("#common_topic_imagesDiv").html(html);
    common_img_topic_Dialog.dialog('open');
 }  else{
	  alert("此图片不存在!");
    }
	}

</script>
<div id="common_img_topic_Dialog">
<div id="common_topic_imagesDiv">
</div>		
</div>