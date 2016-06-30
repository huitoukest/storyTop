package com.tingfeng.staticThing;

import java.io.File;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 
 * @author tingfeng
 * 此类的作用是获取保存系统上传文件的位置，以后会考虑将上次的文件位置写入到数据库或者配置文件中
 */
public class UploadFolder {
    private static String saveFolderPath="images";
	public UploadFolder() {
		// TODO Auto-generated constructor stub
	}
   /**
    * 用于内部文件的保存
    * @param request
    * @return
    */
	public static String getSaveFolderPath(HttpServletRequest request){
		
		return getSaveFolderPath(request.getSession());
	}
	/**
	 * 用于外链http显示
	 * @param request
	 * @return
	 */
	public static String getImageDisPlayFolder(HttpServletRequest request){
		String path=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/"+saveFolderPath+"/";
		return path;
	}
	
	public static String getSaveFolderPath(HttpSession session){
		String RealPath=session.getServletContext().getRealPath("/").replace("/", "\\");
		//String contextPath=request.getContextPath().replace("/", "\\");
		File file=new File(RealPath);
		RealPath=file.getParent();
		//System.out.println("contextPath="+contextPath);
		System.out.println("RealPath="+RealPath);
		
		return RealPath+"\\"+saveFolderPath+"\\";
	}
}
