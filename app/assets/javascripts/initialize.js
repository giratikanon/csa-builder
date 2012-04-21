var mapbox, cartodb;

function locationSuccess(position) {
  // do something with position.coords.latitude and position.coords.longitude
  // for example, re-center the embedded map on the user's position
}

function locationError(msg) {
  // if the user can't be found . . .
}

function initialize() {
  var map = new L.Map('map-canvas').setView(new L.LatLng(40.675573,-73.96212), 11);
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
    navigator.geolocation.getCurrentPosition(success, error);
  }
}