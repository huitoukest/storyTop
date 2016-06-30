<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>
<jsp:include page="../include.jsp"></jsp:include>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<Script language="JavaScript" type="text/javascript">
           var adminManage_table_datagrid;
           
           $(function(){
        	  adminManage_table_datagrid=$("#adminManage_table_datagrid");
       	   
        	   admin_adminManage_getAllAdmins(-1,null);
           });
           
         function admin_adminManage_getAllAdmins(id,name)
         {        	             
        	 adminManage_table_datagrid.datagrid({
         	    fit:true,
         	    url:'getAllAdmins.json',
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
         	    toolbar:"#admin_adminManage_toolbar",
         	    queryParams: {
         			id: id,
         			name: name
         		},
         		frozenColumns:[[{field:'ids',title:'用户编号',width:100,checkbox:true},
         	           	        {field:'id',title:'用户编号',width:100,sortable:true},
         	           	        {field:'name',title:'用户名',width:100,sortable:true},           	           	    
         	           	    ]],
         	    columns:
         	    	[[
         	       // {field:'id',title:'编号',width:100},
         	        //{field:'name',title:'姓名',width:100},
         	        {field:'password',title:'密码',width:100},
         	        {field:'nickName',title:'称呼',width:100},
         	        {field:'powerValue',title:'权力值',width:100},
         	        {field:'lastLoginTime',title:'最近登录时间',align:'left',sortable:true,formatter:
															           	        	function(value,row,index){
															        				return wgUtils.getTime(value, 0);
															        			}
         	        }
         	    ]],
         	 onLoadSuccess:function(data){
         		 console.info(data);
         		 if(wgUtils.isUsed(data))
         			 {
	         			 data=wgUtils.parseToJson(data);
	         			if(wgUtils.isUsed(data.total)&&data.total==0)
	         				{
	         				$.messager.show({
	             				title:"提示",
		          	        	msg:"没有找到相关用户!",
		          	        	timeout:4000,
		          	        	showType:'slide'
	             			 });
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
         
           
           
         function searchAdmin(id,name){
        	 if(typeof id=='undefined'||!id){
        		 return;
        	 }
        	 adminManage_table_datagrid.datagrid("options").queryParams={
        			 id: id,
             		 name: name
     			};
        //console.info(queryParams);
        //console.info($("#tops_table").datagrid("options").queryParams);
        
     	//adminManage_table_datagrid.datagrid();
     	adminManage_table_datagrid.datagrid('load');       	 
         };  
         
         function searchAdminId()
         { if(!$("#user_search_form").form('validate'))
        	 return;
        	 var id=$("#user_search_form #search_content").val();
        	 searchAdmin(id,null);
         };
         
         function searchAdminName(){
        	 if(!$("#user_search_form").form('validate'))
            	 return;
        	 var name=$("#user_search_form #search_content").val();
        	 searchAdmin(-1,name);
         };
         
         function searchAdminAll(){//清空搜索框内容,并请求所有用户
        	 $("#user_search_form #search_content").val('');
        	 searchAdmin(-1,null);
        	 
         };
        function admin_adminManage_help(){
        	var s="1.权力值越小表示权限越大,值最小为(1~127).\n2.当一个管理员的权限比你大的时候,他的相关信息将不会显示!\n3.一个管理员权限和您相等时,其密码显示为***.\n4.您无权增加或修改或删除一个大于等于您的其它管理员信息!";        	
        	alert(s);
        };
        
        function admin_adminManage_editAdmin(){
        	var selections=adminManage_table_datagrid.datagrid('getSelections');
         if(!wgUtils.isUsed(selections)||selections.length<=0)
            	{
            	 alert("您必须至少选择一行数据才能够编辑!");
            	}
            else if(selections.length>1)
            	{
            	alert("请只选择一行数据编辑!");
            	} else{                        
            		common_editAdmin(selections[0],"/admin/updateAdmin.json",true,function(){adminManage_table_datagrid.datagrid('reload');
            			
            		},function(){});       	
            	}
        }
        
        function admin_adminManage_unSelectAdmin(){
        	adminManage_table_datagrid.datagrid('unselectAll');
        }
        
        function admin_adminManage_addAdmin()
        {
        	common_addAdmin("/admin/addAdmin.json",true,function(){adminManage_table_datagrid.datagrid('reload');},null);
        }
        
        function admin_adminManage_checkDeleteAdmin()
        {
        	var selections=adminManage_table_datagrid.datagrid('getSelections');   
            if(!wgUtils.isUsed(selections)||selections.length<=0)
           	{
           	 alert("您必须至少选择一个用户才能够删除!");
           	}
           else{
           	  $.messager.confirm("请确认", "您确定要删除么?", admin_adminManage_deleteAdmin);       	
           	}
        };
        
        function admin_adminManage_deleteAdmin(r)
        {
        	if(r){
        		var selections=adminManage_table_datagrid.datagrid('getSelections');
        		var ids=[];
        		for(var i=0;i<selections.length;i++){
        			ids.push(selections[i].id);
        		}
        		ids=ids.join(',');
        		var url="/admin/deleteAdmins.json?ids="+ids;
        		
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
        				adminManage_table_datagrid.datagrid('load');//从服务器加载,防止删除后加载不完全的情况
        				adminManage_table_datagrid.datagrid('unselectAll');
        				$.messager.show({
        					title:"提示",
        				    msg:d.msg
        				});}
        			}
        		});
        	}
        };
        

</Script>
<title>普通用户管理</title>
</head>
<body>
<div id="admin_adminManage_mainDiv" class="easyui-panel" data-options="fit:true">
		<div id="admin_adminManage_toolbar">
				<form id="user_search_form" method="post" class="easyui-form">
				    <div align="center">
				    <label for="search_content">查询:</label>
				        <input class="easyui-validatebox" data-options="required:true" type="text" name="search_content" id="search_content"/>    
				    <div>
				        <input type="button" value="搜索管理员编号" onclick="searchAdminId();">
				        <input type="button" value="搜索管理员用户名" onclick="searchAdminName();">
				        <input type="button" value="显示所有管理员" onclick="searchAdminAll();">
				    </div>
				    </div>   
				</form>
				<br/>		
				<a onclick="admin_adminManage_addAdmin();" href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" style="float:left;">增加</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_adminManage_checkDeleteAdmin();" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true"style="float:left;">删除</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_adminManage_editAdmin();" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" style="float:left;">修改</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_adminManage_unSelectAdmin();" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" style="float:left;">取消所有选中</a>		
				<div class="datagrid-btn-separator"></div>
				<a onclick="admin_adminManage_help();" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-help',plain:true" >帮助</a>
	    </div>
		<table id="adminManage_table_datagrid"></table>
<jsp:include page="../common/add_edit_admin.jsp"></jsp:include>
</div>
</body>
</html>