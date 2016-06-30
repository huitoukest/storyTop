package com.tingfeng.DTO;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import antlr.collections.List;

import com.tingfeng.model.Image;
import com.tingfeng.model.TopicImage;


public class TopicForm implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer id;
	private AddressForm address;
	private TopicImageForm topicImage;
	private ThingSortForm thingSort;
	private UserForm user;
	private String name;
	private byte type;
	private Date updateTime;
	private Date publishTime;
	private String describe;
	private Byte oldLevel;//成色,10表示全新,9表示9新以上,8表示8新以上,7表示7新以上,6表示7新以下
	private Integer price;//价格0~100000000之间,1~1亿
	private Byte buyWay;//交易方式,1是面交,2是远程交易,3是可商议
	//一个主题的图片url的列表
	private ArrayList<String> images;
    private ArrayList<Integer> imageIds;
    private String phone;
	public TopicForm() {
	}

	public TopicForm(Integer id, AddressForm address,
			TopicImageForm topicImage, ThingSortForm thingSort, UserForm user,
			String name, byte type, Date updateTime, Date publishTime,
			String describe, Byte oldLevel, Integer price, Byte buyWay) {
		super();
		this.id = id;
		this.address = address;
		this.topicImage = topicImage;
		this.thingSort = thingSort;
		this.user = user;
		this.name = name;
		this.type = type;
		this.updateTime = updateTime;
		this.publishTime = publishTime;
		this.describe = describe;
		this.oldLevel = oldLevel;
		this.price = price;
		this.buyWay = buyWay;
	}

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}


	public AddressForm getAddress() {
		return this.address;
	}

	public void setAddress(AddressForm address) {
		this.address = address;
	}

	public TopicImageForm getTopicImage() {
		return this.topicImage;
	}

	public void setTopicImage(TopicImageForm topicImage) {
		this.topicImage = topicImage;
	}


	public ThingSortForm getThingSort() {
		return this.thingSort;
	}

	public void setThingSort(ThingSortForm thingSort) {
		this.thingSort = thingSort;
	}


	public UserForm getUser() {
		return this.user;
	}

	public void setUser(UserForm user) {
		this.user = user;
	}


	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}


	public byte getType() {
		return this.type;
	}

	public void setType(byte type) {
		this.type = type;
	}


	public Date getPublishTime() {
		return this.publishTime;
	}

	public void setPublishTime(Date publishTime) {
		this.publishTime = publishTime;
	}


	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public Byte getOldLevel() {
		return oldLevel;
	}

	public Integer getPrice() {
		return price;
	}

	public Byte getBuyWay() {
		return buyWay;
	}

	public void setOldLevel(Byte oldLevel) {
		this.oldLevel = oldLevel;
	}

	public void setPrice(Integer price) {
		this.price = price;
	}

	public void setBuyWay(Byte buyWay) {
		this.buyWay = buyWay;
	}

	public String getDescribe() {
		return this.describe;
	}

	public void setDescribe(String describe) {
		this.describe = describe;
	}

	public ArrayList<String> getImages() {
		return images;
	}

	public void setImages(ArrayList<String> images) {
		this.images = images;
	}

	public ArrayList<Integer> getImageIds() {
		return imageIds;
	}

	public void setImageIds(ArrayList<Integer> imageIds) {
		this.imageIds = imageIds;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

}
