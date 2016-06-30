package com.tingfeng.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSON;
import com.tingfeng.exception.DataException;
import com.tingfeng.exception.SystemException;
import com.tingfeng.manager.AdminManager;
import com.tingfeng.manager.UserManager;
import com.tingfeng.model.Admin;
import com.tingfeng.page.Page;
import com.tingfeng.page.Pager;
import com.tingfeng.system.MyJson;
import com.tingfeng.utils.SpringUtils;

@Controller
@RequestMapping("/admin")
public class AdminAction {
@Autowired
private UserManager userManager;
@Autowired
private AdminManager adminManager;
	public AdminAction() {
		// TODO Auto-generated constructor stub
	}
@RequestMapping
 public String adminIndex(){
	 return "/admin/index.jsp";
 }
@RequestMapping("/index.do")
public String adminIndex2(){
	 return "/admin/index.jsp";
}
@RequestMapping("/index.html")
public String adminIndex3(){
	 return "/admin/index.jsp";
}
@RequestMapping("/north.do")
public  String getAdminNorth(){
	return "/admin/north.jsp";
}
@RequestMapping("/welcome.do")
public  String getAdminWelcome(){
	return "/admin/welcome.jsp";
}
@RequestMapping("/userManage.do")
public  String getUserManage(){
	return "/admin/userManage.jsp";
}

@RequestMapping("/adminManage.do")
public  String getAdminManage(){
	return "/admin/adminManage.jsp";
}

@RequestMapping("/needAdminLoginTemp.do")
public String sendToAdmin(){
	return "/admin/needAdminLoginTemp.jsp";
}
/**
 * 添加管理员用户
 * @param response
 * @throws IOException
 * @throws SystemException
 */
@RequestMapping("/addAdmin.json")
public void saveAdmin(HttpServletResponse response,Admin admin,HttpServletRequest request) throws IOException, SystemException
{  //System.out.println("username="+user.getName());
   MyJson myJson;
   myJson=this.adminManager.saveAdmin(admin, request);
   myJson.sendToClient(response);	 
}


/**
 * 删除一群管理员用户,需要一个用逗号分隔的id字符串,前台通过判断myJson是否定义来判断是否后台返回数据
 * 通过myJson.success来判断操作是否成功
 * @param response
 * @throws IOException
 * @throws SystemException
 */
@RequestMapping("/deleteAdmins.json")
public void deleteAdmins(HttpServletResponse response,String ids,HttpServletRequest request) throws IOException, SystemException
{  //System.out.println("username="+user.getName());
   MyJson myJson;
   myJson=this.adminManager.deleteAdmins(ids,request);
   myJson.sendToClient(response);	 
}

/**
 * 更新管理员用户
 * @param response
 * @throws IOException
 * @throws SystemException
 */
@RequestMapping("/updateAdmin.json")
public void updateAdmin(HttpServletResponse response,Admin admin,HttpServletRequest request) throws IOException, SystemException
{  //System.out.println("admin.getName="+admin.getName());
   MyJson myJson=new MyJson();
   try{
	   this.adminManager.updateAdmin(admin, request);
	   myJson.setSuccess(true);
	   myJson.setMsg("管理员用户更新成功!");
   } catch(Exception e)
   {
	   myJson.setSuccess(false);
	   myJson.setMsg("管理员用户更新失败:"+e.getMessage());
   }
   myJson.sendToClient(response);	 
}

/**
 * 可以通过id号码和name来确定获得的管理员的数据,当id和name都为空的时后,不发送数据;
 * 当id==-1,表示所有管理员;可以通过id号码和name来确定需要知道的管理员,搜索姓名的时候id必须为-1;
 * 同时,权限大于此登录管理员的其它管理员的密码和用户名将会显示为***
 * @param id
 * @param name
 * @throws IOException 
 */
@RequestMapping("/getAllAdmins.json")
public void getAllAdmins(HttpServletResponse response,Integer id,String name,Page page,HttpServletRequest request) throws IOException{
	Pager<Admin> admins=this.adminManager.getAllAdmins(id, name, page, request);
	//System.out.println(users);
	SpringUtils.sendText(response, JSON.toJSONString(admins)); 
	}


/**
 * 管理员用户的登录
 * @param response
 * @param id
 * @param name
 * @param page
 * @throws IOException
 */
@RequestMapping("/adminLogin.json")
public void loginAdmin(HttpServletResponse response,HttpServletRequest request,Admin admin,String vcode) throws IOException{
	MyJson myJson=new MyJson();
	if(!VerificationCodeAction.checkVCode(vcode, request))
		  throw new DataException("验证码错误！");
    Admin admin2=this.adminManager.getAdminByAdminName(admin.getName());
	 if(admin2==null) { 
		 myJson.setSuccess(false);
		 myJson.setMsg("用户名或者密码错误!");
	 } else if(admin.getPassword()!=null&&admin2.getPassword().equals(admin.getPassword()))
    {
		 this.adminManager.setAdminLogined(admin2, request);		 
   	 myJson.setSuccess(true);
		 myJson.setMsg("登陆成功!");
		 myJson.setObject(admin2);
    } else {
   	 myJson.setSuccess(false);
		 myJson.setMsg("用户名或者密码错误!");
    }
	 myJson.sendToClient(response);
 }

@RequestMapping("/isAdminLogin.json")
public void isAdminLogin(HttpServletResponse response,HttpServletRequest request) throws IOException{
	MyJson myJson;
	myJson=this.adminManager.isAdminLogined(request);
    myJson.sendToClient(response);
}

@RequestMapping("/adminLogOut.json")
public void adminLogOut(HttpServletResponse response,HttpServletRequest request) throws IOException{
	MyJson myJson;
	myJson=this.adminManager.setAdminLogouted(request);
    myJson.sendToClient(response);
}

}

