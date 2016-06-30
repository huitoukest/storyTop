package com.tingfeng.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.math.BigInteger;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.security.MessageDigest;

public class MD5Utils {
/**
 * 返回一个文件的md5码，32位大写
 * @param file
 * @return
 * @throws FileNotFoundException
 */
	public static String getMd5ByFile(byte[] input,long length) throws FileNotFoundException {  
        String value = null;  
       // FileInputStream in = new FileInputStream(file);
    try {  
        //MappedByteBuffer byteBuffer = in.getChannel().map(FileChannel.MapMode.READ_ONLY, 0,length);  
        MessageDigest md5 = MessageDigest.getInstance("MD5");  
        //md5.update(byteBuffer);  
        md5.update(input);
        BigInteger bi = new BigInteger(1, md5.digest());  
        value = bi.toString(16);  
    } catch (Exception e) {  
        e.printStackTrace();  
    } finally {  
            //if(null != in) {  
                //try {  
                //in.close();  
            //} catch (IOException e) {  
                //e.printStackTrace();  
    //}  
        //}  
    }  
    return value;  
    }  

}
