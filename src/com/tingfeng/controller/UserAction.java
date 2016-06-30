package com.tingfeng.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tingfeng.exception.DataException;
import com.tingfeng.exception.SystemException;
import com.tingfeng.manager.UserManager;
import com.tingfeng.model.User;
import com.tingfeng.page.Page;
import com.tingfeng.page.Pager;
import com.tingfeng.system.MyJson;
import com.tingfeng.system.MyPropertyFilter;
import com.tingfeng.utils.SpringUtils;
import com.tingfeng.utils.TimeUtils;

@Controller
public class UserAction {

@Autowired
private UserManager userManager;
	
 public UserAction() {
		// TODO Auto-generated constructor stub
	}
 /**
  * 用户的个人信息
  * @return
  */
@RequestMapping("/user/userInfo.do")
 public String userInfo(){
	 return "/user/userInfo.jsp";
 }
 /**
  * 个人中心
  * @return
  */
@RequestMapping("/user/personCenter.do")
public String personCenter()
{
 return "user/personCenter.jsp";	
}
 

/**
 * 更新用户
 * @param response
 * @param user
 * @throws IOException
 * @throws SystemException
 */
@RequestMapping("/admin/updateUser.json")
public void updateUser(HttpServletResponse response,User user) throws IOException, SystemException
{  //System.out.println("username="+user.getName());
   MyJson myJson=new MyJson();
   try{
   userManager.updateUserByAdmin(user);
   myJson.setSuccess(true);
   myJson.setMsg("用户更新成功!");
   } catch(Exception e)
   {
	   myJson.setSuccess(false);
	   myJson.setMsg("用户更新失败:"+e.getMessage());
   }
   myJson.sendToClient(response);	 
}

/**
 * 添加用户
 * @param response
 * @param user
 * @throws IOException
 * @throws SystemException
 */
@RequestMapping("/admin/addUser.json")
public void saveUser(HttpServletResponse response,User user) throws IOException, SystemException
{  //System.out.println("username="+user.getName());
   MyJson myJson;
   myJson=userManager.saveUser(user);
   myJson.sendToClient(response);	 
}

/**
 * 删除一群用户,需要一个用逗号分隔的id字符串,如果user目录下面还存在topic,则不允许删除,否则可以删除,前台通过判断myJson是否定义来判断是否后台返回数据
 * 通过myJson.success来判断操作是否成功
 * @param response
 * @param user
 * @throws IOException
 * @throws SystemException
 */
@RequestMapping("/admin/deleteUsers.json")
public void deleteUsers(HttpServletResponse response,String ids) throws IOException, SystemException
{  //System.out.println("username="+user.getName());
   MyJson myJson;
   myJson=userManager.deleteUsers(ids);
   myJson.sendToClient(response);	 
}

/**
 * 可以通过id号码和name来确定获得的用户的数据,当id和name都为空的时后,不发送数据;
 * 当id==-1,表示所有用户;可以通过id号码和name来确定需要知道的用户,搜索姓名的时候id必须为-1;
 * @param id
 * @param name
 * @throws IOException 
 */
@RequestMapping("/admin/getAllUsers.json")
public void getAllUsers(HttpServletResponse response,Long id,String name,Page page) throws IOException{
	Pager<User> users=this.userManager.getAllUsers(id, name, page);	
	SpringUtils.sendToTextWithoutThing(response, users,new MyPropertyFilter(new String[]{"topics","userAuthentication"})); 
}



 @RequestMapping("/userRegister.json")
  public void saveUser(HttpServletResponse response,User user,String rPassword,String vcode,HttpServletRequest request) throws IOException, SystemException
  {  
     MyJson myJson;
     if(!VerificationCodeAction.checkVCode(vcode, request))
   	  {
    	 MyJson.sendToError(response, "验证码错误！");
    	 
   	  }else if(rPassword!=null&&user!=null&&user.getPassword()!=null&&rPassword.equals(user.getPassword()))
     {
    	 myJson=userManager.saveUser(user);
    	 myJson.sendToClient(response);
     }
     else {
        	 MyJson.sendToError(response, "两次输入的密码不一样!");    	  
     }
    
  }
 
