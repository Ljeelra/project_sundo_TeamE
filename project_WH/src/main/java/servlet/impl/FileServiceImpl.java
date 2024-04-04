package servlet.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import servlet.dao.FileDAO;
import servlet.service.FileService;
import servlet.vo.CityVO;

@Service("FileService")
public class FileServiceImpl implements FileService {

	@Resource(name="FileDAO")
	private FileDAO dao;

	@Override
	public void fileUpload(List<Map<String, Object>> list) {
		dao.fileUpload(list);
	}

}
