package com.tingfeng.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tingfeng.manager.StoryManager;
import com.tingfeng.manager.StoryTypeManager;
import com.tingfeng.manager.UserManager;
import com.tingfeng.model.Story;
import com.tingfeng.model.StoryType;
import com.tingfeng.model.User;
import com.tingfeng.page.Page;
import com.tingfeng.page.Pager;
import com.tingfeng.staticThing.ConstantsStory;
import com.tingfeng.system.MyJson;
import com.tingfeng.utils.SpringUtils;
import com.tingfeng.utils.StringUtils_wg;
/**
 * 实时小说,用户可以查看单个小说,但是小说列表只能够是缓存中的小说
 * @author tingfeng
 *
 */
@Controller
public class StoryAction {

@Autowired
private UserManager userManager;
@Autowired
private StoryManager storyManager;
@Autowired
private StoryTypeManager storyTypeManager;

public StoryAction() {	}
/**
 * @return 单个小说的展示页面,即详细信息
 */
@RequestMapping("storyInfoJsp.do")
	public String storyInfoJsp()
    { 
	 return "story/storyInfo";
	}

/**
 * @return 小说列表展示页面
 */
@RequestMapping("storyInfosJsp")
public String storyInfosJsp()
{		
	return "story/storyInfos";
   
}
@RequestMapping("/admin/storyManage.do")
public String storyManage(HttpServletRequest request){
	List<StoryType> common_storyTypes=storyTypeManager.getAllStoryType();
	request.setAttribute("common_storyTypes", common_storyTypes);
	return "admin/storyManage.jsp";
}



	@RequestMapping("/user/recommendStory.do")
    public String getRecommendStory(HttpServletRequest request){
		User user=userManager.getLoginUser(request);
		request.setAttribute("userRecommendStoryId",user.getRecommendStoryId());
		request.setAttribute("userCanRecommendStory",user.getCanRecommendStory());
		return "/user/recommendStory.jsp";
    }
	
	@RequestMapping("/admin/getStorys.json")
	public void getAdminAllStorys(HttpServletResponse response,Long id,String name,String author,Long typeId,Integer wordCount,Boolean publishedTime,Boolean endTime,
		Integer updateState,Integer needCorrect,Page page,Date condition_startTime,Date condition_endTime,HttpServletRequest request) throws IOException{
		Pager<Story> pager=storyManager.getAllStorys(id,name,author,typeId,wordCount,publishedTime,endTime,updateState,needCorrect,page,condition_startTime,condition_endTime);
        SpringUtils.sendText(response, pager);
	}
	
