package com.tingfeng.system;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class MyHandle extends HandlerInterceptorAdapter{

	public MyHandle() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub
		super.afterCompletion(request, response, handler, ex);
	}

	@Override
	public void afterConcurrentHandlingStarted(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		// TODO Auto-generated method stub
		super.afterConcurrentHandlingStarted(request, response, handler);
	}

	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub
		request.getSession(true).setAttribute("changeUrl",false);
		super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		// TODO Auto-generated method stub
		if(request.getSession(true).getAttribute("changeUrl")!=null&&(boolean) request.getSession(true).getAttribute("changeUrl"))
			return super.preHandle(request, response, handler);
		
		//将请求的url写到session中,actionUrl的值是/story/XXXX.do的形式
		System.out.println("actionUrl="+request.getRequestURI());
		request.getSession(true).setAttribute("changeUrl",true);
		request.getSession(true).setAttribute("actionUrl",request.getRequestURI());
		request.getRequestDispatcher("test.do").forward(request, response);
		
		return super.preHandle(request, response, handler);
	}

}
