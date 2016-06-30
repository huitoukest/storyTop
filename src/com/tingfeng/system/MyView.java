package com.tingfeng.system;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.view.AbstractView;

/**
 * 
 * @author Administrator
 *我的视图,作用是通过视图解析器将url和writer设置过来,然后此视图将内容write到前端
 */
public class MyView extends AbstractView{
private String responseContent;
	public MyView() {
		// TODO Auto-generated constructor stub
    super();
   //设置默认的contentType
	this.setContentType("text/html;charset=UTF-8");
	}

	@Override  
    protected void renderMergedOutputModel(Map<String, Object> map,  
            HttpServletRequest request, HttpServletResponse response)  
            throws Exception {
//将请求的url写到session中,actionUrl的值是/story/XXXX.do的形式
System.out.println("actionUrl="+request.getRequestURI());
request.getSession(true).setAttribute("actionUrl",request.getRequestURI());

response.setContentType(getContentType());  
response.getWriter().write(this.responseContent);  
response.getWriter().close();  
	}

	public String getResponseContent() {
		return responseContent;
	}

	public void setResponseContent(String responseContent) {
		this.responseContent = responseContent;
	}

	public void setUrl(String requestedFilePath) {
		// TODO Auto-generated method stub
		
	}  

}
