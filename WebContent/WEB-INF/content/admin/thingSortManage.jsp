<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<jsp:include page="../include.jsp"></jsp:include> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<Script language="JavaScript" type="text/javascript">
           var admin_thingSortManage_tree;
           $(function(){
        	   admin_thingSortManage_tree=$("#admin_thingSortManage_tree");
        	   
        	   admin_thingSortManage_treeInit();
           });
           
           function admin_thingSortManage_treeInit(){
        	   admin_thingSortManage_tree.tree({
        		    url:"<%=request.getContextPath()%>/getThingSort.json",
        		    checkbox:true,
        		    onlyLeafCheck:true,
        		    lines:true,
        		    queryParams:{
        		    },
        		    onSelect:function(node){
        		    	//if(node.checked==false){
        		    	//console.info(node);
        		    	//admin_thingSortManage_tree.tree('check',node.target);}
        		    	//node.checked=!node.checked;
        		    	//admin_thingSortManage_tree.tree('update', node);
        		    },
        		    onDblClick:function(node){
        		    	admin_thingSortManage_tree.tree('uncheck',node.target);
        		    },
        		    onClick:function(node){
        		    	//node.checked=!node.checked;
        		    	//admin_thingSortManage_tree.tree('update', node);
        		    }
        		});
           }
           
           function admin_thingSortManage_checkDeleteThingSort(){
        	   var checked=admin_thingSortManage_tree.tree('getChecked');          	          	                 
        	   if(!wgUtils.isUsed(checked)||checked.length<=0)
              	{
              	 alert("您必须至少用多选框选中一个分类才能够删除!");
              	}
              else{
              	  $.messager.confirm("请确认", "您确定要删除么?", admin_thingSortManage_deleteThingSort);       	
              	}
           }
           
           function admin_thingSortManage_deleteThingSort(r){//r是用户点击的确定还是取消的值
        	   if(wgUtils.isUsed(r)&&r){
        	   var selections=admin_thingSortManage_tree.tree('getChecked'); 
        	   
        	   var ids=[];
       		for(var i=0;i<selections.length;i++){
       			ids.push(selections[i].id);
       		}
       		ids=ids.join(',');
       		var url="/admin/deleteThingSorts.json?ids="+ids;      		
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
       		       		admin_thingSortManage_tree.tree('remove',selections[i].target);
       		       		}
                         				 
       				$.messager.show({
       					title:"提示",
       				    msg:d.msg
       				});}
       			}
       		});
        	   }
           }
           
           function admin_thingSortManage_editThingSort(){
        	   var node=admin_thingSortManage_tree.tree('getSelected');
        	  // console.info(node);
        	   common_editThingSort(node,"/admin/updateThingSort.json",function(r){
        		   admin_thingSortManage_tree.tree('update',{
        			   target:node.target,
        			   text:r.text
        		   });
        		   
        	   });
           }
           
           function admin_thingSortManage_unSelectThingSort(){
        	   
           }
           
           function admin_thingSortManage_addThingSort(){
        	   var parent=admin_thingSortManage_tree.tree('getSelected');
        	   if(!wgUtils.isUsed(parent)||!wgUtils.isUsed(parent.id))
        		   {
        		    alert("请先选择一个分类作为父分类!");
        		    return;
        		   }
        	   common_addThingSort("/admin/addThingSort.json",{id:parent.id,pName:parent.text},function(r,data){
        		   admin_thingSortManage_tree.tree('append', {
        				parent: parent.target,
        				data: [{
        					id: data.object.id,
        					text: r.text,
        				}]
        			});
        	   });
           }
           
           
           function admin_thingSortManage_help(){
        	   alert("1.只有没有子分类的物品分类才能够被删除!\n2.通过多选框可以多个分类同时删除!\n3.编辑和增加必须先选中一个分类才行!");
           }
</Script>
<title>物品分类管理</title>
</head>
<body>
物品分类管理:
<hr/>
<div id="admin_thingSortManage_tree_div" class="easyui-panel" data-options="fit:true">
<div id="admin_thingSortManage_tree_tools" class="easyui-panel">
<a onclick="admin_thingSortManage_addThingSort();" href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" style="float:left;">增加</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_thingSortManage_checkDeleteThingSort();" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true"style="float:left;">删除</a>
				<div class="datagrid-btn-separator"></div>
				<a onclick="" href="javascript:admin_thingSortManage_editThingSort();" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" style="float:left;">修改</a>			
				<div class="datagrid-btn-separator"></div>
				<a onclick="admin_thingSortManage_help();" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-help',plain:true" >帮助</a>
</div>
<ul id="admin_thingSortManage_tree"></ul>
<jsp:include page="../common/add_edit_thingSort.jsp"></jsp:include>
</div>
</body>
</html>