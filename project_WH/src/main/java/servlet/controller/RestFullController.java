package servlet.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import servlet.impl.RestFullService;
import servlet.service.ServletService;
import servlet.vo.CityVO;

@RestController
public class RestFullController {
	
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@Resource(name="RestFullService")
	private RestFullService restFullService;
	
	@PostMapping("/testgeool.do")
	public List<CityVO> selectSgg(@RequestParam("sido") String sido) {
		System.out.println("시/도 선택: " + sido);
		List<CityVO> sggList = restFullService.sggList(sido);
		
		//JSON
		//JSONObject jsonList = new JSONObject();
		//jsonList.put("sggList", sggList);
		return sggList;
	}
}
