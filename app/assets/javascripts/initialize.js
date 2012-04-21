var map, mapbox, cartodb, markers = [];

function locationSuccess(position) {
	
	map.setView(new L.LatLng(position.coords.latitude, position.coords.longitude), 12);
  // do something with position.coords.latitude and position.coords.longitude
  // for example, re-center the embedded map on the user's position
}

function locationError(msg) {
  // if the user can't be found . . .
}

function initialize() {
  map = new L.Map('map-canvas').setView(new L.LatLng(40.675573,-73.96212), 12);
  var mapboxUrl = 'http://{s}.tiles.mapbox.com/v3/csabuilder.map-m2jqpyy8/{z}/{x}/{y}.png',
      mapbox = new L.TileLayer(mapboxUrl, {maxZoom: 17});
  map.addLayer(mapbox,true);	

  cartodb = new L.CartoDBLayer({
    map_canvas: 'map_canvas',
    map: map,
    user_name:'csabuilder',
    table_name: 'user_locations',
    query: "SELECT cartodb_id,user_id,ST_Transform(ST_Buffer(the_geom_webmercator,300),3857) as the_geom_webmercator FROM user_locations",
    tile_style:"#user_locations {polygon-fill:#FF1A00;polygon-opacity: 0.4;line-opacity:0;line-color: #FFFFFF;}",
    infowindow: false,
    auto_bound: false,
    debug: true
  });
  
  
  
  
  
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(locationSuccess, locationError);
  }
  
  $(".marker-container").click(function() {
  	addMarker($(this).attr("data-key"));
  
  });
  
  // $(".marker-container").draggable();
  
}

function addMarker(type) {

	var Icon = L.Icon.extend({
	    iconUrl: '/assets/' + type + '-basic.png',
	    iconSize: new L.Point(32, 37),
	    iconAnchor: new L.Point(22, 94),
	    popupAnchor: new L.Point(-3, -76)
	});
	
	var markerIcon = new Icon();
	
	var marker = new L.Marker(map.getCenter(), { icon: markerIcon, draggable: true });
	map.addLayer(marker);
	markers.push(marker);
	
}