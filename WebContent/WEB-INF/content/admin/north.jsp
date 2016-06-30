<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" charset="utf-8">
	$(function(){
		admin_north_showAdminInfo();
	});
	
	//检查管理员用户是否登录,同时展示管理员的相关信息
	function admin_north_showAdminInfo()
	{
		$.ajax({
			url:'<%=request.getContextPath()%>/admin/isAdminLogin.json',
			async:true,
	        cache:false,
	        type:"post",
	        contentType:"application/x-www-form-urlencoded; charset=utf-8",
	        dataType:"json",
	        success:function(msg)
	            {
	               if(msg.success){
	            	   
	            	   admin_login_dialog.dialog("close");
	            	   $("#north_admin_info_href").html("您好,"+msg.object.name+"!");
	            	   $("#north_admin_info_href").click(function(){
	            		   
	            	   });
	               }
	               else{
	            	   admin_login_dialog.dialog("open");
	            	   $("#north_admin_info_href").html("您好,请先登录!");
	            	   $("#north_admin_info_href").click(function(){
	            		   admin_login_dialog.dialog("open");
	            	   });
	               }
	            },
	       complete:function(XMLHttpRequest,textStatus)
	            {},
	      error:function()
	           {}							
		});}
		
		//用户登出
		function admin_north_adminLogOut(){
		
			$.ajax({
				url:'<%=request.getContextPath()%>/admin/adminLogOut.json',
				async : true,
				cache : false,
				type : "post",
				contentType : "application/x-www-form-urlencoded; charset=utf-8",
				dataType : "json",
				success : function(msg) {
					if (msg.success) {
						$("#north_admin_info_href").html("您好!请先登录!");
						$.messager.alert("提示", msg.msg,"info");
						window.top.location.href="<%=request.getContextPath()%>/admin";
					}  else if(!msg.success){
						$.messager.alert("提示", msg.msg,"error");
					}

				}
			});

		}
	
	
</script>
<div id="sessionInfoDiv" style="position: absolute; right: 10px; top: 5px;">
<a href="javascript:void(0);" id="north_admin_info_href" class="easyui-menubutton" data-options="menu:'#layout_north_kzmbMenu',iconCls:'ext-icon-cog'">您好!请先登录!</a> 
</div>
<div id="layout_north_kzmbMenu" style="width: 100px; display: none;">
	<div data-options="iconCls:'ext-icon-door_out'" onclick="admin_north_adminLogOut();">退出系统</div>
</div>