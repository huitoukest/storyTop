package com.tingfeng.DTO;

import java.util.ArrayList;
import java.util.List;

public class ThingSortShowForm {
/**
 * 二级物品分类的id
 */
	Integer id;
	/**
	 * 二级物品分类的名称
	 */
	String name;
	/**
	 * 二级物品分类下面的叶子分类
	 */
	List<ThingSortShowForm> childs;
	
	public ThingSortShowForm() {
		// TODO Auto-generated constructor stub
	}

	public Integer getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public List<ThingSortShowForm> getChilds() {
		return childs;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setChilds(List<ThingSortShowForm> childs) {
		this.childs = childs;
	}

}
