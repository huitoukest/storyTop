<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>
<head>
<jsp:include page="../include.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<Script language="JavaScript" type="text/javascript">
           var affcheManage_table_datagrid;
           
           $(function(){
        	  affcheManage_table_datagrid=$("#affcheManage_table_datagrid");
       	   
        	   admin_affcheManage_getAllAffiches(-1,null);
           });
           
         function admin_affcheManage_getAllAffiches(id,name)
         {        	             
        	 affcheManage_table_datagrid.datagrid({
         	    fit:true,
         	    url:'<%=request.getContextPath()%>/admin/getAllAffiche.json',
         	    border:false,
         	    pagination:true,
         	    idField:'id',
         	    //pagePosition:'top',//'bottom'
         	    pagePosition:'bottom',
         	    fitColumns:true,
         	    //sortName:"id",//排序的字段的名称
         	    //sortOrder:"asc",//排序的方式
         	    pageSize:10,
         	    pageList:[10,20,30],
         	    toolbar:"#admin_affcheManage_toolbar",
         		frozenColumns:[[{field:'ids',title:'1编号',width:100,checkbox:true},
         	           	        {field:'id',title:'公告编号',width:100,sortable:true},
         	           	        {field:'isUsing',title:'是否启用',width:100,sortable:true},           	           	    
         	           	    ]],
         	    columns:
         	    	[[
         	        {field:'affiche',title:'公告内容',width:100},
         	        {field:'publishTime',title:'发布时间',align:'left',sortable:true,formatter:
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
         				alert("没有找到相关公告内容!");
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
         
           
           
         function searchAffiche(id,name){
        	 if(typeof id=='undefined'||!id){
        		 return;
        	 }
        	 affcheManage_table_datagrid.datagrid("options").queryParams={
        			 id: id,
             		 name: name
     			};
        //console.info(queryParams);
        //console.info($("#tops_table").datagrid("options").queryParams);
        
     	//affcheManage_table_datagrid.datagrid();
     	affcheManage_table_datagrid.datagrid('load');       	 
         };  
         
         function searchAfficheId()
         { if(!$("#affiche_search_form").form('validate'))
        	 return;
        	 var id=$("#affiche_search_form #search_content").val();
        	 searchAffiche(id,null);
         };
         
         function searchAfficheName(){
        	 if(!$("#affiche_search_form").form('validate'))
            	 return;
        	 var name=$("#affiche_search_form #search_content").val();
        	 searchAffiche(-1,name);
         };
         
         function searchAfficheAll(){//清空搜索框内容,并请求所有用户
        	 $("#affiche_search_form #search_content").val('');
        	 searchAffiche(-1,null);
        	 
         };
        function admin_affcheManage_help(){
        	var s="您好,公告只有启用之后才会在首页展示！";
        	alert(s);
        };
        
        function admin_affcheManage_editAffiche(){
        	var selections=affcheManage_table_datagrid.datagrid('getSelections');
         if(!wgUtils.isUsed(selections)||selections.length<=0)
            	{
            	 alert("您必须至少选择一行数据才能够编辑!");
            	}
            else if(selections.length>1)
            	{
            	alert("请只选择一行数据编辑!");
            	} else{                        
            		common_editAffiche(selections[0],"/admin/updateAffiche.json",true,function(){affcheManage_table_datagrid.datagrid('reload');
            			
            		},function(){});       	
            	}
        }
        
        function admin_affcheManage_unSelectAffiche(){
        	affcheManage_table_datagrid.datagrid('unselectAll');
        }
        //增加一个网站公告
        function admin_affcheManage_addAffiche()
        {
        	common_addAffiche("/admin/addAffiche.json",true,function(){affcheManage_table_datagrid.datagrid('reload');},null);
        }
        
        function admin_affcheManage_checkDeleteAffiche()
        {
        	var selections=affcheManage_table_datagrid.datagrid('getSelections');   
            if(!wgUtils.isUsed(selections)||selections.length<=0)
           	{
           	 alert("您必须至少选择一个用户才能够删除!");
           	}
           else{
           	  $.messager.confirm("请确认", "您确定要删除么?", admin_affcheManage_deleteAffiche);       	
           	}
        };
        
        function admin_affcheManage_deleteAffiche(r)
        {
        	if(r){
        		var selections=affcheManage_table_datagrid.datagrid('getSelections');
        		var ids=[];
        		for(var i=0;i<selections.length;i++){
        			ids.push(selections[i].id);
        		}
        		ids=ids.join(',');
        		var url="/admin/deleteAffiches.json?ids="+ids;
        		
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
        				affcheManage_table_datagrid.datagrid('load');//从服务器加载,防止删除后加载不完全的情况
        				affcheManage_table_datagrid.datagrid('unselectAll');
        				$.messager.show({
        					title:"提示",
        				    msg:d.msg
        				});}
        			}
        		});
        	}
        };
        

</Script>
<title>网站公告管理</title>
</head>
<body>
<div>
<div id="admin_affcheManage_mainDiv" class="easyui-panel"  data-options="fit:false">	
				<a onclick="admin_affcheManage_addAffiche();" href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" style="float:left;">增加</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_affcheManage_checkDeleteAffiche();" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true"style="float:left;">删除</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_affcheManage_editAffiche();" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" style="float:left;">修改</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_affcheManage_unSelectAffiche();" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" style="float:left;">取消所有选中</a>		
				<div class="datagrid-btn-separator"></div>
				<a onclick="admin_affcheManage_help();" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-help',plain:true" >帮助</a>
	    </div>
		<table id="affcheManage_table_datagrid"></table>
<jsp:include page="../common/add_edit_affiche.jsp"></jsp:include>
</div>
</body>
</html>