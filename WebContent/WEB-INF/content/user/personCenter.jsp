<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户个人中心</title>
<script type="text/javascript">
var userManage_table_datagrid;
var get_userInfo_overall_count=0;
var personCenterUserAu_div;
var personCenterUserDetails_div;
var personCenterUserAu_divHtml;
var personCenterUserAu_table_div;
$(function(){
	userManage_table_datagrid=$("#personCenterUserDetails_table");
	personCenterUserAu_div=$("#personCenterUserAu_div");
	personCenterUserDetails_div=$("#personCenterUserDetails_div");
	personCenterUserAu_table_div=$("#personCenterUserAu_table_div");
	personCenter_userInfoInit();
	personCenterUserAu_div.hide();
});

/**
 * 查看个人信息;
 */
function personCenter_watchUserDetails()
{ //alert("查看个人信息;");
	personCenterUserDetails_div.show();
	personCenterUserAu_div.hide();
	
     personCenter_userInfoInit();
	}; 
function personCenter_userInfoInit(){
	//alert("personCenter_userInfoInit start");
	if((typeof get_userInfo_overall_count=='undefined'||get_userInfo_overall_count<=20)&&(typeof userInfo_overall!='undefined'&&userInfo_overall==-1))
	{  get_userInfo_overall_count++;
	   setTimeout("personCenter_userInfoInit();",300);
	   return;
	} else {
		get_userInfo_overall_count=0;
	}
	//console.info("userInfo_overall:");
	//console.info(userInfo_overall);
	//alert("personCenter_userInfoInit timeOut end");
	var data=userInfo_overall;
	var s="#personCenterUserDetails_table";
	for(var k in data)
	{ 
		var t=new String(k);
		//alert(s+" #"+t);
		if(t=='sex'){
			  if(data[k]==1)
				$(s+" #"+t).html('男');
			  else if(data[k]==0) $(s+" #"+t).html('女');
		} else if(t=='lastLoginTime'){
			$(s+" #"+t).html(wgUtils.getTime(data[k], 0));
		}
		else{
		$(s+" #"+t).html(new String(data[k]));
		}
	}//end for
	};
 
	/**
	 * 编辑个人信息;
	 */
	function personCenter_updateUserDetails()
	{//console.info("userInfo_overall:");
			//console.info(userInfo_overall);
		 var data=userInfo_overall;
		 data.lastLoginTime=wgUtils.getTime(data.lastLoginTime);
		 common_editUser(data,"/user/updateUser.json",false,function successFunction(data2){
			 checkWheatherUserLogin();
			 userInfo_overall=wgUtils.cloneObject(data2.object);//克隆对象,而不是引用,防止表单数据对其的影响			 
			console.info("data2:");
				console.info(data2);
			 personCenter_watchUserDetails();
		 },function falseFunction(data2){});		
	};
	/**
	*个人的主题管理
	*/
	function personCenter_userTopicManage(){
		var url="<%=request.getContextPath()%>/user/userTopicManage.do";
		window.top.location.href=url;
		
	}
	
	function personCenter_userCollectionTopicManage(){
		var url="<%=request.getContextPath()%>/user/userCollectionTopicManage.do";
		window.top.location.href=url;
    }
	
	function personCenter_recommendStory(){		
			var url="<%=request.getContextPath()%>/user/recommendStory.do";
			window.open(url);
	}
	
	/**
	*个人更新密码的操作
	*/
	function personCenter_userUpdatePassword(){
		common_userUpdateP_dialog.dialog('open');
	}	
</script>
<style type="text/css">
.personCenter_ul li span:hover {
	text-decoration: none;
	color: #fff;
	background-color: #434343;
	border-left-color: #171717;
	border-right-color: #525252;	
}
.personCenter_ul{
background-color: #FFFFEE;
}
#personCenterUserDetails_table tr{
   height:25px;
   font-size: larger;
}
#personCenterUserDetails_table th{
   height:25px;
   font-size: larger;
   background: bisque;
}
#personCenterUserDetails_table td{
   height:25px;
   font-size: larger;
   font-weight: bold;
   background: cornsilk;
   padding-left: 20px;
}
</style>
</head>
<body>
<div align="center" style="width:1280px;background-color: #FFFFEE;height: 600px">
<div align="left" style="width:150px; overflow-x:hidden; float:left; border-width: 0px; background-color: #FFFFEE;">
<!-- 这个div是为了罗列有哪些个人中心的功能 -->
<ul class="personCenter_ul">
<li style="height:30px;"><span onclick="personCenter_watchUserDetails();">查看个人信息</span></li>
<li style="height:30px;"><span onclick="personCenter_updateUserDetails();">编辑个人信息</span></li>
<li style="height:30px;"><span onclick="personCenter_userTopicManage();">书架</span></li>
<li style="height:30px;"><span onclick="personCenter_userUpdatePassword();">修改密码</span></li>
<li style="height:30px;"><span onclick="personCenter_recommendStory();">推荐小说</span></li>
</ul>
</div>
<div align="left"  id="personCenter_div" class="easyui-panel" data-options="" style="width:75%; position: absolute; margin-left:70px; margin-top:20px; overflow-x:hidden; border-width: 0px ;">
<!-- 这个div中是实现个人中心的具体的功能 -->
<div id="personCenterUserDetails_div">
		<table id="personCenterUserDetails_table">
		<tr><th>用&emsp;户&emsp;编&emsp;&emsp;号:</th><td id="id"></td></tr>
		<tr><th >用&emsp;&emsp;户&emsp;&emsp;&emsp;名:</th><td id="userName"></td></tr>
		<tr><th>&emsp;&emsp;&emsp;&emsp;&emsp;E-mail:</th><td id="email"></td></tr>
		<tr><th>年&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;龄:</th><td id="age"></td></tr>
		<tr><th>性&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;别:</th><td id="sex"></td></tr>
		<tr><th>手&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;机:</th><td id="phone"></td></tr>
		<tr><th>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;QQ:</th><td id="QQ"></td></tr>
		<tr><th>当前&emsp;可评分次数:</th><td id="markTicketCount"></td></tr>
		<tr><th>最近&emsp;登录&emsp;时间:</th><td id="lastLoginTime"></td></tr>
		<tr><th>注册&emsp;&emsp;&emsp;&emsp;时间:</th><td id="createTime"></td></tr>
		</table>
</div>
<div id="personCenterUpdateUser_div">
       <jsp:include page="../common/add_edit_User.jsp"></jsp:include>
</div>
<jsp:include page="../common/userUpdatePassword.jsp"></jsp:include>
</div>
</div>
</body>
</html>