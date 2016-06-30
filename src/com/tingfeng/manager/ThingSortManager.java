package com.tingfeng.manager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun.istack.internal.logging.Logger;
import com.tingfeng.DAOImpl.BaseDaoImpl;
import com.tingfeng.DTO.ThingSortForm;
import com.tingfeng.DTO.ThingSortShowForm;
import com.tingfeng.DTO.TreeForm;
import com.tingfeng.exception.DataException;
import com.tingfeng.system.MyJson;

@Service("thingSortManager")
public class ThingSortManager {
	Logger logger=Logger.getLogger(ThingSortManager.class);
	// 这里的spring注入实际上是使用接口来注入,所以如果接口中的方法和此类的方法不一样,注入会发生参数不匹配的错误
	public ThingSortManager() {
		// TODO Auto-generated constructor stub
	}
/**返回当前id下的子id和数据
 * 当id为-1的时候返回所有数据,否则id为null的时候返回根节点,否则返回相应id的子节点
 * @param id
 * @param response
 */
	public void getThingSortByPid(Integer id) {		
	}
/**
 * 通过一个name找到
 * @param name
 * @return
 */
	public void getThingSortIdByName(String name){
	}
	
public MyJson updateThingSort(Integer id, String text, Integer pid) {
	MyJson myJson=new MyJson();
	if(id==null||text==null) {
		myJson.setMsg("输入数据非法!");
		myJson.setSuccess(false);
	} else if(text.length()>100){
		throw new DataException("分类名称最大长度为100!");
	}
	return myJson;
}

public MyJson addThingSort(Integer id, String text) {
	// TODO Auto-generated method stub
	MyJson myJson=new MyJson();
	if(id==null||text==null) {
		myJson.setMsg("输入数据非法!");
		myJson.setSuccess(false);
	} else if(text.length()>100){
		throw new DataException("分类名称最大长度为100!");
	} else {
		
}
   
	return myJson;
} 

/**
 * 找到此物品分类下对应的主题数量
 * @param id
 * @return
 */
public void getTopicCountByThingSortId(Integer id){
String hql="select count(*) from Topic tp where tp.thingSort.id="+id;
}


/**
 * ids是一个用逗号隔开的id集合,如1,2,11,35
 * @param ids
 * @param response
 */
public void deleteThingSorts(String ids)
{
	
}

/**
 * 返回一个第二层目录和叶子目录的集合
 * @return
 */
public MyJson index_thingSortShow() {
	MyJson myJson=new MyJson();
	
	return myJson;
}
/**
 * 得到thingSort下的所有子分类名称
 * @param leaf_thingSorts
 * @param thingSort
 */
public void get_leaf_thingSort(){
	
}


public MyJson getThingSortParents(Integer id) {
	MyJson myJson=new MyJson();
	ArrayList<ThingSortForm> thingSortForms=new ArrayList<ThingSortForm>();
	String Hql="from ThingSort ts where ts.id="+id;
	
	myJson.setSuccess(true);
	myJson.setObject(thingSortForms);
	myJson.setMsg("成功!");
	return myJson;

}

/**
 * 得到一个叶子节点thingSort的兄弟节点,但是如果是非叶子节点,则返回其叶子节点
 * @param id
 * @return
 */
public MyJson getThingSortBrothers(Integer id) {
	MyJson myJson=new MyJson();

	return myJson;
}

/**
 * 将传入的ArrayList<Integer>装满一个ThingSort分类下的所有子分类的的节点的ThingSort集合
 * @param thingSort 传入的父分类ThingSort
 * @param ths
 * @return
 */
public void getAllThingSortLeaf(){

}
/**
 * @param thingSort 传入的父分类ThingSort
 */
public void getAllThingSortLeaf1()
{

	}

/**
 * 用自己的代码来获取其子节点，防止懒加载问题的产生
 * @param thingSort
 * @return 
 * @return
 */
@SuppressWarnings("unused")
private void getThingSortLeafs()
{
}

public void getSecondThingSorts() {
	
}
}
