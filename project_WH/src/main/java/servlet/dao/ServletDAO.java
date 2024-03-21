package servlet.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import servlet.impl.EgovComAbstractDAO;
import servlet.vo.CityVO;

@Repository("ServletDAO")
public class ServletDAO extends EgovComAbstractDAO {
	
	@Autowired
	private SqlSessionTemplate session;
	
	public List<CityVO> sidoList() {
		return selectList("servlet.sidoList");
	}

	public List<CityVO> sggList(String sido) {
		return selectList("servlet.sggList", sido);
	}

}
