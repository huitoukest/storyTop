package com.tingfeng.manager;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun.istack.internal.logging.Logger;
import com.tingfeng.DAOImpl.BaseDaoImpl;
import com.tingfeng.model.Image;
import com.tingfeng.staticThing.UploadFolder;

@Service
public class ImagesManager {
@Autowired
private BaseDaoImpl<Image> imageDao;
Logger logger=Logger.getLogger(this.getClass());
	public ImagesManager() {
		// TODO Auto-generated constructor stub
	}
	public BaseDaoImpl<Image> getImageDao() {
		return imageDao;
	}
	public void setImageDao(BaseDaoImpl<Image> imageDao) {
		this.imageDao = imageDao;
	}
	
	public Image getImageByName(String name){
		Image image = null;
		String hql="from Image img where img.name=:name";
		Map<String, Object> params=new HashMap<String, Object>();
		params.put("name", name);
		image=this.getImageDao().get(hql, params);
		return image;
	}
    /**
     * 
     * @param imageId
     * @return 一张图片被各个地方引用的次数
     */
	public Long imageUsedCount(Integer imageId)
	{  if(imageId==null)
		return 0L;
		Long c1,c2;
	   String hql1="select count(*) from TopicImage tt where tt.image.id="+imageId;
	   String hql2="select count(*) from UserAuthentication ut where ut.image.id="+imageId;
	   
	   c1=this.getImageDao().count(hql1);
	   c2=this.getImageDao().count(hql2);
	   if(c1==null) c1=0L;
	   if(c2==null) c2=0L;
	logger.info("当前图片("+imageId+")使用的次数是"+c1+"和"+c2);
	   return c1+c2;
		
	}
	
	/**
	 * 删除多幅图片,不做别的判断,所以删除钱最好自行检查此图片是否已经使用
	 * */
	public void deleteImages(ArrayList<Integer> idsT) {
		String hql="delete Image img where img.id in (";
		if(idsT!=null&&idsT.size()>0){		
			for(int i=0;i<idsT.size()-1;i++){
				if(this.imageUsedCount(idsT.get(i))<1)
				hql=hql+idsT.get(i)+",";
			}
		
			hql=hql+idsT.get(idsT.size()-1)+")";
			this.imageDao.executeHql(hql);
		}
		
	
       logger.info("当前删除图片的hql语句是->"+hql);

	}
	/**
	 * 删除一个图片记录以及其文件
	 */
	public boolean deleteImageAndFile(Integer imageId,HttpServletRequest request){
	if(imageId==null) return false;
		Image image=this.getImageDao().get(Image.class, imageId);
		String path=UploadFolder.getSaveFolderPath(request);
		
		File file=new File(path+image.getName());
		if(file.exists())
			file.delete();
		 this.getImageDao().delete(image);
	   return true;
	}
}
