package com.tingfeng.manager;

import java.io.File;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun.istack.internal.logging.Logger;
import com.tingfeng.DAOImpl.BaseDaoImpl;
import com.tingfeng.DTO.AddressForm;
import com.tingfeng.DTO.ThingSortForm;
import com.tingfeng.DTO.TopicForm;
import com.tingfeng.DTO.UserForm;
import com.tingfeng.exception.DataException;
import com.tingfeng.model.Admin;
import com.tingfeng.model.Image;
import com.tingfeng.model.Topic;
import com.tingfeng.model.TopicImage;
import com.tingfeng.model.User;
import com.tingfeng.page.Page;
import com.tingfeng.page.Pager;
import com.tingfeng.system.MyJson;
import com.tingfeng.utils.StringUtils_wg;
import com.tingfeng.utils.TimeUtils;

@Service("topicManager")
public class TopicManager {
	@Autowired
	private BaseDaoImpl<Topic> topicDao;
	@Autowired
	private BaseDaoImpl<User> userDao;
	@Autowired
	private ThingSortManager thingSortManager;
	@Autowired
	private ImagesManager imagesManager;
	@Autowired
	private TopicImageManager topicImageManager;
	
	Logger logger=Logger.getLogger(TopicManager.class);
	// 这里的spring注入实际上是使用接口来注入,所以如果接口中的方法和此类的方法不一样,注入会发生参数不匹配的错误
	public TopicManager() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * 找到此物品分类下对应的主题数量
	 * @param id
	 * @return
	 */
	public Long getTopicCountByThingSortId(Integer id){
		if(id==null||id<=0) return 0L;
	String hql="select count(*) from Topic tp where tp.thingSort.id="+id;
	return this.topicDao.count(hql);
	}

	public ImagesManager getImagesManager() {
		return imagesManager;
	}

	public void setImagesManager(ImagesManager imagesManager) {
		this.imagesManager = imagesManager;
	}

	public BaseDaoImpl<Topic> getTopicDao() {
		return topicDao;
	}

	public TopicImageManager getTopicImageManager() {
		return topicImageManager;
	}

	public void setTopicImageManager(TopicImageManager topicImageManager) {
		this.topicImageManager = topicImageManager;
	}

	public void setTopicDao(BaseDaoImpl<Topic> topicDao) {
		this.topicDao = topicDao;
	}
			
	public BaseDaoImpl<User> getUserDao() {
		return userDao;
	}

	public void setUserDao(BaseDaoImpl<User> userDao) {
		this.userDao = userDao;
	}
	
	public MyJson saveTopic(Topic topic) {
		// TODO Auto-generated method stub
		return null;
	}

	public Topic getTopicByTopicName(String name) {
		// TODO Auto-generated method stub
		return null;
	}

	public ThingSortManager getThingSortManager() {
		return thingSortManager;
	}

	public void setThingSortManager(ThingSortManager thingSortManager) {
		this.thingSortManager = thingSortManager;
	}

