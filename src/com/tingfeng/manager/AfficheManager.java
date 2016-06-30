package com.tingfeng.manager;

import java.util.ArrayList;
import java.util.LinkedList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tingfeng.DAOImpl.BaseDaoImpl;
import com.tingfeng.exception.DataException;
import com.tingfeng.model.Affiche;
import com.tingfeng.page.Page;
import com.tingfeng.page.Pager;
import com.tingfeng.system.MyJson;
import com.tingfeng.utils.TimeUtils;

@Service
public class AfficheManager {
@Autowired
private BaseDaoImpl<Affiche> afficheDao;
	public AfficheManager() {
		// TODO Auto-generated constructor stub
	}
	public BaseDaoImpl<Affiche> getAfficheDao() {
		return afficheDao;
	}
	public void setAfficheDao(BaseDaoImpl<Affiche> afficheDao) {
		this.afficheDao = afficheDao;
	}
	
	public MyJson getUsingAffiche(){
		MyJson myJson=new MyJson();
		String hql="select ac from Affiche ac where ac.isUsing=true";
		ArrayList<Affiche> arrayList;
		arrayList=(ArrayList<Affiche>) this.getAfficheDao().find(hql);
		myJson.setObject(arrayList);
		myJson.setSuccess(true);
		myJson.setMsg("获取公告成功");
		return myJson;
	}
	public Pager<Affiche> getAllAffiche(Page page) {
		
		String hql="from Affiche";
		ArrayList<Affiche> arrayList;
		arrayList=(ArrayList<Affiche>) this.getAfficheDao().find(hql,page,1000);
		Pager<Affiche> pager=new Pager<Affiche>();
		pager.setRows(arrayList);
		
		hql="select count(*) from Affiche";
		Long count=this.getAfficheDao().count(hql);
		pager.setTotal(count);
		return pager;
	}
	
	public MyJson addAffiche(Affiche affiche) {
		MyJson myJson=new MyJson();
	 if(checkAffiche(affiche)){
		 affiche.setId(null);
		 if(affiche.getIsUsing()==null)
			 affiche.setIsUsing(false);
		affiche.setPublishTime(TimeUtils.getNowDateAndTime()); 
		 this.afficheDao.save(affiche);
		 myJson.setSuccess(true);
		 myJson.setObject(affiche);
		 myJson.setMsg("增加成功！");
	 }else{
		 myJson.setMsg("数据错误！");
	 }
		return myJson;
	}
	/**
	 * 检查一个前台传回的公告数据是否合法
	 * @param affiche
	 * @return
	 */
	public boolean checkAffiche(Affiche affiche){
		if(affiche==null&&(affiche.getAffiche()==null||affiche.getAffiche().length()<2||affiche.getAffiche().length()>500)){
			throw new DataException("公告非法!");
		}
		return true;
	}
	public MyJson updateAffiche(Affiche affiche) {
		MyJson myJson=new MyJson();
		 if(checkAffiche(affiche)){
            if(affiche.getId()==null)
            	{
            	throw new DataException("公告编号非法!");
            	}
			Affiche TAffiche=this.getAfficheDao().get(Affiche.class, affiche.getId());
                  if(TAffiche==null)
                  {
                	  throw new DataException("数据库中不存在此公告!");
                  }
			
			
			 if(affiche.getIsUsing()==null)
				 affiche.setIsUsing(false);
			 
			affiche.setPublishTime(TimeUtils.getNowDateAndTime()); 
			this.getAfficheDao().getCurrentSession().clear();
			this.afficheDao.update(affiche);
			 
			 myJson.setSuccess(true);
			 myJson.setObject(affiche);
			 myJson.setMsg("更新成功！");
		 }else{
			 myJson.setMsg("更新失败！");
		 }
			return myJson;
	}
	
	public MyJson deleteAffiche(String ids) {
		
		MyJson myJson=new MyJson();
		if(ids==null)
		{
			myJson.setSuccess(false);
			myJson.setMsg("删除失败!");
		} else{
				LinkedList<Integer> afficheIds=new LinkedList<Integer>();
				for(String s:ids.split(","))
				{
					try{
						Integer i=new Integer(s);
						afficheIds.add(i);
					} catch(Exception e){
						myJson.setSuccess(false);
						myJson.setMsg("删除失败!前台返回的公告id非法");
						return myJson;
					}
				}
			boolean ok=true;
		      for(Integer id:afficheIds){
		    	  Affiche affiche=this.getAfficheDao().get(Affiche.class, id);
		    	  if(affiche==null){
		    		  
		    		  throw new DataException("数据库中不存在此公告！编号("+id+")");
		    	  }
		    	  try{
		    	  this.getAfficheDao().delete(affiche);
		    	  }catch (Exception e){
		    		  ok=false;
		    		  myJson.setMsg("删除错误！"+e.toString());	
		    	  }
		      }
		      myJson.setSuccess(ok);
		      if(ok)
		      myJson.setMsg("删除成功！");	     
		}
		
		return myJson;
	}

}
