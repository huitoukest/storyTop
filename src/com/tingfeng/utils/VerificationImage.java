package com.tingfeng.utils;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.util.Random;

import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
/**
 * 
 * @author Administrator
 * 此类的主要作用就是产生一个图片验证码
 * 长150,高70
 */
public class VerificationImage {
	private int result2=0;
	private StringBuffer result3;
	private String result1;
    Random rand = new Random();
    private static VerificationImage verificationImage;
	/**
	 * 随机产生的加数和被加数
	 */
	private int jiashu=0;
	private int beijiashu=0;
	/**
	 * 随机产生的计算方式,0表示加,1表示减
	 */
	private int js=0;
	//验证码图片中可以出现的字符集，可根据需要修改
    private char mapTable[]={
            'a','b','c','d','e','f',
            'g','h','i','j','k','l',
            'm','n','o','p','q','r',
            's','t','u','v','w','x',
            'y','z','0','1','2','3',
            '4','5','6','7','8','9'};
    
    private char[] aa={'零','壹','贰','叁','肆','伍','陆','柒','捌','玖'};
    private char[] bb={'0','1','2','3','4','5','6','7','8','9'};
    private char[] cc={'〇','一','二','三','四','五','六','七','八','九'};
    private char[] action={'加','减','+','-'};
    private char[] jieguo={'等','是'};
    
	public VerificationImage() {
	}

	/**
	 * 
	 * @return 一个VerificationImage的实例
	 */
	public static VerificationImage getInstance()
	{if(verificationImage==null)
		verificationImage=new VerificationImage();
	return verificationImage;
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		VerificationImage code=new VerificationImage();
		 JFrame jFrame=new JFrame();
          jFrame.setBounds(400, 400, 250, 250);
          
          ImageIcon img = new ImageIcon(code.getVerificationCode3()); 
          JLabel background = new JLabel(img);
          
          jFrame.add(background);
          jFrame.setVisible(true);
          jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); 
	}
