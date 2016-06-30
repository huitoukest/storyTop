package com.tingfeng.controller;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tingfeng.DAOImpl.BaseDaoImpl;
import com.tingfeng.model.Admin;
import com.tingfeng.staticThing.UploadFolder;
import com.tingfeng.system.IsInited;
import com.tingfeng.utils.SpringUtils;
import com.tingfeng.utils.TimeUtils;

@Controller
public class InitSystemAction{
/**
	 * 
	 */
private static final long serialVersionUID = 1L;
@Autowired
private BaseDaoImpl<Admin> adminDao;
	public InitSystemAction() {
		// TODO Auto-generated constructor stub
		
	}
	/**
	 * 在这里初始化系统
	 * @throws IOException 
	 */
	@RequestMapping("/initSystem.do")
	public void init(HttpServletResponse response,HttpServletRequest request) throws IOException{  
        if(!IsInited.getIsInited().isOk()){
		boolean c=initAdmin();
		
		File file=new File(UploadFolder.getSaveFolderPath(request));
		boolean d=true;
		if (!file.exists()) {
			   file.mkdir();//如果文件夹不存在，那么新建
		         d=false;	  
		}else if(!file.isDirectory()){
				  file.delete();
				  file=new File(UploadFolder.getSaveFolderPath(request));
				  file.mkdir();
				  d=false;
			  }
		
		IsInited.getIsInited().setOk(true);
		if(d){
			SpringUtils.sendText(response, "系统已经初始化，无需再次初始化！");
		}else{
		SpringUtils.sendText(response, "系统初始化成功！");
		}
		} else{
			SpringUtils.sendText(response, "系统已经初始化，无需再次初始化！");
		}
    }
	/**
	 * admin表的初始化
	 * @return 
	 */
	public boolean initAdmin(){
		String hql="select count(*) from Admin";
		Long count=this.getAdminDao().count(hql);
		if(count==null||count<1)
		{
			Admin admin=new Admin();
			admin.setName("admin");
			admin.setPassword("21232f297a57a5a743894a0e4a801fc3");
			admin.setPowerValue(0);
			admin.setNickName("系统管理员");
			admin.setLastLoginTime(TimeUtils.getNowDateAndTime());
			this.getAdminDao().save(admin);
		 return true;
		}
		 return false;
	}
	public BaseDaoImpl<Admin> getAdminDao() {
		return adminDao;
	}
	public void setAdminDao(BaseDaoImpl<Admin> adminDao) {
		this.adminDao = adminDao;
	}
	
}
