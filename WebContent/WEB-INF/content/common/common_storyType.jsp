<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 此页面是一个公共的增加获取小说类型的页面-->
<script type="text/javascript">
var common_storyTypes=[];
$(function(){
	common_getStoryType()
});
function common_getStoryType(){
	$.ajax({
		async : true,
		cache : false,
		type : "post",
		url : "<%=request.getContextPath()%>/getStoryAllTypes.do",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		dataType : "text",
		beforeSend : function(XMLHttpRequest) {
		},
		success : function(msg) {
		    var obj=eval("("+msg+")");
		    //console.info(obj);
		    if(obj&&obj.success){
		    	common_storyTypes=obj.object;	    	
		    }else{
		    	alert("小说类型获取失败!");
		    }
		},
		error : function() {
		}
	});
	
}
</script>