<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<html>
<head>
<%@page import="com.tingfeng.staticThing.UploadFolder" %>
<jsp:include page="../include.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<Script language="JavaScript" type="text/javascript">
var topics_catalog_id=<%=request.getParameter("id")%>;
var topics_catalog_type=<%=request.getParameter("type")%>;
var topics_catalog_thingSort=<%=request.getParameter("thingSort")%>;

var topics_catalog_name='<%=request.getParameter("name")%>';
var topics_catalog_user='<%=request.getParameter("user")%>';

var topics_catalog_startTime='<%=request.getParameter("startTime")%>';
var topics_catalog_endTime='<%=request.getParameter("endTime")%>';

var topics_catalog_address=<%=request.getParameter("address")%>;
var topics_catalog_isPublishTime=<%=request.getParameter("isPublishTime")%>;
var topics_catalog_isUpdataTime=<%=request.getParameter("isUpdateTime")%>;
var topics_catalog_rows=<%=request.getParameter("rows")%>;
var topics_catalog_page=<%=request.getParameter("page")%>;
var topics_catalog_order='<%=request.getParameter("order")%>';
var topics_catalog_sort='<%=request.getParameter("sort")%>';
var topics_catalog_oldLevel=<%=request.getParameter("oldLevel")%>;

var topics_catalog_sortType=<%=request.getParameter("sortType")%>;

$(function (){
	
	//初始化参数的值，默认加载所有主题
	 if(!wgUtils.isUsed(topics_catalog_id)) topics_catalog_id=-1;
     
	 if(!wgUtils.isUsed(topics_catalog_thingSort)) topics_catalog_thingSort=1;
     
     if(!wgUtils.isUsed(topics_catalog_oldLevel)) topics_catalog_oldLevel=0;
     if(!topics_catalog_type) topics_catalog_type=0;
     if(!wgUtils.isUsed(topics_catalog_name)||topics_catalog_name=='null'){
			topics_catalog_name="";
			 } 
		
		if(!wgUtils.isUsed(topics_catalog_user)||topics_catalog_user=='null'){
			topics_catalog_user="";
		} 	
		if(!wgUtils.isUsed(topics_catalog_startTime)||topics_catalog_startTime=='null'){
			//var k;
			topics_catalog_startTime='';
		} 
		if(!wgUtils.isUsed(topics_catalog_endTime)||topics_catalog_endTime=='null'){
			//var k;
			topics_catalog_endTime='';
		} 
		if(!wgUtils.isUsed(topics_catalog_isPublishTime)){
			topics_catalog_isPublishTime=false;
		} 
		if(!wgUtils.isUsed(topics_catalog_isUpdataTime)){
			topics_catalog_isUpdataTime=false;
		}
		if(!wgUtils.isUsed(topics_catalog_address)){
			topics_catalog_address=-2;
		}
		if(!wgUtils.isUsed(topics_catalog_rows)){
			topics_catalog_rows=10;
		}
		if(!wgUtils.isUsed(topics_catalog_page)){
			topics_catalog_page=1;
		}
		if(!wgUtils.isUsed(topics_catalog_order)||topics_catalog_name=='null'){
			topics_catalog_order="asc";
		}
		if(!wgUtils.isUsed(topics_catalog_sort)||topics_catalog_sort=='null'){
			topics_catalog_sort='id';
		}
		if(!wgUtils.isUsed(topics_catalog_sortType)){
			topics_catalog_sortType=0;
		}
	//alert(topics_catalog_sortType);
		

		
$("#indexTop_search_form #indexTop_search_content").val(topics_catalog_name);
		
	getParentThingSort();
	getThingSortBrothers();
	
	setTopics_catalog_oldLevel();
	setTopics_catalog_type();
	setTopics_catalog_sort();
	setTopics_catalog_address();
	setTopics_catalog_parent_address();
	
	getTopics_catalog();
});

