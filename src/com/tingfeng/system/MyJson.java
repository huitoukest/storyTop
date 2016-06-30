package com.tingfeng.system;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSON;
import com.tingfeng.utils.SpringUtils;

//用来发送包装好的Json数据
public class MyJson{
   /**
    * 普通错误
    */
   public final static int ERRORCODE_NORMAL=0;
   /**
    * 需要登录
    */
   public final static int ERRORCODE_NEDDLOGIN=1;
	//当前数据是否成功且有效,只要能够返回信息给前台,都设置成为true
   private Boolean success=false;
   //当前返回的对象
   private Object object=null;
   //给前台的信息
   private String msg="";
   /**仅当success为false的时候生效
    * 错误代码,0表示普通错误,1表示需要登录,以后会有权限的相关错误代码
    */
   private Integer errorCode=0;
   
   public MyJson() {	
	}
   
   /**
    * 发送一个正确格式的myJson数据到前台
    * @param response
    * @param object
    * @param msg
    * @throws IOException
    */
   public static void sendToSuccess(HttpServletResponse response,Object object,String msg) throws IOException{
	   MyJson myJson=new MyJson(true,object,msg);
	   SpringUtils.sendText(response,JSON.toJSONString(myJson));
   }
   /**
    * 发送一个错误格式的myjson信息到前台
    * @param response
    * @param msg
    * @throws IOException
    */
   public static void sendToError(HttpServletResponse response,String msg) throws IOException{
	   MyJson myJson=new MyJson(false,msg);
	   SpringUtils.sendText(response,JSON.toJSONString(myJson));
   }
   
   /**
    * 发送一个错误格式的myjson信息到前台
    * @param response
    * @param msg
    * @param errorCode 见Myjson的静态变量,仅当success为false的时候生效
    * 错误代码,0表示普通错误,1表示需要登录,以后会有权限的相关错误代码
    * @throws IOException
    */
   public static void sendToError(HttpServletResponse response,String msg,int errorCode) throws IOException{
	   MyJson myJson=new MyJson(false,msg);
	   myJson.setErrorCode(errorCode);
	   SpringUtils.sendText(response,JSON.toJSONString(myJson));
   }
   /**
    * 将当前对象的json字符串发送到前台
 * @throws IOException 
    */
   public void sendToClient(HttpServletResponse response) throws IOException{
	   SpringUtils.sendText(response, JSON.toJSONString(this));
   }
   
   public MyJson(Boolean success,Object object,String msg) {
		this.success=success;
		this.object=object;
		this.msg=msg;
		// TODO Auto-generated constructor stub
	}
	
	public MyJson(Boolean success,String msg) {
		this.success=success;
		this.msg=msg;
		// TODO Auto-generated constructor stub
	}
	public MyJson(Boolean success) {
		this.success=success;
		// TODO Auto-generated constructor stub
	}
	public Boolean getSuccess() {
		return success;
	}
	public Object getObject() {
		return object;
	}
	public void setSuccess(Boolean success) {
		this.success = success;
	}
	public void setObject(Object object) {
		this.object = object;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public Integer getErrorCode() {
		return errorCode;
	}
	public void setErrorCode(Integer errorCode) {
		this.errorCode = errorCode;
	}

}
