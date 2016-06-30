package com.tingfeng.utils;

public class StringUtils_wg {

	public StringUtils_wg() {
	}

	/**
	 * 
	 * @param s
	 * @return 一个字符串对象是否可用
	 */
		public static Boolean isStringUsed(String s) {
			if (s != null && !s.trim().equals(""))
				return true;
			return false;
		}
		/**如果使用的是逗号作为分隔符号,使用逗号分隔符会更好
		 * 将souceString用指定的splite分割,自动去除首位空格和首位分隔符号,自动去掉首位多余的分割符号;
		 * @param souceString
		 * @param splite
		 * @return  a,b,c这种格式,方便在sql中用in语句直接使用;转换失败会抛出异常
		 */
		public static String transToSqlColumns(String souceString,String splite){
			souceString=souceString.trim();
			if(souceString.indexOf(splite)==0)
			{
				souceString=souceString.substring(splite.length());
			}
			if(souceString.lastIndexOf(splite)+splite.length()==souceString.length()){
				souceString=souceString.substring(0,souceString.length()-splite.length());
			}
			String[] tdsStrings=souceString.split(splite);
			StringBuffer sb=new StringBuffer();
			
			for(int i=0;i<tdsStrings.length;i++){
				if(i>0)
				sb.append(",");
				sb.append(tdsStrings[i]);
			}
			return sb.toString();
			
		}
		
		/**souceString默认使用的是逗号作为分隔符号
		 * @param souceString
		 * @return  a,b,c这种格式,方便在sql中用in语句直接使用;转换失败会抛出异常
		 */
		public static String transToSqlColumns(String souceString){
			souceString=souceString.trim();
			if(souceString.indexOf(",")==0)
			{
				souceString=souceString.substring(1);
			}
			if(souceString.lastIndexOf(",")==souceString.length()-1){
				souceString=souceString.substring(0,souceString.length()-1);
			}
			return souceString;
			
		}
}
