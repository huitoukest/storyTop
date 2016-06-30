package com.tingfeng.manager;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tingfeng.DAOImpl.BaseDaoImpl;
import com.tingfeng.exception.DataException;
import com.tingfeng.model.Story;
import com.tingfeng.page.Page;
import com.tingfeng.page.Pager;
import com.tingfeng.staticThing.ConstantsAll;
import com.tingfeng.staticThing.ConstantsStory;
import com.tingfeng.utils.StringUtils_wg;
import com.tingfeng.utils.TimeUtils;

@Service("storyManager")
public class StoryManager {
    @Autowired
	public BaseDaoImpl<Story> storyDao;
	public StoryManager() {		
	}
    /**
     * 首次保存某些小说,小说的status请在controller层设置好
     * @param story
     * @return
     */
	public Long saveStory(Story story){
		//if(story==null)
			//throw new DataException("传入的小说为空");
		if(!checkStory(story))
			return -1L;
		if(isStoryExisted(story.getName(),story.getAuthor()))
		{
			throw new DataException("此小说已经存在!");
		}
		story.setId(null);
		story.setScore(0L);
		story.setMarkCount(0L);
		story.setAvgScore(ConstantsAll.storyFistAvgScore);
		story.setCorrectTime(TimeUtils.getNowDateAndTime());
		story.setErrorCount(0);
		story.setMarkCountWhenCorrect(0L);
		return (Long) this.storyDao.save(story);
	}
	
	/**
     * 保存或者更新小说的时候,检查最低要求的属性
     * @param story
     * @return
     */
    public boolean checkStory(Story story){
    	if(story==null)
			throw new DataException("传入的小说不能为空");
    	String s="";
    	if(story.getAuthor()==null||story.getAuthor().trim().length()<1)
    	{
    		s+="作者";
    		story.setAuthor(story.getAuthor().trim());
    	}else if(story.getName()==null||story.getName().trim().length()<1)
    		{
    		 s+="名字";
    		 story.setName(story.getName().trim());
    		}else if(null==story.getUpdateState()){
    			s+="更新状态";
    		}else if(story.getPublishedTime()==null||story.getPublishedTime().getTime()>=System.currentTimeMillis()){
    			s+="发布时间";
    		}else if(story.getStoryBaikeUrl()==null||!ConstantsStory.isUrlStartWithBaike(story.getStoryBaikeUrl())){
    			s+="百科链接(支持百度/搜狗/好搜)";
    		}else if(story.getUpdateState()-ConstantsStory.story_updateState_finish==0&&
    				(story.getEndTime()==null||story.getEndTime().getTime()>=System.currentTimeMillis()||story.getEndTime().getTime()<=story.getPublishedTime().getTime())){
    			s+="完结时间";
    		}else if(story.getWordCount()==null||
    				(story.getUpdateState()-ConstantsStory.story_updateState_finish==0&&story.getWordCount()-ConstantsStory.story_wordCount_unkonw==0)||
    				(story.getUpdateState()-ConstantsStory.story_updateState_finish!=0&&story.getWordCount()-ConstantsStory.story_wordCount_unkonw!=0)){  			
    			s+="字数";
    		}else if(story.getStoryType()==null||story.getStoryType().getId()==null)
    		{
    			s+="小说类别";
    		}
    	if(s.length()>1){
    		s+="小说"+s+"不符合要求!";
    		throw new DataException(s);
    	}
    	return true;	
    }
    
    public boolean isStoryExisted(String name,String author){
    	return false;
    }
    /**
     * 
     * @param id
     * @param name
     * @param author
     * @param typeId
     * @param wordCount
     * @param publishedTime
     * @param endTime
     * @param updateState
     * @param status
     * @param page
     * @param condition_startTime 搜索条件中的开始时间
     * @param condition_endTime 搜索田间中的一个结束时间,可以对某一个对象中的某个时间属性进行范围搜索
     * @return
     */
	public Pager<Story> getAllStorys(Long id, String name,String author, Long typeId,
			Integer wordCount, Boolean publishedTime,Boolean endTime,
			Integer updateState, Integer status, Page page,Date condition_startTime,Date condition_endTime) {
		String hql="select story from Story story where 1=1";
		Map<String,Object> params=new HashMap<String, Object>();
		if(id!=null&&id>0){
			hql+=" and story.id=:id";
			params.put("id",id);
		}else{
			if(StringUtils_wg.isStringUsed(name)){
				hql+=" and story.name like :name";
				params.put("name","'%"+name+"%'");				
			}
			
			if(StringUtils_wg.isStringUsed(author)){
				hql+=" and story.author like :author";
				params.put("author","'%"+author+"%'");				
			}
			
			if(typeId!=null&&typeId>0){
				hql+=" and story.storyType.id =:typeId";
				params.put("typeId",typeId);				
			}
			if(wordCount!=null&&wordCount>0){
				hql+=" and story.wordCount =:wordCount";
				params.put("wordCount",wordCount);
			}
			if(condition_startTime!=null&&condition_endTime!=null&&condition_endTime.getTime()-condition_startTime.getTime()>0){
			    if(publishedTime!=null&&publishedTime){
			    	hql+=" and story.publishedTime>=:condition_startTime and story.publishedTime<=:condition_endTime";
			    	params.put("condition_startTime",condition_startTime);
			    	params.put("condition_endTime",condition_endTime);
		    	}
			    
			    if(endTime!=null&&endTime){
			    	hql+=" and story.endTime>=:condition_startTime and story.endTime<=:condition_endTime";
			    	params.put("condition_startTime",condition_startTime);
			    	params.put("condition_endTime",condition_endTime);
		    	}
			
			}
			
			if(updateState!=null&&updateState>=0){
				hql+=" and story.updateState=:updateState";
				params.put("updateState",updateState);
			}
			
			if(status!=null&&status>=0){
				hql+=" and story.status=:status";
				params.put("status",status);
			}
			
		}			
		Pager<Story> storyPager=this.storyDao.findPager(hql, params, page, 1000);
		return storyPager;
	}
}
