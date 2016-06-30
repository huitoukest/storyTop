<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<%  
String path = request.getContextPath();  
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../include.jsp"></jsp:include>
<style type="text/css">
body
{
 margin:0;
 padding:0;
}
a{
text-decoration: none;
}
</style>
<Script language="JavaScript" type="text/javascript">
           $(function(){
        	   
           });
           
 
            
            function openTabInCenter(href,title)
            {   //alert("12312");
            	if(typeof href == "undefind"&&!href&&typeof title == "undefind"&&!title)
            	return;    
            	        
    				        var tabs = $('#mainTabs');
    						var content='<iframe src=\"'+href+'\" allowTransparency="true" style="border:0;width:100%;height:99%;" frameBorder="0"></iframe>';
    						//console.info("content="+content);
    				        var opts = {
    							title : title,
    							closable : true,
    							//href:href,
    							content:content,//content 其实就是div中的html内容
    							tools:[{
    						        //iconCls:'icon-mini-refresh',
    						        text:'刷新',
    						        iconCls:'icon-mini-refresh',
    						        handler:function(){
    						        	var tab = tabs.tabs('getSelected');//获得当前tab
    						        	tabs.tabs('update', {
    						              tab : tab,
    						              options : {
    						               content : content
    						              }
    						             });
    						        }
    						    }],
    							border : false,
    							fit : true,	
    						};
    						if (tabs.tabs('exists', opts.title)) {
    							tabs.tabs('select', opts.title);
    						} else {
    							tabs.tabs('add', opts);
    						}
    					
    				
    			}
                       
</Script>
<title>管理员页面首页</title>
</head>
<body>
<div align="center" >
欢迎进入管理员页面<hr/>
<div id="admin_div_layout" class="easyui-layout" style="width: 1360px;height:1000px">
<jsp:include page="../admin/adminLogin.jsp"></jsp:include>
<div data-options="region:'north',split:false,href:'admin/north.do'" style="height: 100px; overflow: hidden;"></div>  
    <div data-options="region:'west',href:'',split:true" title="导航" style="width: 200px; padding: 10px;">
		<div data-options="iconCls:'ext-icon-user_edit'" onclick="$('#passwordDialog').dialog('open');">
		<table>
		<tr><td><a href="javascript:void(0);" onclick="openTabInCenter('admin/userManage.do','用户管理')">普通用户管理</a></td></tr>
		<tr><td><br/></td></tr>
		<tr><td><a href="javascript:void(0);" onclick="openTabInCenter('admin/adminManage.do','管理员用户管理')">管理员用户管理</a></td></tr>
		<tr><td><br/></td></tr>
		<tr><td><a href="javascript:void(0);" onclick="openTabInCenter('admin/storyManage.do','小说管理')">小说管理</a></td></tr>
		<!-- <tr><td><a href="javascript:void(0);" onclick="openTabInCenter('admin/thingSortManage.do','物品分类管理')">物品分类管理</a></td></tr>
		<tr><td><br/></td></tr>
		<tr><td><a href="javascript:void(0);" onclick="openTabInCenter('admin/topicManage.do','主题管理')">主题管理</a></td></tr>
		<tr><td><br/></td></tr>
		<tr><td><a href="javascript:void(0);" onclick="openTabInCenter('admin/addressManage.do','地址管理')">地址管理</a></td></tr>
		<tr><td><br/></td></tr>
		<tr><td><a href="javascript:void(0);" onclick="openTabInCenter('admin/userAuManage.do','学生认证管理')">学生认证管理</a></td></tr> -->
		
		<tr><td><br/></td></tr>
		<tr><td><a href="javascript:void(0);" onclick="openTabInCenter('admin/afficheManage.do','网站公告管理')">网站公告管理</a></td></tr>
		<tr><td><br/></td></tr>
		</table>
		</div>	   
	</div>
	
    <div data-options="region:'center',border:false"  >
		<div id="mainTabs" class="easyui-tabs" data-options="fit:true" style="overflow: hidden;" >
			<div title="关于school_eaby系统" data-options="iconCls:'ext-icon-heart',closable:true,fit:true">
				<iframe src="<%=basePath%>admin/welcome.do" allowTransparency="true" style="border: 0; width: 99%; height: 99%;" frameBorder="0"></iframe>
			</div>
		</div>
	</div>
</div>
</div>
</body>
</html>