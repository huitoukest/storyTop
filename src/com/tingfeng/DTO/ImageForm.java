package com.tingfeng.DTO;

import java.util.HashSet;
import java.util.Set;


public class ImageForm implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer id;
	private String imageUrl;
	private String name;
	private Set<TopicImageForm> topicImages = new HashSet<TopicImageForm>(0);

	public ImageForm() {
	}

	public ImageForm(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public ImageForm(String imageUrl, String name, Set<TopicImageForm> topicImages) {
		this.imageUrl = imageUrl;
		this.name = name;
		this.topicImages = topicImages;
	}


	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}


	public String getImageUrl() {
		return this.imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}


	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}


	public Set<TopicImageForm> getTopicImages() {
		return this.topicImages;
	}

	public void setTopicImages(Set<TopicImageForm> topicImages) {
		this.topicImages = topicImages;
	}

}
