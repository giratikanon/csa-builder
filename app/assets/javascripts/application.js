// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .
//= require cartodb-leaflet
//= require wax.leaflet.min

$(document).ready(function(){

	var mapbox, cartodb;

	  function initialize() {
        var map = new L.Map('map_canvas').setView(new L.LatLng(40.675573,-73.96212), 11);


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

	  }

});

