package com.tingfeng.model;

import static javax.persistence.GenerationType.IDENTITY;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

/**
 * 用户收藏的小说的小说关联表
 * @author tingfeng
 *
 */
@Entity
public class User_Topic_Story {
	
	private Long id;
	private User user;
	private Story story;
	
	public User_Topic_Story(Long id) {
		this.id=id;
	}
	
	@Id
	@GeneratedValue
	@Column(name = "id", unique = true, nullable = false)
	public Long getId() {
		return id;
	}
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "storyId", nullable = false)
	public Story getStory() {
		return story;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public void setStory(Story story) {
		this.story = story;
	}
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "userId", nullable = false)
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}

}
