package servlet.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import servlet.impl.EgovComAbstractDAO;
import servlet.vo.CityVO;

@Repository("ServletDAO")
public class ServletDAO extends EgovComAbstractDAO {
	
	@Autowired
	private SqlSession session;
	
	public List<CityVO> sidoList() {
		return session.selectList("servlet.sidoList");
	}

	public List<CityVO> sggList(String sido) {
		return session.selectList("servlet.sggList", sido);
	}

	public CityVO sdView(String sido) {
		return session.selectOne("servlet.sdView", sido);
	}
	
	public CityVO sggView(String sgg_cd) {
		return session.selectOne("servlet.sggView", sgg_cd);
	}

}
