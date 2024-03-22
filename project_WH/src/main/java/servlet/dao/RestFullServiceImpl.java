package servlet.dao;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import servlet.impl.RestFullService;
import servlet.vo.CityVO;

@Service("RestFullService")
public class RestFullServiceImpl implements RestFullService {

	@Resource(name="RestDAO")
	private RestDAO dao;
	
	@Override
	public List<CityVO> sggList(String sido) {
		return dao.sggList(sido);
	}

}
