package servlet.service;

import java.util.List;

import servlet.vo.CityVO;

public interface ServletService {

	List<CityVO> sidoList();
	
	List<CityVO> sggList(String sido);

	CityVO sdView(String sido);

	CityVO sggView(String sgg_cd);


}
