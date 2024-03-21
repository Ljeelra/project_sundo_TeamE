package servlet.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Alias("cityVO")
@Data
public class CityVO {
	private String sd_cd, sgg_cd, bjd_cd, sd_nm, sgg_nm, bjd_nm;
}
