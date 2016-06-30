<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>
<head>
<jsp:include page="../include.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 显示隐藏区域,用户显示主题详情 -->
<style type="text/css">
a{
text-decoration: none;
}
</style>
<Script language="JavaScript" type="text/javascript">
         var topic_topicManage_mainTable;
         var topics_catalog_rows=10;
         var topics_catalog_page=1;
           $(function(){
        	   topic_topicManage_mainTable=$("#topic_topicManage_mainTable");
       	   
        	   getCollectionTopics();
           });
           
           
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
        		
        		htmlString=htmlString+"</tr>";
        		table.html(htmlString);
        		
        	 }
function setCategoryPage(k){
	topics_catalog_page=k;
	getCollectionTopics();
}
           
       function getCollectionTopics()
       {
    	   $.ajax({
    		    async:true,
    		    cache:false,
    		    type:"post",
    		    url:"<%=request.getContextPath()%>/user/getCollectionTopics.json?rows="+topics_catalog_rows+"&page="+topics_catalog_page,
    		    contentType:"application/x-www-form-urlencoded; charset=utf-8",
    		    dataType:"json",
    		    success:function(msg)
    		        {  
    		    	console.info("userCollectionTopics：");
    		    	console.info(msg);
    		       if(msg.success){
    		    	   
    		    	   var data=msg.object.rows;
    		           var htmlString="";
    		    	  if(data.length<1)
    		    		  {
    		    		     alert("没有收藏的主题");
    		    		     return;
    		    		  }
    		           for(var i=0;i<data.length;i++){
    		        	   htmlString=htmlString+"<tr height=\"30px\"><td>第"+(i+1)+"个主题:</td></tr><tr><td>主题编号:"+data[i].topicId;
    		        	   htmlString=htmlString+"</td><td width=\"50px\"></td><td>主题名称:"+data[i].topicName+"</td>";
    		        	   htmlString=htmlString+"<td width=\"50px\"></td><td><a href=\"javascript:void(0);\" onclick=\"showUserCollectionTopics("+data[i].topicId+")\">查看</a></td>";
    		        	   htmlString=htmlString+"<td width=\"50px\"></td><td><a href=\"javascript:void(0);\" onclick=\"deleteUserCollectionTopics("+data[i].id+")\">删除</a></td></tr><tr height=\"30px\"></tr>";
    		           }
    		    	   topic_topicManage_mainTable.html(htmlString);
    		    	   setCategoryPageHtml(msg.object); 
    		       }else{
    		    	   $.messager.show({
    		    	       	title:"提示",
    		    	    	msg:msg.msg,
    		    	    	timeout:5000,
    		    	    	showType:'slide'
    		    	    });
    		       }
    		        },
    		  error:function()
    		       {
    			  $.messager.show({
    		       	title:"提示",
    		    	msg:"和服务器通信失败！",
    		    	timeout:5000,
    		    	showType:'slide'
    		    });
    		            //错误处理
    		       }
    		    });
       }
        
       function showUserCollectionTopics(topicId){
    	   //alert(topicId);
    	   
    	   $.ajax({
   		    async:true,
   		    cache:false,
   		    type:"post",
   		    url:"<%=request.getContextPath()%>/topic/isTopicExited.json?topicId="+topicId,
   		    contentType:"application/x-www-form-urlencoded; charset=utf-8",
   		    dataType:"json",
   		    success:function(msg)
   		        {  
   		    	//console.info("userCollectionTopics：");
   		    	//console.info(msg);
   		       if(msg.success){//如果存在这个主题，才能查看
   		    	   window.top.location.href="<%=request.getContextPath()%>/topic/showTopicDeteils.do?id="+topicId;
   		    	} else{
   		    	alert("主题已被删除,无法查看！");	
   		    	}
   		    	
   		        },
   		  error:function()
   		       {
   			  $.messager.show({
   		       	title:"提示",
   		    	msg:"和服务器通信失败！",
   		    	timeout:5000,
   		    	showType:'slide'
   		    });
   		            //错误处理
   		       }
   		    });
    	   
       }
       
       function deleteUserCollectionTopics(cId){
    	   $.ajax({
      		    async:true,
      		    cache:false,
      		    type:"post",
      		    url:"<%=request.getContextPath()%>/user/deleteCollectionTopics.json?cId="+cId,
      		    contentType:"application/x-www-form-urlencoded; charset=utf-8",
      		    dataType:"json",
      		    success:function(msg)
      		        {  
      		    	//console.info("userCollectionTopics：");
      		    	//console.info(msg);
      		       if(msg.success){//如果存在这个主题，才能查看
      		    	 
      		    	   getCollectionTopics();
      		    	
      		       } else{
      		    	alert("删除失败！"+msg.msg);	
      		    	}
      		    	
      		        },
      		  error:function()
      		       {
      			  $.messager.show({
      		       	title:"提示",
      		    	msg:"和服务器通信失败！",
      		    	timeout:5000,
      		    	showType:'slide'
      		    });
      		            //错误处理
      		       }
      		    });
       }
        
        function topic_topicManage_checkDeleteTopic()
        {
        	var selections=topicManage_table_datagrid.datagrid('getSelections');   
            if(!wgUtils.isUsed(selections)||selections.length<=0)
           	{
           	 alert("您必须至少选择一个主题才能够删除!");
           	}
           else{
           	  $.messager.confirm("请确认", "您确定要删除么?", topic_topicManage_deleteTopic);       	
           	}
        };
        
        
        
        function topic_topicManage_deleteTopic(r)
        {
        	if(r){
        		var selections=topicManage_table_datagrid.datagrid('getSelections');
        		var ids=[];
        		for(var i=0;i<selections.length;i++){
        			ids.push(selections[i].id);
        		}
        		ids=ids.join(',');
        		var url="/user/deleteTopics.json?ids="+ids;
        		
        		//console.info("ids:");
        		//console.info(ids);
        		//alert(url);
        		$.ajax({
        			url:'<%=request.getContextPath()%>/user/getCollectionTopics.json',
        			success:function(d){
        				//d=jQuery.parseJSON(d);
        				//console.info("d:");
        				//console.info(d);
        				if(typeof d.msg!='undefined'&&!d.success)
        				{
        					alert(d.msg);
        					return;
        				} else{
        				topicManage_table_datagrid.datagrid('load');//从服务器加载,防止删除后加载不完全的情况
        				topicManage_table_datagrid.datagrid('unselectAll');
        				$.messager.show({
        					title:"提示",
        				    msg:d.msg
        				});}
        			}
        		});
        	}
        };

</Script>
<title>收藏主题管理</title>
</head>
<body>
<div id="topic_topicManage_mainDiv" style="width:1280px" align="left" class="easyui-layout" >
<table style="margin-left:100px; align:left;"  id="topic_topicManage_mainTable"></table>
<table style="margin-left: 120px" id="topics_catelog_pageTable">
		</table>
</div>
</body>
</html>