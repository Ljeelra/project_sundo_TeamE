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
		
		
		
		let Base = new ol.layer.Tile({
			name : "Base",
			source: new ol.source.XYZ({
				url: 'https://api.vworld.kr/req/wmts/1.0.0/3BEFB2E1-C715-3AE1-BEAB-729D5FF229AD/Base/{z}/{y}/{x}.png'
			})
		}); // WMTS API 사용
		
	    let olView = new ol.View({
	        center: ol.proj.transform([127.100616,37.402142], 'EPSG:4326', 'EPSG:3857'),//좌표계 변환
	        zoom: 6
	    })// 뷰 설정
	    
	    let map = new ol.Map({
	        layers: [Base],
	        target: 'map',
	        view: olView
	    });
		
		$("#sidoList").on("change", function() {
			
			var sdnm = $("#sidoList option:checked").text();//체크된 시도 텍스트값을 가져온다.
			
			$.ajax({
				url: "/testgeool.do", 
				type: "post", 
				data: {"sido" : sdnm}, 
				dataType: 'json', 
				success:function(data){
					alert(data);
				}, 
				error:function(request,status,error){
					
					console.log("code: " + request.status);
			        console.log("message: " + request.responseText);
			        console.log("error: " + error);
				}
			})
			
		});
		
		let sd = new ol.layer.Tile({
			name: "sd",
			source : new ol.source.TileWMS({
				url : 'http://localhost/geoserver/projectsd/wms?service=WMS',
				params: {
					'VERSION' : '1.1.0',
					'LAYERS' : 'projectsd:tl_sd',
					'BBOX' : [1.3871489341071218E7,3910407.083927817,1.4680011171788167E7,4666488.829376997],
					'SRS' : 'EPSG:3857',
					'FORMAT' : 'image/png' 
					//'CQL_FILTER' : 'sd_cd=11'
				},
				serverType : 'geoserver'
			})		
		});
		
		let sgg = new ol.layer.Tile({
			name : "sgg",
			source : new ol.source.TileWMS({
				url : 'http://localhost/geoserver/projectsd/wms?service=WMS',
				params: {
					'VERSION' : '1.1.0',
					'LAYERS' : 'projectsd:tl_sgg',
					'BBOX' : [1.386872E7,3906626.5,1.4428071E7,4670269.5],
					'SRS' : 'EPSG:3857',
					'FORMAT' : 'image/png' 
					//'CQL_FILTER' : 'sgg_cd=11320'${list}
				},
				serverType : 'geoserver'
			})		
		});
		let bjd = new ol.layer.Tile({
			name: "bjd",
			source : new ol.source.TileWMS({
				url : 'http://localhost/geoserver/projectsd/wms?service=WMS',
				params: {
					'VERSION' : '1.1.0',
					'LAYERS' : 'projectsd:tl_bjd',
					'BBOX' : [1.3873946E7,3906626.5,1.4428045E7,4670269.5],
					'SRS' : 'EEPSG:3857',
					'FORMAT' : 'image/png',
					'CQL_FILTER' : 'bjd_cd in (11545103,41173101,41290107,11620101,11620102,11545102,11590109,41171102)'
				},
				serverType : 'geoserver'
			})		
		});
		
	    map.addLayer(bjd);
	});
</script>
</head>
<body>
	<!-- nav -->
	
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

			<button class="selectBtn" name="selectBtn" type="button">선택</button>
	</div>
</body>
</html>