function getTopics_catalog(){
	
	var url='<%=request.getContextPath()%>/topic/topics_catalog.josn?'+getCateLogUrlParams(); 
	///console.info(url);
	$.ajax({
		url:url,
		async:true,
        cache:false,
        type:"post",
        contentType:"application/x-www-form-urlencoded; charset=utf-8",
        dataType:"json",
        success:function(msg)
            {
               if(wgUtils.isUsed(msg)&&msg.total>0){
                   //alert("取到后台信息！");
            	   console.info(msg);
            	   setCategoryShowHtml(msg.rows);
            	   setCategoryPageHtml(msg);
                
               }  else{
            	   alert("没有相关主题！");
               }
            },
       complete:function(XMLHttpRequest,textStatus)
            {},
      error:function()
           {}							
	});
}
 
 function setCategoryPageHtml(msg){
	var total=msg.total;
	var table=$("#topics_catelog_pageTable");
	var maxPage=parseInt(total/topics_catalog_rows);
	      if(total%topics_catalog_rows!=0)
	    	  {
	    	  maxPage=maxPage+1;
	    	  }
	      //alert(maxPage);
	var htmlString="<tr>";
	if(topics_catalog_page==1&&maxPage==1){
		htmlString=htmlString+"<td align=\"center\" width=\"100px\"><buttton style=\"background-color:#66CCFF\" onclick=\"javascript:void(0);\">"+"末页"+"</button></td>";
	}else if(topics_catalog_page<maxPage){
		
			if(topics_catalog_page!=1){
				htmlString=htmlString+"<td align=\"center\" width=\"100px\"><buttton onclick=\"setCategoryPage("+1+")\">"+"首页"+"</button></td>";
				htmlString=htmlString+"<td><buttton onclick=\"setCategoryPage("+(topics_catalog_page-1)+")\">"+"上一页"+"</button></td>";
				htmlString=htmlString+"<td align=\"center\" width=\"250px\"><span style=\"background-color:#66CCFF\" >第"+topics_catalog_page+"页</span></td>";
			}else{
				htmlString=htmlString+"<td align=\"center\" width=\"100px\"><buttton style=\"background-color:#66CCFF\" onclick=\"javascript:void(0);\">"+"首页"+"</button></td>";
			}
			
			htmlString=htmlString+"<td><buttton onclick=\"setCategoryPage("+(topics_catalog_page+1)+")\">"+"下一页"+"</button></td>";
			htmlString=htmlString+"<td align=\"center\" width=\"100px\"><buttton onclick=\"setCategoryPage("+maxPage+")\">"+"末页"+"</button></td>";
		}else if(topics_catalog_page>=maxPage){
			
			htmlString=htmlString+"<td align=\"center\" width=\"100px\"><buttton onclick=\"setCategoryPage("+1+")\">"+"首页"+"</button></td>";
			htmlString=htmlString+"<td><buttton onclick=\"setCategoryPage("+(topics_catalog_page-1)+")\">"+"上一页"+"</button></td>";
			//htmlString=htmlString+"<td align=\"center\" width=\"250px\"><span >第"+topics_catalog_page+"页</span></td>";
			htmlString=htmlString+"<td align=\"center\" width=\"100px\"><buttton style=\"background-color:#66CCFF\" onclick=\"javascript:void(0);\">"+"末页"+"</button></td>";
		}
	  
	htmlString=htmlString+"<td align=\"right\" width=\"50px\"><buttton style=\"color:#8B0000\" onclick=\"javascript:goToPage("+maxPage+");\">"+"转到"+"</button></td>";
	htmlString=htmlString+"<td><form><input onclick=\"javascript:void(0);\" id=\"pageInput\" width=\"20px\" type=\"text\"/></form></td>";
	htmlString=htmlString+"<td>页&nbsp;共"+maxPage+"页</td>";
	
	
	htmlString=htmlString+"</tr>";
	table.html(htmlString);
	
 }
 //转到指定页面
 function goToPage(maxPage){
	 var goPage=$("#pageInput").val();
	 if(typeof goPage!='undefined'&&goPage){
		 if(goPage>maxPage){
			 setCategoryPage(maxPage);
		 }else if(goPage<=0){
			 setCategoryPage(1);
		 }else{
			 setCategoryPage(goPage);
		 }
	 }else
	 alert("请输入正确的跳转页码!");
 }
 
 function setCategoryPage(page){
	 topics_catalog_page=page;
	 refresh_topics_catalog();
 }
 
 function setCategoryShowHtml(rows){
	 var total=rows.length;
	 var htmlString="";
	 for(var i=0;i<total;i++){
		 htmlString="<li style=\"list-style-type: none; position: relative; height:170px;\" width=\"760px\">";
		 htmlString=htmlString+"<div align=\"left\" width=\"160px\" height=\"150px\" style=\"position: absolute; margin-left: 1px; margin-top: 1px;\">";
		 htmlString=htmlString+"<a style=\"position: absolute; margin-left: 1px; margin-top: 1px;\" href=\"<%=request.getContextPath()%>/topic/showTopicDeteils.do?id="+rows[i].id+" \">";
		 htmlString=htmlString+"<img width=\"160px\" height=\"150px\" alt=\"无图！\" src=\""+getTopicImageUrl(rows[i].images)+"\"></img></a></div>";
		 htmlString=htmlString+"<div align=\"left\" width=\"300px\" height=\"146px\" style=\"position: absolute; margin-left: 210px; margin-top: 5px;\">";
		 htmlString=htmlString+"<a href=\"<%=request.getContextPath()%>/topic/showTopicDeteils.do?id="+rows[i].id+" \" style=\"text-decoration: none;\"><span style=\"color: #4169E1\">"+rows[i].name+"</span></a>";
		 htmlString=htmlString+"<br/> <br/> <span>"+rows[i].address.name+"&nbsp;交易方式:"+getBuyWayString(rows[i].buyWay)+"&nbsp;"+getOldLevelString(rows[i].oldLevel)+"</span> <br /><br /><span>交易类型:"+getTypeString(rows[i].type)+"</span> <br /> <br /> <span>发布时间: "+wgUtils.getTime(rows[i].publishTime, 0)+" </span></div>";
		
		 htmlString=htmlString+"<div align=\"left\" width=\"200px\" height=\"150px\" style=\"position: absolute; margin-left: 520px; margin-top: 1px;\"><br/> <br /> <br />";
		 htmlString=htmlString+"<span style=\"color: #A52A2A\">价格:"+rows[i].price+"元</span></div></li>";
		 
		 $("#topicCategoryUl").append(htmlString);
	 }
 }
 

 function getTopicImageUrl(k){
	 if(wgUtils.isUsed(k)&&wgUtils.isUsed(k[0]))
		 return "<%=UploadFolder.getImageDisPlayFolder(request)%>/"+k[0];
	 else return "";
 }
 
 
         function getParentThingSort(){
        	 $.ajax({
         		url:'<%=request.getContextPath()%>/getThingSortParents.json?id='+topics_catalog_thingSort,
         		async:true,
                 cache:false,
                 type:"post",
                 contentType:"application/x-www-form-urlencoded; charset=utf-8",
                 dataType:"json",
                 success:function(msg)
                     {
                        if(wgUtils.isUsed(msg.success)&&wgUtils.isUsed(msg.object)){
                        var data=msg.object;              
 	                   var htmlString="";     
                        for(var k=data.length-1;k>0;k--)
 	                        {
                     	   htmlString=htmlString+getCategoryHtmlString(data[k],topics_catalog_thingSort,1)+"->";
 	                        }
                        htmlString=htmlString+getCategoryHtmlString(data[0],topics_catalog_thingSort,1)+":";
                        
                        $("#topics_catalog_parent_thingSort").append(htmlString);
                        }      
                     
                     },
                complete:function(XMLHttpRequest,textStatus)
                     {},
               error:function()
                    {}							
         	});
         }
                   
       
        function getCategoryHtmlString(data,selectId,dataType)
        {//data是一个json数据,包含id与name，表示前台显示的内容，selectId表示当前选中的内容显示为红色
         //dataType的值为1,2,3,4,5 ;1表示物品分类,2表示成色,3表示价格,4表示时间,5表示交易类型type,data.id实际上表示的是一个值，不一定是id号码
        if(wgUtils.isUsed(data)){       	
          var htmlString="<a href=\"javaScript:setDataType("+data.id+","+dataType+");\" ";
          if(wgUtils.isUsed(selectId)&&selectId==data.id)
          {
        	  htmlString=htmlString+" style=\"color:red;\" ";
          }
         htmlString=htmlString+">"+data.name+"</a>";       
          //if(data.id!=1)
          return htmlString;
          //return data.name;
          }
        return "";
        }
        
        //设置的是筛选条件的类型，然后刷新整个页面
        function setDataType(id,dataType){
       	 if(wgUtils.isUsed(dataType)){
       		 
       		 if(dataType==1){
       			topics_catalog_thingSort=id;
       		 } else if(dataType==2){
       			 topics_catalog_oldLevel=id;
       			 
       		 } else if(dataType==3){
       			 topics_catalog_price=id;
       			 
       		 } else if(dataType==4){
       			 topics_catalog_startTime=id;
       			 
       		 } else if(dataType==5){
       			topics_catalog_type=id;
       		 }else if(dataType==6){
       			topics_catalog_sortType=id;
       		
       			if(id==0){
       			topics_catalog_sort='id';
       			topics_catalog_order='asc';
       		}else if(id<=2){
       			topics_catalog_sort='price';
       		}else{
       			topics_catalog_sort='publishTime';
       		} 
       		
       		if(id%2==1)
       		{
       			topics_catalog_order='asc';
       		}else{
       			topics_catalog_order='desc';
       		}
       		 
       		 
       		//alert(topics_catalog_sort);
       		 
       		 } else if(dataType==7){//7是地址编号
       			topics_catalog_address=id;
       		 }
       		refresh_topics_catalog();
       	 }
        };
        
        function get_topics_catalog_thingSort()
        {//得到物品分类
        	//alert("get_topics_catalog_thingSort()");
        	$.ajax({
        		url:'<%=request.getContextPath()%>/getThingSortParents.json?id='+topics_catalog_thingSort,
        		async:true,
                cache:false,
                type:"post",
                contentType:"application/x-www-form-urlencoded; charset=utf-8",
                dataType:"json",
                success:function(msg)
                    {
                       if(wgUtils.isUsed(msg.success)&&wgUtils.isUsed(msg.object)){
                       var data=msg.object;              
	                   var htmlString="";     
                       for(var k=data.length-1;k>0;k--)
	                        {
                    	   htmlString=htmlString+getCategoryHtmlString(data[k],topics_catalog_thingSort,1)+"->";
	                        }
                       htmlString=htmlString+getCategoryHtmlString(data[0],topics_catalog_thingSort,1)+":";
                       
                       $("#topics_catalog_parent_thingSort").append(htmlString);
                       }      
                    
                    },
               complete:function(XMLHttpRequest,textStatus)
                    {},
              error:function()
                   {}							
        	});
        }
        
        function getThingSortBrothers(){       	
        	$.ajax({
        		url:'<%=request.getContextPath()%>/getThingSortBrothers.json?id='+topics_catalog_thingSort,
        		async:true,
                cache:false,
                type:"post",
                contentType:"application/x-www-form-urlencoded; charset=utf-8",
                dataType:"json",
                success:function(msg)
                    {
                       if(wgUtils.isUsed(msg.success)&&wgUtils.isUsed(msg.object)){
                       var data=msg.object;              
	                   var htmlString="&nbsp;&nbsp;";     
                       for(var k=data.length-1;k>0;k--)
	                        {
                    	   htmlString=htmlString+getCategoryHtmlString(data[k],topics_catalog_thingSort,1)+"&nbsp; | &nbsp;";
	                        }
                       htmlString=htmlString+getCategoryHtmlString(data[0],topics_catalog_thingSort,1)+"";
                       
                       $("#topics_catalog_child_thingSort").append(htmlString);
                       }      
                    
                    },
               complete:function(XMLHttpRequest,textStatus)
                    {},
              error:function()
                   {}							
        	});
        }
        
        function setTopics_catalog_oldLevel(){       	
        	var tableObject=$("#topics_catalog_oldLevel");
        	var arr=[{id:0,name:'全部'},
        	         {id:10,name:'全新'},
        	         {id:9,name:'9新'},
        	         {id:8,name:'8新'},
        	         {id:7,name:'7新'},
        	         {id:6,name:'7新以下'},];
        	//console.info(arr);
        	var hString="<tr><td>&nbsp;&nbsp;";
        	for(var k=0;k<arr.length;k++){
        		hString=hString+getCategoryHtmlString(arr[k],topics_catalog_oldLevel,2)+"&nbsp; | &nbsp;";
        	}
        	hString=hString+"</td></tr>";
        	tableObject.append(hString);
        }
        
        function setTopics_catalog_type()
        {      	//1出售,2求购,3赠送,4交换
           	var tableObject=$("#topics_catalog_type");
           	var arr=[{id:0,name:'全部'},
           	         {id:1,name:'出售'},
           	         {id:2,name:'求购'},
           	         {id:3,name:'赠送'},
           	         {id:4,name:'交换'}];
           	//console.info(arr);
           	var hString="<tr><td>&nbsp;&nbsp;";
           	for(var k=0;k<arr.length;k++){
           		hString=hString+getCategoryHtmlString(arr[k],topics_catalog_type,5)+"&nbsp; | &nbsp;";
           	}
           	hString=hString+"</td></tr>";
           	tableObject.append(hString);
        }
        
        function setTopics_catalog_sort()
        {//设置主题排序方式，价格升序和降序两种方式
           	var tableObject=$("#topics_catalog_sort");
           	var arr=[{id:0,name:'默认排序'},
           	         {id:1,name:'价格升序'},
           	         {id:2,name:'价格降序'},
           	         {id:3,name:'发布最久'},
           	         {id:4,name:'最新发布'}]
           	//console.info(arr);
           	var hString="<tr><td>&nbsp;&nbsp;";
           	for(var k=0;k<arr.length;k++){
           		hString=hString+getCategoryHtmlString(arr[k],topics_catalog_sortType,6)+"&nbsp; | &nbsp;";
           	}
           	hString=hString+"</td></tr>";
           	tableObject.append(hString);
        	
        }
        
        function setTopics_catalog_address()
        {//设置主题地址分类
           	var tableObject=$("#topics_catalog_address");  
        $.ajax({
        		url:'<%=request.getContextPath()%>/getChildOrBrothersAddress.json?id='+topics_catalog_address,
        		async:true,
                cache:false,
                type:"post",
                contentType:"application/x-www-form-urlencoded; charset=utf-8",
                dataType:"json",
                success:function(msg)
                    {console.info("地址信息！");
                	 console.info(msg);
                       if(wgUtils.isUsed(msg)&&msg.length>0){
                       var data=msg;              
	                   var htmlString="&nbsp;&nbsp;";     
                       for(var k=data.length-1;k>0;k--)
	                        {
                    	   data[k].name=data[k].text;
                    	   htmlString=htmlString+getCategoryHtmlString(data[k],topics_catalog_address,7)+"&nbsp; | &nbsp;";
	                        }
                       data[0].name=data[0].text;
                       htmlString=htmlString+getCategoryHtmlString(data[0],topics_catalog_address,7);
                       //alert(htmlString);
                       tableObject.append(htmlString);
                       }      
                    
                    },
               complete:function(XMLHttpRequest,textStatus)
                    {},
              error:function()
                   {}							
        	});
        	
        }
        
        function setTopics_catalog_parent_address()
        {//设置主题地址父分类分类
           	var tableObject=$("#topics_catalog_parent_address");  
        $.ajax({
        		url:'<%=request.getContextPath()%>/getAddressParents.json?id='+topics_catalog_address,
        		async:true,
                cache:false,
                type:"post",
                contentType:"application/x-www-form-urlencoded; charset=utf-8",
                dataType:"json",
                success:function(msg)
                    {console.info("地址父分类信息！");
                	 console.info(msg);
                       if(wgUtils.isUsed(msg)&&msg.length>0){
                       var data=msg;              
	                   var htmlString="&nbsp;&nbsp;";     
                       for(var k=data.length-1;k>0;k--)
	                        {
                    	   data[k].name=data[k].text;
                    	   htmlString=htmlString+getCategoryHtmlString(data[k],topics_catalog_address,7)+"->";
	                        }
                       data[0].name=data[0].text;
                       htmlString=htmlString+getCategoryHtmlString(data[0],topics_catalog_address,7);
                       //alert(htmlString);
                       tableObject.append(htmlString+":");
                       }      
                    
                    },
               complete:function(XMLHttpRequest,textStatus)
                    {},
              error:function()
                   {}							
        	});
        	
        }
        
        function getCateLogUrlParams()
        {   var url="";
        	url=url+"id="+topics_catalog_id;
        	url=url+"&type="+topics_catalog_type;
        	url=url+"&thingSort="+topics_catalog_thingSort;
        	url=url+"&name="+topics_catalog_name;
        	url=url+"&user="+topics_catalog_user;
        	url=url+"&startTime="+topics_catalog_startTime;
        	url=url+"&address="+topics_catalog_address;
        	url=url+"&endTime="+topics_catalog_endTime;
        	url=url+"&isPublishTime="+topics_catalog_isPublishTime;
        	url=url+"&rows="+topics_catalog_rows;
        	url=url+"&page="+topics_catalog_page;
        	
        	url=url+"&order="+topics_catalog_order;
        	url=url+"&sort="+topics_catalog_sort;
        	
        	url=url+"&oldLevel="+topics_catalog_oldLevel;
        	url=url+"&sortType="+topics_catalog_sortType;
        	//alert(url);
        	return url;
        }
        
        function refresh_topics_catalog()
        {  
          var url="<%=request.getContextPath()%>/topic/topics_catalog.do?"
				+ getCateLogUrlParams();
		window.top.location.href = url;
	}

	
	function getBuyWayString(value){
		if(value==1)
	        	return '面交';
			if(value==2)
				return '远程交易';
			if(value==3) return '可商议';
	}
	
	function getOldLevelString(value){
		
			if(value==10) return "全新";
			if(value==9) return "9新";
			if(value==8) return "8新";
			if(value==7) return "7新";
			if(value==6) return "7新以下";        				
		
	}
	
	function getTypeString(value){
		if(value==1)
				return "出售";
			if(value==2)
				return "求购";
			if(value==3)
				return "赠送";
			if(value==4)
				return "置换";
			return value;
	}
</Script>
<title>主题列表</title>
</head>
<body>
	<div style="width: 1280px;" id="topics_catalog_searchContent" align="left">
		<div id="topics_catalog_parent_thingSort"></div>
		物品分类:
		<table id="topics_catalog_child_thingSort"></table>
		成色:
		<table id="topics_catalog_oldLevel"></table>
		交易类型:
		<table id="topics_catalog_type"></table>
		地址:
		<div id="topics_catalog_parent_address"></div>
		<br/>
		<div id="topics_catalog_address"></div>
		排序:
		<table id="topics_catalog_sort"></table>
		<!-- 保留到以后完成  
				 发布时间:
				 <table id="topics_catalog_updateTime"></table>
				-->
	</div>
	<br />
	<div style="width: 1280px;">
		<ul id="topicCategoryUl">
		</ul>
		<table id="topics_catelog_pageTable">
		</table>
	</div>
</body>
</html>