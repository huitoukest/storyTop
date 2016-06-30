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
 * 用户收藏的评论的关联表
 * @author tingfeng
 *
 */
@Entity
public class User_Collection_Topic {

	private Long id;
	private User user;
	private Topic topic;
	public User_Collection_Topic() {
		// TODO Auto-generated constructor stub
	}
	@Id
	@GeneratedValue
	@Column(name = "id", unique = true, nullable = false)
	public Long getId() {
		return id;
	}
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "topicId", nullable = false)
	public Topic getTopic() {
		return topic;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public void setTopic(Topic topic) {
		this.topic = topic;
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
