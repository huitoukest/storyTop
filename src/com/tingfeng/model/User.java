package com.tingfeng.model;
// Generated 2015-2-11 21:18:51 by Hibernate Tools 4.0.0

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;


@Entity
@Table(name = "user")
public class User implements java.io.Serializable {
	private static final long serialVersionUID = 1L;
	private Long id;
	private Integer age;
	private String email;
	private Date lastLoginTime;
	private String userName;
	private String password;
	private String phone;
	private String photo;
	private String qq;
	private Integer sex;
	private Date createTime;
	private Date updateTime;
	/**
	 * 当用户状态为2的时候表示锁定,用户只能够进行读取操作,不能够写如操作,比如发表,评分等
	 * 到当前时间大于锁定时间的时候,用户解除锁定
	 */
	private Date lockedTime;
	/**
	 * 当用户状态为3的时候表示不允许登录,
	 * 当此时间小于当前时间的时候,用户才可以登录;
	 */
	private Date notAllowLoginTime;
	/**
	 * 用户的状态保存在Constans常量中
	 */
	private Integer status=0;
	/**
	 * 书龄几年,暂时不用
	 */
	private Integer readTime;
	/**
	 *当前拥有的评分次数,最多7次;可以修改
	 */
	private Integer markTicketCount;
	/**
	 * 上次获得评分票的时间
	 */
	private Date lastGetTicketTime;
	/**
	 * 最近评论的的信息:包括评论的小说的id编号和评论的时间:毫秒数,用json字符串保存.一个json数组
	 */
	private String recentlyMarkInfo;
    /**
     * 用户推荐的小说的id,这里指的是用户推荐的数据库中没有的小说的id编号,设置为0或者null表示暂时没有推荐;
     * 设置为-1表示,推荐的小说已经被删除或者未通过,否则指向一个推荐的小说的id编号,
     */
	private Long recommendStoryId;
	/**
	 * 当前是否能够推荐小说,如果上一次推荐的小说还在审核中,那么就不能够推荐,否课可以推荐
	 */
	private boolean canRecommendStory;
	public User() {
	}
	
	public Integer getStatus() {
		return status;
	}
	
	public boolean getCanRecommendStory() {
		return canRecommendStory;
	}

	public void setCanRecommendStory(boolean canRecommendStory) {
		this.canRecommendStory = canRecommendStory;
	}

	@Id
	@GeneratedValue
	@Column(name = "id", unique = true, nullable = false)
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	@Column(name = "email")
	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "lastLoginTime", nullable = false, length = 19)
	public Date getLastLoginTime() {
		return this.lastLoginTime;
	}

	public void setLastLoginTime(Date lastLoginTime) {
		this.lastLoginTime = lastLoginTime;
	}

	@Column(name = "userName", nullable = false,unique = true, length = 50)
	public String getUserName() {
		return userName;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public Integer getReadTime() {
		return readTime;
	}

	public Integer getMarkTicketCount() {
		return markTicketCount;
	}

	public Date getLastGetTicketTime() {
		return lastGetTicketTime;
	}

	public String getRecentlyMarkInfo() {
		return recentlyMarkInfo;
	}

	public void setReadTime(Integer readTime) {
		this.readTime = readTime;
	}

	public void setMarkTicketCount(Integer markTicketCount) {
		this.markTicketCount = markTicketCount;
	}

	public void setLastGetTicketTime(Date lastGetTicketTime) {
		this.lastGetTicketTime = lastGetTicketTime;
	}
    
	public void setRecentlyMarkInfo(String recentlyMarkInfo) {
		this.recentlyMarkInfo = recentlyMarkInfo;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	@Column(name = "password", nullable = false, length = 50)
	public String getPassword() {
		return this.password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	@Column(name = "phone", length = 20)
	public String getPhone() {
		return this.phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	@Column(name = "photo")
	public String getPhoto() {
		return this.photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}

	@Column(name = "qq", length = 16)
	public String getQq() {
		return this.qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Date getLockedTime() {
		return lockedTime;
	}

	public Date getNotAllowLoginTime() {
		return notAllowLoginTime;
	}

	public void setLockedTime(Date lockedTime) {
		this.lockedTime = lockedTime;
	}

	public void setNotAllowLoginTime(Date notAllowLoginTime) {
		this.notAllowLoginTime = notAllowLoginTime;
	}

	public Long getRecommendStoryId() {
		return recommendStoryId;
	}

	public void setRecommendStoryId(Long recommendStoryId) {
		this.recommendStoryId = recommendStoryId;
	}

	public Integer getAge() {
		return age;
	}

	public Integer getSex() {
		return sex;
	}

	public void setAge(Integer age) {
		this.age = age;
	}

	public void setSex(Integer sex) {
		this.sex = sex;
	}		

}
