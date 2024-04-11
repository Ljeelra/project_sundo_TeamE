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

<!-- SweetAlert2 -->
<!-- <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> -->

<script type="text/javascript">
	$(function(){
		let sd, sgg, bjd, legend, style, overlay;
		
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
					
					let sd_CQL="sd_cd="+$('#sidoList').val();
					map.removeLayer(sd);
					
					sd = new ol.layer.Tile({
						name: "sd",
						source : new ol.source.TileWMS({
							url : 'http://localhost/geoserver/projectsd/wms?service=WMS',
							params: {
								'VERSION' : '1.1.0',
								'LAYERS' : 'projectsd:e4sggview',
								'BBOX' : [1.3867446E7,3906626.5,1.4684053E7,4670269.5],
								'SRS' : 'EPSG:3857',
								'FORMAT' : 'image/png',
								'CQL_FILTER' : sd_CQL
							},
							serverType : 'geoserver'
						}),
						opacity : 0.5
					});
					
					map.addLayer(sd);
				    console.log(sd);
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
					
					let sgg_CQL="sgg_cd="+$('#sigungu').val();
					map.removeLayer(bjd);
					
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
					
				    map.addLayer(bjd);
				    console.log(bjd);
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
 			//console.log(typeof legend);
 		});
 			
		$('.selectBtn').click(function(){
			map.removeLayer(sd);
			map.removeLayer(bjd);
			
			let sd_CQL="sd_cd="+$('#sidoList').val();
			let sgg_CQL="sgg_cd="+$('#sigungu').val();
			//console.log(sgg_CQL);
			
			if(sgg_CQL != "sgg_cd=시군구 선택" && legend != null){
				switch(legend){
				case '1' :
					style = 'ELbjdview';
					break;
				case '2' :
					style = 'NBbjdview';
					break;
				default : 
					console.log(legend);
				}
			} else if(sgg_CQL === 'sgg_cd=시군구 선택' && legend != null){
				switch(legend){
				case '1' :
					console.log(legend);
					style='ELsggview';
					break;
				case '2' :
					console.log(legend);
					style='NBsggview';
					break;
				default :
					console.log(legend);
				}
			}
			
			//console.log(style);

			if(sgg_CQL=='sgg_cd=시군구 선택' && legend != null){
				//console.log("sgg_cd=시군구 선택")
				sd = new ol.layer.Tile({
					name: "sd",
					source : new ol.source.TileWMS({
						url : 'http://localhost/geoserver/projectsd/wms?service=WMS',
						params: {
							'VERSION' : '1.1.0',
							'LAYERS' : 'projectsd:e4sggview',
							'BBOX' : [1.3867446E7,3906626.5,1.4684053E7,4670269.5],
							'SRS' : 'EPSG:3857',
							'FORMAT' : 'image/png',
							'CQL_FILTER' : sd_CQL,
							'STYLES' : style
						},
						serverType : 'geoserver'
					}),
					opacity : 0.5
				});
				
/* 				bjd = new ol.layer.Tile({
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
				}); */
				
				map.addLayer(sd);
				
			} else if(sgg_CQL != 'sgg_cd=시군구 선택' && legend != null){//법정동 sgg_CQL값이 시군구 선택이 아니고 범례 값이 null이 아닐때
				sd = new ol.layer.Tile({
					name: "sd",
					source : new ol.source.TileWMS({
						url : 'http://localhost/geoserver/projectsd/wms?service=WMS',
						params: {
							'VERSION' : '1.1.0',
							'LAYERS' : 'projectsd:e4sggview',
							'BBOX' : [1.3867446E7,3906626.5,1.4684053E7,4670269.5],
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
		    
			map.addLayer(sd);
		    map.addLayer(bjd);
			} 
			
		});
		
		map.on('singleclick', async (evt) => {
			
		    if(sd == null){
		    	alert('시도를 선택해주세요!');
		    	return false;
		    } else{
		    	map.removeOverlay(overlay);
		    	
				let container = document.createElement('div');
				container.setAttribute("class", "ol-popup-custom");
			    let content = document.createElement('div');
			    content.setAttribute("class", "popup-content");
			    
			    container.appendChild(content);
			    document.body.appendChild(container);	
	    
			    let coordinate = evt.coordinate; // 클릭한 지도 좌표
	
			    console.log(map.getLayers().getArray());
				
			    let wmsLayer;
			    if(bjd != null){
					wmsLayer = map.getLayers().getArray().filter(layer => {
				        return layer.get("name") === 'bjd';
				    })[0];   	
			    } else{
					wmsLayer = map.getLayers().getArray().filter(layer => {
				        return layer.get("name") === 'sd';
				    })[0];			  
			    }
	
			    console.log(wmsLayer);
	
			    const source = wmsLayer.getSource();
			    console.log(source);
			    const param = source.getParams();
			    
				
			    const layer = param['LAYERS'];
			    console.log(layer);
			    
			    const url = source.getFeatureInfoUrl(coordinate, map.getView().getResolution() || 0, 'EPSG:3857', {
			        QUERY_LAYERS: layer,
			        INFO_FORMAT: 'application/json'
			    });
	
			    console.log(url);
	
			    // GetFeatureInfo URL이 유효할 경우
			    if (url) {
			        try {
			            const request = await fetch(url.toString(), { method: 'GET' });
	
			            if (request.ok) {
			                const json = await request.json();
	
			                if (json.features.length === 0) {
			                    overlay.setPosition(undefined);
			                } else {
			                    const feature = new ol.format.GeoJSON().readFeature(json.features[0]);
			                    const vector = new ol.source.Vector({ features: [feature] });
			                  
			                    let totalUsage;
			                    let locNm;
			                    if(layer=='projectsd:e4sdview'){
									totalUsage = feature.get('usage');
									locNm =feature.get('sd_nm');
			                   	} else{
									totalUsage = feature.get('usage');
									locNm =feature.get('bjd_nm');
			                   	}

								
								console.log(totalUsage);
								console.log(locNm);
								
			                    content.innerHTML = '<div class="info"><p>'+ locNm +'</p>' + totalUsage + ' kwh' +
		    					'</div>';
	
			                    overlay = new ol.Overlay({
			                        element: content			                        
			                    });
	
			                    map.addOverlay(overlay);
			                    overlay.setPosition(coordinate);
			                }
			            } else {
			                console.log(request.status);
			            }
			        } catch (error) {
			            console.log(error.message);
			        }
			    }
	
			}
		});
		
	});
</script>
<style type="text/css">

	.info{
		margin-bottom: 1px;
		background-color: white;
		display: inline-block;
		justify-content: center;
		border : solid 1px black;
		line-height: 100%;
    	width: 100%;
    	height: auto;
    	box-sizing: border-box;
    	text-align: center;
    	border-radius: 10%;
    	font-size:12px;
	}
	.info > p{
		margin: 3px;
		font-weight: bold;
	}
</style>
</head>
<body>

	<!-- nav -->
	<a href="/fileUpload.do">파일업로드</a>
	<!-- Map -->
	<div id="map" class="map" style="width: 100%; height: 900px; left: 0px; top: 0px">
	</div>
	<!-- <div id="map-popup"></div> -->
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
               <option selected disabled hidden>--범례 선택--</option>
               <option value="1">등간격</option>
               <option value="2">Natural Breaks</option>
            </select>

			<button class="selectBtn" name="selectBtn" type="button">선택</button>
	</div>

<!-- 	<div class="barModal">
		<progress id="progressBar" value="0" max="100" ></progress>
	</div> -->
	
</body>
</html>