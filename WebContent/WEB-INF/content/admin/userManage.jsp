<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>
<head>
<jsp:include page="../include.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<Script language="JavaScript" type="text/javascript">
           var userManage_table_datagrid;
           
           $(function(){
        	  userManage_table_datagrid=$("#userManage_table_datagrid");
       	   
        	   admin_userManage_getAllUsers(-1,null);
           });
           
         function admin_userManage_getAllUsers(id,name)
         {        	             
        	 userManage_table_datagrid.datagrid({
         	    fit:true,
         	    url:'<%=request.getContextPath()%>/admin/getAllUsers.json',
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
         	    toolbar:"#admin_userManage_toolbar",
         	    queryParams: {
         			id: id,
         			name: name
         		},
         		frozenColumns:[[{field:'ids',title:'用户编号',width:100,checkbox:true},
         	           	        {field:'id',title:'用户编号',width:70,sortable:true},
         	           	        {field:'userName',title:'用户名',width:100,sortable:true},           	           	    
         	           	    ]],
         	    columns:
         	    	[[
         	       // {field:'id',title:'编号',width:100},
         	        //{field:'name',title:'姓名',width:100},
         	        {field:'password',title:'密码',width:50},
         	        {field:'email',title:'Email',width:100},
         	        {field:'age',title:'年龄',width:30},
         	        {field:'sex',title:'性别',width:30,formatter:
           	        	function(value,row,index){        				
         	        	if(wgUtils.isUsed(value)){
        					return value==1?'男':'女';
        				};
        			}},
         	        {field:'phone',title:'手机',width:100},
         	        //{field:'photo',title:'头像',width:100},
         	        {field:'qq',title:'QQ',width:100},
         	        {field:'markTicketCount',title:'评分次数',width:70},
         	        {field:'lastLoginTime',title:'最近登录时间',width:100,sortable:true,formatter:
															           	        	function(value,row,index){
															        				return wgUtils.getTime(value, 0);
															        			}
         	        },
         	       {field:'createTime',title:'创建时间',align:'left',sortable:true,formatter:
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
         				alert("没有找到相关用户!");
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
         
           
           
         function searchUser(id,name){
        	 if(typeof id=='undefined'||!id){
        		 return;
        	 }
        	 userManage_table_datagrid.datagrid("options").queryParams={
        			 id: id,
             		 name: name
     			};
        //console.info(queryParams);
        //console.info($("#tops_table").datagrid("options").queryParams);
        
     	//userManage_table_datagrid.datagrid();
     	userManage_table_datagrid.datagrid('load');       	 
         };  
         
         function searchUserId()
         { if(!$("#user_search_form").form('validate'))
        	 return;
        	 var id=$("#user_search_form #search_content").val();
        	 searchUser(id,null);
         };
         
         function searchUserName(){
        	 if(!$("#user_search_form").form('validate'))
            	 return;
        	 var name=$("#user_search_form #search_content").val();
        	 searchUser(-1,name);
         };
         
         function searchUserAll(){//清空搜索框内容,并请求所有用户
        	 $("#user_search_form #search_content").val('');
        	 searchUser(-1,null);
        	 
         };
        function admin_userManage_help(){
        	var s="您好!";
        	alert(s);
        };
        
        function admin_userManage_editUser(){
        	var selections=userManage_table_datagrid.datagrid('getSelections');
         if(!wgUtils.isUsed(selections)||selections.length<=0)
            	{
            	 alert("您必须至少选择一行数据才能够编辑!");
            	}
            else if(selections.length>1)
            	{
            	alert("请只选择一行数据编辑!");
            	} else{                        
            		common_editUser(selections[0],"/admin/updateUser.json",true,function(){userManage_table_datagrid.datagrid('reload');},function(){});       	
            	}
        }
        
        function admin_userManage_unSelectUser(){
        	userManage_table_datagrid.datagrid('unselectAll');
        }
        
        function admin_userManage_addUser()
        {
        	common_addUser("/admin/addUser.json",true,function(){userManage_table_datagrid.datagrid('reload');},null);
        }
        
        function admin_userManage_checkDeleteUser()
        {
        	var selections=userManage_table_datagrid.datagrid('getSelections');   
            if(!wgUtils.isUsed(selections)||selections.length<=0)
           	{
           	 alert("您必须至少选择一个用户才能够删除!");
           	}
           else{
           	  $.messager.confirm("请确认", "您确定要删除么?", admin_userManage_deleteUser);       	
           	}
        };
        
        function admin_userManage_deleteUser(r)
        {
        	if(r){
        		var selections=userManage_table_datagrid.datagrid('getSelections');
        		var ids=[];
        		for(var i=0;i<selections.length;i++){
        			ids.push(selections[i].id);
        		}
        		ids=ids.join(',');
        		var url="/admin/deleteUsers.json?ids="+ids;
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
        				userManage_table_datagrid.datagrid('load');//从服务器加载,防止删除后加载不完全的情况
        				userManage_table_datagrid.datagrid('unselectAll');
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
<div id="admin_userManage_mainDiv" class="easyui-panel" data-options="fit:true">
		<div id="admin_userManage_toolbar">
				<form id="user_search_form" method="post" class="easyui-form">
				    <div align="center">
				    <label for="search_content">查询:</label>
				        <input class="easyui-validatebox" data-options="required:true" type="text" name="search_content" id="search_content"/>    
				    <div>
				        <input type="button" value="搜索用户编号" onclick="searchUserId();">
				        <input type="button" value="搜索用户名" onclick="searchUserName();">
				        <input type="button" value="显示所有用户" onclick="searchUserAll();">
				    </div>
				    </div>   
				</form>
				<br/>		
				<a onclick="admin_userManage_addUser();" href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" style="float:left;">增加</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_userManage_checkDeleteUser();" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true"style="float:left;">删除</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_userManage_editUser();" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" style="float:left;">修改</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_userManage_unSelectUser();" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" style="float:left;">取消所有选中</a>		
				<div class="datagrid-btn-separator"></div>
				<a onclick="admin_userManage_help();" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-help',plain:true" >帮助</a>
	    </div>
		<table id="userManage_table_datagrid"></table>
<jsp:include page="../common/add_edit_User.jsp"></jsp:include>
</div>
</body>
</html>