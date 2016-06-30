<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户个推荐小说</title>
<script type="text/javascript">
var formValid;
var userRecommendStoryId="<%=request.getAttribute("userRecommendStoryId")%>";
var userCanRecommendStory="<%=request.getAttribute("userCanRecommendStory")%>";
$(function(){	
	var s="";
	if(userCanRecommendStory+""=="false"){
		$("#addStoryDiv").css("display","none");
		s="您上次推荐的小说正在审核中,请等待审核结果出来后再推荐!"
	}else{		
		if(userRecommendStoryId=="null")
			userRecommendStoryId=0;
		if(userRecommendStoryId+""=="-1"){
			s="您上次推荐的小说没有通过审核!";
		}else if(userRecommendStoryId>0){
			s="您上次推荐的小说已经通过审核!编号:"+userRecommendStoryId;
		}
		getStoryType();
		initValidate();	
	}
	
	$("#message_div").html(s);	
	$('#addsStoryucessDialog').dialog({
	    width: 250,
	    height: 150,
	    closed: true,
	    cache: false,
	    modal: true
	});
});


function initValidate(){
	var param={
	  "justValidate":false,//只是验证,不修改和增加错误信息
	  "isRightMsg":true,//在input的右边显示错误信息,默认为false,默认在input的下边显示错误信息!
	  "validateWhenInit":false,//在初始化之后是否自动校验;
	  "validatedWhenFocus":false,//当获取焦点的时候是否进行校验;
	  "validatedWhenBlur":true,//当失去焦点的时候是否进行校验;
	  "validatedWhenChange":true,//当输入值改变的时候是否进行校验;
	  "rules":{
		"#name":{required:true,length:[1,50]},
		"#author":{required:true,length:[1,50]},
		"#publishedTime":{required:true,date:true},
		"#endTime":{required:true,date:true},
		"#storyType":{required:true,min:1,msg:"请选择小说类型"},
		"#wordCount":{required:true,min:1,max:8,msg:"请选择小说字数"},
		"#updateState":{required:true,min:1,max:8,msg:"请选择小说更新状态",extend:function(v){
						var v=$("#updateState").val();
						if(v==2||v==3){
							$("#wordCount").val(8);
							$("#endTime").val("2100-1-1");
						}else if(v==0){
							$("#wordCount").val(0);
							$("#endTime").val('');
						}	
					 return true;
		              }
		},
		"#storyBaikeUrl":{required:true,url:true,extend:function(v){
			var urls=["http://baike.baidu.com","http://baike.sogou.com","http://baike.haosou.com"];
			for(var i=0;i<urls.length;i++){
				url=urls[i];
				v=wgUtils.trim(v);
				if(v.indexOf(url) == 0){
					 return true;
				}
			}
			return "网址不符合要求!";
		}}, 
	   },//用一个键值对,来表示错误信息的规则,以及其校验方式
	};
 	formValid=wgValidate.init(param);
}

function submitStoryForm(){
	if(!formValid.validWithMsg()){
		return;
	}
	var data=wgUtils.serializeObject($("#form_user_recommendStory"))
	console.info(data);
	$.ajax({
		async : true,
		cache : false,
		type : "post",
		url : "<%=request.getContextPath()%>/user/recommendStory.json",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		dataType : "text",
		data:data,
		beforeSend : function(XMLHttpRequest) {
		},
		success : function(msg) {
			console.info(msg);
			var obj=0;
			try{
			obj=eval("("+msg+")");
			}catch(e){
				obj.msg="错误!";
			}
			if(obj&&obj.success){
		    	$.messager.show({
    	        	title:"提示",
    	        	msg:obj.msg,
    	        	timeout:5000,
    	        	showType:'slide'
    	        });
		    	showAddStorySuccessDialog();
		    }else{
		    	$.messager.show({
    	        	title:"提示",
    	        	msg:obj.msg,
    	        	timeout:5000,
    	        	showType:'slide'
    	        }); 
		    }
		},
		error : function() {
			$("#message_div").html("服务器接受信息错误!请稍后再试!");
		}
	});
}

