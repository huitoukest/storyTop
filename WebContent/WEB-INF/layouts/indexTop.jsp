<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%
	response.setCharacterEncoding("UTF-8");
	request.setCharacterEncoding("UTF-8");
	response.setContentType("UTF-8");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><sitemesh:title></sitemesh:title></title>
<sitemesh:head></sitemesh:head>
</head>
<style type="text/css">
body {
	margin: 10;
	padding: 10;
	background-image: url(<%=request.getContextPath()%>/images/body.jpg);
	background-repeat: repeat-x;
	background-position: center top;
	margin: 0px;
	padding-top: 0px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
	background-color: #F3F3F3;
	
}

.navblock ul li {
	float: left;
	list-style: none;
}

.navblock {
	background-color: #333;
}

.navblock  span {
	display: block;
	height: 30px;
	line-height: 25px;
	color: #333333;
	background-color: #CCCCCC;
	border-left: #BBBBBB solid 1px;
	border-right: #CCCCCC solid 7px;
}

.navblock  span:hover {
	text-decoration: none;
	color: #fff;
	background-color: #434343;
	border-left-color: #171717;
	border-right-color: #525252;
}

#hrefcss a:hover{
     text-decoration: none;
	color: #fff;
	background-color: #434343;
	border-left-color: #171717;
	border-right-color: #525252;
}

.topTable1Css span {
	border-left-color: #0b0b0b;
	border-left-color: #171717;
	border-right-color: #525252;
	padding: 2px;
	text-decoration: none;
}

.topTable1Css span:hover {
	text-decoration: none;
	color: #fff;
	background-color: #434343;
	border-left-color: #171717;
	border-right-color: #525252;
}

.topTable1Css a:hover {
	text-decoration: none;
	color: #fff;
	background-color: #434343;
	border-left-color: #171717;
	border-right-color: #525252;
}

.bottom {
	font-family: "微软雅黑";
	font-size: 12pt;
	line-height: 50px;
	color: #FFF;
	background-color: #0682CC;
	border-top-width: 1px;
	border-top-style: solid;
	border-top-color: #87CEFA;
	border-bottom-width: 3px;
	border-bottom-style: solid;
	border-bottom-color: #77CAFB;
	text-align: center;
}
</style>
<script type="text/javascript">
var serverTime =<%=System.currentTimeMillis()%>;
var today, hour, second, minute, year, month, date;
var strDate;
var n_day;
var timeContnet;
var userInfo_overall=-1;//一个全局的user的json数据集合

$(function(){
	checkWheatherUserLogin();
	indexTop_getUsingAffiche();
});

function showtime() {
	if (serverTime == null) {
		today = new Date();
	} else {
		today = new Date(serverTime);
		serverTime = serverTime + 1000;
	}
	n_day = today.getDay();
	switch (n_day) {
	case 0: {
		strDate = "星期日"
	}
		break;
	case 1: {
		strDate = "星期一"
	}
		break;
	case 2: {
		strDate = "星期二"
	}
		break;
	case 3: {
		strDate = "星期三"
	}
		break;
	case 4: {
		strDate = "星期四"
	}
		break;
	case 5: {
		strDate = "星期五"
	}
		break;
	case 6: {
		strDate = "星期六"
	}
		break;
	case 7: {
		strDate = "星期日"
	}
		break;
	}
	year = today.getFullYear();
	month = today.getMonth() + 1;
	date = today.getDate();
	hour = today.getHours();
	minute = today.getMinutes();
	second = today.getSeconds();
	timeContnet = year + " 年 " + month + " 月 " + date + " 日 " + strDate
			+ " " + hour + ":" + minute + ":" + second; //显示时间
	document.getElementById('time').innerHTML = timeContnet;
	setTimeout("showtime();", 1000); //设定函数自动执行时间为 1000 ms(1 s)
}

//设置所有的子目录,通过传送过来的jsonDate数据
function setAllcategory(jsonDate)
{ if(jsonDate==undefined)
	return;
jsonDate=eval(jsonDate);
	//alert(jsonDate.length);
	var content='';
     content=document.getElementById("ulContent").innerHTML;
     //alert(content);
  for(var i=0;i<jsonDate.length;i++)
	  {
	  content=content+setIl(jsonDate[i].name,jsonDate[i].url);
	  }
 // alert(content);
  document.getElementById("ulContent").innerHTML=content;
}

function setIl(name,url)
{ var a="<li><span style=\"cursor: pointer;\" onclick=\"window.top.location.href=\'";
  var b="\' \">";
  var c="</span></li>";
return (a+url+b+name+c);	
}  

