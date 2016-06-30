<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>
<head>
<jsp:include page="../include.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>地址分类</title>
<script type="text/javascript">
var topicCategoryUrl="<%=request.getContextPath()%>/topic/topics_catalog.do?id=-1&type=0&thingSort=1&name=&user=&startTime=&endTime=&isPublishTime=false&rows=10&page=1&order=desc&sort=id&oldLevel=0&sortType=4&address=";
$(function(){
	
	getAddressCategory();

});

function getAddressCategory(){
	var addressCategoryShow_div=$("#addressCategoryShow_div"); 
	$.ajax({
	    async:true,
	    cache:false,
	    type:"post",
	    url:"<%=request.getContextPath()%>/getAddressCategory.json?",
	    contentType:"application/x-www-form-urlencoded; charset=utf-8",
	    dataType:"json",
	    success:function(msg)
	        {  
	    	//console.info(msg);
	       if(msg.success){
	    		var HString="";
	    		if(wgUtils.isUsed(msg.object))
	    		for(var i=0;i<msg.object.length;i++)
	    		{  var data=msg.object[i];
	    		   var aString=getAddressTextHtml(topicCategoryUrl+data.address.id,data.address.name);
	    		   //if(data[i].addressCategory.length<1)
	    			   //continue;
	    			HString=HString+"<div><br/><br/><br/><div style=\"text-align: center;\">"+aString+"</div><hr/>";
	    			//console.info("HString");
	                //console.info(HString);
	    			//continue;
	    			data=data.addressCategory;//得到三级分类子叶子节点的数组,省级
	    			HString=HString+"<table style=\"width:96%;\">";
	    			for(var j=0;j<data.length;j++)
	    			{
	    				var htmlString=getAddressShow(data[j]);
	    				//alert(HString);
	    			  HString=HString+htmlString;    			
	    			}
	    			HString=HString+"</table></div>";   
	    		}
	    		//console.info("HString");
               // console.info(HString);
                addressCategoryShow_div.html(HString);
	    	}
	       
	    	if(!msg.success){
	    	  $.messager.show({
				title:"提示",
	        	msg:msg.msg,
	        	timeout:5000,
	        	showType:'slide'
			 });
	    	   //location.reload();
	    	 //$("#CollectionTopic_a").html("主题已收藏！");
	       }
	        },
	  error:function()
	       {

	       }
	    });
}

//返回每一个节点显示的html代码
function getAddressTextHtml(url,name)
{
	return "<a href=\""+url+"\" style=\"text-decoration:none; margin:0px 0px 0px 0px;color:red; \" >"+name+"</a>";
	}


//三级地址以及子节点的html；
function getAddressShow(data)
{
	if(!wgUtils.isUsed(data))
		return;
    var selectIndex=0;

     var htmlNextLine=7;//9列换一行
     var htmlString="<tr aligh=\"left\" height=\"30px\" >";
	 //传入二级分类的id号码    
	 htmlString=htmlString+"<th align=\"left\"><a href=\""+topicCategoryUrl+data.address.id+"\" style=\"text-decoration:none; margin:0px 0px 0px 0px \" >"+data.address.name+">></a></th></tr><br/>";
	 var htmlStart=true;
	 data=data.addressCategory;
	 
	 for(var k=0;k<data.length;k++)
         { 
      	    selectIndex++;
             if((k+1)%(htmlNextLine+1)==0){
      	    		htmlStirng=htmlString+"<tr aligh=\"left\">";
      	    		htmlStart=true;
      	    	}
      	    	if((k+1)%(htmlNextLine+1)==0){
      	    		htmlString=htmlString+"<td align=\"center\" width=\"128px\"><a href=\""+topicCategoryUrl+data[k].address.id+"\" style=\"text-decoration:none; margin:0px 0px 5px 0px\">";
      	    	}
      	    	else {
      	    		htmlString=htmlString+"<td align=\"center\" width=\"128px\"><a href=\""+topicCategoryUrl+data[k].address.id+"&PthingSort="+data[k].address.id+"\" style=\"text-decoration:none; margin:0px 0px 5px 0px\">";
      	    	}
      	    	
      	    	htmlString=htmlString+data[k].address.name+"</a></td>";
      	    
      	    if((k+1)%htmlNextLine==0){
      	    	htmlStart=false;
      	    	htmlString=htmlString+"</tr>";
      	      }
      	    }	            	    
      	    if(htmlStart){
      	    	htmlString=htmlString+"</tr>";
      	    }
      	    //trObject.append(htmlString);
      	    selectIndex++;
      	 //console.info(htmlString);   
         return htmlString;
 }
 </script>
</head>
<body>
<div style="width:1280px; text-align: left;" id="addressCategoryShow_div">
</div>
</body>
</html>