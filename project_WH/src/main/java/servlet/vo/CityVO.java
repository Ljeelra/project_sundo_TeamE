package servlet.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Alias("cityVO")
@Data
public class CityVO {
	//시도
	private String geom, ufid, sd_cd, sd_nm, divi;
	//시군구
	private String geometry, adm_sect_c, sgg_nm, sgg_oid, col_adm_se, gid, sgg_cd;

	private String xmax, ymax, xmin, ymin;
}