function checkWheatherUserLogin()
{
	$.ajax({
		url:'<%=request.getContextPath()%>/isUserLogined.json',
		async:true,
        cache:false,
        type:"post",
        contentType:"application/x-www-form-urlencoded; charset=utf-8",
        dataType:"json",
        success:function(msg)
            {
               if(msg.success){
            	   $("#topTable1 #login_span").hide();
              	   $("#topTable1 #register_span").hide();
              	   
              	    $("#topTable1 #personCenter_td").attr("width","350px");
					$("#topTable1 #logout_td").attr("width","73px");
					
					$("#topTable1 #login_td").attr("width","0px");
					$("#topTable1 #register_td").attr("width","0px");
              	   
              	  $("#topTable1 #personCenter_span").show();
            	   $("#topTable1 #logout_span").show();
            	   
            	  $("#topTable1 #logined_user_name").html("您好,"+msg.object.userName+"! ");
               }
               else{
            	   $("#topTable1 #login_span").show();
              	   $("#topTable1 #register_span").show();
            	   
              	 $("#topTable1 #login_td").attr("width","350px");
					$("#topTable1 #register_td").attr("width","73px");
              	   
            	   $("#topTable1 #personCenter_span").hide();
              	   $("#topTable1 #logout_span").hide();
              	   
              	 $("#topTable1 #personCenter_td").attr("width","0px");
					$("#topTable1 #logout_td").attr("width","0px");
              	   
              	 $("#topTable1 #logined_user_name").html('');
               }
               userInfo_overall=msg.object;
            },
       complete:function(XMLHttpRequest,textStatus)
            {},
      error:function()
           {}							
	});}
	
	//用户登出
	function indexTop_userLogOut(){
	
		$.ajax({
			url:'<%=request.getContextPath()%>/user/userLogOut.json',
			async : true,
			cache : false,
			type : "post",
			contentType : "application/x-www-form-urlencoded; charset=utf-8",
			dataType : "json",
			success : function(msg) {
				if (msg.success) {
					
					$("#topTable1 #login_td").attr("width","350px");
					$("#topTable1 #register_td").attr("width","73px");
					
					$("#topTable1 #login_span").show();
					$("#topTable1 #register_span").show();

					$("#topTable1 #personCenter_span").hide();
					$("#topTable1 #logout_span").hide();
					
					$("#topTable1 #personCenter_td").attr("width","0px");
					$("#topTable1 #logout_td").attr("width","0px");
					
					$("#topTable1 #logined_user_name").html('');
					userInfo_overall = null;
				}

			}
		});

	}
	//获取网站公告信息
	function indexTop_getUsingAffiche(){
		var affiche_td=$("#affiche_td");
		$.ajax({
			url:'<%=request.getContextPath()%>/getUsingAffiche.json',
			async : true,
			cache : false,
			type : "post",
			contentType : "application/x-www-form-urlencoded; charset=utf-8",
			dataType : "json",
			success : function(msg) {
				if (msg.success) {
					var obj=msg.object;
					console.info(obj);
					if(wgUtils.isUsed(obj)&&obj.length<1)
					{
						affiche_td.html("暂无公告！");
						return;
					}
					var htmlString="";
					for(var i=0;i<obj.length;i++)
						{
						  htmlString=htmlString+(i+1)+".";
						  htmlString=htmlString+obj[i].affiche+" "+wgUtils.getTime(obj[i].publishTime, 0)+"<br/>";
						}
					//alert(htmlString);
					affiche_td.html(htmlString);
				}else{
					affiche_td.html("网站公告获取失败！");
				}

			}
		});

	}
	
	function getTopicCatalog(id){
		window.top.location.href="<%=request.getContextPath()%>/topic/topics_catalog.do?id=-1&type=0&thingSort=1&name=&user=&startTime=&endTime=&isPublishTime=false&rows=10&page=1&order=desc&sort=id&oldLevel=0&sortType=4&address="+id;
	}
	
	 function indexTop_getCategoryHtmlString(data)
     {//data是一个json数据,包含id与name，表示前台显示的内容，selectId表示当前选中的内容显示为红色
      //dataType的值为1,2,3,4,5 ;1表示物品分类,2表示成色,3表示价格,4表示时间,5表示交易类型type,data.id实际上表示的是一个值，不一定是id号码
     if(wgUtils.isUsed(data)){       	
       var htmlString="<a style=\"color:#F8F8FF;vertical-align:middle;\"  href=\"javaScript:getTopicCatalog("+data.id+");\" ";

      htmlString=htmlString+">"+data.name+"</a>";       
       //if(data.id!=1)
       return htmlString;
       //return data.name;
       }
     return "";
     }
	
	//获取三级地址分类信息
	function indexTop_getSecondAddress(){		
		//设置主题地址分类
 	var tableObject=$("#secondAddress_div");  
        $.ajax({
        		url:'<%=request.getContextPath()%>/getChildOrBrothersAddress.json?id=2',
        		async:true,
                cache:false,
                type:"post",
                contentType:"application/x-www-form-urlencoded; charset=utf-8",
                dataType:"json",
                success:function(msg)
                    {//console.info("地址信息！");
                	 //console.info(msg);
                       if(wgUtils.isUsed(msg)&&msg.length>0){
                       var data=msg;              
                       var htmlString="&nbsp;&nbsp;"; 
                       var all=new Object();
                           all.id=-2;
                           all.name="全部主题";
                           htmlString=htmlString+"<a style=\"color:#F8F8FF;vertical-align:middle;\" href=\"<%=request.getContextPath()%>\">首页</a>"+"&nbsp;&nbsp;";
                       htmlString=htmlString+indexTop_getCategoryHtmlString(all)+"&nbsp;&nbsp;";
                       for(var k=data.length-1;k>0&&data.length-k<9;k--)
                            {//首页地址目录最多显示10个
                    	   data[k].name=data[k].text;
                    	   htmlString=htmlString+indexTop_getCategoryHtmlString(data[k])+"&nbsp;&nbsp;";
                            }
                       data[0].name=data[0].text;
                       htmlString=htmlString+indexTop_getCategoryHtmlString(data[0])+"&nbsp;&nbsp;";
                       
                       htmlString=htmlString+"<a style=\"color:#F8F8FF;vertical-align:middle;\" href=\"<%=request.getContextPath()%>/topic/showAddressCategory.do\">更多>></a>";
                       
                       //alert(htmlString);
                       tableObject.append(htmlString);
                       }      
                    
                    },
               complete:function(XMLHttpRequest,textStatus)
                    {},
              error:function()
                   {}							
        	});
	}
	
	//用户的主题搜索
	function indexTop_searchTopicName()
	{ var indexTop_search_form=$("#indexTop_search_form");
		if(!indexTop_search_form.form('validate'))
	   	 return; 
		var url='<%=request.getContextPath()%>/topic/topics_catalog.do';
	      url=url+"?id=-1&name="+$("#indexTop_search_form #indexTop_search_content").val();
	      var  typeValue=$("#indexTop_search_form #type").combobox('getValue');
	      
	      if(!wgUtils.isUsed(typeValue))
	    	  {
	    	  typeValue=0; 
	    	  }
	      url=url+"&type="+typeValue;

	      window.top.location.href=url;
	}
	
