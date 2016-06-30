<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>
<jsp:include page="../include.jsp"></jsp:include>
<head>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/my/static_Js_Data.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 显示隐藏区域,用户显示小说详情 -->
<style type="text/css">
.boxShow a{color:#333; text-decoration:none;border:2px solid #FFF; float:left; cursor:hand;} 
.boxShow a span{display:none; color:#FFF;  background:#333;} 
.boxShow a:hover{color:#999; border:2px solid #333; } 
.boxShow a:hover span{display:inline; position:absolute;} 
</style>
<Script language="JavaScript" type="text/javascript">
           var storyManage_table_datagrid;
           var common_storyTypes="${common_storyTypes}";
           $(function(){
        	  storyManage_table_datagrid=$("#storyManage_table_datagrid");
       	   
        	   story_storyManage_getAllStorys(-1,null);
        	   common_storyTypes=eval("("+common_storyTypes+")");
        	   initSearch();
           });
           
          function initSearch(){
        	$("#combo_storyStatus_search").combobox('loadData',myConstants.json_storyStatus);
        	$("#combo_storyUpdateStatus_search").combobox('loadData',myConstants.json_storyUpdataState);
        	$("#combo_wordCount_search").combobox('loadData',myConstants.json_storyWordCount); 
        	$("#combo_storyType_search").combobox('loadData',common_storyTypes); 
           }
         function story_storyManage_getAllStorys(id,name)
         {        	             
        	 storyManage_table_datagrid.datagrid({
         	    fit:true,
         	    url:'<%=request.getContextPath()%>/admin/getStorys.json',
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
         	    toolbar:"#story_storyManage_toolbar",
         	    queryParams: {
         			id: id,
         			name: name
         		},
         		frozenColumns:[[{field:'ids',title:'小说编号',width:55,checkbox:true},
         	           	        {field:'id',title:'小说编号',width:55,sortable:true},
         	           	    	{field:'name',title:'小说名',width:100},
         	           	    ]],
         	    columns:
         	    	[[                     
                    {field:'author',title:'作者',width:80}, 
					{field:'storyType',title:'小说分类',width:50,formatter:
           	        	function(value,row,index){
						var id=-1;
						try{
						id=value.id;
						}catch (e) {
							id=-1;
						}
        				return wgUtils.getValueById(common_storyTypes, id, 'name');
        			}},
         	        {field:'wordCount',title:'字数',width:70,formatter:
           	        	function(value,row,index){
        	            return wgUtils.getValueById(myConstants.json_storyWordCount, value,'name');
        			}},
        			{field:'status',title:'小说状态',width:50,formatter:
           	        	function(value,row,index){
        				 return wgUtils.getValueById(myConstants.json_storyStatus, value,'name');
        			}},
        			{field:'updateState',title:'更新状态',width:50,formatter:
           	        	function(value,row,index){
        				 return wgUtils.getValueById(myConstants.json_storyUpdataState, value,'name');
        			}},
         	        {field:'markCountWhenCorrect',title:'纠正次数',width:50},
         	        {field:'errorCount',title:'错误次数',width:50},
        			{field:'storyBaikeUrl',title:'百科url',width:50,formatter:
           	        	function(value,row,index){      				 
        				 return '<a href="'+value+'" target= _blank>打开</a>';
        			}},
         	       {field:'correctTime',title:'初始纠错时间',sortable:true,formatter:function(value,row,index){
       				return wgUtils.getTime(value, 0);
       					}
					},		
         	        {field:'publishedTime',title:'发布时间',sortable:true,formatter:function(value,row,index){
															        				return wgUtils.getTime(value, 0);
															        			}
         	        },
         	       {field:'endTime',title:'完结时间',align:'left',sortable:true,formatter:
          	        	function(value,row,index){
       					return wgUtils.getTime(value, 0);
       					}
					}
         	    ]],
         	 onLoadSuccess:function(data){
         		 //console.info(data);
         		 if(wgUtils.isUsed(data))
         			 {
	         			 data=wgUtils.parseToJson(data);
	         			if(wgUtils.isUsed(data.total)&&data.total==0)
	         				{
		         				alert("没有找到相关小说!");
		         				return;
	         				}
	         			if(data.success==false)
	         				alert(data.msg);         			
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
         
           
           
         function searchStory(id,name){
        	 if(typeof id=='undefined'||!id){
        		 return;
        	 }
        	 
        	 var data=wgUtils.serializeObject($("#user_search_form"));
        	     data.id=id;
        	     data.name=name;
        	 storyManage_table_datagrid.datagrid("options").queryParams=data;
        //console.info(queryParams);
        //console.info($("#tops_table").datagrid("options").queryParams);
        
     	//storyManage_table_datagrid.datagrid();
     	storyManage_table_datagrid.datagrid('load');       	 
         };  
         
         function searchStoryId()
         { if(!$("#user_search_form").form('validate'))
        	 return;
        	 var id=$("#user_search_form #search_content").val();
        	 searchStory(id,null);
         };
         
         function searchStoryAll(){//清空搜索框内容,并请求所有用户
        	 $("#user_search_form #search_content").val('');
        	 searchStory(-1,null);
        	 
         };
        function story_storyManage_help(){
        	var s="1.当搜索小说编号的时候,其它限制条件无效!\n2.开始时间和结束时间必须和其作用的时间范围同时选择才有效!";        	
        	alert(s);
        };
        
        function story_storyManage_editStory(){
        	var selections=storyManage_table_datagrid.datagrid('getSelections');
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
            		
            		common_editStory(data,"/admin/updateStory.json",true,function(){storyManage_table_datagrid.datagrid('reload');
            			
            		},function(){});       	
            	}
        }
        
        function story_storyManage_unSelectStory(){
        	storyManage_table_datagrid.datagrid('unselectAll');
        }
        
        //查看小说
        function story_storyManage_lookStory(){
        	
        	var selections=storyManage_table_datagrid.datagrid('getSelections');
            if(!wgUtils.isUsed(selections)||selections.length<=0)
               	{
               	 alert("您必须至少选择一个小说才能够查看!");
               	}
               else if(selections.length>1)
               	{
               	alert("请只选择一个小说!");
               	} else{
               		var id=selections[0].id;
               		window.open("<%=request.getContextPath()%>/story/showStoryDeteils.do?id="+id);
               	}
        }
        
        function story_storyManage_addStory()
        {
        	common_addStory("/admin/addStory.json",true,function(){storyManage_table_datagrid.datagrid('reload');},null);
        }
        
        function story_storyManage_checkDeleteStory()
        {
        	var selections=storyManage_table_datagrid.datagrid('getSelections');   
            if(!wgUtils.isUsed(selections)||selections.length<=0)
           	{
           	 alert("您必须至少选择一个小说才能够删除!");
           	}
           else{
           	  $.messager.confirm("请确认", "您确定要删除么?", story_storyManage_deleteStory);       	
           	}
        };
        
        function story_storyManage_deleteStory(r)
        {
        	if(r){
        		var selections=storyManage_table_datagrid.datagrid('getSelections');
        		var ids=[];
        		for(var i=0;i<selections.length;i++){
        			ids.push(selections[i].id);
        		}
        		ids=ids.join(',');
        		var url="/admin/deleteStorys.json?ids="+ids;
        		
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
        				storyManage_table_datagrid.datagrid('load');//从服务器加载,防止删除后加载不完全的情况
        				storyManage_table_datagrid.datagrid('unselectAll');
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
<title>普通用户管理</title>
</head>
<body>
<div id="story_storyManage_mainDiv" class="easyui-layout" data-options="fit:true">
		<div id="story_storyManage_searchContent" data-options="region:'north',title:'搜索条件:',split:true" style="height:230px;">
				
				<form id="user_search_form" method="post" class="easyui-form">
				    <div align="center">
				    <div id="search_condition_div">
				         查询限制条件:
				         <br/>
				         <table>
				         <tr>
				         	<td><label for="user">小说名称:</label>
				    		 	<input class="easyui-validatebox" data-options="required:false" type="text" name="name"/>
				    		 </td>	
				    		 <td><label for="author">小说作者:</label>
				    		 	<input class="easyui-validatebox" data-options="required:false" type="text" name="author"/>
				    		 </td>				    		 		   			 
						</tr>
						<tr>
				         	<td>
				         	<label for="combo_wordCount_search">字数:</label>
				    			<input id="combo_wordCount_search" class="easyui-combobox" name="type" data-options="
				                                editable:false,
												valueField: 'id',
												textField: 'name',
												" />
							</td>
				   			 <td><label for="combo_storyUpdateStatus_search">更新状态:</label>
				    			<input id="combo_storyUpdateStatus_search" class="easyui-combobox" name="type" data-options="
				                                editable:false,
												valueField: 'id',
												textField: 'name',
												" />
							</td>
						</tr>
							<tr>	
							<td><label for="combo_storyStatus_search">小说状态:</label>
				    			<input id="combo_storyStatus_search" class="easyui-combobox" name="type" data-options="
				                                editable:false,
												valueField: 'id',
												textField: 'name',
												" />
							</td>	
							<td><label for="combo_storyType_search">小说类型:</label>
				    			<input id="combo_storyType_search" class="easyui-combobox" name="type" data-options="
				                                editable:false,
												valueField: 'id',
												textField: 'name',
												" />
							</td>				
							</tr>					
					<tr>
						<td><label for="search_startTime">开始时间:</label>
				    	<input class="easyui-datetimebox" data-options="required:false,showSeconds:true,editable:false" type="text" name="condition_startTime"/></td>
				   		 <td><label for="search_endTime">结束时间:</label>
				       	<input class="easyui-datetimebox" data-options="required:false,showSeconds:true,editable:false" type="text" name="condition_endTime"/></td>
		       	 	</tr>
		           <tr>
	           			 <td>时间范围作用于:</td><td>
				         <label for="publishedTime">发布时间:</label>
				         <input type="checkbox" name="publishedTime" value='true' />
				         <label for="endTime">完结时间:</label>
				         <input type="checkbox" name="endTime" value='true' />
				         </td>
	               </tr>
				         
				   </table>				   				  				    
				    </div>
				    
				    
				    <label for="search_content">关键字查询:</label>
				        <input class="easyui-validatebox" data-options="required:true" type="text" name="search_content" id="search_content"/>    
				    <div >
				        <input type="button" value="搜索小说编号" onclick="searchStoryId();">
				        <input type="button" value="显示所有符合条件的小说" onclick="searchStoryAll();">
				        <input type="button" value="清除所有限制条件" onclick="clearSearchForm();">
				    </div>
				    </div>   
				</form>
				</div>
				<br/>
				<div data-options="region:'center'">
				<div id="story_storyManage_toolbar">		
				<a onclick="story_storyManage_addStory();" href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" style="float:left;">增加</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:story_storyManage_checkDeleteStory();" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true"style="float:left;">删除</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:story_storyManage_editStory();" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" style="float:left;">修改</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:story_storyManage_lookStory();" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" style="float:left;">查看</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:story_storyManage_unSelectStory();" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" style="float:left;">取消所有选中</a>		
				<div class="datagrid-btn-separator"></div>
				<a onclick="story_storyManage_help();" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-help',plain:true" >帮助</a>
	          </div>	    
		<table id="storyManage_table_datagrid"></table>
		</div>

<jsp:include page="../common/add_edit_story.jsp"></jsp:include>
<jsp:include page="../common/tree_dialog.jsp"></jsp:include>
</div>
</body>
</html>