package com.tingfeng.manager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tingfeng.DAOImpl.BaseDaoImpl;
import com.tingfeng.exception.DataException;
import com.tingfeng.model.Topic;
import com.tingfeng.model.User;
import com.tingfeng.page.Page;
import com.tingfeng.page.Pager;
import com.tingfeng.system.MyJson;

@Service
public class CollectionTopicsManager {

@Autowired
private TopicManager topicManager;
	public CollectionTopicsManager() {
		// TODO Auto-generated constructor stub
	}

	public TopicManager getTopicManager() {
		return topicManager;
	}

	public void setTopicManager(TopicManager topicManager) {
		this.topicManager = topicManager;
	}

	public MyJson getUserCollectionTopics(HttpServletRequest request,HttpServletResponse response,Page page){
		MyJson myJson=new MyJson();
	    return myJson;
	}
	
/**
 * 保存一条收藏记录
 * @param user
 * @param topicId
 */
	public void saveCollectionTopic(User user, Integer topicId) {
		
	}
	
	public void getCollectionTopicsByUserAndTopicId(User user, Integer topicId){
		String hql="select ct from CollectionTopics ct where ct.user.id="+user.getId()+" and ct.topicId="+topicId;
	}

	public MyJson deleteCollectionTopics(HttpServletRequest request,Integer cId) {
		if(cId==null||cId<-1)
		throw new DataException("收藏编号非法！");
		MyJson myJson=new MyJson();
		myJson.setSuccess(true);
	return myJson;	
	}
	
	
	
}
