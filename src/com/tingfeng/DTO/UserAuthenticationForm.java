package com.tingfeng.DTO;

import static javax.persistence.GenerationType.IDENTITY;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import com.tingfeng.model.User;
/**
 * 
 * @author tingfeng
 * 用户认证表
 */
@Entity
@Table(name = "userAuthentication", catalog = "school_eaby")
public class UserAuthenticationForm implements java.io.Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer id;
	/**
	 * 用户认证表的主键依赖于用户表的主键
	 */
	private User user;
	/**
	 * 此属性保存的是用户认证为学生用户的认证图片,保存在images下的userAuthentication目录
	 */
	private String imageUrl;
	/**
	 * 此用户是否需要认证,如果需要,则后台审核,可以当作用户是否申请认证的属性
	 */
	private Boolean isNeedAuthentication=false;
	/**
	 * 在后台审核过后,确认是否是学生用户
	 */
	private Boolean isStudentUser;
	/**
	 * 最近审核时间,防止一个用户段时间内多次审核,规定每7天可以审核一次
	 * 有空可以同时规定每两年必须审核一次
	 */
	private Date lastAuthenticationTime;
	/**
	 * 审核消息,或者别的消息,比如审核失败的原因等等;
	 */
	private String msg;
	
	public UserAuthenticationForm() {
		// TODO Auto-generated constructor stub
	}

	public UserAuthenticationForm(User user, String imageUrl,
			Boolean isNeedAuthentication, Boolean isStudentUser,
			Date lastAuthenticationTime, String msg) {
		super();
		this.user = user;
		this.imageUrl = imageUrl;
		this.isNeedAuthentication = isNeedAuthentication;
		this.isStudentUser = isStudentUser;
		this.lastAuthenticationTime = lastAuthenticationTime;
		this.msg = msg;
	}
	
	
	
	public UserAuthenticationForm(Integer id, User user, String imageUrl,
			Boolean isNeedAuthentication, Boolean isStudentUser,
			Date lastAuthenticationTime, String msg) {
		super();
		this.id = id;
		this.user = user;
		this.imageUrl = imageUrl;
		this.isNeedAuthentication = isNeedAuthentication;
		this.isStudentUser = isStudentUser;
		this.lastAuthenticationTime = lastAuthenticationTime;
		this.msg = msg;
	}

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="userId", unique = true, nullable = false)
	public User getUser() {
		return user;
	}
	
	@Column(length = 255,unique = true)
	public String getImageUrl() {
		return imageUrl;
	}

	public Boolean getIsNeedAuthentication() {
		return isNeedAuthentication;
	}

	public Boolean getIsStudentUser() {
		return isStudentUser;
	}

	public Date getLastAuthenticationTime() {
		return lastAuthenticationTime;
	}
	@Column(length = 255)
	public String getMsg() {
		return msg;
	}

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "id", unique = true, nullable = false)
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public void setUser(User user) {
		this.user= user;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public void setIsNeedAuthentication(Boolean isNeedAuthentication) {
		this.isNeedAuthentication = isNeedAuthentication;
	}

	public void setIsStudentUser(Boolean isStudentUser) {
		this.isStudentUser = isStudentUser;
	}

	public void setLastAuthenticationTime(Date lastAuthenticationTime) {
		this.lastAuthenticationTime = lastAuthenticationTime;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

}