	/**
	 * 1.一共13个参数,仅当id为-1,其余都为空的时候返回所有主题,
	 * 2.当有其余条件的时候,id同时为-1的时候,返回相应条件的搜索结果
	 * 根据前台传送回来的数据来筛选出相应的数据发送到前台,条件非为限制条件和搜索关键字两个方面
	 * @param response
	 * @param id 主题id
	 * @param name 主题名称,支持模糊查询
	 * @param user 用户名称
	 * @param userId 用户id
	 * @param type 交易类型
	 * @param thingSort 物品分类
	 * @param address 交易地点
	 * @param startTime 开始时间
	 * @param endTime 结束时间
	 * @param page 分页信息
	 * @param isPublishTime startTime和endTime是否作为发布时间的筛选条件
	 * @param isUpdateTIme startTime和endTime是否作为updateTime的筛选条件
	 * @param request
	 * @throws IOException
	 */
	public Pager<TopicForm> getAllTopics(HttpServletRequest request,
			HttpServletResponse response, Integer id, String name, String user,Integer userId,
			Byte type, Integer thingSort, Integer address, Date startTime,
			Date endTime, Boolean isPublishTime, Boolean isUpdateTime, Page page,Byte oldLevel) {
		
		Pager<TopicForm> topicFormsPager=new Pager<TopicForm>();
		ArrayList<TopicForm> topicForms;
		ArrayList<Topic> topicArrayList;
		
		if(page.getSort()!=null){
			page.setSort("tp."+page.getSort());
		}
		
		String hqlWhere="";
		Map<String,Object> params=new HashMap<String, Object>();
		//根据条件筛选内容
        if(userId!=null&&userId>=0){
        	hqlWhere=hqlWhere+"and tp.user.id=:userId ";
			params.put("userId", userId);
        } else
		if(StringUtils_wg.isStringUsed(user)){
			hqlWhere=hqlWhere+"and tp.user.name=:userName ";
			params.put("userName", user);
		}
		if(type!=null&&type!=0){
			hqlWhere=hqlWhere+"and tp.type="+type+" ";
			//params.put("userName", user);
		}
		if(thingSort!=null){
			hqlWhere=hqlWhere+"and tp.thingSort.id="+thingSort+" ";
		}
		if(address!=null&&address>=0){
			hqlWhere=hqlWhere+"and tp.address.id="+address+" ";
		}
		
		if(oldLevel!=null&&oldLevel!=0){
			hqlWhere=hqlWhere+"and tp.oldLevel="+oldLevel+" ";
		}
		
		if(startTime!=null&&endTime!=null&&(isPublishTime!=null||isUpdateTime!=null))
		{   if(isPublishTime!=null&&isPublishTime)
			hqlWhere=hqlWhere+"and tp.publishTime>=:startTime and tp.publishTime<=:endTime ";
		    
		   if(isUpdateTime!=null&&isUpdateTime)
			hqlWhere=hqlWhere+"and tp.updateTime>=:startTime and tp.updateTime<=:endTime ";
		    
		    params.put("startTime", startTime);
		    params.put("endTime", endTime);
		}
		
		logger.info("当前筛选的条件hql语句是:"+hqlWhere);
		
		//开始关键字查询
		if(id!=null&&id==-1&&(!StringUtils_wg.isStringUsed(name)))
		{//当查询条件都是空的时候,并且id为-1的时候,返回所有用户
			//String hql="from Topic tp ";
			//if(hqlWhere!=null&&!hqlWhere.equals(""))
			//{
				//hql=hql+hqlWhere;
			//}											
			topicFormsPager.setTotal(this.topicDao.count("select count(*) from Topic tp where 1=1 "+hqlWhere,params));
			topicArrayList=(ArrayList<Topic>)this.getTopicDao().find("from Topic tp where 1=1 "+hqlWhere, params,page,1000);
			
			topicForms=this.topics_To_topicForms(topicArrayList);
			
			topicFormsPager.setRows(topicForms);
		}else if(id!=null&&id>0)
		{//当指明是搜索id号码的时候,其余条件都是浮云
			String h="";
			if(userId!=null&&userId>=0){
	        	h=" and tp.user.id="+userId;
	        } 
			
			topicFormsPager.setTotal(this.topicDao.count("select count(*) from Topic tp where tp.id="+id+h));
			topicArrayList=(ArrayList<Topic>)this.getTopicDao().find("from Topic tp where tp.id="+id+h, page,1000);
			
			topicForms=this.topics_To_topicForms(topicArrayList);
			topicFormsPager.setRows(topicForms);
			
		}else if(id!=null&&id==-1&&StringUtils_wg.isStringUsed(name)){
			//如果搜素的是主题名
			//Map<String,Object> params=new HashMap<String, Object>();
			params.put("name", "%"+name+"%");
			
			topicFormsPager.setTotal(this.topicDao.count("select count(*) from Topic tp where tp.name like :name "+hqlWhere,params));
			topicArrayList=(ArrayList<Topic>)this.getTopicDao().find("from Topic tp where tp.name like :name "+hqlWhere, params,page,1000);			
			topicForms=this.topics_To_topicForms(topicArrayList);
			topicFormsPager.setRows(topicForms);
		}
			 
		
		
		return topicFormsPager;
	}
	
/**
 * 将一个topic的Entity List转换成为TopicForm的DTO List
 * @param topicArrayList
 * @return
 */
public ArrayList<TopicForm> topics_To_topicForms(ArrayList<Topic> topicArrayList){
	ArrayList<TopicForm> topicForms=new ArrayList<TopicForm>();
	
	for(Topic t:topicArrayList){
		//t.getTopicImages();
		TopicForm topicForm=new TopicForm();
		topicForms.add(topicForm);				
	}
	
	return topicForms;
}
/**
 * 将一个topic的Entity转换成为TopicForm的DTO
 * @param topic
 */
public void topic_To_TopicForm(Topic topic){
	
}
/**
 * 增加一个Topic
 * @param name
 * @param type
 * @param userId
 * @param thingSortId
 * @param addressId
 * @param describe
 * @return
 */
public MyJson addTopic(String phone,String name, Byte type, Integer userId,
		Integer thingSortId, Integer addressId, String describe,Byte buyWay,Byte oldLevel,Integer price,ArrayList<Integer> imgIds) {
	MyJson myJson = null;
	
	return myJson;
}

private MyJson checkTopic(String phone,String name, Byte type, Integer userId,
		Integer thingSortId, Integer addressId, String describe,Byte buyWay,Byte oldLevel,Integer price) {
	MyJson myJson=new MyJson();
	myJson.setSuccess(true);
	String s="";
	
	if(!StringUtils_wg.isStringUsed(name)||name.length()>50)
	{
		s="请输入一个1~50字以内的主题标题!";
		myJson.setSuccess(false);
	} else if(type==null||type<1||type>4)
	{
		s="主题类别不合法!";
		myJson.setSuccess(false);
	}else if(!StringUtils_wg.isStringUsed(describe)||describe.length()<20||describe.length()>500){
		 s="交易详情的字数必须在20~500之间!";
		 myJson.setSuccess(false);
	 }else if(!isMobileNO(phone)){
		 s="手机号码错误！";
		 myJson.setSuccess(false);
	 }
	else if(userId==null)
	{
		s="数据库中不存在此用户,请重新选择发布主题的用户!";
		myJson.setSuccess(false);
	} else if(thingSortId==null){
		s="数据库中不存在此物品分类,请重新选择发布主题的物品分类!";
		myJson.setSuccess(false);
	} else if(addressId==null)
	{
		s="数据库中不存在此地址,请重新选择发布主题的地址!";
		myJson.setSuccess(false);
	 } else if(buyWay==null||buyWay>3||buyWay<1)
	 {
		 s="交易方式错误,请重新选择交易方式!";
			myJson.setSuccess(false);
	 } else if(oldLevel==null||oldLevel>10||oldLevel<6){
		 s="物品成色非法,请重新选择物品的成色!";
			myJson.setSuccess(false);
	 } else if(price==null||price<0||price>100000000){
		 s="物品价格非法,请重新选择物品价格!";
			myJson.setSuccess(false);
	 }
	
	if(myJson.getSuccess())
	s="前台数据检测通过!";
	
	myJson.setMsg(s);
	return myJson;
}


public  boolean isMobileNO(String mobiles){  
	if(mobiles==null||mobiles.length()<11)
		return false;
	Pattern p = Pattern.compile("^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$");  
	
	Matcher m = p.matcher(mobiles);  
	
	System.out.println(m.matches()+"---");
	
		return m.matches(); 
}


/**
 * 更新一个主题
 * @param id
 * @param name
 * @param type
 * @param userId
 * @param thingSortId
 * @param addressId
 * @param describe
 * @return
 */
public MyJson updateTopic(String phone,Integer id, String name, Byte type, Integer userId,
		Integer thingSortId, Integer addressId, String describe,Byte buyWay,Byte oldLevel,Integer price,ArrayList<Integer> imgIds) {
	MyJson myJson;
	myJson=this.checkTopic(phone,name,type,userId,thingSortId,addressId,describe,buyWay,oldLevel,price);
	Topic topicD = null;
	if(id!=null&&myJson.getSuccess())
	{
		topicD=this.getTopicDao().get(Topic.class, id);
	}
	
	if(topicD!=null)
	{//如果检测通过
		
	
		myJson=new MyJson();
		myJson.setSuccess(true);
		myJson.setMsg("更新成功!");
	}
	
	return myJson;
}

public MyJson deleteTopic(Integer id,HttpServletRequest request) {
	MyJson myJson;
	       myJson=new MyJson();
	  try {
		
	} catch (Exception e) {
		myJson.setMsg("操作失败!"+e.getMessage());
		  myJson.setSuccess(false);
	}	       	  
	  return myJson;
}


/**
 * 删除一个主题的相关图片
 * @param topic
 */
public void deleteTopicImage(Topic topic,HttpServletRequest request){
	if(topic!=null&&topic.getId()!=null)
	{ 
	
		logger.info("开始删除一个主题的相关图片和文件!");
	String hql="select img from Image img where img.id in (select ti.image.id from TopicImage ti where ti.topic.id="+topic.getId()+")";
	  String path=request.getServletContext().getRealPath("/")+"images/";
	//首先取出和此主题相关的图片     
	ArrayList<Image> images=(ArrayList<Image>) this.getImagesManager().getImageDao().find(hql);
	
	hql="delete TopicImage ti where ti.topic.id="+topic.getId();//然后删除相关的关联信息，所以关联信息中的图片已经消失
	this.getTopicImageManager().getTopicImageDao().executeHql(hql);  
	
	//然后删除无用图片和无用的文件
		if(images!=null){
			for(Image img:images){//所以，如果没有这个图片的引用了，那么删除相关的东西
				if(this.imagesManager.imageUsedCount(img.getId())<1){
					File file=new File(path+img.getName());
					if(file.exists())
						file.delete();
					this.getImagesManager().getImageDao().delete(img);
				}
			}
		}
	
	}
	
}

/**
 * 以管理员省份删除用户
 * @param ids
 * @return
 */
public MyJson deleteTopics_admin(String ids,HttpServletRequest request) {
	MyJson myJson=new MyJson();
	if(ids==null)
	{
		myJson.setSuccess(false);
		myJson.setMsg("删除失败!");
	} else{
			LinkedList<Integer> topicIds=new LinkedList<Integer>();
			for(String s:ids.split(","))
			{
				try{
					Integer i=new Integer(s);
					topicIds.add(i);
				} catch(Exception e){
					myJson.setSuccess(false);
					myJson.setMsg("删除失败!前台返回的主题id非法");
					return myJson;
				}
			} 			
				//myJson.setSuccess(true);
				for(Integer i:topicIds)
				{   Topic topic=this.getTopicDao().get(Topic.class, i);						     				        
				try{
				this.deleteTopicImage(topic, request);}
				catch(Exception e){
					throw new DataException("删除主题图片出错！");
				}
				this.getTopicDao().delete(topic);
					}
				myJson.setSuccess(true);
				myJson.setMsg("删除成功!");
				}
				//this.getTopicDao().getSession();

	     
	if(myJson.getSuccess()==false)
	{  logger.info("删除主题操作回滚"); 
		this.getTopicDao().getSessionFactory().getCurrentSession().getTransaction().rollback();
	}
	return myJson;
}
/**
 * 以用户身份删除主题
 * @param ids
 * @param user
 * @return
 */
public MyJson deleteTopics_user(String ids,User user,HttpServletRequest request) {
	MyJson myJson=new MyJson();
	if(ids==null)
	{
		myJson.setSuccess(false);
		myJson.setMsg("删除失败!");
	} else{
			LinkedList<Integer> topicIds=new LinkedList<Integer>();
			for(String s:ids.split(","))
			{
				try{
					Integer i=new Integer(s);
					topicIds.add(i);
				} catch(Exception e){
					myJson.setSuccess(false);
					myJson.setMsg("删除失败!前台返回的主题id非法");
					return myJson;
				}
			} 			
				//myJson.setSuccess(true);
				for(Integer i:topicIds)
				{   Topic topic=this.getTopicDao().get(Topic.class, i);						     				        
				
					{
						throw new DataException("您无权删除其它用户发表的主题!");
					}
					
				}
				myJson.setSuccess(true);
				myJson.setMsg("删除成功!");
				}
				//this.getTopicDao().getSession();

	     
	if(myJson.getSuccess()==false)
	{
		this.getTopicDao().getSessionFactory().getCurrentSession().getTransaction().rollback();
	}
	return myJson;
}
/**
 * 返回的是主题的一个简略目录，不包括主题的详细介绍,区别就是会返回一个分类下所有子分类的主题，同样的地址也是如此
 * @param request
 * @param response
 * @param id
 * @param name
 * @param user
 * @param type
 * @param thingSort
 * @param address
 * @param startTime
 * @param endTime
 * @param isPublishTime
 * @param isUpdateTime
 * @param page
 * @param oldLevel
 * @return
 */
public Pager<TopicForm> getTopics_catalog(HttpServletRequest request,
		HttpServletResponse response, Integer id, String name, String user,Integer userId, Byte type, Integer thingSort, Integer address,
		Date startTime, Date endTime, Boolean isPublishTime,
		Boolean isUpdateTime, Page page, Byte oldLevel) {
	
	Pager<TopicForm> topicFormsPager=new Pager<TopicForm>();
	ArrayList<TopicForm> topicForms;
	ArrayList<Topic> topicArrayList;
	
	if(page.getSort()!=null){
		page.setSort("tp."+page.getSort());
	}
	
	String hqlWhere="";
	Map<String,Object> params=new HashMap<String, Object>();
	//根据条件筛选内容
    if(userId!=null&&userId>=0){
    	hqlWhere=hqlWhere+"and tp.user.id=:userId ";
		params.put("userId", userId);
    } else
	if(StringUtils_wg.isStringUsed(user)){
		hqlWhere=hqlWhere+"and tp.user.name=:userName ";
		params.put("userName", user);
	}
	if(type!=null&&type!=0){
		hqlWhere=hqlWhere+"and tp.type="+type+" ";
		//params.put("userName", user);
	}
	if(thingSort!=null){
	
		}			 		
	return topicFormsPager;
}

public MyJson getTopicUserAuInfo(Integer id) {
	MyJson myJson=new MyJson();
	String Hql="select ua.isStudentUser from UserAuthentication ua where ua.user.id=(select tp.user.id from Topic tp where tp.id="+id+")";
	Session session=this.topicDao.getCurrentSession();
	Query query=session.createQuery(Hql);
	      Boolean isStudentUser=(Boolean) query.uniqueResult();
	      myJson.setSuccess(true);
	      myJson.setObject(isStudentUser);
	      myJson.setMsg("获取成功!");
	return myJson;
}
/**
 * 普通用户删除主题的一张图片
 * @param request
 * @param imageId
 * @param topicId
 */
public void deleteTopicImageUser(HttpServletRequest request, Integer imageId,
		Integer topicId) {

}
/**
 * 管理员用户删除主题的一张图片
 * @param request
 * @param imageId
 * @param topicId
 * @return
 */
public MyJson deleteTopicImageAdmin(HttpServletRequest request,
		Integer imageId, Integer topicId) {
	Admin admin=null;
	if(request.getSession().getAttribute("admin")==null)
		throw new DataException("请先登录!");
	admin=(Admin) request.getSession().getAttribute("admin");
	
	MyJson myJson=new MyJson();
	if(imageId==null||topicId==null)  
	throw  new DataException("数据非法！");
	String hql="delete TopicImage ti where ti.topic.id="+topicId+" and ti.image.id="+imageId;
	
	int change=this.getTopicImageManager().getTopicImageDao().executeHql(hql);
	if(change<1)
	{
		throw new DataException("删除错误,数据库中无此记录！");
	}
	//删除数据库中的关联记录之后，在本地删除相应的文件和图片数据库记录
   if(this.getImagesManager().imageUsedCount(imageId)<1)
   {
	this.getImagesManager().deleteImageAndFile(imageId, request);	   
   }
	myJson.setMsg("删除成功！");
	myJson.setSuccess(true);
	return myJson;
}

public MyJson isTopicExited(HttpServletRequest request, Integer topicId) {
	MyJson myJson=new MyJson();
	if(topicId==null)
		{
		  throw new DataException("主题编号非法！");
		}else {
	    if(this.getTopicDao().get(Topic.class, topicId)!=null){
	    	myJson.setSuccess(true);
	    }else{
	    	myJson.setSuccess(false);
	    }
	return  myJson;
		}
	
	
}




}
