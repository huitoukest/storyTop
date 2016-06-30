package com.tingfeng.DTO;

import java.util.ArrayList;

public class AddressCategoryForm {
    private AddressForm address;
    private ArrayList<AddressCategoryForm> addressCategory;
	
	public AddressCategoryForm() {
		// TODO Auto-generated constructor stub
	}

	public AddressForm getAddress() {
		return address;
	}

	public ArrayList<AddressCategoryForm> getAddressCategory() {
		return addressCategory;
	}

	public void setAddress(AddressForm address) {
		this.address = address;
	}

	public void setAddressCategory(ArrayList<AddressCategoryForm> addressCategory) {
		this.addressCategory = addressCategory;
	}

}
