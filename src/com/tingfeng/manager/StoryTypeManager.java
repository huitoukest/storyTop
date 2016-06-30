package com.tingfeng.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tingfeng.DAOImpl.BaseDaoImpl;
import com.tingfeng.model.StoryType;

@Service("storyTypeManager")
public class StoryTypeManager {
    @Autowired
	public BaseDaoImpl<StoryType> storyTypeDao;
	public StoryTypeManager() {		
	}
   
	public List<StoryType> getAllStoryType(){
		String hql="from StoryType";
		return this.storyTypeDao.find(hql);
	}
}
