package com.tingfeng.DAOImpl;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.tingfeng.DAOI.BaseDaoI;
import com.tingfeng.exception.DataException;
import com.tingfeng.page.Page;
import com.tingfeng.page.Pager;
import com.tingfeng.utils.SqlUtils;

/**
 * get时单个对线,find时List对象
 * @author tingfeng
 *
 * @param <T>
 */
@Repository("baseDao")
public class BaseDaoImpl<T> implements BaseDaoI<T> {

	private SessionFactory sessionFactory;
	private Session session=null;

	public SessionFactory getSessionFactory() {
		return sessionFactory;
	}

	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

	public Session getCurrentSession() {
		if(session!=null)
			return session;
		//if(this.sessionFactory.getCurrentSession()!=null)
		return this.sessionFactory.getCurrentSession();
		//return this.sessionFactory.openSession();
	}
	
	public Session getSession() {
		return session;
	}

	public void setSession(Session session) {
		this.session = session;
	}

	@Override
	public Serializable save(T o) {
		return this.getCurrentSession().save(o);
	}


	@Override
	public T get(Class<T> c, Serializable id) {
		return (T) this.getCurrentSession().get(c,new Long(id.toString()));
	}

	
	@Override
	public T get(String hql) {
		Query q = this.getCurrentSession().createQuery(hql);
		List<T> l = q.list();
		if (l != null && l.size() > 0) {
			return l.get(0);
		}
		return null;
	}

	@Override
	public T get(String hql, Map<String, Object> params) {
		Query q = this.getCurrentSession().createQuery(hql);
		if (params != null && !params.isEmpty()) {
			for (String key : params.keySet()) {
				q.setParameter(key, params.get(key));
			}
		}
		List<T> l = q.list();
		if (l != null && l.size() > 0) {
			return l.get(0);
		}
		return null;
	}

	@Override
	public void delete(T o) {
		this.getCurrentSession().delete(o);
	}
	
	/**"delete from "+tableName+" where "+columnName+" in ("+columnValues+")"
	 * 用in语句删除指定表中,包含有指定值得指定列的记录;
	 * @param tableName
	 * @param columnName
	 * @param columnValues
	 */
	@Override
	public void deleteByColumns(String tableName,String columnName,String columnValues) {
		if(SqlUtils.sqlValidate(columnValues)){
			throw new DataException("列名字数据中包含sql关键字!");
		}
		String hql="delete from "+tableName+" where "+columnName+" in ("+columnValues+")";
		this.executeHql(hql);		
	}
	
	@Override
	public void deleteByColumns(String tableName,String columnName,List<?> columnValues) {
		StringBuffer sb=new StringBuffer();
		for(int i=0;i<columnValues.size();i++){
			if(i>0)
				sb.append(",");
			    sb.append("?");
		}
		String hql="delete from "+tableName+" where "+columnName+" in ("+sb.toString()+")";
		this.executeHql(hql,columnValues);		
	}

	@Override
	public void update(T o) {
		this.getCurrentSession().update(o);
	}

	@Override
	public void saveOrUpdate(T o) {
		this.getCurrentSession().saveOrUpdate(o);
	}
	
	@Override
	public List<T> find(String hql) {
		Query q = this.getCurrentSession().createQuery(hql);
		return q.list();
	}

	@Override
	public List<T> find(String hql, Map<String, Object> params) {
		Query q = this.getCurrentSession().createQuery(hql);
		if (params != null && !params.isEmpty()) {
			for (String key : params.keySet()) {
				q.setParameter(key, params.get(key));
			}
		}
		return q.list();
	}

	@Override
	public List<T> find(String hql, Map<String, Object> params, int page, int rows) {
		Query q = this.getCurrentSession().createQuery(hql);
		if (params != null && !params.isEmpty()) {
			for (String key : params.keySet()) {
				q.setParameter(key, params.get(key));
			}
		}
		return q.setFirstResult((page - 1) * rows).setMaxResults(rows).list();
	}