  @RequestMapping("/userLogin.json")
 public void loginUser(HttpServletResponse response,HttpServletRequest request,User user,String vcode) throws IOException
 {   MyJson myJson=new MyJson();
	if(!VerificationCodeAction.checkVCode(vcode, request))
	  {
		MyJson.sendToError(response, "验证码错误！");
		return;
	  }
	
     User user2=this.userManager.getUserByUserName(user.getUserName());
	 if(user2==null) { 
		 myJson.setSuccess(false);
		 myJson.setMsg("当前用户不存在!");
	 } else if(user.getPassword()!=null&&user2.getPassword().equals(user.getPassword()))
     {
		 this.userManager.setUserLogined(user2, request,true);		 
    	 myJson.setSuccess(true);
		 myJson.setMsg("登陆成功!");
		 myJson.setObject(user2);
     } else {
    	 myJson.setSuccess(false);
		 myJson.setMsg("用户名或者密码错误!");
     }
	 myJson.sendToClient(response);
 }
 /**
  * 可以检测用户是否登录,同时可以获取用户的相关信息;
  * @param request
  * @param response
  * @throws IOException
  */
  @RequestMapping("/isUserLogined.json")
  public void isUserLogined(HttpServletRequest request,HttpServletResponse response) throws IOException{
	  MyJson myJson=new MyJson();
	  User user=this.userManager.isUserLogined(request);
	  User userTemp=new User();
	  if(user!=null){
		  BeanUtils.copyProperties(user, userTemp);
		  myJson.setSuccess(true);
		  userTemp.setPassword("***");
		  myJson.setObject(userTemp);
	  }
	  myJson.sendToClient(response);
  }
 
  @RequestMapping("/user/userLogOut.json")
  public void userLogOut(HttpServletRequest request,HttpServletResponse response) throws IOException
  { MyJson myJson=new MyJson();
    this.userManager.setUserLogouted(request);
    myJson.setSuccess(true);
    myJson.setMsg("操作成功!");
    myJson.sendToClient(response);
  }
  /**
   * 更新用户,和更改密码分开,让用户的密码更加保险
   * @param user
   * @param request
   * @param response
   * @throws IOException
   */
  @RequestMapping("/user/updateUser.json")
  public void updateUser(User user,HttpServletRequest request,HttpServletResponse response) throws IOException{
	  MyJson myJson=new MyJson();
	  User dbUser=this.userManager.getLoginUser(request);
	 if(dbUser!=null&&dbUser.getId()-user.getId()!=0)
		 throw new DataException("操作非法,无法更新其他用户信息!");
	  User userTemp=this.userManager.getUserDao().get(User.class, user.getId());
	  if(userTemp!=null){
	  	  
      userTemp=getUpdateUserFromDb(userTemp, user);
	  this.userManager.updateUser(userTemp);
	  
	  User userTemp2=new User();
	  BeanUtils.copyProperties(userTemp, userTemp2);
	  userTemp2.setPassword("***");
	  myJson.setSuccess(true);
	  myJson.setMsg("操作成功!");
      myJson.setObject(userTemp2);
	  this.userManager.setUserLogined(userTemp, request,false);  
	
	  } else{
		  myJson.setSuccess(false);
		   myJson.setMsg("操作失败!请先登录!");
	 }
	    myJson.sendToClient(response);  
  }
  /**
   * 将dbUser中的一些非必要信息更新,除开密码,注册时间这些等不可更新属性,之后请使用dbUser中的值;
   * @param dbUser 数据库当前保存的user
   * @param tmpUser 前端传来的需要更新的usedr
   */
  public static User getUpdateUserFromDb(User dbUser,User tmpUser){  
	  dbUser.setAge(tmpUser.getAge());
	  dbUser.setEmail(tmpUser.getEmail());
	  dbUser.setPhone(tmpUser.getPhone());
	  dbUser.setQq(tmpUser.getQq());
	  dbUser.setPhoto(tmpUser.getPhoto());
	  dbUser.setSex(tmpUser.getSex());
	  dbUser.setUpdateTime(TimeUtils.getNowDateAndTime());
	  dbUser.setUserName(tmpUser.getUserName());	  
	  return dbUser;
  }
  
  /**
   * 用户更新密码
   * @param request
   * @param response
   * @param oldPassword
   * @param newPassword
   * @param rNewPassword
 * @throws IOException 
   */
  @RequestMapping("/user/updatePassword.json")
  public void updateUserPassword(HttpServletRequest request,HttpServletResponse response,String oldPassword,String newPassword,String rNewPassword,String vcode) throws IOException
  {
	if(newPassword==null||oldPassword==null||rNewPassword==null)
		throw new DataException("请输入相应的新旧密码！");
   
	if(!newPassword.equals(rNewPassword))
	  throw new DataException("两次输入新的密码不一致！");
  
   if(!VerificationCodeAction.checkVCode(vcode, request))
		  throw new DataException("验证码错误！");
	 User user=this.userManager.getLoginUser(request);
	 if(!oldPassword.equals(user.getPassword()))
	 throw new DataException("旧密码错误！");
	   MyJson myJson;
	   myJson=this.userManager.updateUserPassword(user,newPassword,request);
	   myJson.sendToClient(response);  
  }
  
}
