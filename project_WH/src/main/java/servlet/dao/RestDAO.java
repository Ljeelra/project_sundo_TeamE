package servlet.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import servlet.impl.EgovComAbstractDAO;
import servlet.vo.CityVO;

@Repository("RestDAO")
public class RestDAO extends EgovComAbstractDAO {

	@Autowired
	private SqlSession session;

	public List<CityVO> sggList(String sido) {
		return session.selectList("Rest.sggList", sido);
	}
	
}
