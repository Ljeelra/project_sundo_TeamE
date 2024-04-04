/**
 * 
 */
$( document ).ready(function() {

	let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
	    target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
	    layers: [ // 지도에서 사용 할 레이어의 목록을 정의하는 공간이다.
	      new ol.layer.Tile({
	        source: new ol.source.OSM({
	          url: 'https://api.vworld.kr/req/wmts/1.0.0/CEB52025-E065-364C-9DBA-44880E3B02B8/Base/{z}/{y}/{x}.png' // vworld의 지도를 가져온다.
	        })
	      })
	    ],
	    view: new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
	      center: ol.proj.fromLonLat([128.4, 35.7]),
	      zoom: 7
	    })
	});
	var wms = new ol.layer.Tile({
		source : new ol.source.TileWMS({
			url : 'https://localhost/geoserver/test/wms?service=WMS',
			params: {
				'VERSION' : '1.1.0',
				'LAYERS' : 'test%3Atl_bjd_test1',
				'BBOX' : '1.3873946E7%2C3906626.5%2C1.4428045E7%2C4670269.5',
				'SRS' : 'EEPSG%3A3857',
				'FORMAT' : 'image/png' 

			},
			serverType : 'geoserver'
		})
	});

	map.addLayer(wms);
});