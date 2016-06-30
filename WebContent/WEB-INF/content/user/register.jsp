<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>注册页面</title>
<link href="./js/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
<script src="./js/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>
<script src="./js/ligerUI/js/ligerui.all.js" type="text/javascript"></script>
<script src="./js/jquery-validation/jquery.validate.min.js"></script>
<script src="./js/jquery-validation/jquery.metadata.js" type="text/javascript"></script>
<script src="./js/jquery-validation/messages_cn.js" type="text/javascript"></script>
<script type="text/javascript">
	var eee;
	var sexValue=1;
	$(function() {
		//ajaxValidateForm();
		$.metadata.setType("attr", "validate");
		var v = $("form").validate({
			debug : true,
			errorPlacement : function(lable, element) {	
				//ajaxValidateForm();
				//return;
				if (element.hasClass("l-textarea")) {
					element.ligerTip({
						content : lable.html(),
						target : element[0]
					});
				} else if (element.hasClass("l-text-field")) {
					element.parent().ligerTip({
						content : lable.html(),
						target : element[0]
					});
				} else {
					//lable.appendTo(element.parents("td:first").next("td"));
				}
			},
			success : function(lable) {
				lable.ligerHideTip();
				lable.remove();			
			},
			submitHandler : function() {
				$("form .l-text,.l-textarea").ligerHideTip();
				ajaxValidateForm();
				//alert("后台数据提交");
			}
		});
		$("form").ligerForm();
		$(".l-button-test").click(function() {
			alert(v.element($("#txtName")));
		});
	});
	function ajaxValidateForm()
    {   $("#div1").html('');
		var data="name="+$("#name").val();
          data=data+"&password="+$("#password").val();
          data=data+"&rePassword="+$("#rpassword").val();
          data=data+"&nickName="+$("#nickName").val();
          data=data+"&email="+$("#email").val();
          data=data+"&readTime="+$("#readTime").val();
          data=data+"&age="+$("#age").val();
          data=data+"&sex="+sexValue;
          data=data+"&phone="+$("#phone").val();
          data=data+"&qq="+$("#qq").val();
          data=data+"&vcode="+$("#vcode").val();        
        $.ajax({
        async:true,
        cache:false,
        type:"post",
        url:"register.do",
        contentType:"application/x-www-form-urlencoded; charset=utf-8",
        dataType:"text",
        data:data,
        beforeSend:function(XMLHttpRequest)
            {
                $("#showResult").text("正在查询");
                //Pause(this,100000);
            },
        success:function(msg)
            {   
        	if(msg=="registerSuccess")
        	{
        	$("#div1").html("登录成功,立即跳转!");
        	window.location.href="registerSuccessJsp.do"; 
        	}
        	else
        	$("#div1").html(msg);
            //$("#showResult").css("color","red");
            },
       complete:function(XMLHttpRequest,textStatus)
            {
                //隐藏正在查询图片
            },
      error:function()
           {
                //错误处理
           }
        });
    }
	
	function check(browser)
	  {
		sexValue=browser;
		//alert("sexValue"+sexValue);
	  }
	//刷新验证码
	function refresh() {  
        document.getElementById("authImg").src = "getVCode.do";  
    } 
</script>
<style type="text/css">
body {
	font-size: 12px;
}

.l-table-edit {
	
}

.l-table-edit-td {
	padding: 4px;
}

.l-button-submit, .l-button-test {
	width: 80px;
	float: left;
	margin-left: 10px;
	padding-bottom: 2px;
}

.l-verify-tip {
	left: 230px;
	top: 120px;
}
</style>

</head>

