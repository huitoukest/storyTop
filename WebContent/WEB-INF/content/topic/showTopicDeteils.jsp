<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="com.tingfeng.model.User" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%  
String path = request.getContextPath();  
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";  
%>  
<html>
<head>
<%@page import="com.tingfeng.staticThing.UploadFolder" %>
<jsp:include page="../include.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
#showTopicDeteild_table dl dt {
	font-family: "微软雅黑";
	font-size: 10pt;
	color: #333;
	padding: 0px;
	float: left;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	margin-left: 15px;
	text-align: right;
	width: 150px;
	font-weight: bold;
}
#showTopicDeteild_table dl dd {
	float: left;
	margin-left: 15px;
	color: #0066CC;
}
#showTopicDeteild_table dl {
	clear: left;
	line-height: 40px;
	margin: 0px;
	padding: 0px;
}
#showTopicDeteils_div .jyxq {
	margin: 15px;
	border-top-width: 1px;
	border-top-style: dotted;
	border-top-color: #CCC;
	overflow: hidden;
	position: relative;
}
#showTopicDeteild_table {
	margin: 15px;
	overflow: hidden;
	position: relative;
}
#showTopicDeteils_div .jyxq dl dt {
	text-align: right;
	width: 150px;
	margin-left: 15px;
	font-size: 10pt;
	font-weight: bold;
	font-family: "微软雅黑";
	position: absolute;
	top: 20px;
	height: 25px;
}
#showTopicDeteils_div .jyxq dl {
	padding: 0px;
	margin-top: 15px;
	margin-right: 0px;
	margin-bottom: 0px;
	margin-left: 0px;
}
#showTopicDeteils_div .jyxq dl dd {
	margin-left: 180px;
	margin-top: 15px;
	width: 800px;
	color: #333;
	font-family: "微软雅黑";
	font-size: 10pt;
	line-height: 30px;
	position: relative;
	letter-spacing: 1px;
}

</style>
<Script language="JavaScript" type="text/javascript">
var topicDeteils_id;
var loginUserId=-1;
var isCollectionedT=false;

$(function (){
	<%
	if(request.getParameter("id")!=null) {%>
	   topicDeteils_id=<%=request.getParameter("id")%>;
	<%}%>
	
	<%if(request.getSession().getAttribute("user")!=null){
		   User user=(User)request.getSession().getAttribute("user");
		if(user!=null) 
		{%> loginUserId=<%=user.getId()%>;
			<%} }%>
		
    isCollectionedTopic();
	get_topics_catalog_thingSort();
	common_userAuthenticationState();
	topicImageLarge();
	
	
});

