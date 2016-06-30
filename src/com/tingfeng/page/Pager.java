package com.tingfeng.page;

import java.util.ArrayList;

import org.springframework.beans.BeanUtils;

/**
 * 
 * @author tingfeng
 * 后台用来装载数据之后往前台发送用的包装类
 * @param <T>
 * 
 */
public class Pager<T>{
	/**
	 * 一个ArrayList的行数据集合
	 */
private ArrayList<T> rows=new ArrayList<T>(0);
/**
 * 当前总的记录数量,指的是数据库中一共有多少条数据
 */
private Long total=0L;
	/**
	 * 
	 * @param rows 一个ArrayList的行数据集合
	 * @param total 当前总的记录数量,指的是数据库中一共有多少条数据
	 */
	public Pager(ArrayList<T> rows,Long total) {
		this.rows=rows;
		this.total=total;
		// TODO Auto-generated constructor stub
	}
	public Pager() {
		// TODO Auto-generated constructor stub
	}
	public ArrayList<T> getRows() {
		return rows;
	}
	public Long getTotal() {
		return total;
	}
	public void setRows(ArrayList<T> rows) {
		this.rows = rows;
	}
	public void setTotal(Long total) {
		this.total = total;
	}
	/**
	 * 将自己的内容复制一份出来,这样来防止json序列化的时候,
	 * 将不必要的数据库内容被拷贝了出来
	 * @return
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
    public Pager<T> copyMySelf(Class<T> cls) throws InstantiationException, IllegalAccessException{
    	ArrayList<T> rr=new ArrayList<T>();
    	for(T t:rows){
    		T tt=cls.newInstance();
    		BeanUtils.copyProperties(t,tt);
    		rr.add(tt);
    	}
    	Pager<T> p=new Pager<T>(rr,this.total);
    	return p;
    }
}
