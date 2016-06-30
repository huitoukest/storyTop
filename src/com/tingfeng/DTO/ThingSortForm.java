package com.tingfeng.DTO;

import java.util.HashSet;
import java.util.Set;

public class ThingSortForm implements java.io.Serializable {

	private static final long serialVersionUID = 1L;
	private Integer id;
	private ThingSortForm thingSort;
	private String name;
	private Set<ThingSortForm> thingSorts = new HashSet<ThingSortForm>(0);

	public ThingSortForm() {
		super();
	}

	public ThingSortForm(Integer id, ThingSortForm thingSort, String name,
			Set<ThingSortForm> thingSorts) {
		super();
		this.id = id;
		this.thingSort = thingSort;
		this.name = name;
		this.thingSorts = thingSorts;
	}

	public Integer getId() {
		return id;
	}

	public ThingSortForm getThingSort() {
		return thingSort;
	}

	public String getName() {
		return name;
	}

	public Set<ThingSortForm> getThingSorts() {
		return thingSorts;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public void setThingSort(ThingSortForm thingSort) {
		this.thingSort = thingSort;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setThingSorts(Set<ThingSortForm> thingSorts) {
		this.thingSorts = thingSorts;
	}	


}
