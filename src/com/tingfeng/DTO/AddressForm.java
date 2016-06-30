package com.tingfeng.DTO;


public class AddressForm implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer id;
	private AddressForm address;
	private String name;


	public AddressForm() {
	}

	public AddressForm(String name) {
		this.name = name;
	}

	public Integer getId() {
		return id;
	}

	public AddressForm getAddress() {
		return address;
	}

	public String getName() {
		return name;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public void setAddress(AddressForm address) {
		this.address = address;
	}

	public void setName(String name) {
		this.name = name;
	}


}