function isCollectionedTopic()
{   //var isok=false;
	  $.ajax({
		    async:true,
		    cache:false,
		    type:"post",
		    url:"<%=request.getContextPath()%>/isCollectionedTopic.json?topicId="+topicDeteils_id,
		    contentType:"application/x-www-form-urlencoded; charset=utf-8",
		    dataType:"json",
		    success:function(msg)
		        {   
		    	//alert(msg.success);
		    	isCollectionedT=msg.success;
		        },
		    });
	///return isok;
	}
        function get_topics_catalog_thingSort()
	    { var url='<%=request.getContextPath()%>/getAllTopics.json?id='+topicDeteils_id;
	        	$.ajax({
	        		url:url,
	        		async:true,
	                cache:false,
	                type:"post",
	                contentType:"application/x-www-form-urlencoded; charset=utf-8",
	                dataType:"json",
	                success:function(msg)
	                    {
	                       if(wgUtils.isUsed(msg.total)){
	                       var data=msg.rows[0];
	                       console.info("data");
	                       console.info(data);
	                    	  // $("#showTopicDeteils_topicForm").form('load',data); 
	                    	  var ss="#showTopicDeteild_table ";
	                    	  
	                    	  //alert(isCollectionedT);
	                    	  //alert("loginUserId:"+loginUserId);
	                    	  if(loginUserId!=-1&&loginUserId!=data.user.id&&!isCollectionedT){
	                    		  //如果不是登陆用户发布的主题
	                    		  var html="收藏此主题";
	                    		$("#CollectionTopic_a").html(html);  
	                    	    
	                    	  }else if(loginUserId!=-1&&isCollectionedT){	                    		
	                    		  $("#CollectionTopic_span").html("主题已收藏！");
	                    		  
	                    	  }else{
	                    		  $("#CollectionTopic_a").html("");  
	                    	  }
	                    	  
	                    	  $(ss+"#name").html(data.name);
	                    	 
	                    	  var type=data.type;
	                    	  if(type==1){
	                    		  type="出售";
	                    	  } else if(type==2){
	                    		  type="求购";
	                    	  } else if(type==4){
	                    		  type="交换";
	                    	  }else if(type==3){
	                    		  type="赠送";
	                    	  }
	                    	 
	                    	  $(ss+"#type").html(type);
	                    	  
	                    	 //alert("data.user.name="+data.user.name);
	                    	  $(ss+"#user").html(data.user.name);
	                    	  //console.info( $(ss+"#user"));
	                    	  $(ss+"#address").html(data.address.name);
	                    	  $(ss+"#thingSort").html(data.thingSort.name);
	                    	  
	                    	  var buyWay=data.buyWay;
	                    	  if(buyWay==1){
	                    		  buyWay="面交";
	                    	  }else if(buyWay==2){
	                    		  buyWay="远程交易";
	                    	  }else if(buyWay==3){
	                    		  buyWay="待商议";
	                    	  }
	                    	  $(ss+"#buyWay").html(buyWay);
	                    	  var oldLevel=data.oldLevel;
	                    	  
	                    	  if(oldLevel==10){
	                    		  oldLevel="全新";
	                    	  }else if(oldLevel==9){
	                    		  oldLevel="9新";
	                    	  }else if(oldLevel==8) {
	                    		  oldLevel="8新";
	                    	  }else if(oldLevel==7) {
	                    		  oldLevel="7新";
	                    	  } else if(oldLevel<7){
	                    		  oldLevel="7新以下";
	                    	  }
	                    	  
	                    	  $(ss+"#oldLevel").html(oldLevel);
	                    	  $(ss+"#price").html(data.price);
	                    	  $("#describe").html(data.describe);
	                    	  $("#phone").html(data.phone);
	                    	  
	                    	  showTopicDeteilsImg(msg);
	                       }  
	                    },
	               complete:function(XMLHttpRequest,textStatus)
	                    {},
	              error:function()
	                   {}							
	        	});
      };

      function collectionTopic(){
    	  $.ajax({
  		    async:true,
  		    cache:false,
  		    type:"post",
  		    url:"<%=request.getContextPath()%>/user/saveCollectionTopic.json?topicId="+topicDeteils_id,
  		    contentType:"application/x-www-form-urlencoded; charset=utf-8",
  		    dataType:"json",
  		    success:function(msg)
  		        {   
  		       if(msg.success){
  		    	  $.messager.show({
      				title:"提示",
   	        	msg:msg.msg,
   	        	timeout:5000,
   	        	showType:'slide'
      			 });
  		    	   //location.reload();
  		    	 $("#CollectionTopic_a").html("主题已收藏！");
  		       }else{
  		    	   
  		    	alert(msg.msg);
  		       }
  		        },
  		  error:function()
  		       {
  	
  		       }
  		    });
      }
      
      function showTopicDeteilsImg(data)
      {var showTopicDeteils_img_div=$("#showTopicDeteils_img_div");
    	   data=data.rows[0].images;
           //console.info(data);  	   
    	   for(var i=0;i<data.length;i++){    	   
    		   var img='<%=UploadFolder.getImageDisPlayFolder(request)%>/'+data[i];
    	   //alert(img);
    	   //img="http://localhost:8087/school_eaby/images/b7cb06d94d795f92d7440b8c5a9804ec9c16fdfaaf51f3de4096105595eef01f3a2979df.jpg";
    	   if(wgUtils.isUsed(img))
    		   {
    		   var html="<img onclick=\"topicImageLargeShow('"+img+"')\" height=\"300px\" width=\"300px\" src=\" "+img+ " \"  alt=\"图片加载失败了！\" /><br/><br/> ";
    		   //alert(html);
    		   showTopicDeteils_img_div.append(html);
    		   }
    	   }
      }
      //验证发布此主题的用户是否是认证的用户
      function common_userAuthenticationState() { 
    		var common_userAuthenticationState_td=$("#common_userAuthenticationState_td");
    		$.ajax({
    		    async:true,
    		    cache:false,
    		    type:"post",
    		    url:"<%=request.getContextPath()%>/topic/getTopicUserAuInfo.json?id="+topicDeteils_id,
    		    contentType:"application/x-www-form-urlencoded; charset=utf-8",
    		    dataType:"json",
    		    success:function(msg)
    		        {   
    		       if(msg.success){
    		    	   var data=msg.object;
    		    	      if(!wgUtils.isUsed(data)){
    		    	    	 common_userAuthenticationState_td.html("否");
    		    	      }else
common_userAuthenticationState_td.html("是");
    		    	   
    		       }else{
    		    	   common_userAuthenticationState_td.html("获取失败!");
    		    	
    		       }
    		        },
    		  error:function()
    		       {
    	
    		       }
    		    });
    			}//end function
    			
    			function topicImageLargeShow(img){
    				$("#topicLargeImage").attr('src',img);
    				$('#topicImageLargeDialog').dialog('open');
    			}
    			
    			function topicImageLarge(){
    				
    				$('#topicImageLargeDialog').dialog({
    				    title: '图片',
    				    width: '75%',
    				    height: '80%',
    				    closed: true,
    				    cache: false,
    				    modal: false,
    				    buttons:[{
    						text:'关闭',
    						handler:function(){
    							$('#topicImageLargeDialog').dialog('close');
    						}
    					}],
    				});
    			}
    			
        </Script>
