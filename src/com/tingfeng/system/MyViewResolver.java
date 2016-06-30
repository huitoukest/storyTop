package com.tingfeng.system;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.Locale;
import org.apache.log4j.Logger;
import org.springframework.core.Ordered;
import org.springframework.core.io.Resource;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.view.AbstractCachingViewResolver;

/**
 * 
 * @author Administrator 自定义的一个视图解析器,它的作用实际上就是更具controller返回的字符串,来返回一个视图
 */
public class MyViewResolver extends AbstractCachingViewResolver implements
		Ordered {
 private String prefix;//url前缀
 private String suffix;//url后缀
	private Logger logger = Logger.getLogger(MyViewResolver.class.getName());
	private int order = Integer.MIN_VALUE;
	// requested file location under web app
	private String location;
	// View
	private String viewName;

	public void setViewName(String viewName) {
		this.viewName = viewName;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public int getOrder() {
		return this.order;
	}

	@Override
	protected View loadView(String viewName, Locale locale) throws Exception {
		/*
		if (location == null) {
			throw new Exception(
					"No location specified for GenericFileViewResolver.");
		}
		*/
		String requestedFilePath = location + viewName;
		requestedFilePath=prefix+viewName+suffix;
		Resource resource = null;
		// String url = "";
		try {
			logger.info(requestedFilePath);
			resource = getApplicationContext().getResource(requestedFilePath);
			// url = resource.getURI().toString();
		} catch (Exception e) {
			// this exception should be catched and return null in order to call
			// next view resolver
			logger.error("No file found for file: " + requestedFilePath);
			return null;
		}
		logger.info("Requested file found: " + requestedFilePath
				+ ", viewName:" + viewName);
		// get view from application content, scope=prototype
		MyView myView=new MyView();
		myView.setUrl(requestedFilePath);
		myView.setResponseContent(inputStreamTOString(resource.getInputStream(),
				"UTF-8"));
		return myView;
	}

	final static int BUFFER_SIZE = 4096;

	/**
	 * Convert Input to String based on specific encoding
	 * 
	 * @param in
	 * @param encoding
	 * @return
	 * @throws Exception
	 */
	public static String inputStreamTOString(InputStream in, String encoding)
			throws Exception {
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();
		byte[] data = new byte[BUFFER_SIZE];
		int count = -1;
		while ((count = in.read(data, 0, BUFFER_SIZE)) != -1)
			outStream.write(data, 0, count);

		data = null;
		return new String(outStream.toByteArray(), encoding);
	}

	public String getPrefix() {
		return prefix;
	}

	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}

	public String getSuffix() {
		return suffix;
	}

	public void setSuffix(String suffix) {
		this.suffix = suffix;
	}

}