package com.tingfeng.DAOImpl;

import java.util.ArrayList;
import org.hibernate.Session;
import org.junit.Test;

import com.tingfeng.DAOImpl.BaseDaoImpl;
import com.tingfeng.model.User;
import com.tingfeng.page.Page;
import com.tingfeng.page.Pager;
import com.tingfeng.utils.HibernateUtil;

public class TestBaseDao {

	public TestBaseDao() {
		// TODO Auto-generated constructor stub
	}
    @Test
	public void testFindWithPage()
	{
		Session session=HibernateUtil.openSession();
		BaseDaoImpl<User> userDao=new BaseDaoImpl<User>();
		userDao.setSession(session);
		session.beginTransaction();
		 

		 Pager<User> users = new Pager<User>();
		 ArrayList<User> userList;
			Long count;

			Page page=new Page(10,1, "desc", "id");
			
			String hql = "from User user";
			String hqlCount = "select count(*) ";
			
				count = userDao.count(hqlCount + hql);
				//page.setOrder(null);
				//userList=(ArrayList<User>)  userDao.find("from User user order by user.id desc", page);
				userList=(ArrayList<User>)  userDao.find("from User user ", page,1000);
				
				users.setRows(userList);
				users.setTotal(count);
				HibernateUtil.CommitAndcolseSession(session);
			return;		 		 
	}
}
