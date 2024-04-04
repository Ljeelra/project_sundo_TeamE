package servlet.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import servlet.dao.ServletDAO;
import servlet.service.ServletService;
import servlet.vo.CityVO;

@Service("ServletService")
public class ServletImpl extends EgovAbstractServiceImpl implements ServletService{
	
	@Resource(name="ServletDAO")
	private ServletDAO dao;

	@Override
	public List<CityVO> sidoList() {
		return dao.sidoList();
	}
	
	@Override
	public List<CityVO> sggList(String sido) {
		return dao.sggList(sido);
	}

	@Override
	public CityVO sdView(String sido) {
		return dao.sdView(sido);
	}
	
	@Override
	public CityVO sggView(String sgg_cd) {
		return dao.sggView(sgg_cd);
	}


}
