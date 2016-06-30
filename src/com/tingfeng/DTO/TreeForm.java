package com.tingfeng.DTO;

import java.util.ArrayList;
import java.util.Map;
/**
 * 
 * @author tingfeng
 * 用来往前台发送所有相关的tree数据
 */
public class TreeForm implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer id;
    private String text;
    /**
     * 值为closed或者open
     */
    private String state;
    private Boolean checked=false;
    private ArrayList<TreeForm> children;
    private Map<String, Object> attributes;
    
	public TreeForm() {
		super();
	}	

	public TreeForm(Integer id, String text, String state,
			Boolean checked, ArrayList<TreeForm> children,
			Map<String, Object> attributes) {
		super();
		this.id = id;
		this.text = text;
		this.state = state;
		this.checked = checked;
		this.children = children;
		this.attributes = attributes;
	}

	public Integer getId() {
		return id;
	}

	public String getText() {
		return text;
	}

	public String getState() {
		return state;
	}

	public ArrayList<TreeForm> getChildren() {
		return children;
	}

	public Map<String, Object> getAttributes() {
		return attributes;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public void setText(String text) {
		this.text = text;
	}

	public void setState(String state) {
		this.state = state;
	}

	public void setChildren(ArrayList<TreeForm> children) {
		this.children = children;
	}

	public void setAttributes(Map<String, Object> attributes) {
		this.attributes = attributes;
	}

	public Boolean getChecked() {
		return checked;
	}

	public void setChecked(Boolean checked) {
		this.checked = checked;
	}

}
