package com.tingfeng.DAOI;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import com.tingfeng.page.Page;
import com.tingfeng.page.Pager;

public interface BaseDaoI<T> {

	public Serializable save(T o);

	public void delete(T o);
	public void deleteByColumns(String tableName,String columnName,String columnValues);
	public void deleteByColumns(String tableName,String columnName,List<?> columnValues);
	
	public void update(T o);

	public void saveOrUpdate(T o);

	public T get(Class<T> c, Serializable id);

	public T get(String hql);

	public T get(String hql, Map<String, Object> params);

	public List<T> find(String hql);

	public List<T> find(String hql, Map<String, Object> params);

	public List<T> find(String hql, int page, int rows);

	public List<T> find(String hql, Map<String, Object> params, int page, int rows);
	
	public Pager<T> findPager(String hql,Map<String, Object> params,Page page,Integer maxRowsPerPage);
	
	public List<T> find(String hql,Page page,Integer maxRowsPerPage);
	
	public List<T> find(String hql,Map<String, Object> params,Page page,Integer maxRowsPerPage);

	public Long count(String hql);

	public Long count(String hql, Map<String, Object> params);

	public int executeHql(String hql);
	
	public int executeHql(String hql,Map<String, Object> params);
	
	public int executeHql(String hql,Object... objects);
	
	public int executeHql(String hql,List<?> objects);

}