<body style="padding: 10px">
	<h2>用户注册:</h2>
	<hr>
	<form name="form1" method="post" action="register.do" id="form1">
		<div id="div1">
		<% if(request.getAttribute("errorMsg")!=null&&!request.getAttribute("errorMsg").equals(""))
			  {%>
			  <%=request.getAttribute("errorMsg") %>        
			    <%}      %></div>
		<table cellpadding="0" cellspacing="0" class="l-table-edit">
			<tr>
				<td align="right" class="l-table-edit-td">用户名:</td>
				<td align="left" class="l-table-edit-td"><input name="name" type="text" id="name" ltype="text"
					validate="{required:true,minlength:3,maxlength:50}" /></td>
				<td align="left"></td>
			</tr>
			<tr>
				<td align="right" class="l-table-edit-td">昵称:</td>
				<td align="left" class="l-table-edit-td"><input name="nickName" type="text" id="nickName"
					ltype="text" validate="{required:true,minlength:3,maxlength:20}" /></td>
				<td align="left"></td>
			</tr>
			<tr>
				<td align="right" class="l-table-edit-td">密码:</td>
				<td align="left" class="l-table-edit-td"><input name="password" type="text" id="password"
					ltype="text" validate="{required:true,minlength:3,maxlength:50}" /></td>
				<td align="left"></td>
			</tr>

			<tr>
				<td align="right" class="l-table-edit-td">再次输入密码:</td>
				<td align="left" class="l-table-edit-td"><input name="rpassword" type="text" id="rpassword"
					ltype="text" validate="{required:true,minlength:3,maxlength:50}" /></td>
				<td align="left"></td>
			</tr>

			<tr>
				<td align="right" class="l-table-edit-td" valign="top">性别:</td>
				<td align="left">
				<input id="sex1" type="radio" name="sex" value="1" checked="checked" onclick="check(this.value)"/><label for="rbtnl_0">男</label>
				<input id="sex2" type="radio" name="sex" value="0" onclick="check(this.value)"/><label for="rbtnl_1">女</label></td>
				<td align="left"></td>
			</tr>
			<tr>
				<td align="right" class="l-table-edit-td">Email:</td>
				<td align="left" class="l-table-edit-td"><input name="txtEmail" type="text" id="email"
					ltype="text" validate="{required:false,email:true,maxlength:255}" /></td>
				<td align="left"></td>
			</tr>
			<tr>
				<td align="right" class="l-table-edit-td">手机:</td>
				<td align="left" class="l-table-edit-td"><input name="phone" type="text" id="phone"
					ltype="text" validate="{required:false,maxlength:20,digits:true}" /></td>
				<td align="left"></td>
			</tr>
			<tr>
				<td align="right" class="l-table-edit-td">QQ:</td>
				<td align="left" class="l-table-edit-td"><input name="qq" type="text" id="qq"
					ltype="text" validate="{required:false,maxlength:16,digits:true}" /></td>
				<td align="left"></td>
			</tr>
			<tr>
				<td align="right" class="l-table-edit-td">年龄:</td>
				<td align="left" class="l-table-edit-td"><input name="age" type="text" id="age"
					ltype='spinner' ligerui="{type:'int'}" value="0" class="required"
					validate="{digits:true,min:1,max:120}" /></td>
				<td align="left"></td>
			</tr>
			<tr>
				<td align="right" class="l-table-edit-td">看了几年小说?:</td>
				<td align="left" class="l-table-edit-td"><select name="readTime" id="readTime" ltype="select">
						<option value="1">小于1年</option>
						<option value="2">1~2年</option>
						<option value="3">2~3年</option>
						<option value="4">3~4年</option>
						<option value="5">4~6年</option>
						<option value="6">6年以上</option>
				</select></td>
			</tr>
			<tr>
				<td align="right" class="l-table-edit-td">验证码:</td>
				<td align="left" class="l-table-edit-td">
			    <img src="getVCode.do" id="authImg"/><a href="javascript:void(0);" onClick="refresh()">看不清</a><br>
			    </td>
				<td align="left"></td>
			</tr>
			<tr>
				<td align="right" class="l-table-edit-td">请输入六位数字的验证码:</td>
				<td align="left" class="l-table-edit-td"><input name="vcode" type="text" id="vcode"
					ltype="text" validate="{digits:true,required:true,maxlength:6,minlength:6}" /></td>
				<td align="left">
				</td>
				
			</tr>
		</table>
		<br/> <input type="submit" value="提交" id="Button1" class="l-button l-button-submit" /> <input
			type="reset" value="重置" class="l-button l-button-test" />
	</form>
	<div style="display: none">
		<!--  数据统计代码 -->
	</div>
</body>
</html>