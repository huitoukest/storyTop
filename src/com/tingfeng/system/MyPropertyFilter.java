package com.tingfeng.system;

import com.alibaba.fastjson.serializer.PropertyFilter;
/**
 * 
 * @author tingfeng
 * 过滤指定类 的指定字段 的指定值,若没有指定,则通过,如需要过滤更多可以多新建一个过滤器
 * 过滤值存在bug,所以暂时只能够过滤类以及其属性
 */
public class MyPropertyFilter implements PropertyFilter {
	/**
	 * 需要过滤的属性,若不指定,保留所有属性
	 */
	private String withoutProperty;
	/**
	 * 需要过滤的属性,若不指定,保留所有属性
	 */
	private String[] withoutProperties;
	/**
	 * 需要过滤的类,若不指定,保留所有值
	 */
	private Class className;
	/**
	 * 需要过滤的值,若不指定,保留所有值
	 */
	private Object withoutValue;

	public MyPropertyFilter() {
		// TODO Auto-generated constructor stub
	}

	public MyPropertyFilter(String withoutProperty) {
		this.withoutProperty = withoutProperty;
	}
	
	public MyPropertyFilter(Class className) {
		this.className = className;
	}

	public MyPropertyFilter(String[] withoutProperties) {
		this.withoutProperties = withoutProperties;
	}
	
public MyPropertyFilter(Class className,String withoutProperty,
			 Object withoutValue) {
		this.withoutProperty = withoutProperty;
		this.className = className;
		this.withoutValue = withoutValue;
	}

public MyPropertyFilter(Class className,String withoutProperty) {
	this.withoutProperty = withoutProperty;
	this.className = className;
}

public MyPropertyFilter(Class className,String[] withoutProperties) {
	this.withoutProperties = withoutProperties;
	this.className = className;

}

public MyPropertyFilter(Class className,String[] withoutProperties,
		Object withoutValue) {
	this.withoutProperties = withoutProperties;
	this.className = className;
	this.withoutValue = withoutValue;
}

/**
 * return false 剔除此字段
 */
	@Override
	public boolean apply(Object source, String name, Object value) {
		Boolean s=compareToClass(source);
		Boolean n=compareToProperty(name);
		Boolean v=compareToValue(value);
		//过滤条件有严格的先后顺序
		if(s==null&&n==null&&v==null)
		return true;
		if(s!=null&&n!=null&&v!=null)
			return (s||v||n);
		if(s==null&&n!=null&&v!=null)
			return (n||v);
		if(s!=null&&n==null&&v!=null)
			return (s||v);
		if(s!=null&&n!=null&&v==null)
			return (s||n);
		if(s==null&&n==null&&v!=null)
			return v;
		if(s==null&&v==null&&n!=null)
			return n;
		if(s!=null&&v==null&&v==null)
			return s;		
		return true;
	}

	private Boolean compareToClass(Object source){
		if(className==null)
			return null;
		if(source.getClass().equals(className))
		return false;
		return true;
	}
	private Boolean compareToProperty(String name){
		if(withoutProperty==null&&(withoutProperties == null || withoutProperties.length==0))
			return null;
		
		if (withoutProperty!=null&&withoutProperty.equals(name)) 
		return false;		
        
		if(withoutProperties != null &&withoutProperties.length>=0)
			for (String string : withoutProperties) {
				if (string != null && string.equals(name)) {
					return false;
				}
			}
		
			return true;
	}
	
	private Boolean compareToValue(Object value){
		if(withoutValue==null) return null;
		if(withoutValue.equals(value))
			return false;
			return true;
	}
	
	
	public String getWithoutProperty() {
		return withoutProperty;
	}

	public String[] getWithoutProperties() {
		return withoutProperties;
	}

	public void setWithoutProperty(String withoutProperty) {
		this.withoutProperty = withoutProperty;
	}

	public void setWithoutProperties(String[] withoutProperties) {
		this.withoutProperties = withoutProperties;
	}

	public Class getClassName() {
		return className;
	}

	public Object getWithoutValue() {
		return withoutValue;
	}

	public void setClassName(Class className) {
		this.className = className;
	}

	public void setWithoutValue(Object withoutValue) {
		this.withoutValue = withoutValue;
	}

}
