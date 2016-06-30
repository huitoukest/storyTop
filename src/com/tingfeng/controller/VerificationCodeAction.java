package com.tingfeng.controller;

import java.io.IOException;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tingfeng.exception.DataException;
import com.tingfeng.utils.StringUtils_wg;
import com.tingfeng.utils.VerificationImage;
/**
 * 
 * @author Administrator
 * 此类的主要作用就是输出验证码图片,然后将验证码的验证结果输送到session中
 */
@Controller
public class VerificationCodeAction {
String vcode;
VerificationImage vImage=new VerificationImage();;
	public VerificationCodeAction() {
		// TODO Auto-generated constructor stub
	}
	@RequestMapping("/getVCode.do")
    public void getVCode(HttpServletResponse response,HttpServletRequest request)
   { 
    try {  
        //发送图片  
        ImageIO.write(vImage.getVerificationCode(), "JPEG", response.getOutputStream()); 
        //System.out.println("发送图片成功");
    } catch (IOException e){  
        e.printStackTrace();  
    } 
  vcode=vImage.getResult1();
  HttpSession session=request.getSession(true);
//将验证码保存到session中，便于以后验证      
  session.setAttribute("vcode", vcode);
  session.setAttribute("vcodeRefresh",false);//一个当前验证码是否需要刷新的标记
  //System.out.println("VCodeKey"+VCodeKey);
 
   }
	
	/**
	 * 返回验证码是否正确的结果
	 * @param vcode 前台传送来的验证码
	 * @param request
	 * @param codeKey 取出验证码的key
	 * @return
	 */
	public static boolean checkVCode(String vcode,HttpServletRequest request){
	    HttpSession session=request.getSession(true);
		if(session.getAttribute("vcodeRefresh")==null||(Boolean)session.getAttribute("vcodeRefresh"))
		{//如果当前的验证码是需要刷新的
			throw new DataException("请刷新验证码后再试！");
		}
	    String s= (String) request.getSession().getAttribute("vcode");
		boolean isRight=true;
		//System.out.println("服务器端得到的验证码结果s="+s);
		if(vcode==null||vcode.equals(""))
            isRight=false;
		  else if(!StringUtils_wg.isStringUsed(s))
			  isRight=false;
		  else if(!s.equals(vcode))
			  isRight=false;
		
		if(!isRight)
		{  //如果不正确表示需要刷新验证码
			session.setAttribute("vcodeRefresh",true);
		}
		return isRight;
	}
	
	
}
