<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个公共的显示地址tree的对话框,作为一个组件嵌入到其他页面 ,需要Jquery,easyUI的支持-->
<!-- 通过treeTreeId和treeTreeName来获得用户选择的信息,
通过common_treeDialog.dialog('open')来打开对话框,通过common_treeDialog_treeInit(url,id)来初始化tree,
通过common_treeDialogInit(title,btnName,icon,f)来初始化对话框 -->  
<script type="text/javascript">
var common_treeDialog;
var common_treeDialog_tree;
var treeTreeId;//保存选择tree中节点id
var treeTreeName;//一个选中节点的显示名称

$(function(){
	common_treeDialog_tree=$("#common_treeDialog_tree");
	   common_treeDialog=$("#common_treeDialog");	   
	   //common_treeDialog_treeInit();
});

/**
 *对话框初始化,标题,按钮名称,按钮图标
*/
function common_treeDialogInit(title,btnName,icon,f)
{
	common_treeDialog.dialog({
		title: title,
	    width: 450,
	    height: 500,
	    closed:true,
	    cache: false,
	    //href: 'get_content.php',
	    modal: true,
	    buttons:[{
             text:btnName,
            iconCls:icon,
            handler:function(){
            common_dialogSubmit();
            if(typeof f=='function'){
     		   f();
     	   }
             }}] 
	                         
	});
};

/**
 * 提交内容前的检测以及内容提交
 */
function common_dialogSubmit(){
	 var checked=common_treeDialog_tree.tree('getChecked');          	          	                 
	   if(!wgUtils.isUsed(checked)||checked.length<=0)
 	{
 	 alert("请用多选框选择其中一个地址!");
 	} else if(!wgUtils.isUsed(checked)||checked.length>1){
 		alert("请用多选框选择其中一个地址!");
 	}else {
 		treeTreeId=checked[0].id;
 		treeTreeName=checked[0].text;
 		
 		common_treeDialog.dialog('close');
 	}	   
}

/**
 * tree的初始化,传入url和选中的id号码,和是否自动展开整个树
 */
function common_treeDialog_treeInit(url,id,isExpandAll){
	   common_treeDialog_tree.tree({
		    url:"<%=request.getContextPath()%>"+url,
		    checkbox:true,
		    onlyLeafCheck:true,
		    lines:true,	
		    formatter:function(node){
		    	if(wgUtils.isUsed(node.id)&&node.id==id){
		    		node.checked=true;
		    	}
		    	//alert(node);
		    	return node.text;
		    },
		    onDblClick:function(node){
		    	common_treeDialog_tree.tree('uncheck',node.target);
		    },
		    onCheck:function(node, checked){//当用户点击checkbox的时候触发此时间
		    	console.info(node);
		    	if(checked==true){
		    		var nodes = common_treeDialog_tree.tree('getChecked');
		    		for(var i=0;i<nodes.length;i++){
		    			if(node.id!=nodes[i].id)
		    			common_treeDialog_tree.tree('uncheck',nodes[i].target);
		    		}
		    		//common_treeDialog_tree.tree('check',node.target);
		    	}
		    	
		    },  
		    onLoadSuccess:function(node,data){
		    	if(typeof isExpandAll!="undefined"&&isExpandAll)
		    	common_treeDialog_tree.tree('expandAll');
		    	else if(wgUtils.isUsed(id)&&id!=-1){
		    		common_treeDialog_tree.tree('expandAll');//或者如果有提前选中的,那么就展开
		    	}
		    }
		});
}
</script>

<div id="common_treeDialog">
<ul id="common_treeDialog_tree"></ul>			
</div>