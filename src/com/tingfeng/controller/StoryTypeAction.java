package com.tingfeng.controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tingfeng.manager.StoryTypeManager;
import com.tingfeng.model.StoryType;
import com.tingfeng.system.MyJson;

@Controller
public class StoryTypeAction {
@Autowired
private StoryTypeManager storyTypeManager;

public StoryTypeAction() {	}

	/**
	 * 的到当前小说类型的json数据
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("/getStoryAllTypes.do")
	public void getStoryAllTypes(HttpServletRequest request,
			HttpServletResponse response) {
		ArrayList<StoryType> storyTypes = (ArrayList<StoryType>) this.storyTypeManager.getAllStoryType();
		try {
			if (storyTypes == null)
				MyJson.sendToError(response, "服务器没有查询到小说类型的相关信息,请稍后再试!");
			else
				MyJson.sendToSuccess(response, storyTypes, "ok");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
