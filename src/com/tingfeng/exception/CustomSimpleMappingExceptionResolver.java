package com.tingfeng.exception;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

import com.sun.istack.internal.logging.Logger;
import com.tingfeng.system.MyJson;

public class CustomSimpleMappingExceptionResolver extends SimpleMappingExceptionResolver {  
Logger logger=Logger.getLogger(CustomSimpleMappingExceptionResolver.class);
@Override  
protected ModelAndView doResolveException(HttpServletRequest request,  
    HttpServletResponse response, Object handler, Exception ex) {  
// Expose ModelAndView for chosen error view.  
String viewName = determineViewName(ex, request);
//如果请求的url不包含.json就是普通的请求
String url=request.getRequestURI();
boolean isJson=url.indexOf(".json")>-1;
if (viewName != null) {// JSP格式返回
    if (!(request.getHeader("accept").indexOf("application/json") > -1 || (request  
            .getHeader("X-Requested-With")!= null && request  
            .getHeader("X-Requested-With").indexOf("XMLHttpRequest") > -1))&&!isJson) {  
        // 如果不是异步请求  
        // Apply HTTP status code for error views, if specified.  
        // Only apply it if we're processing a top-level request.  
        Integer statusCode = determineStatusCode(request, viewName);        
        logger.info("普通异常捕获!");      
        if (statusCode != null) {  
            applyStatusCodeIfPossible(request, response, statusCode);  
        }  
        return getModelAndView(viewName, ex, request);  
    } else {// JSON格式返回  
    	logger.info(".josn和ajax请求异常捕获!");
        try {  
            //PrintWriter writer = response.getWriter();  
            //writer.write(ex.getMessage());  
            //writer.flush();
            MyJson.sendToError(response, "提示:"+ex.getMessage());
        } catch (IOException e) {  
        	logger.info(".json拦截异常!"+e.toString());
        }  
        return null;  

    }  
} else {  
    return null;  
}  
}  
}  
