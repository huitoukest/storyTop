package com.tingfeng.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import com.sun.istack.internal.logging.Logger;
import com.tingfeng.exception.DataException;
import com.tingfeng.manager.ImagesManager;
import com.tingfeng.model.Image;
import com.tingfeng.staticThing.UploadFolder;
import com.tingfeng.system.MyJson;
import com.tingfeng.utils.MD5Utils;
import com.tingfeng.utils.SpringUtils;
import com.tingfeng.utils.StringUtils_wg;


@Controller  
public class UploadFileAction{   
@Autowired
private ImagesManager imagesManager;

Logger logger=Logger.getLogger(this.getClass());
@RequestMapping("/file/upLoadFile.do")
    public String upLoadFile(){
    	return "/test/upLoadFile.jsp";
    }  
	
    @RequestMapping("/file/upload.do"   )  
    public String addUser(@RequestParam("file") CommonsMultipartFile[] files,HttpServletRequest request){  
          
        for(int i = 0;i<files.length;i++){  
            System.out.println("fileName---------->" + files[i].getOriginalFilename());  
          
            if(!files[i].isEmpty()){  
                int pre = (int) System.currentTimeMillis();  
                try {  
                    //拿到输出流，同时重命名上传的文件  
                    FileOutputStream os = new FileOutputStream("H:/" + new Date().getTime() + files[i].getOriginalFilename());  
                    //拿到上传文件的输入流  
                    FileInputStream in = (FileInputStream) files[i].getInputStream();  
                      
                    //以写字节的方式写文件  
                    int b = 0;  
                    while((b=in.read()) != -1){  
                        os.write(b);  
                    }  
                    os.flush();  
                    os.close();  
                    in.close();  
                    int finaltime = (int) System.currentTimeMillis();  
                    System.out.println(finaltime - pre);  
                      
                } catch (Exception e) {  
                    e.printStackTrace();  
                    System.out.println("上传出错");  
                }  
        }  
        }  
        return "/success";  
    }  
     
      
    @SuppressWarnings("unchecked")
	@RequestMapping("/file/uploadImages.json"  )  
    public void saveImages(HttpServletRequest request,HttpServletResponse response) throws IllegalStateException, IOException {  
    	//request.
    	if(request.getSession().getAttribute("user")==null&&request.getSession().getAttribute("admin")==null)
    	throw new DataException("请先登录！");
    	MyJson myJson=new MyJson();
    	 HashMap<String, Object> map=new HashMap<String, Object>();
         
    	 ArrayList<String> imgUrls=new ArrayList<String>();
         //保存每张图片原来的命名
         ArrayList<String> imgNames=new ArrayList<String>();
    	 
         //这个path就是tomcat运行此程序的webContent的真实路径
    	 String path = UploadFolder.getSaveFolderPath(request);   
    	 
    	//创建一个通用的多部分解析器  
        CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(request.getSession().getServletContext());  
        //判断 request 是否有文件上传,即多部分请求  
        if(multipartResolver.isMultipart(request)){  
            //转换成多部分request    
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest)request;  
            //取得request中的所有文件名  
            Iterator<String> iter = multiRequest.getFileNames();  
            if(multiRequest.getFileMap().keySet().size()>5){
            	throw new DataException("一个主题最多上传5张图片,请重新上传符合要求数量的图片！");
            }
           // logger.info("当前上传的文件的数量是:"+multiRequest.getFileMap().keySet().size());
            
            //通过迭代来检查文件的扩展名是否符合要求
            while(iter.hasNext()){
            	MultipartFile file = multiRequest.getFile(iter.next());
            	String fileName=file.getOriginalFilename();
            	System.out.println("文件名是="+fileName);           	
            	if(fileName.lastIndexOf('.')>=0){
            		String extensionName=fileName.substring(fileName.lastIndexOf('.'),fileName.length()).toLowerCase();
            				System.out.println("上传的文件扩展名是="+extensionName);
            				
            				boolean isExtentionNameRight=extensionName.equals(".jpg")||extensionName.equals(".bmp")||extensionName.equals(".png")||extensionName.equals(".jpg")||extensionName.equals(".jpeg");
            				if(!isExtentionNameRight)
            				{
            					throw new DataException("图片限于bmp,png,jpeg,jpg格式");
            				}
            	}
            }
            
            iter = multiRequest.getFileNames();
            
            HttpSession session=request.getSession();
            //session.setAttribute("fileUpLoadCount", 0);
            if(session.getAttribute("imageIds")!=null){
            	//说明现在正在上传文件,那么删除掉原来的文件
            	//throw new DataException("您正在上传文件，不能够重复提交上传的文件！");
            	//ArrayList<String> imgUrlsT=(ArrayList<String>) session.getAttribute("imgUrls");
            	ArrayList<String> imgNamesT=(ArrayList<String>) session.getAttribute("imgNames");
            	ArrayList<Integer> idsT=(ArrayList<Integer>)session.getAttribute("imageIds");
            	ArrayList<Integer> newIdsArrayList=new ArrayList<Integer>();
            	
            	//logger.info("当前Session中保存的图片的数量是："+idsT.size());
            	
            	if(idsT!=null&&idsT.size()>0)
            	for(int i=0;i<idsT.size();i++){
            		//如果这个图片没有被使用,那么删除
            	   if(idsT!=null&&idsT.size()>0&&idsT.get(i)!=null){
            		if(this.getImagesManager().imageUsedCount(idsT.get(i))<1){
            		   File fileT=new File(path+imgNamesT.get(i));
            			if(fileT.exists())
            				fileT.delete();
            		       newIdsArrayList.add(idsT.get(i));	
            		}
            	   }
            	}//end for
            	if(idsT!=null)
            	this.imagesManager.deleteImages(newIdsArrayList);   	
            }
           while(iter.hasNext()){  
                //记录上传过程起始时的时间，用来计算上传时间  
                int pre = (int) System.currentTimeMillis();  
                //取得上传文件  
                MultipartFile file = multiRequest.getFile(iter.next());  
                if(file != null){  
                    //取得当前上传文件的文件名称  
                    String myFileName = file.getOriginalFilename();  
                    
                    
                    //如果名称不为“”,说明该文件存在，否则说明该文件不存在  
                    if(myFileName.trim() !=""){ 
                        //System.out.println(myFileName);
                        //重命名上传后的文件名  
                        String fileName =file.getOriginalFilename();  
                        //定义上传路径  
                        //String path = "H:/" + fileName;
                        if(file.getSize()>=10240000)
                        	throw new DataException("上传的文件最大为10M");
                        
                        String fileMd5Stirng=MD5Utils.getMd5ByFile(file.getBytes(),file.getSize());                       
                        String extensionName=fileName.substring(fileName.lastIndexOf('.'),fileName.length()).toLowerCase();
                        if(extensionName==null) extensionName="";
                        
                        //图片的名称就是md5的名称和扩展名，url则是包括路径和名称
                        if(!imgNames.contains(fileMd5Stirng+extensionName))
                        	imgNames.add(fileMd5Stirng+extensionName);
                        
                        String localPath=path+fileMd5Stirng+extensionName;
                        File localFile = new File(localPath);                        
                        file.transferTo(localFile);                   
                        if(!imgUrls.contains(UploadFolder.getImageDisPlayFolder(request)+fileMd5Stirng+extensionName))
                        imgUrls.add(UploadFolder.getImageDisPlayFolder(request)+fileMd5Stirng+extensionName);
                    }
                }
                
                
                //记录上传该文件后的时间  
                int finaltime = (int) System.currentTimeMillis();  
               // System.out.println(finaltime - pre);  
            }  //end iterator
            
            //session.setAttribute("imgUrls", imgUrls);
            //session.setAttribute("imgNames", imgNames);          
        //将上传保存的文件信息保存到数据库
        ArrayList<Integer> imageIds=new ArrayList<Integer>();   	
       	for(int i=0;i<imgUrls.size();i++){
       		Image img=new Image();
   		      img.setImageUrl(imgUrls.get(i));
   		      img.setName(imgNames.get(i));
   		      Image imageTemp=this.imagesManager.getImageByName(imgNames.get(i));
   		      if(imageTemp!=null)
   		      {
   		    	imageIds.add(imageTemp.getId());  
   		      }else{
       	      Serializable t=this.imagesManager.getImageDao().save(img);
       	      imageIds.add((Integer) t);} 
       	}
       	
       	session.setAttribute("imageIds", imageIds);
       	session.setAttribute("imgUrls", imgUrls);
       	session.setAttribute("imgNames", imgNames);
        
       	map.put("urls", imgUrls);
        map.put("ids",imageIds);
       if(!StringUtils_wg.isStringUsed(myJson.getMsg()))
       {
    	   myJson.setMsg("成功上传图片"+imageIds.size()+"张！");
       }
        myJson.setObject(map);
        
           // session.setAttribute("fileUpLoadCount", imgUrls.size());
        }         
        myJson.setSuccess(true); 
       // myJson.setMsg("成功上传文件"+imgUrls.size()+"个！");; 
        myJson.sendToClient(response);
    }
    
    @SuppressWarnings("unchecked")
	public static ArrayList<String> getFileUrls(HttpServletRequest request,HttpServletResponse response)
    {ArrayList<String>  urls = null;
    	HttpSession session=request.getSession();
        if(session.getAttribute("imgUrls")!=null){
        	  urls=(ArrayList<String>) session.getAttribute("imgUrls");
        }else{ if(session.getAttribute("fileUpLoadCount")!=null&&(int)session.getAttribute("fileUpLoadCount")>0)
           {
        	throw new DataException("系统错误，无法找到上传后的对应文件！");
           }
        }
         
        return urls;
    }    
    /**
     * 返回的是保存之后的图片的id的集合
     * @param request
     * @param response
     * @return
     */
    @SuppressWarnings("unchecked")
	public static ArrayList<Integer> getImageIds(HttpServletRequest request){
    	ArrayList<Integer> imageIds=null;
    	if(request.getSession().getAttribute("imageIds")!=null)
    		imageIds=(ArrayList<Integer>) request.getSession().getAttribute("imageIds");   	
    	return imageIds;
    }     
    /**
     * 将Session中存在的ImageId设置为空
     * @param request
     */
    public static void setSessionImageIdsNull(HttpServletRequest request){
    	HttpSession session=request.getSession();
    	session.setAttribute("imageIds", null);
    }

	public ImagesManager getImagesManager() {
		return imagesManager;
	}

	public void setImagesManager(ImagesManager imagesManager) {
		this.imagesManager = imagesManager;
	}
      
}  