/***
 * 
 * @return 四位随机验证码
 */
	public BufferedImage getVerificationCode()
	{
        int width=100;
        int height=50;
       BufferedImage image = new BufferedImage(width, height, 
                BufferedImage.TYPE_INT_RGB); 
        // 获取图形上下文 
        Graphics g = image.getGraphics(); 
        // 设定背景色 
        //g.setColor(new Color(0xDCDCDC));
        g.setColor(getColor());
        g.fillRect(0, 0, width, height); 
        //画边框 
        g.setColor(Color.black); 
        g.drawRect(0,0,width-1,height-1); 
        // 取随机产生的认证码
        String strEnsure = "";
        // 4代表4位验证码,如果要生成更多位的认证码,则加大数值
        for(int i=0; i<4; ++i) {
            strEnsure+=mapTable[(int)(mapTable.length*Math.random())];
        }  
        result1=strEnsure;
        // 　　将认证码显示到图像中,如果要生成更多位的认证码,增加drawString语句
        g.setColor(Color.black); 
        g.setFont(new Font("Atlantic Inline",Font.PLAIN,18)); 
        String str = strEnsure.substring(0,1); 
        g.drawString(str,8,17);  
        str = strEnsure.substring(1,2); 
        g.drawString(str,20,15); 
        str = strEnsure.substring(2,3); 
        g.drawString(str,35,18);   
        str = strEnsure.substring(3,4); 
        g.drawString(str,45,15); 
        // 随机产生10个干扰点
        Random rand = new Random();
        for (int i=0;i<80;i++) { 
            int x = rand.nextInt(width); 
            int y = rand.nextInt(height); 
            g.drawOval(x,y,1,1); 
        }    
        
        // 释放图形上下文
        g.dispose();
        //getDrawContent();
        return image;
    }
	/**
	 * 第二种验证码的计算方式,两位数的加减法
	 * @return 一个新的验证码图片
	 */
	public BufferedImage getVerificationCode2()
	{
        int width=150;
        int height=70;
        int degree=0;//继续一共旋转的角度,方便最后的时候旋转回来
       BufferedImage image = new BufferedImage(width, height, 
                BufferedImage.TYPE_INT_RGB); 
        // 获取图形上下文 
        Graphics g = image.getGraphics(); 
        // 设定背景色 
        Color background=getColor();
        g.setColor(background);
        g.fillRect(0, 0, width, height); 
        //画边框 
        g.setColor(background);
        g.drawRect(0,0,width-1,height-1); 
        // 　　将认证码显示到图像中,如果要生成更多位的认证码
        char[] content=getDrawContent2();
        int[] xs=getRadonWidths(content.length);
        int[] ys=getRadomHeights(content.length);
        for(int i=0;i<content.length;i++)
        {   String s=content[i]+"";
                   if(content[i]=='!')
                	   s="";
                   //如果在画字之前旋转图片
            if(i!=2){       
                   int maxDegree=rand.nextInt(2);
                   if(maxDegree==0)
                   	maxDegree=0;
                   else maxDegree=305;
           degree=rand.nextInt(45)+maxDegree;           
            }   else degree=0;
            g.setColor(Color.black); 
            if(i==2)//运算符号显示大一些
            	g.setFont(new Font("Atlantic Inline",Font.PLAIN,24));
            else
            g.setFont(new Font("Atlantic Inline",Font.PLAIN,18));          
            RotateString(s, xs[i], ys[i], g, degree,Color.black);
        }
       //画干扰点
        CreateRandomPoint(width, height, 80, g);       
        //随机画几条线
        CreateRandomLine(width, height,4,g);        
        // 释放图形上下文
        g.dispose();
        System.out.println("计算的结果是="+getResult2());      
        return image;
    }
	/**
	 * @return 一个六位数字的验证码
	 */
	public BufferedImage getVerificationCode3()
	{
		 int width=150;
	        int height=70;
	        int degree=0;//继续一共旋转的角度,方便最后的时候旋转回来
	       BufferedImage image = new BufferedImage(width, height, 
	                BufferedImage.TYPE_INT_RGB); 
	        // 获取图形上下文 
	        Graphics g = image.getGraphics(); 
	        // 设定背景色 
	        Color background=getColor();
	        g.setColor(background);
	        g.fillRect(0, 0, width, height); 
	        //画边框 
	        g.setColor(background);
	        g.drawRect(0,0,width-1,height-1); 
	        // 　　将认证码显示到图像中,如果要生成更多位的认证码
	        char[] content=getDrawContent3(6);
	        int[] xs=getRadonWidths(content.length);
	        int[] ys=getRadomHeights(content.length);
	        for(int i=0;i<content.length;i++)
	        {   String s=content[i]+"";
	                   if(content[i]=='!')
	                	   s="";
	                   int maxDegree=rand.nextInt(2);
	                   if(maxDegree==0)
	                   	maxDegree=0;
	                   else maxDegree=295;
	           degree=rand.nextInt(65)+maxDegree;           
	            g.setColor(Color.black); 
	            g.setFont(new Font("Atlantic Inline",Font.PLAIN,19));          
	            RotateString(s, xs[i], ys[i], g, degree,new Color(rand.nextInt(100),rand.nextInt(100),rand.nextInt(100)));
	        }
	       //画干扰点
	        CreateRandomPoint(width, height, 80, g);       
	        //随机画几条线
	        CreateRandomLine(width, height,4,g);        
	        // 释放图形上下文
	        g.dispose();
	        System.out.println("计算的结果是="+getResult3());      
	        return image;
	}
	/**
	 * 旋转并且画出指定字符串
	 * @param s 需要旋转的字符串
	 * @param x 字符串的x坐标
	 * @param y 字符串的Y坐标
	 * @param g 画笔g
	 * @param degree 旋转的角度
	 * @param c 所画的字符串的颜色
	 */
    private void RotateString(String s,int x,int y,Graphics g,int degree,Color c)
	{
		Graphics2D g2d = (Graphics2D) g.create();                                  
        //   平移原点到图形环境的中心  ,这个方法的作用实际上就是将字符串移动到某一个位置
        g2d.translate(x-1, y+3);             
        //   旋转文本  
         g2d.rotate(degree* Math.PI / 180);
         g2d.setColor(c);
         //特别需要注意的是,这里的画笔已经具有了上次指定的一个位置,所以这里指定的其实是一个相对位置
         g2d.drawString(s,0 , 0);
	}
	
	/**
	 * 
	 * @param width
	 * @param height
	 * @param many
	 * @param g
	 */
	private void CreateRandomPoint(int width,int height,int many,Graphics g)
	{  // 随机产生干扰点
        for (int i=0;i<many;i++) { 
            int x = rand.nextInt(width); 
            int y = rand.nextInt(height); 
            g.setColor(getColor());
            g.drawOval(x,y,1,1); 
        } 
	}
