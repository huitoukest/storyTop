package com.tingfeng.DTO;

import java.util.HashSet;
import java.util.Set;

public class CategoryForm implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer id;
	private CategoryForm category;
	private Boolean isValible;
	private String name;
	private Integer orders;
	private String url;
	private Set<CategoryForm> categories = new HashSet<CategoryForm>(0);

	public CategoryForm() {
	}

	public CategoryForm(String name, String url) {
		this.name = name;
		this.url = url;
	}

	public CategoryForm(CategoryForm category, Boolean isValible, String name,
			Integer orders, String url, Set<CategoryForm> categories) {
		this.category = category;
		this.isValible = isValible;
		this.name = name;
		this.orders = orders;
		this.url = url;
		this.categories = categories;
	}


	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}


	public CategoryForm getCategory() {
		return this.category;
	}

	public void setCategory(CategoryForm category) {
		this.category = category;
	}


	public Boolean getIsValible() {
		return this.isValible;
	}

	public void setIsValible(Boolean isValible) {
		this.isValible = isValible;
	}

	
	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}


	public Integer getOrders() {
		return this.orders;
	}

	public void setOrders(Integer orders) {
		this.orders = orders;
	}


	public String getUrl() {
		return this.url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	
	public Set<CategoryForm> getCategories() {
		return this.categories;
	}

	public void setCategories(Set<CategoryForm> categories) {
		this.categories = categories;
	}

}
