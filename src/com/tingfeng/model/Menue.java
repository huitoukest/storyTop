package com.tingfeng.model;
// Generated 2015-2-11 21:18:51 by Hibernate Tools 4.0.0

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 方便以后的菜单权限管理
 */
@Entity
@Table(name = "menue")
public class Menue implements java.io.Serializable {
	/**
	 * id号码为-1的表示根菜单,即所有菜单;
	 * pid为-1的表示一级目录 
	 */
    private Long id;
	private String name;
	/**
	 * 1表示启用,0或者null表示禁用,默认启用
	 */
	private Integer status;
	/**
	 * 排序序号,越小,排在越前面
	 */
	private Integer sort;
	private String url;
	/**
	 * 是否在首页展示此目录,1表示展示,0或者null表示不展示,默认不展示
	 */
	private Integer isShow;
	

	public Menue() {
	}

	public Menue(String name, String url) {
		this.name = name;
		this.url = url;
	}
	@Id
	@GeneratedValue
	@Column(name = "id", unique = true, nullable = false)
	public Long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public Integer getStatus() {
		return status;
	}

	public Integer getSort() {
		return sort;
	}

	public String getUrl() {
		return url;
	}

	public Integer getIsShow() {
		return isShow;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}


}
