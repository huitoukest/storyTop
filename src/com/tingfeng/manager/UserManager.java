package com.tingfeng.manager;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun.istack.internal.logging.Logger;
import com.tingfeng.DAOImpl.BaseDaoImpl;
import com.tingfeng.exception.DataException;
import com.tingfeng.exception.SystemException;
import com.tingfeng.model.User;
import com.tingfeng.page.Page;
import com.tingfeng.page.Pager;
import com.tingfeng.staticThing.ConstantsAll;
import com.tingfeng.staticThing.ConstantsUser;
import com.tingfeng.system.MyJson;
import com.tingfeng.utils.StringUtils_wg;
import com.tingfeng.utils.TimeUtils;

@Service("userManager")
public class UserManager {
	Logger logger=Logger.getLogger(this.getClass());
	@Autowired
	private BaseDaoImpl<User> userDao;

	// 这里的spring注入实际上是使用接口来注入,所以如果接口中的方法和此类的方法不一样,注入会发生参数不匹配的错误
	public UserManager() {
		// TODO Auto-generated constructor stub
	}

	public boolean isUserExisted(String userName) throws DataException { // System.out.println("查询用户是否存在");
		if (userName == null || userName.length() > 50) {
			throw new DataException("用户名非法(isUserExisted)");
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("name", userName);
		long count = 0;
		String Hql = "select count(*) from User user where user.userName=:name";
		count = this.userDao.count(Hql, map);
		if (count > 0)
			return true;
		return false;
	}

	public BaseDaoImpl<User> getUserDao() {
		return userDao;
	}

	public void setUserDao(BaseDaoImpl<User> userDao) {
		this.userDao = userDao;
	}

	/**
	 * 保存一个新的user
	 * 
	 * @param user
	 * @return
	 * @throws SystemException
	 * @throws DataException
	 */
	@SuppressWarnings("unused")
	public MyJson saveUser(User user) throws SystemException {
		MyJson myJson;
		user.setId(null);
		if (user == null)
		   { myJson=new MyJson(false, "保存的用户不能为空!");
			return myJson; }		
		myJson = checkUser(user);
		try {
			if (myJson.getSuccess() == true) {
				if (null != getUserByUserName(user.getUserName())) {
					myJson.setSuccess(false);
					myJson.setMsg("用户名已经被使用!");
				} else {
					user.setLastLoginTime(TimeUtils.getNowDateAndTime());
					user.setLastGetTicketTime(TimeUtils.getNowDateAndTime());
					user.setStatus(ConstantsUser.user_status_normal);
					user.setMarkTicketCount(ConstantsAll.userDefaultTickets);
					user.setRecentlyMarkInfo("[]");
					user.setCreateTime(TimeUtils.getNowDateAndTime());
					user.setUpdateTime(TimeUtils.getNowDateAndTime());
					user.setRecommendStoryId(0L);
					user.setCanRecommendStory(true);
					Serializable id = this.getUserDao().save(user);
					myJson.setMsg("操作成功,用户编号是:" + id);
					myJson.setObject(id);
				}
			}
		} catch (Exception e) {
			throw new SystemException("保存用户到数据库的时候发生错误:" + e.getMessage());
		}
		return myJson;
	}

	/**
	 * 先清除Hibernate的session中的内容,然后更新
	 * 
	 * @param user
	 * @throws DataException
	 */
	public void updateUser(User user) throws DataException {
		User user3;
		
		if ((user == null || user.getId() == null )|| user.getUserName() == null)
			throw new DataException("被更新的用户不能为空");
		user3=this.userDao.get(User.class, user.getId());
		if (user.getId() != null
				&& user3 == null) {
			throw new DataException("数据库中不存在此用户");
		}
		User userTemp=this.getUserByUserName(user.getUserName());
		long check=0;
		if(userTemp==null) check=0;
		else check=userTemp.getId()-user.getId();		
		if(check!=0 )
			throw new DataException("该用户名已经被使用!");
		
		user3.setUserName(user.getUserName());
		user3.setEmail(user.getEmail());
		user3.setPhone(user.getPhone());
		user3.setSex(user.getSex());
		user3.setQq(user.getQq());
		user3.setReadTime(user.getReadTime());
		this.getUserDao().getCurrentSession().clear();
		this.getUserDao().update(user3);
	}
	
	/**
	 * 先清除Hibernate的session中的内容,然后更新
	 * 
	 * @param user
	 * @throws DataException
	 */
	public void updateUserByAdmin(User user) throws DataException {
		User user3;
		
		if ((user == null || user.getId() == null )|| user.getUserName() == null)
			throw new DataException("被更新的用户不能为空");
		user3=this.userDao.get(User.class, user.getId());
		if (user.getId() != null
				&& user3 == null) {
			throw new DataException("数据库中不存在此用户");
		}
		User userTemp=this.getUserByUserName(user.getUserName());
		long check=0;
		if(userTemp==null) check=0;
		else check=userTemp.getId()-user.getId();		
		if(check!=0 )
			throw new DataException("该用户名已经被使用!");
		
		if(user.getPassword()!=null&&user.getPassword().length()>0)
	    user3.setPassword(user.getPassword());
		user3.setUserName(user.getUserName());
		user3.setEmail(user.getEmail());
		user3.setPhone(user.getPhone());
		user3.setSex(user.getSex());
		user3.setQq(user.getQq());
		user3.setReadTime(user.getReadTime());
		this.getUserDao().getCurrentSession().clear();
		this.getUserDao().update(user3);
	}

	public User getUserByUserName(String userName) throws DataException {
		if(userName==null||userName.equals(""))
		{
			throw new DataException("请输入有效的用户名!");
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("name", userName);
		String Hql = "from User user where user.userName=:name";
		User user = this.userDao.get(Hql, map);
		return user;
	}

	/**
	 * 可以通过id号码和name来确定获得的用户的数据,当id和name都为空的时后,不发送数据;
	 * 当id==-1,表示所有用户;可以通过id号码和name来确定需要知道的用户,搜索姓名的时候id必须为-1;
	 * 
	 * @param id
	 * @param name 
	 */
	public Pager<User> getAllUsers(Long id, String name, Page page) {
		Pager<User> users = new Pager<User>();
		Long count;

		if(page.getOrder()!=null)
		{
			page.setSort("user."+page.getSort());
			//System.out.println(page.getSort());
		}
		
		if (id == null)
			return users;
		String hql = "from User user";
		// String hqlList="select * ";
		String hqlCount = "select count(*) ";

		if (id == -1 && (name == null || name.equals(""))) {
			count = this.getUserDao().count(hqlCount + hql);
			if ((page.getPage() - 1) * page.getRows() > count)
				return null;
			users.setRows((ArrayList<User>) this.getUserDao().find(hql, page,1000));
			users.setTotal(count);
		} else if (id > 0) {
			User user = this.getUserDao().get(User.class, id);
			if (user != null) {
				users.setTotal(1L);
				ArrayList<User> userArrayList = new ArrayList<User>();
				userArrayList.add(user);
				users.setRows(userArrayList);
			} else {
				return users;
			}
		} else if (id == -1 && name != null && !name.equals("")) {

			ArrayList<User> userArrayList;

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("name", "%" + name + "%");

			userArrayList = (ArrayList<User>) this.getUserDao().find(
					"from User user Where user.userName like :name", map,page,1000);
			
			if (userArrayList == null)
				userArrayList = new ArrayList<User>();
			
			users.setTotal(this.getUserDao().count("select count(*) from User user Where user.userName like :name", map));
			users.setRows(userArrayList);

		}

		return users;
	}
	/**
	 * 
	 * @param user
	 * @param isUpdate 在设置好user的信息后,是否需要更新
	 */
	private User setUserTicket(User user,boolean isUpdate){
		if(user.getMarkTicketCount()==null){
			user.setMarkTicketCount(ConstantsAll.userDefaultTickets);
		}
		if(user.getLastGetTicketTime()==null){
			user.setLastGetTicketTime(TimeUtils.getNowDateAndTime());
		}
		if(user.getMarkTicketCount()<ConstantsAll.userMaxTickets&&System.currentTimeMillis()-user.getLastGetTicketTime().getTime()>ConstantsAll.userGetTicketsTime)
		{	 user.setMarkTicketCount(user.getMarkTicketCount()+1);
		     user.setLastGetTicketTime(new Date());	    
		}else if(user.getMarkTicketCount()>ConstantsAll.userMaxTickets){
			 user.setMarkTicketCount(ConstantsAll.userMaxTickets);
		}
		 if(isUpdate)
		 {   userDao.getCurrentSession().clear();
		     userDao.update(user);
		 }
		return user;
	}
	
	/**
	 * 将用户设置为登陆状态,因为用户信息设置比较很多,所以直接将整个user保存到session中
	 * 同时用户登录的时候将之最近登录时间更新
	 * @param user
	 * @param request
	 * @param isRequestLogin 是否是用户请求的登录,和内部将之某用户设置为登录状态相区分
	 * @throws DataException
	 */
	public void setUserLogined(User user, HttpServletRequest request,boolean isRequestLogin)
			throws DataException {
		try {
			if (user == null || user.getUserName() == null
					|| user.getPassword() == null||user.getId()==null) {
				throw new DataException("用户非法,无法登陆");
			}
			if(isRequestLogin&&System.currentTimeMillis()-user.getLastLoginTime().getTime()<30000){
				throw new DataException("每个用户每30秒只能够登录一次!");
			}
			if(user.getStatus()==null){
				user.setStatus(ConstantsUser.user_status_normal);
			}else{
				String s="";
				switch (user.getStatus()) {
				/*case ConstantsUser.user_status_locked:
					 s="您的账户已经被锁定!";
					 if(user.getLockedTime()!=null)
						 s=s+"解锁日期:"+TimeUtils.getDateAndTime(user.getLockedTime(),"yyyy-MM-dd HH:mm:ss");
					 throw new DataException(s);*/
				case ConstantsUser.user_status_notAllowLogin:
					s="您的账户已经被禁止登陆!";
					 if(user.getLockedTime()!=null)
						 s=s+"解禁日期:"+TimeUtils.getDateAndTime(user.getNotAllowLoginTime(),"yyyy-MM-dd HH:mm:ss");
					throw new DataException(s);
				case ConstantsUser.user_status_deleted:
					s="此账户已经被删除!";
					throw new DataException(s);
				default:
					break;
				}

			}
			request.getSession().setAttribute("user", user);
			user.setLastLoginTime(TimeUtils.getNowDateAndTime());
			user=setUserTicket(user,false);
			this.userDao.update(user);
		} catch (Exception e) {
			//request.getSession().setAttribute("user",null);
			throw new DataException("用户更新登录状态失败。"+e.getMessage());
		}
	}

	/**
	 * 将用户设置为离线
	 */
	public void setUserLogouted(User user, HttpServletRequest request) {
		request.getSession().setAttribute("user", null);
	}
	
	/**
	 * 将session中的用户设置为离线
	 */
	public void setUserLogouted(HttpServletRequest request) {
		request.getSession().setAttribute("user", null);
	}

	/**
	 * 
	 * @param user
	 * @param request
	 * @return 判断用户是否登录,密码和用户名或者用户id号码相同则表示登录
	 */
	public boolean isUserLogined(User user, HttpServletRequest request) {
		if (user == null)
			return false;
		User user2 = (User) request.getSession().getAttribute("user");
		if (user2 == null)
			return false;
		if (user.getId() == user2.getId())
			return true;
		if (user.getUserName() == user2.getUserName()
				&& user.getPassword() == user2.getPassword())
			return true;
		return false;
	}
/**
 * 判断当前是否有用户登录,如果有,就返回当前的用户,没有就返回空
 * @param request
 * @return
 */
	public User isUserLogined(HttpServletRequest request){
		return (User) request.getSession().getAttribute("user");
	}
	
	/**
	 * 
	 * @return 返回当前登录的用户,没有则返回空
	 * @throws DataException
	 */
	public User getLoginUser(HttpServletRequest request) throws DataException {
		return (User) request.getSession().getAttribute("user");
	}

	/**
	 * 
	 * @param user
	 * @return 一个用户是否是一个管理员
	 */
	public boolean isAdmin(User user) {
		return false;
	}

	/**
	 * 主要是检查用户前台数据是否符合要求
	 * 
	 * @param user
	 * @return
	 */
	public MyJson checkUser(User user) {
		// System.out.println("checkUser");

		String name = user.getUserName();
		String password = user.getPassword();
		String email = user.getEmail();
		String phone = user.getPhone();
		String qq = user.getQq();
		Integer age = user.getAge();
		Integer sex = user.getSex();
		String s = "";
		boolean ok = true;
		// System.out.println("checkUser2");
		if (!StringUtils_wg.isStringUsed(password)
				|| !StringUtils_wg.isStringUsed(name)) {
			ok = false;
			s = "请输入要求的用户名和密码!";
			// System.out.println("checkUser3");
		} else if (name.length() > 50 || password.length() > 50) {
			s = s + ("用户名和密码的长度不能超过50!\n");
			ok = false;
		}

		if (email != null && email.length() > 255) {
			s = s + ("电子邮件的长度不能超过255!\n");
			ok = false;
		}
		if (phone != null && phone.length() > 20) {
			s = s + ("手机号码的长度不能超过20!\n");
			ok = false;
		}
		if (age != null && (age <= 0 || age >127)) {
			s = s + ("您的年纪太奇葩!\n");
			ok = false;
		}
		if (sex != null && (sex < 0 || sex > 2)) {
			s = s + ("服务器没有收到您的性别......!");
			ok = false;
		}
		if (ok)
			s = "数据通过检查!";
		// System.out.println("ok="+ok+"\ns="+s);
		return new MyJson(ok, s);
	}
/**
 * 如果用户下有发表的主题,则拒绝删除
 * 否则删除用户的认证信息和用户本身
 * @param user
 * @return
 */
	public MyJson deleteUser(User user) {
		MyJson myJson=new MyJson();
		//myJson.setSuccess(true);
		if(user==null||user.getId()==null)
		{ 
			myJson.setSuccess(false);
			myJson.setMsg("返回的用户信息不正确:用户为null或者用户id为null");
		} else {
			getUserDao().delete(user);
			myJson.setSuccess(false);
			myJson.setMsg("该用户(编号:"+user.getId()+")下存在发表的主题,无法删除!");			
		}
		return myJson;
	}


	public MyJson deleteUsers(String ids) {
		MyJson myJson=new MyJson();
		if(ids==null)
		{
			myJson.setSuccess(false);
			myJson.setMsg("删除失败!");
		} else{try{
				LinkedList<Long> userIds=new LinkedList<Long>();
				for(String s:ids.split(","))
				{
					try{
						Long i=new Long(s);
						userIds.add(i);
					} catch(Exception e){
						myJson.setSuccess(false);
						myJson.setMsg("删除失败!前台返回的用户id非法");
						return myJson;
					}
				} 
				this.getUserDao().deleteByColumns("User","id",userIds);
				myJson.setSuccess(true);
				myJson.setMsg("删除成功!");
		}
		catch (Exception e) {
			myJson.setMsg("删除失败!前台返回的用户id非法");
		}	
		
	}
		return myJson;
	}

	public MyJson updateUserPassword(User user, String newPassword,HttpServletRequest request) {
		MyJson myJson=new MyJson();
		
		String hql="update User user set user.password=:password where user.id="+user.getId();
		Map<String , Object> params=new HashMap<String, Object>();
		params.put("password", newPassword);
		int k=this.userDao.executeHql(hql, params);
		if(k>0)
		{
			myJson.setMsg("更新成功");
			myJson.setSuccess(true);
			user.setPassword(newPassword);
		    this.setUserLogined(user, request,false);
		} else{
			myJson.setSuccess(false);
			myJson.setMsg("更新失败");
		}
		return myJson;
	}
	
	
}
