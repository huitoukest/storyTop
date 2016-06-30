package com.tingfeng.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun.istack.internal.logging.Logger;
import com.tingfeng.DAOImpl.BaseDaoImpl;
import com.tingfeng.model.Topic;
import com.tingfeng.model.TopicImage;
@Service
public class TopicImageManager {
@Autowired
private BaseDaoImpl<TopicImage> topicImageDao;
Logger logger=Logger.getLogger(this.getClass());
	public TopicImageManager() {
		// TODO Auto-generated constructor stub
	}
	public BaseDaoImpl<TopicImage> getTopicImageDao() {
		return topicImageDao;
	}
	public void setTopicImageDao(BaseDaoImpl<TopicImage> topicImageDao) {
		this.topicImageDao = topicImageDao;
	}

   public long getImageCountOfTopic(Topic topic){
	  String hql="select count(*) from TopicImage ti where ti.topic.id="+topic.getId();
	   Long c=this.getTopicImageDao().count(hql);
	   if(c!=null&&c>0)
		   return c;
	   return 0;
   }
   
   public TopicImage getTopicImage(Integer imageId,Integer topicId){
	   String hql="select ti from TopicImage ti where ti.topic.id="+topicId+" and ti.image.id="+imageId;
       TopicImage topicImage=this.getTopicImageDao().get(hql);
       return topicImage;
   }

}
