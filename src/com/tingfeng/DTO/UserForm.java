package com.tingfeng.DTO;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;


public class UserForm implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer id;
	private Byte age;
	private String email;
	private Date lastLoginTime;
	private String name;
	private String password;
	private String phone;
	private String photo;
	private String qq;
	private Byte sex;
	private Set<TopicForm> topics = new HashSet<TopicForm>(0);

	public UserForm() {
	}

	public UserForm(Date lastLoginTime, String name, String password) {
		this.lastLoginTime = lastLoginTime;
		this.name = name;
		this.password = password;
	}

	public UserForm(Byte age, String email, Date lastLoginTime, String name,
			String password, String phone, String photo, String qq, Byte sex,
			Set<TopicForm> topics) {
		this.age = age;
		this.email = email;
		this.lastLoginTime = lastLoginTime;
		this.name = name;
		this.password = password;
		this.phone = phone;
		this.photo = photo;
		this.qq = qq;
		this.sex = sex;
		this.topics = topics;
	}


	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Byte getAge() {
		return this.age;
	}

	public void setAge(Byte age) {
		this.age = age;
	}


	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}


	public Date getLastLoginTime() {
		return this.lastLoginTime;
	}

	public void setLastLoginTime(Date lastLoginTime) {
		this.lastLoginTime = lastLoginTime;
	}


	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}


	public String getPassword() {
		return this.password;
	}

	public void setPassword(String password) {
		this.password = password;
	}


	public String getPhone() {
		return this.phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}


	public String getPhoto() {
		return this.photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}


	public String getQq() {
		return this.qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
	}


	public Byte getSex() {
		return this.sex;
	}

	public void setSex(Byte sex) {
		this.sex = sex;
	}

	public Set<TopicForm> getTopics() {
		return this.topics;
	}

	public void setTopics(Set<TopicForm> topics) {
		this.topics = topics;
	}

}
