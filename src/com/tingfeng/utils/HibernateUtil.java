package com.tingfeng.utils;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;
import org.hibernate.service.ServiceRegistryBuilder;

public class HibernateUtil {
	private final static SessionFactory FACTORY = buildSessionFactory();

	private static SessionFactory buildSessionFactory() {
		Configuration cfg = new Configuration().configure("1Hibernate.cfg.xml");
		ServiceRegistry serviceRegistry = new ServiceRegistryBuilder().applySettings(cfg.getProperties()).buildServiceRegistry();
		SessionFactory factory = cfg.buildSessionFactory(serviceRegistry);
		return factory;
	}
	
	public static SessionFactory getSessionFactory() {
		return FACTORY;
	}
	
	public static Session openSession() {
		return FACTORY.openSession();
	}
	
	public static Session openSessionBeginTransaction()
	{
		Session session=FACTORY.openSession();
        session.beginTransaction();
        return session;
	}

	public static void CommitAndcolseSession(Session session)
	{
		if(session!=null)
		{	session.getTransaction().commit();
		 close(session);
		}
	}
	
	public static void close(Session session) {
		if(session!=null) session.close();
	}
}