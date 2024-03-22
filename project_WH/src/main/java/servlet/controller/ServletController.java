package servlet.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import servlet.service.ServletService;
import servlet.vo.CityVO;

@Controller
public class ServletController {
	@Resource(name = "ServletService")
	private ServletService servletService;

	@RequestMapping(value={"/main.do", "/"})
	public String mainTest() throws Exception {
		System.out.println("sevController.java - mainTest()");

		return "main/main";
	}

	@RequestMapping(value = "/test")
	public String test() {
		return "main/test";
	}

	@RequestMapping(value = "/testgeool.do")
	public String testgeool(ModelMap model) {
		List<CityVO> sidoList = servletService.sidoList();
		model.addAttribute("sidoList", sidoList);
		
//		List<CityVO> sggList = servletService.sggList(sido);
//		model.addAttribute("sggList", sggList);
		
//		List<CityVO> bjdList = servletService.bjdList(sgg);
//		model.addAttribute("bjdList", bjdList);
		return "main/testgeool";
	}
	
}