	@Override
	public List<T> find(String hql, int page, int rows) {
		Query q = this.getCurrentSession().createQuery(hql);
		List<T> tt=q.setFirstResult((page - 1) * rows).setMaxResults(rows).list();
		return tt;
	}
	
	
	/**
	 * 自动使用page中的信息排序,所以不需要自己排序,但是需要给page的排序字段加上表明,例如page.getSort本是"name",改成"user.name"
	 * @param hql
	 * @param params
	 * @param page
	 * @param maxRowsPerPage 每页的最大记录数量,传入null的之后将会默认为前端传入的最大值;
	 * @return
	 */
	@Override
	public List<T> find(String hql,Map<String, Object> params,Page page,Integer maxRowsPerPage) {
		if(page==null||page.getRows()==null||page.getPage()==null) return this.find(hql, params);				
		if(maxRowsPerPage!=null&&page.getRows()>maxRowsPerPage) page.setRows(maxRowsPerPage);
		if(page.getOrder()!=null&&page.getSort()!=null)
		{// hql=hql.trim()+" order by :BaseDaoImplSort "+page.getOrder();
		  //params.put("BaseDaoImplSort", page.getSort());
			hql=hql.trim()+" order by "+page.getSort()+" "+page.getOrder();
		}
		return this.find(hql, params, page.getPage(), page.getRows());
	}

	/**
	 * 自动使用page中的信息排序,所以不需要自己排序,但是需要给page的排序字段加上表明,例如page.getSort本是"name",改成"user.name"
	 */
	@Override
	public List<T> find(String hql,Page page,Integer maxRowsPerPage) {
		if(page==null||page.getRows()==null||page.getPage()==null) return this.find(hql);
		if(maxRowsPerPage!=null&&page.getRows()>maxRowsPerPage) page.setRows(maxRowsPerPage);
		if(page.getOrder()!=null&&page.getSort()!=null)
		{ //hql=hql.trim()+" order by :BaseDaoImplSort "+page.getOrder();
		  //Map<String,Object> params=new HashMap<String,Object>();
		  //params.put("BaseDaoImplSort", page.getSort());
		  return this.find(hql.trim()+" order by "+page.getSort()+" "+page.getOrder(),page.getPage(), page.getRows());
		  //return this.find(hql, params,page.getPage(), page.getRows());
		}
		return this.find(hql, page.getPage(), page.getRows());
	}
	/**
	 * 只需要传入搜索数据记录的相关hql,其会自动构建相应的Pager,其中hql语句中的from关键字请用小写
	 * @param hql
	 * @param params
	 * @param page
	 * @param maxRowsPerPage
	 * @return
	 */
	@Override
	public Pager<T> findPager(String hql,Map<String, Object> params,Page page,Integer maxRowsPerPage){
	        String countHql="select count(*) "+hql.trim().substring(hql.indexOf("from"));	
	        Long count=this.count(countHql, params);
	        Pager<T> pager=new Pager<T>();
	        pager.setTotal(count);
	        ArrayList<T> list=(ArrayList<T>) this.find(hql, params, page, maxRowsPerPage);
	        pager.setRows(list);
	        return pager;
	}
	
	@Override
	public Long count(String hql) {
		Query q = this.getCurrentSession().createQuery(hql);
		return (Long) q.uniqueResult();
	}

	@Override
	public Long count(String hql, Map<String, Object> params) {
		Query q = this.getCurrentSession().createQuery(hql);
		if (params != null && !params.isEmpty()) {
			for (String key : params.keySet()) {
				q.setParameter(key, params.get(key));
			}
		}
		return (Long) q.uniqueResult();
	}

	@Override
	public int executeHql(String hql) {
		Query q = this.getCurrentSession().createQuery(hql);
		return q.executeUpdate();
	}
    
	@Override
	public int executeHql(String hql, Map<String, Object> params) {
		Query q = this.getCurrentSession().createQuery(hql);
		if (params != null && !params.isEmpty()) {
			for (String key : params.keySet()) {
				q.setParameter(key, params.get(key));
			}
		}
		return q.executeUpdate();
	}
	
	@Override
	public int executeHql(String hql,Object... objects) {
		Query q = this.getCurrentSession().createQuery(hql);
		if (objects != null) {
			for (int i=0;i<objects.length;i++) {
				q.setParameter(i,objects[i]);
			}
		}
		return q.executeUpdate();
	}
	
	@Override
	public int executeHql(String hql,List<?> objects) {
		Query q = this.getCurrentSession().createQuery(hql);
		if (objects != null) {
			for (int i=0;i<objects.size();i++) {
				q.setParameter(i,objects.get(i));
			}
		}
		return q.executeUpdate();
	}

}