/**
 * 
 * @param width
 * @param height
 * @param minMany 最少产生的数量
 * @param g
 */
	private void CreateRandomLine(int width,int height,int minMany,Graphics g)
	{  // 随机产生干扰线条
		for (int i=0;i<rand.nextInt(minMany)+5;i++) { 
            int x1 = rand.nextInt(width)%15; 
            int y1 = rand.nextInt(height);
            int x2 = (int) (rand.nextInt(width)%40+width*0.7); 
            int y2 = rand.nextInt(height); 
            g.setColor(getColor());
            g.drawLine(x1, y1, x2, y2);
        } 
	}
	
	/*** 
	 * @return 随机返回一种颜色
	 */
	private Color getColor()
	{//让颜色变浅一些,这样验证码可以看到更加清楚一点
		int R=(int) (55+Math.random()*200);
		int G=(int) (55+Math.random()*200);
		int B=(int) (55+Math.random()*200);
	return new Color(R,G,B);
	}
    /**
     * 
     * @return 返回getVerificationCode2需要画出的内容:两位数加减法字符数组
     */
    private char[] getDrawContent2()
    { beijiashu=0;
      jiashu=0;
    char[] temp=new char[6];
    char[] w =aa;  
    int k=0;
     
          /**
           * 产生被加数
           */
        //从aa\bb\cc中选择一个字符数组作为素材    
        k=(int)(Math.random()*4);
        if(k==0)
      	  w=aa;
        else if(k==1) w=bb;
        else if(k==3) w=cc;
          k=(int)(Math.random()*10);
          temp[0]=w[k];
          if(k==0) temp[0]='!';
          beijiashu+=k*10;
          k=(int)(Math.random()*10);
          temp[1]=w[k];
          beijiashu+=k;
          /**
           * 产生加数
           */
        //从aa\bb\cc中选择一个字符数组作为素材    
        k=(int)(Math.random()*4);
        if(k==0)
      	  w=aa;
        else if(k==1) w=bb;
        else if(k==3) w=cc;
         
       k=(int)(Math.random()*10);
          temp[3]=w[k];
      if(k==0) temp[3]='!';  
      jiashu=k*10+jiashu;         
        k=(int)(Math.random()*10);
          temp[4]=w[k];
          jiashu+=k;
          //选择加减乘除
          w=action;
          k=(int)(Math.random()*4 );
          temp[2]=w[k];
          js=k%2;
          //结果
          w=jieguo;
          k=(int)(Math.random()*2);
          temp[5]=w[k];
    //System.out.println(new String(temp));
          return temp;
    }
   
    /**
     * @param many 指定画出的几位数字
     * @return 返回getVerificationCode3需要画出的内容,:
     */
    private char[] getDrawContent3(int many)
    { beijiashu=0;
      jiashu=0;
     char[] temp=new char[many];
     char[] w =aa;
     int k=0;
     result3=new StringBuffer();
          /**
           * 产生数字
           */
    for(int i=0;i<many;i++)
    {
    	k=(int)(Math.random()*4);
        if(k==0)
      	  w=aa;
        else if(k==1) w=bb;
        else if(k==3) w=cc;
        
        k=(int)(Math.random()*10);
        temp[i]=w[k];
        result3.append(k);
        
    }
    
          return temp;
    }
    
    /**
     * 对图片选择,这里保留以方便以后使用
     * @param bufferedimage
     * @param degree
     * @return 一张旋转后的图片
     */
    public BufferedImage rolateImage(BufferedImage bufferedimage,int degree,Color backGround)
    {                
    	BufferedImage img;
    	int w = bufferedimage.getWidth();
    	int h = bufferedimage.getHeight();
    	int type = BufferedImage.TYPE_INT_RGB;
    	Graphics2D graphics2d;
    	graphics2d = (img = new BufferedImage(w, h, type)).createGraphics();
    	graphics2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
                    RenderingHints.VALUE_INTERPOLATION_BICUBIC);
    	graphics2d.rotate(Math.toRadians(degree), w / 2, h / 2);
    	graphics2d.drawImage(bufferedimage,null, null);	
    	return img;
    }
    
    
    /**
     * 得到验证码getVerificationCode1,计算出来的结果
     */
    public String getResult1()
    {return result1;
    }
    
    /**
     * 得到验证码getVerificationCode2,计算出来的结果
     */
    public int getResult2()
    { if(js==0)
    	return(beijiashu+jiashu);
      else if(js==1) return (beijiashu-jiashu);
    	return 0;
    }
    
    /**
     * 得到验证码getVerificationCode3,一个字符串
     */
    public String getResult3()
    { return result3.toString();
    }
    /**
     * 
     * @param many
     * @return 画图的时候随机的高度的数组
     */
    private int[] getRadomHeights(int many){
    	int[] temp=new int[many]; 
    	for(int i=0;i<many;i++){
    		temp[i]=getRadomHeight();
    	}
    	return temp;
    }
    /**
     * 
     * @param many
     * @return 画图的时候起始x坐标的数组
     */
    private int[] getRadonWidths(int many)
    { int[] temp=new int[many]; 
	  for(int i=0;i<many;i++){
		  if(i==0)
		  temp[i]=getRadonWidth(0);
		  else temp[i]=getRadonWidth(temp[i-1]);
	  }
	  return temp;   	
    }
    
    private int getRadomHeight()
    { int fullHeight=40;
      return (int)(Math.random()*fullHeight)%35+15;   	
    }
    
    private int getRadonWidth(int minWidth)
    { int maxWidth=70;
      int minJianju=maxWidth/9;
      int maxJianju=maxWidth/6;
      int temp=maxJianju-minJianju;
      //在的规定的范围内产生一个随机数
      return (int)(Math.random()*temp)+minWidth+minJianju;   	
    }
}
