package servlet.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import servlet.impl.EgovComAbstractDAO;
import servlet.vo.CityVO;

@Repository("FileDAO")
public class FileDAO extends EgovComAbstractDAO {

	@Autowired
	private SqlSession session;

	public void fileUpload(List<Map<String, Object>> list) {
		for(Map<String, Object> data : list) {
			session.insert("rest.fileUpload", data);			
		}
	}
	
}
