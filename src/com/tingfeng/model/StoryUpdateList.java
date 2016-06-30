// default package
// Generated 2014-10-10 11:04:57 by Hibernate Tools 3.4.0.CR1
package com.tingfeng.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * 小说更新中的榜单的缓存表
 */
@Entity
@Table(name = "storyUpdateList")
public class StoryUpdateList extends BaseStory implements java.io.Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 2886812425473071282L;

	
	public StoryUpdateList(Long id) {
		super.setId(id);
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	@ManyToOne
	@JoinColumn(name="storyTypeId",nullable = false)
	public StoryType getStoryType() {
		return storyType;
	}

	public void setStoryType(StoryType storyType) {
		this.storyType = storyType;
	}

	@Id
	@GeneratedValue
	@Column(name = "id", unique = true, nullable = false)
	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Column(name = "name", nullable = false,length=50)
	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(name = "author",nullable = false,length=50)
	public String getAuthor() {
		return this.author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public Integer getUpdateState() {
		return updateState;
	}

	public Date getEndTime() {
		return endTime;
	}

	public Integer getWordCount(){
		if(updateState==null||updateState==2||updateState==3)
			wordCount=8;
		return this.wordCount;
	}
	
	public void setWordCount(Integer wordCount) {
		if(updateState==null||updateState==2||updateState==3)
			wordCount=8;
		this.wordCount = wordCount;
	}

	public void setUpdateState(Integer updateState) {
		this.updateState = updateState;
	}
	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	@Column(name = "image",length=255)
	public String getImage() {
		return this.image;
	}

	public void setImage(String image) {
		this.image = image;
	}
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "publishedTime", nullable = false, length = 19)
	public Date getPublishedTime() {
		return publishedTime;
	}

	public void setPublishedTime(Date publishedTime) {
		this.publishedTime = publishedTime;
	}
	public Long getScore() {
		return score;
	}
	public Long getMarkCount() {
		return markCount;
	}
	public String getStoryBaikeUrl() {
		return storyBaikeUrl;
	}
	public void setScore(Long score) {
		this.score = score;
	}
	public void setMarkCount(Long markCount) {
		this.markCount = markCount;
	}
	public void setStoryBaikeUrl(String storyBaikeUrl) {
		this.storyBaikeUrl = storyBaikeUrl;
	}
	@Override
	public int hashCode() {
		return this.getId().intValue();
	}
	@Override
	public boolean equals(Object obj) {
		if(obj instanceof BaseStory)
		{   BaseStory o=((BaseStory)obj);
			
			if(o.getId()-this.getId()==0)
				return true;
			if(o.getAuthor().equals(this.getAuthor())&&o.getName().equals(this.getName()))
				return true;
		}
		return false;
	}
}
