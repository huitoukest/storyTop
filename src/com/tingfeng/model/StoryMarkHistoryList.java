package com.tingfeng.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 小说评分,历史更新小说榜单100名;
 * @author tingfeng
 * 
 */
@Entity
public class StoryMarkHistoryList {
    public Long id;
    /**
     * 一个ArrayList<BaseStory>的json字符前100名,每月1日缓存一次;缓存的类是BaseStory,
     */
    public String content;
	public StoryMarkHistoryList() {
		// TODO Auto-generated constructor stub
	}
	@Id
	@GeneratedValue
	@Column(name = "id", unique = true, nullable = false)
	public Long getId() {
		return id;
	}
	@Column(columnDefinition="mediumtext")
	public String getContent() {
		return content;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public void setContent(String content) {
		this.content = content;
	}

}