</script>
<body bgcolor="#87CEFA">
	<div align="center">
	    <div align="center"  style="background-color: #FFFFEE;width:1280px;">
		<jsp:include page="../content/common/userLogin.jsp"></jsp:include>
		<jsp:include page="../content/common/userRegist.jsp"></jsp:include>
		<table id="topTable1" style="width:width=1280px;background-color: #FAF0E6;" name="topTable1" class="topTable1Css">
			<tr style="width:width=1280px;">
				<td width="421px" id='time' align="left"><script language="javascript">
					showtime();
				</script></td>
				<td width="435px" align="center"><label
					onclick="window.top.location.href= '<%=request.getContextPath()%>'"> <span
						style="cursor: pointer;"><a href="javascript:void(0);">school_ebay:www.school_ebay.com</a></span>
				</label></td>

				<td align="right" width="350xp" id="login_td"><span id="login_span" onclick="common_login_dialog.dialog('open');"
					style="cursor: pointer;">登录</span></td>
				<td align="right" width="73px" id="register_td"><span id="register_span" onclick="common_regist_dialog.dialog('open');"
					style="cursor: pointer;">注册</span></td>
				<td align="right"></td>
				<td align="right" width="350xp" id="personCenter_td"><label id="logined_user_name" for="personCenter_span"></label><span
					id="personCenter_span" name="personCenter_span"
					onclick="window.top.location.href= '<%=request.getContextPath()%>/user/personCenter.do'"
					style="cursor: pointer;">个人中心</span></td>
				<td align="right" width="73px" id="logout_td"><span id="logout_span" onclick="indexTop_userLogOut()"
					style="cursor: pointer;">退出</span></td>
			</tr>
		</table>
		<br />
		<form id="indexTop_search_form" method="post" class="easyui-form">
			<table style="width:width=1280px;" id="indexTopTable2" name="indexTopTable2" align="center">
				<tr>
				    <td width="300px"><a href="javascript:void(0);" onclick="window.top.location.href= '<%=request.getContextPath()%>'"><img width="250px" height="80px" alt="网站logo不见了！" src="<%=request.getContextPath()%>/images/logo.png" onclick="return false;"/></a> </td>
					<td width="90px"><label for="search_content">搜索主题:</label></td>
					<td width="120px">
					 <input class="easyui-validatebox"
						data-options="required:true" type="text" name="indexTop_search_content" id="indexTop_search_content" /></td>
					
					<td width="100px"><input width="100px" class="easyui-combobox" name="type" id="type"
						data-options="
				                                editable:false,
												valueField: 'value',
												value:'0',
												textField: 'label',
												data: [{
													label: '全部',
													value:0
												},{
													label: '出售',
													value:1
												},{
													label: '求购',
													value: 2
												},{
													label: '赠送',
													value: 3
												},{
													label: '交换',
													value: 4												}]" />
						</td>
						<td width="90px">
						<input type="button" value="搜索主题" onclick="indexTop_searchTopicName();">						
						</td>
						<td width="90px" align="right">
						<a  href="<%=request.getContextPath()%>/user/userAddTopic.do">发布新主题</a>
						</td>
						
										    <td width="360px" align="center">
	<!--*******************************滚动公告开始*******************************-->			    
	<table width="280px" height="75px" border="1px" style="border-color: #FFFFF0" cellpadding="0" cellspacing="0">
	  <tbody>
        <tr style="background-color: #CCEEEE">
          <td >
            <span style="font-weight:blod; color:#333333">
                       网站公告:
            </span>
		  </td>
		</tr>
        <tr>
          <td align="left">
        <marquee onmouseover="if(document.all!=null){this.stop()}" onmouseout="if(document.all!=null){this.start()}" scrollamount="1" scrolldelay="1" direction="up"  style="height:70px;">
            <table cellspacing="0" cellpadding="0" width="100%" border="0">
              <tbody>
              
			<tr>
                <td width="100%" id="affiche_td">
