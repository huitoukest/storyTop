package com.tingfeng.utils;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class TimeUtils {
	public static Date date;

	/**
	 * @return 返回当前系统时间(时:分:秒) 
	 * */
	public static Date getNowTime() {
		date = new Date();
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
		String dateString = simpleDateFormat.format(date);
		return date;
	}
	/**
	 * @return 返回当前系统日期(年-月-日) 
	 * */
	public static Date getNowDate() {
		date = new Date();
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String dateString = simpleDateFormat.format(date);
		return date;
	}
	/**
	 * @return 返回当前系统日期和时间(年-月-日 时:分:秒) 
	 * */
	public static Date getNowDateAndTime() {
		date = new Date();
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		String dateString = simpleDateFormat.format(date);
		return date;
	}
	
	/**
	 * @return 返回指定时间(时:分:秒) 
	 * */
	public static Date getTime(String string) throws ParseException {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
		date = simpleDateFormat.parse(string);
		return date;
	}
	/**
	 * @return 返回指定日期(年-月-日) 
	 * */
	public static Date getDate(String string) throws ParseException {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		date = simpleDateFormat.parse(string);
		return date;
	}
	/**
	 * @return 返回指定日期和时间(年-月-日 时:分:秒) 
	 * */
	public static Date getDateAndTime(String string) throws ParseException {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		date = simpleDateFormat.parse(string);
		return date;
	}
	/**
	 * 
	 * @param time
	 * @param format "yyyy-MM-dd HH:mm:ss"
	 * @return 返回一个毫秒数锁代表的时间,字符串格式
	 */
	public static String getDateAndTime(Long time,String format){
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
		Date d=new Date(time);
		return simpleDateFormat.format(d);
	}

	/**
	 * 
	 * @param d 时间日期
	 * @param format "yyyy-MM-dd HH:mm:ss"
	 * @return 返回一个毫秒数锁代表的时间,字符串格式
	 */
	public static String getDateAndTime(Date d,String format){
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
		return simpleDateFormat.format(d);
	}
}
