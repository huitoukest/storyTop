<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登陆页面</title>
</head>
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
				//验证表单数据
				ajaxValidateForm();
				//alert("后台数据提交");
			}
		});
		$("form").ligerForm();
	});
	
	function ajaxValidateForm()
    {   $("#div1").html('');
		var data="name="+$("#name").val();
          data=data+"&password="+$("#password").val();
          data=data+"&vcode="+$("#vcode").val();
        $.ajax({
        async:true,
        cache:false,
        type:"post",
        url:"loginCheck.do",
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
            if(msg=="loginSuccess")
            	{
            	$("#div1").html("登录成功,立即跳转!");
            	window.location.href="loginSuccessJsp.do"; 
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
	//选择性别
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
	<h2>用户登陆:</h2>
	<hr>
	<form name="form1" method="post" action="loginCheck.do" id="form1">
		<div id="div1">
		<% if(request.getAttribute("errorMsg")!=null&&!request.getAttribute("errorMsg").equals(""))
			  {%>
			  <%=request.getAttribute("errorMsg") %>        
			    <%}      %>
		</div>
		<table cellpadding="0" cellspacing="0" class="l-table-edit">
			<tr>
				<td align="right" class="l-table-edit-td">用户名:</td>
				<td align="left" class="l-table-edit-td"><input name="name" type="text" id="name" ltype="text"
					validate="{required:true,minlength:3,maxlength:50}" /></td>
				<td align="left"></td>
			</tr>
			
			<tr>
				<td align="right" class="l-table-edit-td">密码:</td>
				<td align="left" class="l-table-edit-td"><input name="password" type="text" id="password"
					ltype="text" validate="{required:true,minlength:3,maxlength:50}" /></td>
				<td align="left"></td>
			</tr>
			<tr>
				<td align="right" class="l-table-edit-td">验证码:</td>
				<td align="left" class="l-table-edit-td">
			    <img src="getVCode.do" id="authImg"/><a href="#" onClick="refresh()">看不清</a><br>
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