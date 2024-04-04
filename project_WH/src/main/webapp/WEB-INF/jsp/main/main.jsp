<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OpenLayers 테스트</title>
<!-- jquery -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<!-- openlayers CDN -->
<script src="https://cdn.jsdelivr.net/npm/ol@v9.0.0/dist/ol.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v9.0.0/ol.css">
<script type="text/javascript">
	$(function(){
		let sd, sgg, bjd, legend, style;
		
		let Base = new ol.layer.Tile({
			name : "Base",
			source: new ol.source.XYZ({
				url: 'https://api.vworld.kr/req/wmts/1.0.0/3BEFB2E1-C715-3AE1-BEAB-729D5FF229AD/Base/{z}/{y}/{x}.png'
			})
		}); // WMTS API 사용
		
	    let olView = new ol.View({
	        center: ol.proj.transform([127.100616,37.402142], 'EPSG:4326', 'EPSG:3857'),//좌표계 변환
	        zoom: 6,
	        minZoom: 7,
	        maxZoom: 19
	    })// 뷰 설정
	    
	    let map = new ol.Map({
	        layers: [Base],
	        target: 'map',
	        view: olView
	    });
		
		$('#sidoList').on("change", function() {
			
			let sdnm = $("#sidoList option:checked").text();//체크된 시도 텍스트값을 가져온다.
			
			$.ajax({
				url: "/main.do", 
				type: "post", 
				data: {"sido" : sdnm}, 
				dataType: 'json', 
				success:function(result){
					//console.log(result);
					let geomObject = JSON.parse(result[result.length-1].geom);
					let bbox = geomObject.bbox;
					//console.log(bbox);
					map.getView().fit(bbox, {duation : 900});
					
					$('#sigungu').empty();
					let sggval = "<option>시군구 선택</option>";
					for(let i=0;i<result.length;i++){
						sggval += "<option value="+result[i].sgg_cd+">"+result[i].sgg_nm+"</option>"
					}
					$("#sigungu").append(sggval);
				}, 
				error:function(request,status,error){					
					console.log("code: " + request.status);
			        console.log("message: " + request.responseText);
			        console.log("error: " + error);
				}
			})
			
		});
		
 		$('#sigungu').on("change", function(){
			let sgg_cd = $('#sigungu option:checked').val();
			
			$.ajax({
				url: "/sggSelect.do", 
				type: "post", 
				data: {"sgg_cd" : sgg_cd}, 
				dataType: 'json', 
				success:function(result){
					//console.log(result);
					let geomObject = JSON.parse(result.geom);
					let bbox = geomObject.bbox;
					//console.log(bbox);
					map.getView().fit(bbox, {duation : 900});
				}, 
				error:function(request,status,error){					
					console.log("code: " + request.status);
			        console.log("message: " + request.responseText);
			        console.log("error: " + error);
				}
			})
		});
 		
 		$('#legend').on("change", function(){
 			legend = $('#legend').val();
 			console.log(legend);
 		});
 			
		$('.selectBtn').click(function(){
			map.removeLayer(sd);
			map.removeLayer(bjd);
			
			let sd_CQL="sd_cd="+$('#sidoList').val();
			let sgg_CQL="sgg_cd="+$('#sigungu').val();
			console.log(sgg_CQL);
			
			if(sgg_CQL != '시군구 선택' && legend != null){
				switch(legend){
				case 1 :
					style = 'ELbjdview';
					break;
				case 2 :
					style = 'QUbjdbiew';
					break;
				default : 
					style = 'NBbjdview';
				}
			} else if(legend != null){
				switch(legend){
				case 1 :
					style = 'ELsdview';
					break;
				case 2 :
					style = 'QUsdbiew';
					break;
				default : 
					style = 'NBsdview';
				}
			}
			
			console.log(style);
			//if문 작성
			//시도만, 시도+범례, 시도+시군구+범례X, 시도+시군구+범례O
			//시도선택만 했을 경우, 범례X => legend==null, sgg_CQL=='시군구 선택'
			//시도+범례 => legend != null, sgg_CQL =='시군구 선택'
			//시도+시군구+범례x => legend == null, sgg_CQL !='시군구 선택'
			//시도+시군구+범례O => legend != null, sgg_CQL !='시군구 선택'
			//--> 범례 선택하지 않는 경우는 그냥 on change 쪽으로 넘겨도 될것 같은데..
			if(sgg_CQL=='시군구 선택' && legend != null){
				sd = new ol.layer.Tile({
					name: "sd",
					source : new ol.source.TileWMS({
						url : 'http://localhost/geoserver/projectsd/wms?service=WMS',
						params: {
							'VERSION' : '1.1.0',
							'LAYERS' : 'projectsd:e4sdview',
							'BBOX' : [1.3871489341071218E7,3910407.083927817,1.4680011171788167E7,4666488.829376997],
							'SRS' : 'EPSG:3857',
							'FORMAT' : 'image/png',
							'CQL_FILTER' : sd_CQL,
							'STYLE' : style
						},
						serverType : 'geoserver'
					}),
					opacity : 0.5
				});
				
				bjd = new ol.layer.Tile({
					name: "bjd",
					source : new ol.source.TileWMS({
						url : 'http://localhost/geoserver/projectsd/wms?service=WMS',
						params: {
							'VERSION' : '1.1.0',
							'LAYERS' : 'projectsd:e4bjdview',
							'BBOX' : [1.3873946E7,3906626.5,1.4428045E7,4670269.5],
							'SRS' : 'EPSG:3857',
							'FORMAT' : 'image/png',
							'CQL_FILTER' : sgg_CQL
						},
						serverType : 'geoserver'
					}),
					opacity : 0.8
				});
				
			} else{//법정동 sgg_CQL값이 시군구 선택이 아니고 범례 값이 null이 아닐때
				sd = new ol.layer.Tile({
					name: "sd",
					source : new ol.source.TileWMS({
						url : 'http://localhost/geoserver/projectsd/wms?service=WMS',
						params: {
							'VERSION' : '1.1.0',
							'LAYERS' : 'projectsd:e4sdview',
							'BBOX' : [1.3871489341071218E7,3910407.083927817,1.4680011171788167E7,4666488.829376997],
							'SRS' : 'EPSG:3857',
							'FORMAT' : 'image/png',
							'CQL_FILTER' : sd_CQL
						},
						serverType : 'geoserver'
					}),
					opacity : 0.5
				});					
			
				bjd = new ol.layer.Tile({
					name: "bjd",
					source : new ol.source.TileWMS({
						url : 'http://localhost/geoserver/projectsd/wms?service=WMS',
						params: {
							'VERSION' : '1.1.0',
							'LAYERS' : 'projectsd:e4bjdview',
							'BBOX' : [1.3873946E7,3906626.5,1.4428045E7,4670269.5],
							'SRS' : 'EPSG:3857',
							'FORMAT' : 'image/png',
							'CQL_FILTER' : sgg_CQL,
							'STYLES' : style
						},
						serverType : 'geoserver'
					}),
					opacity : 0.8
				});
			} //else{}범례 선택 없이 버튼 누를 때 추가
			
		    map.addLayer(sd);
		    //map.addLayer(sgg);
		    map.addLayer(bjd);
		});
		
	});
	

</script>
</head>
<body>
<h1>탄소 지도 정보시스템</h1>
	<!-- nav -->
	<a href="/fileUpload.do">파일업로드</a>
	<!-- Map -->
	<div id="map" class="map" style="width: 100%; height: 900px; left: 0px; top: 0px">
	</div>
	<!-- select -->
	<div id="selectlayer">
			<select id="sidoList" name="sido">
				<option selected disabled hidden>--시/도를 선택해주세요--</option>
				<c:forEach items="${sidoList }" var="sido">
					<option class="sd" value="${sido.sd_cd}">${sido.sd_nm}</option>
				</c:forEach>
			</select>
			<select id="sigungu" name="sigungu">
				<option></option>
			</select>
			<select id="legend">
               <option selected disabled hidden>범례 선택</option>
               <option value="1">등간격</option>
               <option value="2">등분위</option>
               <option value="3">Natural Breaks</option>
            </select>

			<button class="selectBtn" name="selectBtn" type="button">선택</button>
	</div>

<!-- 	<div class="barModal">
		<progress id="progressBar" value="0" max="100" ></progress>
	</div> -->
	
</body>
</html>