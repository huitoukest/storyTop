package com.tingfeng.system;
/**
 * 
 * @author tingfeng
 * 工厂模式，全局统计系统初始化的状态
 */
public class IsInited {

	private static IsInited isInited;
	private  boolean isOk=false;
	private IsInited() {
		// TODO Auto-generated constructor stub
	}
public static IsInited getIsInited(){
	if(isInited==null){
		isInited=new IsInited();
	}
	return isInited;
}
public boolean isOk() {
	return isOk;
}
public void setOk(boolean isOk) {
	this.isOk = isOk;
}
	
}
