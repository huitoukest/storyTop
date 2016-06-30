package com.tingfeng.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 
 * @author tingfeng
 * 网站公告
 */
@Entity
public class Affiche {
	/**
	 * 此公告是否被使用
	 */
	private Integer id;
	private Boolean isUsing;
    private String affiche;
    private Date publishTime;
	public Affiche() {
		// TODO Auto-generated constructor stub
	}
	@Id
	@GeneratedValue
	@Column(name = "id", unique = true, nullable = false)
	public Integer getId() {
		return id;
	}
	public Boolean getIsUsing() {
		return isUsing;
	}
	
	@Column(length=500)
	public String getAffiche() {
		return affiche;
	}
	public Date getPublishTime() {
		return publishTime;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public void setIsUsing(Boolean isUsing) {
		this.isUsing = isUsing;
	}
	public void setAffiche(String affiche) {
		this.affiche = affiche;
	}
	public void setPublishTime(Date publishTime) {
		this.publishTime = publishTime;
	}


}
