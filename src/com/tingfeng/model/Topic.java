package com.tingfeng.model;
// Generated 2015-2-11 21:18:51 by Hibernate Tools 4.0.0

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import static javax.persistence.GenerationType.IDENTITY;

import javax.persistence.Id;
import javax.persistence.Table;

/**
 *对小说的评论,暂时保留
 */
@Entity
@Table(name = "topic")
public class Topic implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1936324187410092609L;
	private Long id;
	private Date createTime;
	private Date updateTime;
	/**
	 * 评论内容
	 */
	private String content;
 
	private Story story;
	public Topic(Long id){
		this.id=id;
	}
	
	@Id
	@GeneratedValue
	@Column(name = "id", unique = true, nullable = false)
	public Long getId() {
		return id;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	@Column(length=2000)
	public String getContent() {
		return content;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "storyId", nullable = false)
	public Story getStory() {
		return story;
	}
	public void setStory(Story story) {
		this.story = story;
	}	
}
