package com.tingfeng.DTO;

import java.util.HashSet;
import java.util.Set;


public class TopicImageForm implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer id;
	private TopicForm topic;
	private ImageForm image;
	private Set<TopicForm> topics = new HashSet<TopicForm>(0);

	public TopicImageForm() {
	}

	public TopicImageForm(TopicForm topic, ImageForm image) {
		this.topic = topic;
		this.image = image;
	}

	public TopicImageForm(TopicForm topic, ImageForm image, Set<TopicForm> topics) {
		this.topic = topic;
		this.image = image;
		this.topics = topics;
	}


	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}


	public TopicForm getTopic() {
		return this.topic;
	}

	public void setTopic(TopicForm topic) {
		this.topic = topic;
	}


	public ImageForm getImage() {
		return this.image;
	}

	public void setImage(ImageForm image) {
		this.image = image;
	}


	public Set<TopicForm> getTopics() {
		return this.topics;
	}

	public void setTopics(Set<TopicForm> topics) {
		this.topics = topics;
	}

}
