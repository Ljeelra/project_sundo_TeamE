package servlet.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import servlet.service.FileService;
import servlet.service.ServletService;
import servlet.vo.CityVO;

@RestController
public class RestFullController {
	
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@Resource(name="FileService")
	private FileService fileService;
	
	@PostMapping("/main.do")
	public List<CityVO> selectSgg(@RequestParam("sido") String sido) {
		System.out.println("시/도 선택: " + sido);
		List<CityVO> sggList = servletService.sggList(sido);
		CityVO sdView = servletService.sdView(sido);
		sggList.add(sdView);
		//JSON
		//JSONObject jsonList = new JSONObject();
		//jsonList.put("sggList", sggList);
		return sggList;
	}
	
	@PostMapping("/sggSelect.do")
	public CityVO selectSggView(@RequestParam("sgg_cd") String sgg_cd) {
		CityVO sggview = servletService.sggView(sgg_cd);
		return sggview;
	}
	
	@PostMapping("/fileUpload.do")
	public void readfile(@RequestParam("uploadFile") MultipartFile uploadData) throws IOException {
		System.out.println(uploadData.getName());
		System.out.println(uploadData.getContentType());
		System.out.println(uploadData.getSize());
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		
		InputStreamReader isr = new InputStreamReader(uploadData.getInputStream());
		BufferedReader br = new BufferedReader(isr);
		
		String line = null;
		
		while ((line = br.readLine()) != null)	{
			Map<String, Object> m = new HashMap<>();
			String[] lineArr = line.split("\\|");

			m.put("useym", lineArr[0]);	//사용_년월	useym
			//m.put("land_lc", lineArr[1]);	//대지_위치	land_lc
			//m.put("land_addr", lineArr[2]);	//도로명_대지_위치 land_addr
			m.put("sgg_cd", lineArr[3]);	//시군구_코드 sgg_cd
			m.put("bjd_cd", lineArr[4]);	//법정동_코드 bjd_cd
			//m.put("land_cd", lineArr[5]);	//대지_구분_코드 land_cd
			//m.put("bun", lineArr[6]);	//번 bun
			//m.put("ji", lineArr[7]);	//지 ji
			//m.put("nadd_no", lineArr[8]);	//새주소_일련번호 nadd_no
			//m.put("nroad_cd", lineArr[9]);	//새주소_도로_코드 nroad_cd
			//m.put("nground_cd", lineArr[10]);//새주소_지상지하_코드 nground_cd
			//m.put("nmainno", lineArr[11]);	//새주소_본_번 nmainno
			//m.put("nsubno", lineArr[12]);	//새주소_부_번 nsubno
			m.put("usage", lineArr[13] == "" ? 0 : Integer.parseInt(lineArr[13]));	//사용_량(KWh)	usage
			list.add(m);	
		}
		
		fileService.fileUpload(list);
		
		br.close();
		isr.close();
		
	}
}
