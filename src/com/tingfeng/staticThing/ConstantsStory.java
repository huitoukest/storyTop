package com.tingfeng.staticThing;

public class ConstantsStory {
    
	public static final int story_status_normal=0;
	public static final int story_status_delete=1;	
	/**
	 * 用户推荐的小说,需要等待管理员检查,检查正常表示normal,
	 * 检查失败直接删除,不会对用户做回复,暂时这么解决
	 */
	public static final int story_status_needCkeck=2;
   /**
    * 需要纠正小说信息的小说
    */
	public static final int story_status_needCorrect=3;
	/**
	 * 1千字以内
	 */
	public static final int story_wordCount_oK_to_1K=1;
	
	public static final int story_wordCount_1K_to_10K=2;
	/**
	 * 1万字到10万字
	 */
	public static final int story_wordCount_1W_to_10W=3;
	
	public static final int story_wordCount_10W_to_50W=4;
	
	public static final int story_wordCount_50W_to_200W=5;
	
	public static final int story_wordCount_200W_to_500W=6;
	/**
	 * 字数超过500W
	 */
	public static final int story_wordCount_more_than_500W=7;
	/**
	 * 未知,更新,未完结的小说
	 */
	public static final int story_wordCount_unkonw=8;

	/**
	 * 小说已经完结
	 */
	public static final int story_updateState_finish=1;
	/**
	 * 小说更新中
	 */
	public static final int story_updateState_update=2;
	/**
	 * 暂停更新或者太监的小说
	 */
	public static final int story_updateState_other=3;
	/**
	 * 百度百科,搜狗百科,好搜百科三种;
	 */
	public static final String[] story_baike_urls={"http://baike.sogou.com","http://baike.baidu.com","http://baike.haosou.com"};
	/**
	 * 判断一个url连接是否是以百科为起始字符串
	 */
	public static boolean isUrlStartWithBaike(String url){
		boolean ok=false;
		for(String ss:story_baike_urls){
			if(url.startsWith(ss))
				{
				   ok=true;
				   break;
				}
		}
	 return ok;
	}
}
