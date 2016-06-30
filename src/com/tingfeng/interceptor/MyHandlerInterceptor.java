package com.tingfeng.interceptor;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.sun.istack.internal.logging.Logger;
import com.tingfeng.system.MyJson;

public class MyHandlerInterceptor extends HandlerInterceptorAdapter {  
  Logger logger=Logger.getLogger(this.getClass()); 
	// 继承HandlerInterceptorAdapter类  
  // 重写 preHandle()方法，在业务处理器处理请求之前对该请求进行拦截处理  ,
	//返回true，这样才会调用业务控制器去处理该请求；返回false，这样该请求就不会被处理。
    public boolean preHandle(HttpServletRequest request,  
            HttpServletResponse response, Object handler) throws Exception {
    	
    	String reqUrl=request.getRequestURI();
    	      //logger.info("当前请求的url是"+reqUrl);
    	      
    	if(matchUrl(reqUrl, new String[]{"/index","login","regist",".jsp","welcome","getVcode","isAdmin","isUser","initSystem"}))
    	return true;
    	 
    	HttpSession session=request.getSession();
    	 
    	if(matchUrl(reqUrl, new String[]{"/admin"}))
    	 {  
    		
    		if(reqUrl.endsWith("/admin")||reqUrl.endsWith("/admin/"))
    		return true;
    		
    		if(matchUrl(reqUrl, new String[]{"north","south","main","east","west"}))
    		return true;
    		
    		if(session.getAttribute("admin")==null)
    		 {     
    			   String path = request.getContextPath();  
			       String url=path+"/admin/needAdminLoginTemp.jsp?reqUrl="+reqUrl; 
			       setNeedLogin(url, request, response);
			       //response.sendRedirect(url);                 
    		return false;		 
    		 }
    		 else return true;
    	 }
    	 
    	 else if(matchUrl(reqUrl, new String[]{"/user/"})){    		 
        	 {
        		 if(session.getAttribute("user")==null)
        			 { String path = request.getContextPath();  
       			       String url=path+"/needUserLoginTemp.jsp?reqUrl="+reqUrl;
       			       setNeedLogin(url, request, response);
        			   //response.sendRedirect(url);
        			   return false;
        			 }
        			 else return true;
        	 }
    	 }
    	
    	      return true;
    }  
  
    public void setNeedLogin(String url,HttpServletRequest request,HttpServletResponse response) {
    	 //JSP格式返回
        if (!(request.getHeader("accept").indexOf("application/json") > -1 || (request  
                .getHeader("X-Requested-With")!= null && request  
                .getHeader("X-Requested-With").indexOf("XMLHttpRequest") > -1))&&request.getRequestURI().indexOf(".json")<0) {  
        	try {
				response.sendRedirect(url);
			} catch (IOException e) {
				logger.info("需要登录JSP!"+e.toString());
				//e.printStackTrace();
			}
        } else {// JSON格式返回  
               try{
				MyJson.sendToError(response,"请先登录,后再操作!", MyJson.ERRORCODE_NEDDLOGIN);
			} catch (IOException e) {
				logger.info("需要登录json!"+e.toString());
			}
        }  
    }
    
    /**
     * 判断当前请求的url，是否匹配给定的url数组中的一个
     * @param reqUrl
     * @return
     */
    public boolean matchUrl(String reqUrl,String[] url)
    {
    	for(String u:url){
    		if(reqUrl.toLowerCase().indexOf(u)>0)
        		return true;
    	}
    	return false;
    }
    public void postHandle(HttpServletRequest request,  
            HttpServletResponse response, Object o, ModelAndView mav)  
            throws Exception {  
        //System.out.println("postHandle");  
    }  
  
    public void afterCompletion(HttpServletRequest request,  
            HttpServletResponse response, Object o, Exception excptn)  
            throws Exception {  
        //System.out.println("afterCompletion");  
    }  
}