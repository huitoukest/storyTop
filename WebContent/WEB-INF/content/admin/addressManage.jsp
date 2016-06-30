<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<jsp:include page="../include.jsp"></jsp:include> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<Script language="JavaScript" type="text/javascript">
           var admin_addressManage_tree;
           $(function(){
        	   admin_addressManage_tree=$("#admin_addressManage_tree");
        	   
        	   admin_addressManage_treeInit();
           });
           
           function admin_addressManage_treeInit(){
        	   admin_addressManage_tree.tree({
        		    url:"<%=request.getContextPath()%>/getAddress.json",
        		    checkbox:true,
        		    onlyLeafCheck:true,
        		    lines:true,
        		    queryParams:{
        		    },
        		    onSelect:function(node){
        		    	//if(node.checked==false){
        		    	//console.info(node);
        		    	//admin_addressManage_tree.tree('check',node.target);}
        		    	//node.checked=!node.checked;
        		    	//admin_addressManage_tree.tree('update', node);
        		    },
        		    onDblClick:function(node){
        		    	admin_addressManage_tree.tree('uncheck',node.target);
        		    },
        		    onClick:function(node){
        		    	//node.checked=!node.checked;
        		    	//admin_addressManage_tree.tree('update', node);
        		    }
        		});
           }
           
           function admin_addressManage_checkDeleteAddress(){
        	   var checked=admin_addressManage_tree.tree('getChecked');          	          	                 
        	   if(!wgUtils.isUsed(checked)||checked.length<=0)
              	{
              	 alert("您必须至少用多选框选中一个地址才能够删除!");
              	}
              else{
              	  $.messager.confirm("请确认", "您确定要删除么?", admin_addressManage_deleteAddress);       	
              	}
           }
           
           function admin_addressManage_deleteAddress(r){//r是用户点击的确定还是取消的值
        	   if(wgUtils.isUsed(r)&&r){
        	   var selections=admin_addressManage_tree.tree('getChecked'); 
        	   
        	   var ids=[];
       		for(var i=0;i<selections.length;i++){
       			ids.push(selections[i].id);
       		}
       		ids=ids.join(',');
       		var url="/admin/deleteAddresss.json?ids="+ids;      		
       		//console.info("ids:");
       		//console.info(ids);
       		//alert(url);
       		$.ajax({
       			url:'<%=request.getContextPath()%>'+url,
       			dataType:'json',
       			success:function(d){
       				
       				if(typeof d.msg!='undefined'&&!d.success)
       				{
       					alert(d.msg);
       					return;
       				} else{//如果删除成功
       					
       					for(var i=0;i<selections.length;i++){
       		       		admin_addressManage_tree.tree('remove',selections[i].target);
       		       		}
                         				 
       				$.messager.show({
       					title:"提示",
       				    msg:d.msg
       				});}
       			}
       		});
        	   }
           }
           
           function admin_addressManage_editAddress(){
        	   var node=admin_addressManage_tree.tree('getSelected');
        	  // console.info(node);
        	   common_editAddress(node,"/admin/updateAddress.json",function(r){
        		   admin_addressManage_tree.tree('update',{
        			   target:node.target,
        			   text:r.text
        		   });
        		   
        	   });
           }
           
           function admin_addressManage_unSelectAddress(){
        	   
           }
           
           function admin_addressManage_addAddress(){
        	   var parent=admin_addressManage_tree.tree('getSelected');
        	   if(!wgUtils.isUsed(parent)||!wgUtils.isUsed(parent.id))
        		   {
        		    alert("请先选择一个地址作为父地址!");
        		    return;
        		   }
        	   common_addAddress("/admin/addAddress.json",{id:parent.id,pName:parent.text},function(r,data){
        		   admin_addressManage_tree.tree('append', {
        				parent: parent.target,
        				data: [{
        					id: data.object.id,
        					text: r.text,
        				}]
        			});
        	   });
           }
           
           
           function admin_addressManage_help(){
        	   alert("1.只有没有子地址的地址才能够被删除!\n2.通过多选框可以多个地址同时删除!\n3.编辑和增加必须先选中一个地址才行!");
           }
</Script>
<title>地址管理</title>
</head>
<body>
地址管理:
<hr/>
<div id="admin_addressManage_tree_div" class="easyui-panel" data-options="fit:true">
<div id="admin_addressManage_tree_tools" class="easyui-panel">
<a onclick="admin_addressManage_addAddress();" href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" style="float:left;">增加</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_addressManage_checkDeleteAddress();" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true"style="float:left;">删除</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_addressManage_editAddress();" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" style="float:left;">修改</a>			
				<div class="datagrid-btn-separator"></div>
				<a onclick="admin_addressManage_help();" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-help',plain:true" >帮助</a>
</div>
<ul id="admin_addressManage_tree"></ul>
<jsp:include page="../common/add_edit_address.jsp"></jsp:include>
</div>
</body>
</html>