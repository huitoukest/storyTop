//通过wordCount的号码返回其代表的字数,即通过小说字数的id号码,返回其代表的字数值
function getWordCount(w)
{   if(w==1)
	return "1到千字";
	if(w==2)	
	return "1千~1万字";
	if(w==3)	
	return "1万~10万字";
	if(w==4)	
	return "10万~50万字";
	if(w==5)	
	return "50万~200万字";
	if(w==6)	
	return "200万~500万字";
	if(w==7)	
	return "大于500万字";
	if(w==8)	
	return "未完结,字数未知";
	return "未知";
}
//返回小说id号码代表的意义
function getUpdateState(s)
{  if(s==1)
	return "完结";
	if(s==2)
	return "持续更新";
	if(s==3)
	return "暂停更新";
	if(s==4)
	return "太监";
	if(s==5)
	return "未知"
	}

//从毫秒转换为时间的字符串,第一个参数-->代表时间的毫秒数,wayToget--->返回的字符串方式
function getTime(item,wayToget) {
	if(!item||item.length<19)
		return "无";
	//console.info("当前wayToget的值是--->"+wayToget);
	if(typeof wayToget=='undefined'||!wayToget)
		wayToget=0;
	var newTime = new Date(item); //就得到普通的时间了
	var fullYear = newTime.getFullYear();
	var month = newTime.getMonth() + 1;
	var day = newTime.getDate();
	var hours = newTime.getHours();
	var minutes = newTime.getMinutes();
	var second = newTime.getSeconds();
	var wayString=null;
	if(wayToget==0)
	wayString=(fullYear + "-" + month + '-' + day + '  ' + hours + ':'
			+ minutes + ':' + second);
	else
	wayString=(month + '/' + day +'/'+fullYear+ '  ' + hours + ':'
			+ minutes + ':' + second);
	//console.info("getTime当前返回的字符串是-->"+wayString);
	return wayString.toString(); 	 
}