<br>
				</td>
			  </tr>
			
     
			  </tbody>
			 </table>
			 </marquee>
		  </td>
		</tr>
	</tbody>
<!--*******************************滚动公告结束*******************************-->
	</table> 
	</td>
					    <td width="10px"></td>
				</tr>
			</table>
		</form>
		
		<div id="topDiv1" name="topDiv1"></div>
		
		<!-- 子目录页面 -->
		<table id="topTable3" name="topTable3">
			<tr>
				<td width="95%">
					<div class="navblock">
						<ul style="list-style: none;" id="ulContent" name="ulContent">
							<!--  鼠标滑过状态在li上添加 class="navhov"  -->
						</ul>
					</div>
				</td>
			</tr>
		</table>	
		<hr style="width:1280px">
		<div id="bodyContent" name="bodyContent" style="background-color: #FFFFEE;width:1280px;"align="center">
			<sitemesh:body></sitemesh:body>
		</div>
	     <br/>
	     <br/>
		<!-- 网站底部 -->
		<div align="left" style="width:1280px;background-color: #F8F8D0;">
		&nbsp;友情链接：
		 <br/>
		 <br/>
		 <div align="center"><div style="margin-bottom: 5px;">
		 <a href="http://www.yibinu.cn" target="_blank">宜宾学院</a>&nbsp;|&nbsp;
		 <a href="http://www.baidu.com" target="_blank">百度一下</a>&nbsp;|&nbsp;
		 <a href="http://yibin.ganji.com" target="_blank">宜宾赶集网</a>&nbsp;|&nbsp;
		<a href="http://www.58.com" target="_blank">58同城</a>&nbsp;|&nbsp;
		<a href="http://www.sohu.com" target="_blank">搜狐网</a>&nbsp;|&nbsp;
		<a href="http://www.sina.com.cn" target="_blank">新浪网</a>
		 </div>
		 </div>
		 <div class="bottom">版权所有：王刚 &nbsp;&nbsp;联系人：王刚 &nbsp;&nbsp;电话：15283533538&nbsp;&nbsp;&nbsp; 川蜀备：236541 </div>
		 </div>	
		</div>
	</div>
</body>
</html>