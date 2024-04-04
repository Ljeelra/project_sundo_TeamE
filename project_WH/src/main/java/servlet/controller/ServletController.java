package servlet.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import servlet.service.ServletService;
import servlet.vo.CityVO;

@Controller
public class ServletController {
	@Resource(name = "ServletService")
	private ServletService servletService;

	@GetMapping(value={"/main.do", "/"})
	public String main(Model model) {
		List<CityVO> sidoList = servletService.sidoList();
		model.addAttribute("sidoList", sidoList);		

		return "main/redirect";
	}
	
	@RequestMapping("/")
	public String firstMain(Model model) {
		List<CityVO> sidoList = servletService.sidoList();
		model.addAttribute("sidoList", sidoList);	
		return "recdirect:/main.do";
	}
	
	@GetMapping("fileUpload.do")
	public String uploadPage() {
		return "main/fileUpload";
	}
	
	@GetMapping("/testgeool.do")
	public String test(Model model) {
		List<CityVO> sidoList = servletService.sidoList();
		model.addAttribute("sidoList", sidoList);		

		return "main/testgeool";
	}
	
}
