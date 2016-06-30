package com.tingfeng.model;


import java.util.Date;

import org.hibernate.Session;
import org.junit.Test;

import com.tingfeng.utils.HibernateUtil;

public class TestUser {

	 @Test
	 public void testadd()
	 {
		 Session session=HibernateUtil.openSession();
		 session.beginTransaction();
		 User user=new User();
		      user.setUserName("userTest"+(int)(Math.random()*110000));
		      user.setPassword("userTest"+(int)(Math.random()*100000));
		      user.setQq("123465"+(int)(Math.random()*10000));
		      user.setLastLoginTime(new Date());
		      System.out.println("username= "+user.getUserName());
		      System.out.println("userpassword= "+user.getPassword());
		      System.out.println("userQQ= "+user.getQq());
		 session.save(user);
		 HibernateUtil.CommitAndcolseSession(session);
		 
	 }
	 
	 @Test
	 public void testGet()
	 {
		 Session session=HibernateUtil.openSession();
		 session.beginTransaction();
		 User user=(User) session.get(User.class,2);
		 
		 HibernateUtil.CommitAndcolseSession(session);
	 }
}
