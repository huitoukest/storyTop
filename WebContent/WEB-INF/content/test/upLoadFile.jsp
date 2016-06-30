<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include.jsp"></jsp:include>
<title>文件上传测试</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">  
var userForm2=$("#userForm2");
    
    i = 1;  
    j = 1;  
    $(document).ready(function(){
                   
        $("#btn_add2").click(function(){  
            document.getElementById("newUpload2").innerHTML+='<div id="div_'+j+'"><input  name="file_'+j+'" type="file"  /><input type="button" value="删除"  onclick="del_2('+j+')"/></div>';  
              j = j + 1;  
        });  
    });
    
    function del_2(o){  
        document.getElementById("newUpload2").removeChild(document.getElementById("div_"+o));  
   } 
    function userFormSubmit(){
    	alert("文件上传表单提交了！");
    	var options={
    			url:"<%=request.getContextPath()%>/file/upload2.do",
			type : 'post',
			dataType : 'json',
			success : function(data) {
				console.info(data);
			}
		};
			$("#userForm2").ajaxSubmit(options);
	}

	
</script>
</head>
<body>

	<h1>springMVC包装类上传文件</h1>
	<form name="userForm2" id="userForm2" action="<%=request.getContextPath()%>/file/upload2.do"
		enctype="multipart/form-data" method="post"">
		<div id="newUpload2">
			<input type="file" name="file" id="fileUpload" >
		</div>
		<input type="button" id="btn_add2" value="增加一行"> <input type="button" value="上传"
			onclick="userFormSubmit();">
	</form>
	
	<hr>
	<div>UploadAction</div>
	<h1 style="text-align:center;">zyUpload示例</h1>
	    <div id="uploadFile_demo"></div>   
	<hr>
	<div id="fileQueue"></div>
    <input type="file" name="uploadify" id="uploadify" />
    <p>
      <a href="javascript:$('#uploadify').uploadifyUpload()">上传</a>| 
      <a href="javascript:$('#uploadify').uploadifyClearQueue()">取消上传</a>
    </p>
</body>
</html>