function getStoryType(){
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
		    console.info(obj);
		    if(obj&&obj.success){
		    	var storyTypes=obj.object;
		    	var s='<option value="0">请选择小说类型</option>';
		    	for(var i=0;i<storyTypes.length;i++){
		    		var storyType=storyTypes[i];
		    	     s+='<option value="'+storyType.id+'">'+storyType.name+'</option>';
		    	}
		    }else{
		    	$("#message_div").html(obj.msg);
		    }
		    $("#storyType").html(s);
		},
		error : function() {
			$("#message_div").html("服务器接受信息错误!请稍后再试!");
		}
	});
	
}

function showAddStorySuccessDialog(){
  $("#addsStoryucessDialog").dialog('open');
}

function closeWebPage(){
	 if (navigator.userAgent.indexOf("MSIE") > 0) {
	  if (navigator.userAgent.indexOf("MSIE 6.0") > 0) {
	   window.opener = null;
	   window.close();
	  } else {
	   window.open('', '_top');
	   window.top.close();
	  }
	 }
	 else if (navigator.userAgent.indexOf("Firefox") > 0) {
	  window.location.href = 'about:blank ';
	 } else {
	  window.opener = null;
	  window.open('', '_self', '');
	  window.close();
	 }		
}
</script>
<style type="text/css">
.storyTable tr{
  line-height: 30px;
  background: antiquewhite;
  text-align: right;
}
.storyTable tr th{
	padding-right: 15px;
    padding-top: 10px;
}
.storyTable tr td{
  padding-right: 20px;
  padding-left: 5px;
  text-align: left;
}
.story_btn{ 
  font-size: x-large;
  padding: 5px;
  width: 80px;
  margin-top: 10px;
  margin-bottom: 10px;
}
</style>
</head>
<body>
<div align="center" style="width:1280px;background-color: #FFFFEE;">
<div id="message_div"></div>
<div id="addStoryDiv" style="width:1280px;">
<form method="post" id="form_user_recommendStory">
    <table class="storyTable">
      <tr>
          <th>小说名称:</th><td><input type="text" id="name" name="name"></td>
      </tr>
      <tr>
          <th>小说作者:</th><td><input type="text" id="author" name="author"></td>
      </tr>
      <tr>
          <th>小说发表日期:</th><td><input type="text" id="publishedTime" name="publishedTime" placeholder="格式:2015-1-1"></td>
      </tr>
      <tr>
          <th>小说类型:</th>
          <td>
          <select id="storyType" name="storyType.id" style="width:173px">
							<option value="0">请选择小说类型</option>
							
		 </select>
          </td>
      </tr>
      <tr id="tr_updateState">
          <th>更新状态:</th><td>
                       <select id="updateState" name="updateState" style="width:173px">
							<option value="0">请选择小说的更新状态</option>
							<option value="1">完结</option>
							<option value="2">持续更新</option>
							<option value="3">暂停更新/太监</option>
					</select></td>
      </tr>
      <tr id="tr_wordCount">
          <th>小说字数:</th><td>
						<select id="wordCount" name="wordCount" style="width:173px">
									<option value="0">请选择小说的字数</option>
									<option value="1">1到千字</option>
									<option value="2">1千~1万字</option>
									<option value="3">1万~10万字</option>
									<option value="4">10万~50万字</option>
									<option value="5">50万~200万字</option>
									<option value="6">200万~500万字</option>
									<option value="7">大于500万字</option>
									<option value="8">未完结,字数未知</option>
							</select>
							</td>
      </tr>
      <tr id="tr_endTime">
          <th>小说完结时间:</th><td><input type="text" id="endTime" name="endTime" placeholder="格式:2015-1-1"></td>
      </tr>
      <tr>
          <th>小说百科链接:</th><td><input type="text" id="storyBaikeUrl" name="storyBaikeUrl" placeholder="支持百度百科/搜狗百科/好搜百科"></td>
      </tr>
      <tr>
          <td><input class="story_btn" type="button" value="提交" onclick="submitStoryForm()"></td><td><input class="story_btn" type="reset" value="重置" ></td>
      </tr>
    </table>
</form>
</div>
<div id="addsStoryucessDialog" class="easyui-dialog"  style="width:250px;height:150px;"
		data-options="title:'提示',buttons:'#storybb',modal:true">
	<span>推荐成功!</span>
</div>
<div style="display:none"  id="storybb">
	<a href="#" class="easyui-linkbutton" onclick="closeWebPage()">确认!</a>
</div>
</div>
</body>
</html>