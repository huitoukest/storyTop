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
import com.tingfeng.manager.AfficheManager;
import com.tingfeng.model.Affiche;
import com.tingfeng.page.Page;
import com.tingfeng.page.Pager;
import com.tingfeng.system.MyJson;
import com.tingfeng.utils.SpringUtils;

@Controller
public class AfficheAction {
	@Autowired
private  AfficheManager afficheManager;

	public AfficheAction() {
		// TODO Auto-generated constructor stub
	}
	
   public AfficheManager getAfficheManager() {
		return afficheManager;
	}


	public void setAfficheManager(AfficheManager afficheManager) {
		this.afficheManager = afficheManager;
	}
	
@RequestMapping("/admin/afficheManage.do")
public String afficheManage(){
	
	return "/admin/afficheManage.jsp";
}
	
/**
    * 得到可用的网站公告
    * @param response
    * @throws IOException
    * @throws SystemException
    */
	@RequestMapping("/getUsingAffiche.json")
	public void getUsingAffiche(HttpServletResponse response) throws IOException
	{  MyJson myJson=new MyJson();
	   try{
	  myJson=this.getAfficheManager().getUsingAffiche();
	  } catch(Exception e)
	   {   
		   myJson.setSuccess(false);
		   myJson.setMsg("获取公告失败！"+e.getMessage());
	   }
	   myJson.sendToClient(response);	 
	}
	
	
	@RequestMapping("/admin/getAllAffiche.json")
	public void getAllAffiche(HttpServletRequest request,HttpServletResponse response,Page page) throws IOException{
		if(request.getSession().getAttribute("admin")==null)
			throw new DataException("请以管理员身份登录！");
		MyJson myJson=new MyJson();
		Pager<Affiche> pager=null;
		   try{
		  pager=this.getAfficheManager().getAllAffiche(page);
		  } catch(Exception e)
		   {   
			   myJson.setSuccess(false);
			   myJson.setMsg("获取公告失败！"+e.getMessage());
			   myJson.sendToClient(response);	 
		   }
		   SpringUtils.sendText(response, JSON.toJSONString(pager));	 
	}
	
	@RequestMapping("/admin/addAffiche.json")
	public void addAffiche(HttpServletRequest request,HttpServletResponse response,Affiche affiche) throws IOException{
		if(request.getSession().getAttribute("admin")==null)
			throw new DataException("请以管理员身份登录！");
		MyJson myJson=new MyJson();
		
		   try{
		  myJson=this.getAfficheManager().addAffiche(affiche);
		  } catch(Exception e)
		   {   
			   myJson.setSuccess(false);
			   myJson.setMsg("获取公告失败！"+e.getMessage());
			   	 
		   } finally{
			   myJson.sendToClient(response);
		   }
 
	}
	
	@RequestMapping("/admin/updateAffiche.json")
	public void updateAffiche(HttpServletRequest request,HttpServletResponse response,Affiche affiche) throws IOException{
		if(request.getSession().getAttribute("admin")==null)
			throw new DataException("请以管理员身份登录！");
		MyJson myJson=new MyJson();
		
		   try{
		  myJson=this.getAfficheManager().updateAffiche(affiche);
		  } catch(Exception e)
		   {   
			   myJson.setSuccess(false);
			   myJson.setMsg("更新公告失败！"+e.getMessage());
			   	 
		   } finally{
			   myJson.sendToClient(response);
		   }
 
	}
	
	
	@RequestMapping("/admin/deleteAffiches.json")
	public void deleteAffiche(HttpServletRequest request,HttpServletResponse response,String ids) throws IOException{
		if(request.getSession().getAttribute("admin")==null)
			throw new DataException("请以管理员身份登录！");
		MyJson myJson=new MyJson();
		
		   try{
		  myJson=this.getAfficheManager().deleteAffiche(ids);
		  } catch(Exception e)
		   {   
			   myJson.setSuccess(false);
			   myJson.setMsg("删除公告失败！"+e.getMessage());
			   	 
		   } finally{
			   myJson.sendToClient(response);
		   }
 
	}
}
