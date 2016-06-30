package com.tingfeng.manager;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tingfeng.DAOImpl.BaseDaoImpl;
import com.tingfeng.exception.DataException;
import com.tingfeng.exception.SystemException;
import com.tingfeng.model.Admin;
import com.tingfeng.page.Page;
import com.tingfeng.page.Pager;
import com.tingfeng.system.MyJson;
import com.tingfeng.utils.StringUtils_wg;
import com.tingfeng.utils.TimeUtils;

@Service("adminManager")
public class AdminManager {
	@Autowired
	BaseDaoImpl<Admin> adminDao;

	// 这里的spring注入实际上是使用接口来注入,所以如果接口中的方法和此类的方法不一样,注入会发生参数不匹配的错误
	public AdminManager() {
		// TODO Auto-generated constructor stub
	}

	public boolean isAdminExisted(String name) throws DataException { // System.out.println("查询管理员用户是否存在");
		if (name == null || name.length() > 50) {
			throw new DataException("管理员用户名非法(isAdminExisted)");
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("name", name);
		long count = 0;
		String Hql = "select count(*) from Admin admin where admin.name=:name";
		count = this.adminDao.count(Hql, map);
		if (count > 0)
			return true;
		return false;
	}

	public BaseDaoImpl<Admin> getAdminDao() {
		return adminDao;
	}

	public void setAdminDao(BaseDaoImpl<Admin> adminDao) {
		this.adminDao = adminDao;
	}

	/**
	 * 保存一个新的admin
	 * 
	 * @param admin
	 * @return
	 * @throws SystemException
	 * @throws DataException
	 */
	public MyJson saveAdmin(Admin admin,HttpServletRequest request) throws SystemException {
		admin.setId(null);
		if (admin == null)
			return null;
		MyJson myJson;
		//myJson = checkAdmin(admin);
		if(this.getLoginAdmin(request)==null)
			throw new DataException("请先登录后再进行操作!");
		myJson = checkAdmin(admin);
		if(myJson.getSuccess()==false)
			throw new DataException(myJson.getMsg());
		
		if(admin.getPowerValue()<=this.getLoginAdmin(request).getPowerValue())
		   throw new DataException("您无权增加一个权限大于等于自己的管理员!请增大权限值!");
		try {
			if (myJson.getSuccess() == true) {
				if (null != getAdminByAdminName(admin.getName())) {
					myJson.setSuccess(false);
					myJson.setMsg("管理员用户名已经被使用!");
				} else {
					admin.setLastLoginTime(TimeUtils.getNowDateAndTime());
					Serializable id = this.getAdminDao().save(admin);
					myJson.setMsg("成功,管理员用户编号是:" + id);
					myJson.setObject(id);
				}
			}
		} catch (Exception e) {
			String s=("保存管理员用户到数据库的时候发生错误:" + e.getMessage());
			myJson.setSuccess(false);
			myJson.setMsg(s);
		}
		return myJson;
	}

	/**
	 * 先清除Hibernate的session中的内容,然后更新
	 * 
	 * @param admin
	 * @throws DataException
	 */
	public void updateAdmin(Admin admin,HttpServletRequest  request) throws DataException {
		
		if (admin == null || admin.getId() == null && admin.getName() == null)
			throw new DataException("被更新的管理员用户不能为空");
		MyJson json=this.checkAdmin(admin);
		
		if(json.getSuccess()==false)
			throw new DataException(json.getMsg());
			Admin adminForm=this.adminDao.get(Admin.class, admin.getId());
		if (adminForm==null||admin.getId()== null) {
			throw new DataException("数据库中不存在此管理员用户");
		}
		
		if(adminForm.getPowerValue()<=this.getLoginAdmin(request).getPowerValue()&&admin.getId()-this.getLoginAdmin(request).getId()==0)
			   throw new DataException("您无权增加一个权限大于等于自己的管理员!请增大权限值!");
	
		
		Admin adminTemp=this.getAdminByAdminName(admin.getName());
		
		long check=0;
		if(adminTemp==null) check=0;
		else check=adminTemp.getId()-admin.getId();	
		if(check!=0 )
			throw new DataException("该用户名已经被使用!");
		
		//this.getAdminDao().getSessionFactory().getCurrentSession().clear();
		
		adminTemp=this.getAdminDao().get(Admin.class, admin.getId());
		//adminTemp.setLastLoginTime(TimeUtils.getNowDateAndTime());
		adminTemp.setName(admin.getName());
		adminTemp.setNickName(admin.getNickName());
		if(admin.getPassword()!=null&&admin.getPassword().length()>1)
		adminTemp.setPassword(admin.getPassword());
		adminTemp.setPowerValue(admin.getPowerValue());
		this.getAdminDao().update(adminTemp);
	
	}
	/**
	 * 删除一个权限小于自己的管理员
	 * @param admin
	 * @param request
	 * @return
	 */
public MyJson deleteAdmin(Admin admin,HttpServletRequest request){
	MyJson myJson=new MyJson();
	
	admin=this.getAdminDao().get(Admin.class, admin.getId());
	if(this.getLoginAdmin(request)==null)
		   throw new DataException("请先以管理员身份登录!");
	
	if(admin.getPowerValue()<=this.getLoginAdmin(request).getPowerValue())
		   throw new DataException("您无权删除一个权限大于等于自己的管理员!");
	
	myJson.setMsg("删除成功!");
	myJson.setSuccess(true);
	return myJson;
}


public Admin getAdminByAdminName(String name) throws DataException {
		if(name==null||name.equals(""))
		{
			throw new DataException("请输入有效的管理员用户名!");
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("name", name);
		String Hql = "from Admin admin where admin.name=:name";
		Admin admin = this.adminDao.get(Hql, map);
		return admin;
	}

	/**
	 * 可以通过id号码和name来确定获得的管理员用户的数据,当id和name都为空的时后,不发送数据;
	 * 当id==-1,表示所有管理员用户;可以通过id号码和name来确定需要知道的管理员用户,搜索姓名的时候id必须为-1;
	 * 
	 * @param id
	 * @param name
	 */
	public Pager<Admin> getAllAdmins(Integer id, String name, Page page,HttpServletRequest request) {
		Admin loginAdmin=this.getLoginAdmin(request);
		if(loginAdmin==null)
			throw new DataException("请先以管理员身份登录!");
		Pager<Admin> admins = new Pager<Admin>();
		Long count;

		if (id == null)
			return null;
		String hql = "from Admin admin";
		// String hqlList="select * ";
		String hqlCount = "select count(*) ";

		if (id == -1 &&(name == null || name.equals(""))) {//取出所有admin用户
			count = this.getAdminDao().count(hqlCount + hql);
			if ((page.getPage() - 1) * page.getRows() > count)
				return null;
			admins.setRows((ArrayList<Admin>) this.getAdminDao().find(hql, page,1000));
			admins.setTotal(count);
		} else if (id > 0) {
			Admin admin = this.getAdminDao().get(Admin.class, id);
			if (admin != null) {
				//admins.getRows().clear();
				
				admins.setTotal(1L);
				ArrayList<Admin> adminArrayList = new ArrayList<Admin>();
				adminArrayList.add(admin);
				admins.setRows(adminArrayList);
			} else {
				return admins;
			}
		} else if (id == -1 && name != null && !name.equals("")) {
			Admin admin = this.getAdminByAdminName(name);

			ArrayList<Admin> adminArrayList;

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("name", "%" + name + "%");

			adminArrayList = (ArrayList<Admin>) this.getAdminDao().find(
					"from Admin admin Where admin.name like :name", map);

			if (adminArrayList == null)
				adminArrayList = new ArrayList<Admin>();

			if (admin != null)
				adminArrayList.add(0, admin);

			admins.setTotal(new Long(adminArrayList.size()));
			admins.setRows(adminArrayList);

		}
		
		ArrayList<Admin> adminArrayList=admins.getRows();
		
		for(int i=0;i<adminArrayList.size();i++)
		{
			Admin ad=adminArrayList.get(i);
			if(ad.getPowerValue()<loginAdmin.getPowerValue()){
				//ad.setName("***");
				//ad.setPassword("***");
				adminArrayList.remove(i);
				i--;//这里需要注意的是,移出一个就少了一个,List中的值会向前移动,所以i必须处理下
				admins.setTotal(admins.getTotal()-1);
			} else if(ad.getPowerValue()-loginAdmin.getPowerValue()==0&&ad.getId()-loginAdmin.getId()!=0){
				//ad.setName("***");
				ad.setPassword("***");
				//adminArrayList.remove(i);
			} 
		}//end for i

		return admins;
	}

	/**
	 * 将管理员用户设置为登陆状态,因为管理员用户信息设置比较很多,所以直接将整个admin保存到session中
	 * 
	 * @throws DataException
	 */
	public void setAdminLogined(Admin admin, HttpServletRequest request)
			throws DataException {
		try {
			if (admin == null || admin.getName() == null
					|| admin.getPassword() == null) {
				throw new DataException("管理员用户非法,无法登陆");
			}
			request.getSession().setAttribute("admin", admin);
			admin.setLastLoginTime(TimeUtils.getNowDateAndTime());
			this.adminDao.update(admin);
		} catch (Exception e) {
			throw new DataException("管理员用户登录失败。");
		}
	}

	/**
	 * 将管理员用户设置为登陆状态,因为管理员用户信息设置比较很多,所以直接将整个admin保存到session中
	 * 
	 * @param adminname
	 *            根据管理员用户名,将数据库查询到的admin对象保存到session中
	 * @param request
	 * @throws DataException
	 */
	public void setAdminLogined(String adminname, HttpServletRequest request)
			throws DataException {
		Admin admin = this.getAdminByAdminName(adminname);
		setAdminLogined(admin, request);
	}

	/**
	 * 将管理员用户设置为离线
	 */
	public void setAdminLogouted(Admin admin, HttpServletRequest request) {
		request.getSession().setAttribute("admin", null);
	}

	/**
	 * 
	 * @param request
	 * @return 判断管理员用户是否登录,密码和管理员用户名或者管理员用户id号码相同则表示登录
	 */
	public MyJson isAdminLogined(HttpServletRequest request) {
         MyJson myJson=new MyJson();
		Admin admin2 = (Admin) request.getSession().getAttribute("admin");
	    if(admin2!=null&&admin2.getId()!=null)
	    {
	    	myJson.setMsg("登录成功!");
	    	myJson.setObject(admin2);
	    	myJson.setSuccess(true);
	    }else {
	    	myJson.setMsg("尚未登录!");
	    	myJson.setSuccess(false);
	    }
		return myJson;
	}

	/**
	 * 
	 * @return 返回当前登录的管理员用户,没有则返回空
	 * @throws DataException
	 */
	public Admin getLoginAdmin(HttpServletRequest request) throws DataException {
		Object obj=request.getSession().getAttribute("admin");
		if(obj==null)
			return null;
		Admin admin=(Admin)obj ;
		return admin;
	}

	/**
	 * 
	 * @param admin
	 * @return 一个管理员用户是否是一个管理员
	 */
	public boolean isAdmin(Admin admin) {
		return false;
	}

	/**
	 * 主要是检查管理员用户前台数据是否符合要求
	 * 
	 * @param admin
	 * @return
	 */
	public MyJson checkAdmin(Admin admin) {
		// System.out.println("checkAdmin");

		String name = admin.getName();
		String password = admin.getPassword();
		String nickName=admin.getNickName();
		Integer powerValue=admin.getPowerValue();
		String s = "";

		boolean ok = true;
		// System.out.println("checkAdmin2");
		if (!StringUtils_wg.isStringUsed(password)
				|| !StringUtils_wg.isStringUsed(name)||!StringUtils_wg.isStringUsed(nickName)) {
			ok = false;
			s = "请输入要求的管理员用户名、密码、和称呼!";
			// System.out.println("checkAdmin3");
		} else if (name.length() > 50 || password.length() > 50||nickName.length()>50) {
			s = s + ("管理员用户名、密码、称呼的长度不能超过50!<br>");
			ok = false;
		} else if(powerValue==null||powerValue>127||powerValue<=0){
			s=s+"请输入合法的管理员权限值(1~127)";
		}
		
		if (ok)
			s = "数据通过检查!";
		// System.out.println("ok="+ok+"\ns="+s);
		return new MyJson(ok, s);
	}
/**
 * 删除一群管理员用户
 * @param ids
 * @param request
 * @return
 */
	public MyJson deleteAdmins(String ids, HttpServletRequest request) {
		//if(admin.getPowerValue()<=this.getLoginAdmin(request).getPowerValue())
			   //throw new DataException("您无权删除一个权限大于等于自己的管理员!");
		MyJson myJson=new MyJson();
		if(ids==null)
		{
			myJson.setSuccess(false);
			myJson.setMsg("删除失败!");
		} else{
				LinkedList<Long> adminIds=new LinkedList<Long>();
				for(String s:ids.split(","))
				{
					try{
						Long i=new Long(s);
						adminIds.add(i);
					} catch(Exception e){
						myJson.setSuccess(false);
						myJson.setMsg("删除失败!前台返回的用户id非法");
						return myJson;
					}
				} 
					for(Long i:adminIds)
					{   Admin admin=this.getAdminDao().get(Admin.class, i);						     
					        if(admin.getPowerValue()<=this.getLoginAdmin(request).getPowerValue())
							      throw new DataException("您无权删除权限大于等于自己的管理员!");					          
							//MyJson myJson2=this.deleteAdmin(admin, request);
					        this.getAdminDao().delete(admin);							
						}
					myJson.setSuccess(true);
					myJson.setMsg("删除成功!");
					}
					//this.getAdminDao().getSession();
		//if(myJson.getSuccess()==false)
		//{
			//this.getAdminDao().getSessionFactory().getCurrentSession().getTransaction().rollback();
		//}
		return myJson;
	}
/**
 * 当前登录的管理员退出登录状态
 * @param request
 * @return
 */
public MyJson setAdminLogouted(HttpServletRequest request) {
	 MyJson myJson=new MyJson();
		Admin admin2 = (Admin) request.getSession().getAttribute("admin");
	    if(admin2!=null&&admin2.getId()!=null)
	    {   request.getSession().setAttribute("admin",null);
	    	myJson.setMsg("退出登录成功!");
	    	myJson.setObject(admin2);
	    	myJson.setSuccess(true);
	    }else {
	    	myJson.setMsg("尚未登录!");
	    	myJson.setSuccess(false);
	    }
		return myJson;
}
}
