package servlet.controller;

import java.util.List;

import javax.annotation.Resource;

import org.json.JSONObject;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import servlet.service.ServletService;
import servlet.vo.CityVO;

@RestController
public class RestFullController {
	
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@PostMapping("/testgeool.do")
	public String selectSgg(@RequestParam("sido") String sido) {
		System.out.println("시/도 선택: " +sido);
		List<CityVO> sggList = servletService.sggList(sido);
		
		//JSON
		JSONObject jsonList = new JSONObject();
		jsonList.put("sggList", sggList);
		return jsonList.toString();
	}
}