<title>主题详情</title>
</head>
<body>
<div style="width:1280px">
		<div id="showTopicDeteils_div" align="left">
	<div id="showTopicDeteild_table">
    
    <dl>    
    <dt>主&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;题&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名:</dt>
    <dd id="name" name="name"></dd>
    <dd>&nbsp;&nbsp;&nbsp;<a href="javascript:void(0);" style="text-decoration: none;" onclick="collectionTopic()" id="CollectionTopic_a"></a>
		<span id="CollectionTopic_span"></span></dd>
    </dl>
    	
     <dl>    
    <dt>是否认证学生用户:</dt>
    <dd id="common_userAuthenticationState_td"></dd>
    </dl>
    
       <dl>    
    <dt>主&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;题&nbsp;&nbsp;&nbsp;&nbsp;分&nbsp;&nbsp;&nbsp;&nbsp;类:</dt>
    <dd id="type" name="type"></dd>
    </dl>
    
       <dl>    
    <dt>发&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;布&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;人:</dt>
    <dd id="user" name="user"></dd>
    </dl>
       <dl>    
    <dt>地&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;点:</dt>
    <dd id="address" name="address"></dd>
    </dl>
    
    <dl>    
    <dt>物&nbsp;&nbsp;&nbsp;&nbsp;品&nbsp;&nbsp;&nbsp;&nbsp;分&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;类:</dt>
    <dd id="thingSort" name="thingSort"></dd>
    </dl>	
    
    <dl>    
    <dt>交&nbsp;&nbsp;&nbsp;&nbsp;易&nbsp;&nbsp;&nbsp;&nbsp;方&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;式:</dt>
    <dd id="buyWay" name="buyWay"></dd>
    </dl>
    
    <dl>    
    <dt>联&nbsp;&nbsp;&nbsp;&nbsp;系&nbsp;&nbsp;&nbsp;&nbsp;手&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机:</dt>
    <dd id="phone" name="phone"></dd>
    </dl>
    
    <dl>    
    <dt>物&nbsp;&nbsp;&nbsp;&nbsp;品&nbsp;&nbsp;&nbsp;&nbsp;成&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;色:</dt>
    <dd id="oldLevel" name="oldLevel"></dd>
    </dl>
    
    <dl>    
    <dt>交&nbsp;&nbsp;&nbsp;&nbsp;易&nbsp;&nbsp;&nbsp;&nbsp;价&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;格:</dt>
    <dd id="price" name="price"></dd>
    </dl>  
	 </div>
     <div class="jyxq">  
     <dl>
	<dt>交&nbsp;&nbsp;&nbsp;&nbsp;易&nbsp;&nbsp;&nbsp;&nbsp;详&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;情:</dt>
		<dd rows="6" cols="150" id="describe" name="describe"></dd>
		</dl></div>
	<br/>
	<div id="showTopicDeteils_img_div" style="margin-left: 200px">
	
	
	</div>
		</div>
		
<div id="topicImageLargeDialog" align="center">
 <img id="topicLargeImage" src=""  alt=\"图片加载失败了！\" /> 
 </div>
 </div>
</body>
</html>