package com.tingfeng.system;

import java.io.File;
import java.util.ArrayList;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.hibernate.Transaction;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.sun.istack.internal.logging.Logger;
import com.tingfeng.manager.ImagesManager;
import com.tingfeng.staticThing.UploadFolder;

/**
 * 
 * @author tingfeng 自定义一个Session监听器,主要的作用是在Session销毁的时候,将用户上传的无用的文件删除
 */

@Component
public class MySessionListener implements HttpSessionListener {
	Logger logger=Logger.getLogger(MySessionListener.class);

	private ImagesManager imagesManager;

	public MySessionListener() {
		
	}

	public ImagesManager getImagesManager() {
		return imagesManager;
	}

	public void setImagesManager(ImagesManager imagesManager) {
		this.imagesManager = imagesManager;
	}

	@Override
	public void sessionCreated(HttpSessionEvent arg0) {
		// TODO Auto-generated method stub
		ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(arg0.getSession().getServletContext());
		imagesManager = (ImagesManager ) ctx.getBean("imagesManager"); // 填写要注入的类,注意第一个字母小写
		
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent arg0) {
		HttpSession session = arg0.getSession();
		            if(session==null)
		            	return;
		String path = UploadFolder.getSaveFolderPath(session);
		Transaction transaction=null;
		try{
		imagesManager.getImageDao().setSession(imagesManager.getImageDao().getSessionFactory().openSession());
		imagesManager.getImageDao().getSession().beginTransaction();				  
			this.deleteUnusedFile(session, path);
			transaction=imagesManager.getImageDao().getSession().getTransaction();
			transaction.commit();
			
		} catch(Exception e){
			if(transaction!=null)
			transaction.rollback();
		}
	}

	@SuppressWarnings("unchecked")
	public void deleteUnusedFile(HttpSession session, String path) {
		if (session.getAttribute("imageIds") != null) {
			ArrayList<String> imgNamesT = (ArrayList<String>) session
					.getAttribute("imgNames");
			ArrayList<Integer> idsT = (ArrayList<Integer>) session
					.getAttribute("imageIds");
			ArrayList<Integer> newIdsArrayList = new ArrayList<Integer>();
			if (imgNamesT != null && imgNamesT.size() > 0)
				for (int i = 0; i < imgNamesT.size(); i++) {
					// 如果这个图片没有被使用,那么删除
					if (idsT != null
							&& idsT.size() > 0
							&& idsT.get(i) != null
							&& this.getImagesManager().imageUsedCount(
									idsT.get(i)) < 1) {
                        String fileName=path+imgNamesT.get(i);
						File fileT = new File(fileName);
						if (fileT.exists())
						{	
							fileT.delete();
						logger.info("删除文件："+fileName);
						}
						newIdsArrayList.add(idsT.get(i));
					}
				}// end for
			if (idsT != null)
				this.imagesManager.deleteImages(newIdsArrayList);
		}
	}
}