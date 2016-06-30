<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>
<head>
<jsp:include page="../include.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 显示隐藏区域,用户显示主题详情 -->
<style type="text/css">
.boxShow a{color:#333; text-decoration:none;border:2px solid #FFF; float:left; cursor:hand;} 
.boxShow a span{display:none; color:#FFF;  background:#333;} 
.boxShow a:hover{color:#999; border:2px solid #333; } 
.boxShow a:hover span{display:inline; position:absolute;} 
</style>
<Script language="JavaScript" type="text/javascript">
           var topicManage_table_datagrid;
           var alertCount=0;
           
           $(function(){
        	  topicManage_table_datagrid=$("#topicManage_table_datagrid");
       	   
        	   topic_topicManage_getAllTopics(-1,null);
           });
           
         function topic_topicManage_getAllTopics(id,name)
         {   //alert("123");
        	 topicManage_table_datagrid.datagrid({
         	    //fit:true,
         	    url:'<%=request.getContextPath()%>/getUserAllTopics.json',
         	    border:false,
         	    pagination:true,
         	    idField:'id',
         	    //pagePosition:'top',//'bottom'
         	    pagePosition:'bottom',
         	    fitColumns:true,
         	    //sortName:"id",//排序的字段的名称
         	    //sortOrder:"asc",//排序的方式
         	    pageSize:20,
         	    pageList:[20,30,40,50,60],
         	    toolbar:"#topic_topicManage_toolbar",
         	    queryParams: {
         			id: id,
         			name: name
         		},
         		frozenColumns:[[{field:'ids',title:'主题编号',width:60,checkbox:true},
         	           	        {field:'id',title:'主题编号',width:60,sortable:true},
         	           	        //{field:'name',title:'主题名',width:100,sortable:true},           	           	    
         	           	    ]],
         	    columns:
         	    	[[
                    {field:'name',title:'主题名',width:100}, 
					{field:'type',title:'主题分类',width:60,formatter:
           	        	function(value,row,index){
        				if(value==1)
        					return "出售";
        				if(value==2)
        					return "求购";
        				if(value==3)
        					return "赠送";
        				if(value==4)
        					return "置换";
        				return value;
        			}},					
         	        {field:'phone',title:'联系手机',width:100},        	        
         	        {field:'address',title:'交易地点',width:120,formatter:
           	        	function(value,row,index){
        				return value.name;
        			}},
         	        {field:'thingSort',title:'交易物品类别',width:105,formatter:
           	        	function(value,row,index){
        				return value.name;
        			}},
         	        {field:'buyWay',title:'交易方式',width:70,formatter:
           	        	function(value,row,index){
        				if(value==1)
         	        	return '面交';
        				if(value==2)
        					return '远程交易';
        				if(value==3) return '可商议';
        			}},
         	        {field:'oldLevel',title:'成色',width:70,formatter:
           	        	function(value,row,index){
        				if(value==10) return "全新";
        				if(value==9) return "9新";
        				if(value==8) return "8新";
        				if(value==7) return "7新";
        				if(value==6) return "7新以下";        				
        			}},
         	        {field:'price',title:'交易价格',width:70},
         	        {field:"describe",title:'交易详情',width:200,formatter:function(value,row,index){
         	        	return showHiddenBox(value);
       	          }},{field:'images',title:'图片',width:100,formatter:function(value,row,index){
       	        	
       	        	if(!wgUtils.isUsed(value)||value.length<1)
       	        		return "无图";
       	        	else{
       	        		var htmls=value.join(";");
       	        		var ids=row.imageIds.join(";");
       	        		//console.info(htmls);
     	    		   return "<a href=\"javascript:void(0);\" onclick=\"img_topic_dialog_setUserAuImg('"+htmls+"','"+ids+"',"+row.id+") \" >查看/删除</a> ";
     	    	   };
     	       }},
         	        {field:'publishTime',title:'发布时间',sortable:true,formatter:function(value,row,index){
															        				return wgUtils.getTime(value, 0);
															        			}
         	        },
         	       {field:'updateTime',title:'更新时间',align:'left',sortable:true,formatter:
          	        	function(value,row,index){
       				return wgUtils.getTime(value, 0);
       			}},{field:'idss',title:'查看详细信息',sortable:false,formatter:function(value,row,index){
       				var html='';
 				   html=html+"<a href=\"<%=request.getContextPath()%>/topic/showTopicDeteils.do?id="+row.id+"\" >查看</a>";
   	    	   return html;
 			}}
         	    ]],
         	 onLoadSuccess:function(data){
         		 //console.info(data);
         		 if(wgUtils.isUsed(data))
         			 {
	         			 data=wgUtils.parseToJson(data);
	         			if(wgUtils.isUsed(data.total)&&data.total==0)
	         				{   //alert("zhix");
	         					alertCount=alertCount+1;
	         					if(alertCount==1)
		         				alert("没有找到相关主题!");
		         				return;
	         				}else{
	         			if(data.success==false)
	         				alert(data.msg);         			
         			 }         	
	         			}	
         	 },
         	onLoadError:function(){
         		$.messager.show({
     				title:"提示",
  	        	msg:"服务器未响应,请输入正确的信息,并稍后再试!",
  	        	timeout:4000,
  	        	showType:'slide'
     			 });
         	}
         	});;
         };
         
           
           
         function searchTopic(id,name){
        	 //alert("5666");
        	 if(typeof id=='undefined'||!id){
        		 return;
        	 }
        	 
        	 var data=wgUtils.serializeObject($("#user_search_form"));
        	     data.id=id;
        	     data.name=name;
        	 topicManage_table_datagrid.datagrid("options").queryParams=data;
        //console.info(queryParams);
        //console.info($("#tops_table").datagrid("options").queryParams);
        
     	//topicManage_table_datagrid.datagrid();
     	//alert("xadsf");
     	topicManage_table_datagrid.datagrid('load');       	 
         };  
         
         function searchTopicId()
         { if(!$("#user_search_form").form('validate'))
        	 return;
        	 var id=$("#user_search_form #search_content").val();
        	 	
        	 searchTopic(id,null);
         };
         
         function searchTopicName(){
        	 if(!$("#user_search_form").form('validate'))
            	 return;
        	 var name=$("#user_search_form #search_content").val();
        	 //alert("5666");	
        	 searchTopic(-1,name);
         };
         
         function searchTopicAll(){//清空搜索框内容,并请求所有用户
        	 $("#user_search_form #search_content").val('');
        //alert("5666");	
         searchTopic(-1,null);
        	 
         };
        function topic_topicManage_help(){
        	var s="1.当搜索主题编号的时候,限制条件无效!\n2.开始时间和结束时间必须和其作用的时间范围同时选择才有效!";        	
        	alert(s);
        };
        
        function topic_topicManage_editTopic(){
        	var selections=topicManage_table_datagrid.datagrid('getSelections');
         if(!wgUtils.isUsed(selections)||selections.length<=0)
            	{
            	 alert("您必须至少选择一行数据才能够编辑!");
            	}
            else if(selections.length>1)
            	{
            	alert("请只选择一行数据编辑!");
            	} else{
            		data=wgUtils.cloneObject(selections[0]);
            		var userId=selections[0].user.id;
            		var thingSortId=selections[0].thingSort.id;
            		var addressId=selections[0].address.id;
            		
            		data.user=selections[0].user.name;
            		data.userId=userId;
            		
            		data.thingSort=selections[0].thingSort.name;
            		data.thingSortId=thingSortId;
            		
            		data.address=selections[0].address.name;
            		data.addressId=addressId;
            		//alert("002");
            		common_editTopic(data,"/user/updateTopic.json",false,function(){topicManage_table_datagrid.datagrid('reload');
            			
            		},function(){});       	
            	}
        }
        
        function topic_topicManage_unSelectTopic(){
        	topicManage_table_datagrid.datagrid('unselectAll');
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
        			url:'<%=request.getContextPath()%>'+url,
        			dataType:'json',
        			success:function(d){
        				//d=jQuery.parseJSON(d);
        				//console.info("d:");
        				//console.info(d);
        				if(typeof d.msg!='undefined'&&!d.success)
        				{
        					alert(d.msg);
        					return;
        				} else{
        					//alert("333");
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
        
        
        function search_getAddress(){
        	common_treeDialogInit("选择","确定","icon-add",search_getAddressTreeIdAndName);
        	common_treeDialog_treeInit("/getAddress.json");
        	common_treeDialog.dialog('open');	
        }

        function search_getThingSort(){
        	common_treeDialogInit("选择","确定","icon-add",search_getThingSortTreeIdAndName);
        	common_treeDialog_treeInit("/getThingSort.json");
        	common_treeDialog.dialog('open');	
        }
        
        function search_getThingSortTreeIdAndName(){
        	$("#user_search_form #search_thingSort").val(treeTreeName);
        	$("#user_search_form input[name=thingSort]").val(treeTreeId);
        	
        }
        
        function search_getAddressTreeIdAndName(){
        	$("#user_search_form #search_address").val(treeTreeName);
        	$("#user_search_form input[name=address]").val(treeTreeId);        	
        }
        function clearSearchForm(){
        	$("#user_search_form #search_condition_div input").val('');
        	$("#user_search_form input[name=isPublishTime]").attr("checked",false);
        	$("#user_search_form input[name=isPublishTime]").val('true');
        	$("#user_search_form input[name=isUpdateTime]").attr("checked",false);
        	$("#user_search_form input[name=isUpdateTime]").val('true');
        	
        }
        function showHiddenBox(k){
        	var spanHtml="";
        	for(var i=0;i<k.length;i++){
        		spanHtml=spanHtml+k[i];
        		if((i+1)%25==0){
        			spanHtml=spanHtml+k[i]+"<br/>";
        		}
        	}
        	var html="<div class=\"boxShow\"><a href=\"javascript:void(0);\"><span >"+spanHtml+"</span>"+k+"</a></div>";
        	//alert(html);
        	return html;    	
        }
</Script>
<title>用户主题管理</title>
</head>
<body>
<div id="topic_topicManage_mainDiv" class="easyui-layout"  style="width:1270px;height:700px;">
		<div id="topic_topicManage_searchContent" data-options="region:'north',title:'搜索条件:',split:true" style="height:230px">
				
				<form id="user_search_form" method="post" class="easyui-form">
				    <div align="center">
				    <div id="search_condition_div">
				         查询限制条件:
				         <br/>
				         <table>
				         <tr><td><label for="search_type">交易类型:</label>
				    <input class="easyui-combobox" name="type" data-options="
				                                editable:false,
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
												}]" /></td></tr>
				         <tr><td> <label for="search_address">主题地址:</label>
				    <input class="easyui-validatebox" onclick="search_getAddress()" data-options="required:false,editable:false" readonly="readonly" type="text" name="search_address" id="search_address" />
				    <input class="easyui-validatebox" data-options="required:false,editable:false" readonly="readonly" type="hidden" name="address" />
				    </td><td>  <label for="search_thingSort">交易物品分类:</label>
				    <input class="easyui-validatebox" onclick="search_getThingSort()" data-options="required:false,editable:false" readonly="readonly" type="text" name="search_thingSort" id="search_thingSort"/>
				    <input class="easyui-validatebox" data-options="required:false,editable:false" readonly="readonly" type="hidden" name="thingSort"/>
				    </td></tr>
				         <tr><td><label for="search_startTime">开始时间:</label>
				    <input class="easyui-datetimebox" data-options="required:false,showSeconds:true,editable:false" type="text" name="startTime"/></td>
				    <td><label for="search_endTime">结束时间:</label>
				       <input class="easyui-datetimebox" data-options="required:false,showSeconds:true,editable:false" type="text" name="endTime"/></td></tr>
				         <tr><td>时间范围作用于:</td><td>
				         <label for="publishTime">发布时间:</label>
				         <input type="checkbox" name="isPublishTime" value='true' />
				         <label for="isUpdateTime">更新时间:</label>
				         <input type="checkbox" name="isUpdateTime" value='true' />
				         </td></tr>
				         
				   </table>				   				  				    
				    </div>
				    
				    
				    <label for="search_content">关键字查询:</label>
				        <input class="easyui-validatebox" data-options="required:true" type="text" name="search_content" id="search_content"/>    
				    <div >
				        <input type="button" value="搜索主题编号" onclick="searchTopicId();">
				        <input type="button" value="搜索主题名" onclick="searchTopicName();">
				        <input type="button" value="显示所有符合条件的主题" onclick="searchTopicAll();">
				        <input type="button" value="清除所有限制条件" onclick="clearSearchForm();">
				    </div>
				    </div>   
				</form>
				</div>
				<br/>
				<div data-options="region:'center'" style="height:800px">
				<div id="topic_topicManage_toolbar">
				<a onclick="" href="javascript:topic_topicManage_checkDeleteTopic();" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true"style="float:left;">删除</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:topic_topicManage_editTopic();" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" style="float:left;">修改</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:topic_topicManage_unSelectTopic();" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" style="float:left;">取消所有选中</a>		
				<div class="datagrid-btn-separator"></div>
				<a onclick="topic_topicManage_help();" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-help',plain:true" >帮助</a>
	          </div>	    
		<table align="center" id="topicManage_table_datagrid" style="height:600px;width:1265px;" ></table>
		</div>
		
<jsp:include page="../common/add_edit_topic.jsp"></jsp:include>
<jsp:include page="../common/tree_dialog.jsp"></jsp:include>
<jsp:include page="../common/img_topic_dialog_user.jsp"></jsp:include>

</div>
</body>
</html>