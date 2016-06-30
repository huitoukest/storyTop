<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<html>
<head>
<%@page import="com.tingfeng.staticThing.UploadFolder"%>
<jsp:include page="../include.jsp"></jsp:include> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<Script language="JavaScript" type="text/javascript">
 var admin_userAuManage_div;
 var admin_userAuManage_table;
 var common_imgDialog;
 
 $(function(){
	 admin_userAuManage_div=$("#admin_userAuManage_div");
	 admin_userAuManage_table=$("#admin_userAuManage_table");
	 common_imgDialog=$("#common_imgDialog");
	 
	 admin_userAuManageInit();
	 common_imgDialogInit();
 });

 /**
  *对话框初始化,标题,按钮名称,按钮图标
 */
 function common_imgDialogInit()
 {
 	common_imgDialog.dialog({
 		title: '图片',
 	    width: 730,
 	    height: 650,
 	    closed:true,
 	    cache: false,
 	    //href: 'get_content.php',
 	    modal: true,
 	    buttons:[{
              text:'确定',
             handler:function(){
            	 common_imgDialog.dialog('close');
      	   }
              }]});	              
 };
 /**
  * 传入一个用户认证的图片
  */
 function setUserAuImg(url)
 {  
 	if(wgUtils.isUsed(url))
  {	//
 	
 	//alert(url);
 	console.info(url);
    //$("#common_userAu_img").attr("url",url);
    document.getElementById("common_userAu_img").src=url;
    common_imgDialog.dialog('open');
  }  else{
 	  alert("此图片不存在!");
     }
 	}
 
 
 function  admin_userAuManageInit()
 {        	            
	 admin_userAuManage_table.datagrid({
 	    fit:true,
 	    url:'<%=request.getContextPath()%>/admin/getAlluserAu.json',
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
 	    toolbar:"#admin_userAu_toolbar",
 	    queryParams: {
 			userId: -1
 		},
 		frozenColumns:[[{field:'ids',title:'用户编号',width:100,checkbox:true},
 	           	        {field:'id',title:'认证编号',width:100,sortable:true},
 	           	        {field:'user',title:'用户',width:100,sortable:true,formatter:
	           	        	function(value,row,index){
	        				if(typeof value=='undefined'){
	        					return '错误用户！';
	        				}
 	           	        	return value.name;
	        			}},           	           	    
 	           	    ]],
 	    columns:
 	    	[[
 	       // {field:'id',title:'编号',width:100},
 	        //{field:'name',title:'姓名',width:100},
 	        {field:'isNeedAuthentication',title:'是否申请认证',width:100,formatter:
   	        	function(value,row,index){
				if(value){
					return "是";
				}else {
					return "否";
				}
			}},
 	        {field:'isStudentUser',title:'是否是认证学用户',width:100},
 	        {field:'isAuthened',title:'是否已经审核',width:100},
 	        //{field:'photo',title:'头像',width:100},
 	        {field:'msg',title:'系统消息',width:100},
 	        {field:'image',title:'图片',width:100,formatter:function(value,row,index){
 	           //console.info(value);
 	    	   if(typeof value=='undefined'){
 	    		   return "无图";
 	    	   }
 	           if(typeof value.name!='undefind'&&wgUtils.isUsed(value.name)){
 	    		   return "<a href=\"javascript:void(0);\" onclick=\"setUserAuImg('<%=UploadFolder.getImageDisPlayFolder(request)%>/"+value.name+"') \" >查看</a> ";
 	    	   }else return "无图";
 	       }},
 	        {field:'lastAuthenticationTime',title:'最近审核时间',align:'left',sortable:true,formatter:
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
 				alert("没有找到相关数据!");
 				return;
 				}else
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
 
 function searchUserName(){
	 var search_content=$("#user_search_form #search_content").val();
	 if(!$("#user_search_form").form('validate'))
    	 return;
    	admin_userAuManage_table.datagrid("options").queryParams={		 
     		usreId:-1, 
    		name: search_content
			};
    	 admin_userAuManage_table.datagrid('load');   
 }
 
 function searchUserAll(){
	 $("#user_search_form #search_content").val('');
    	admin_userAuManage_table.datagrid("options").queryParams={		 
     		userId:-1,
			};
    	 admin_userAuManage_table.datagrid('load');  
 }
 
 function admin_userAu_help(){
	 alert('谢谢您的使用!');
 }
 
 function admin_userAu_unSelectUser(){
	 admin_userAuManage_table.datagrid('unselectAll');
 }
 //编辑用户认证信息
 function admin_userAu_editUser()
 {
	 var selections=admin_userAuManage_table.datagrid('getSelections');
	 if(!wgUtils.isUsed(selections)||selections.length<=0)
 	{
 	 alert("您必须至少选择一行数据才能够编辑!");
 	}
 else if(selections.length>1)
 	{
 	alert("请只选择一行数据编辑!");
 	} else{  
 		
 		common_editUserAu(selections[0],"/admin/updateUserAu.json",true,function(){
 			admin_userAuManage_table.datagrid('reload');
 			
 		},function(){});			
 	}
 }
</Script>
<title>学生认证管理</title>
</head>
<body>
普通用户认证为学生用户的管理:
<hr/>
<div id="admin_userAuManage_div" class="easyui-panel" data-options="fit:true">
<jsp:include page="../common/add_edit_userAu.jsp"></jsp:include>
  <div id="admin_userAu_toolbar">
   <form id="user_search_form" method="post" class="easyui-form">
				    <div align="center">
				    <label for="search_content">查询:</label>
				        <input class="easyui-validatebox" data-options="required:true" type="text" name="search_content" id="search_content"/>    
				    <div>
				        <input type="button" value="搜索用户名" onclick="searchUserName();">
				        <input type="button" value="显示所有用户" onclick="searchUserAll();">
				    </div>
				    </div>   
				</form>
				<br/>		
				<a onclick="" href="javascript:admin_userAu_editUser();" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" style="float:left;">修改</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_userAu_unSelectUser();" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" style="float:left;">取消所有选中</a>		
				<div class="datagrid-btn-separator"></div>
				<a onclick="admin_userAu_help();" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-help',plain:true" >帮助</a>
	   
  </div>
<table id="admin_userAuManage_table"></table>
</div>
<div id="common_imgDialog">	
<img src="" id="common_userAu_img" width="650px" height="550px" alt="未找到相关图片!"/>		
</div>
</body>
</html>