    /**
     * 用户向系统推荐小说
     * @param response
     * @param request
     * @param vcode
     * @param story
     * @throws IOException 
     */
	@RequestMapping("/user/recommendStory.json")
	public void recommendStory(HttpServletResponse response,HttpServletRequest request,String vcode,Story story) throws IOException{
		if(story!=null)
			story.setStatus(ConstantsStory.story_status_needCkeck);
		User user=userManager.getLoginUser(request);
		if(user.getCanRecommendStory()==false){
			 MyJson.sendToError(response,"请等待管理员审核上部小说,审核之后再推荐!");
			return;
		}
	    Long storyId=storyManager.saveStory(story);	 
		 user.setRecommendStoryId(storyId);
		 user.setCanRecommendStory(false);
		 userManager.updateUser(user);
		 MyJson.sendToSuccess(response,null, "推荐成功,等待管理员审核!");
	}	 

/**
 * 根据小说的Id号码来得到此小说的json数据
 * @param storyId
 * @param request
 * @param response
 * @throws IOException 
 */
@RequestMapping("getStoryInfo.do")
public void getStory(Long storyId,HttpServletRequest request,
		HttpServletResponse response) throws IOException{
	if(storyId==null)
	{
	SpringUtils.sendText(response, "error1");
	return;
	} 
	Story story=this.storyManager.storyDao.get(Story.class, storyId);
	if(story==null)
	{
	SpringUtils.sendText(response, "error2");
	return;
	}
	
	//SpringUtils.sendToJson(response, storyForm);	
}

/**
 * 
 * @return 小说修改的页面
 */
@RequestMapping("storyUpdateJsp")
public String storyUpdateJsp()
{		
	return "story/storyUpdate";  
}
/**
 * 更新小说的信息
 * @param story
 * @param storyType
 * @param request
 * @param response
 */
@RequestMapping("updateStory.do")
public void updateStory(Story story, String storyType,
		HttpServletRequest request, HttpServletResponse response){
	String Msg = validateStory(story, storyType);
	Boolean ok = true;
	String[] storyTypes = null;
	if(StringUtils_wg.isStringUsed(storyType))
	{
		storyTypes=storyType.split(",");	
	}	
	if(Msg!=null)
		ok=false;
	else if(story.getId()<=0)
	{
		ok=false;
		Msg="数据库中没有此小说!";
	}
	MyJson myJson=new MyJson(ok,Msg);
	try {
		/**
		 * 如果数据验证没有问题
		 */
		if (ok) {
			//System.out.println(story.getContent());
			//Set<Story_StoryType> story_StoryTypes=new HashSet<Story_StoryType>();
			this.getStoryManager().storyDao.update(story);;//先更新story对象才行	
			
			//查询当前小说的类型
			boolean needUpdateStoryTypes=false;
			ArrayList<StoryType> storyTypesOld = null;
			//=this.storyManager.getStoryTypesByStoryId(story.getId());
			//判断是否需要更新小说的类型
			if(storyTypesOld.size()==storyTypes.length){
			for(int i=0;i<storyTypes.length;i++)
			{   boolean isneed=true;
				for(int j=0;j<storyTypesOld.size();j++)
				{
					if(storyTypes[i].equals(""+storyTypesOld.get(j).getId()))
					{//如果当前种类已经存在于数据库中
						isneed=false;
					}
				}
				if(isneed)
				{
					needUpdateStoryTypes=true;
					break;
				}
			} } else {
				needUpdateStoryTypes=true;
			}
			
			if(needUpdateStoryTypes){
			
			myJson.setSuccess(true);
			myJson.setMsg("id="+story.getId());
			myJson.sendToClient(response);
		} else {
			myJson.sendToClient(response);
			//SpringUtils.sendText(response, Msg);
		}
	} }catch (IOException e) {
		// TODO Auto-generated catch block
		try {
			SpringUtils.sendText(response, "向数据库存储的时候发生异常,请稍后再试!");
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		e.printStackTrace();
	}
}

/**
 * isDetail为false则只发送id/name/author/更新状态四个信息
 * @param storyTypes 小说类型
 * @param storyName 小说名称
 * @param page 记录分页
 * @param isDetail 是否发送详细信息,true表示发送小说全部信息
 * @param request
 * @param response
 */
@RequestMapping("getStorysInfo.do")
public void getStorysByType(String storyTypes,String storyName,Page page,Boolean isDetail,HttpServletRequest request,
		HttpServletResponse response)
{
	}


	public StoryManager getStoryManager() {
		return storyManager;
	}

	public void setStoryManager(StoryManager storyManager) {
		this.storyManager = storyManager;
	}

//验证成功返回null,不成功返回相应的信息
public String validateStory(Story story, String storyType){
	String Msg = "";
	Boolean ok = true;
	String[] storyTypes = null;
	if (story == null || story.getName() == null) {
		Msg = "服务器没有收到您提交的小说信息,请稍后再试!";
		ok = false;
	}else if(!StringUtils_wg.isStringUsed(storyType))
	{
		Msg="请选择小说的类别,最多3个类别!";
		ok=false;
	} else if(StringUtils_wg.isStringUsed(storyType))
	{
		storyTypes=storyType.split(",");
		if(storyTypes==null||storyTypes.length<1)
		{
			Msg="请选择小说的类别,最多3个类别!";
			ok=false;
		}
	}
	 if (ok&&!StringUtils_wg.isStringUsed(story.getAuthor())
			|| story.getUpdateState() == null || story.getUpdateState() < 1||story.getUpdateState()>4
			|| story.getWordCount() == null || story.getWordCount() < 1) {
		Msg = "您还没有输入完整有效的作者/简介/更新状态/字数信息!";
		ok = false;
	} else if(ok&&story.getPublishedTime()==null||story.getPublishedTime().getTime()>System.currentTimeMillis()) 
	{
		Msg = "出版时间非法!";
		ok = false;
	}
	else {
		StringBuffer stringBuffer = new StringBuffer();
		if (story.getName().length() > 50) {
			stringBuffer.append("小说的名字太长了<br>");
			ok = false;
		} else if (story.getName().length() < 1) {
			stringBuffer.append("小说的名字太短了<br>");
			ok = false;
		}
		if (!StringUtils_wg.isStringUsed(story.getAuthor())) {
			stringBuffer.append("请输入作者名称<br>");
			ok = false;
		}
		if (story.getWordCount() < 1) {
			stringBuffer.append("请输入小说作品的字数<br>");
			ok = false;
		} else if (story.getWordCount() > 8) {
			stringBuffer.append("小说作品的字数非法<br>");
			ok = false;
		}
		if (ok && story.getAuthor().length() > 50) {
			stringBuffer.append("作者的名字太长了<br>");
			ok = false;
		} else if (ok && story.getAuthor().length() < 1) {
			stringBuffer.append("作者的名字太短了<br>");
			ok = false;
		}
        Msg=stringBuffer.toString();
	}
	 if(!ok) return Msg;
	 return null;
}
}
