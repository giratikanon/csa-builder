#  --CREATE THE USER WITH a LOCATION (based on IP?) and return the cartodb_id
#  INSERT INTO users(name,the_geom) VALUES('Javier de la Torre',ST_SetSrid(st_makepoint(-73.96212,40.675573),4326)) RETURNING cartodb_id;
#
#  --ADD LOCATIONS OF INTEREST TO THE USER
#  INSERT INTO user_locations(user_id,the_geom) VALUES(2,ST_SetSrid(st_makepoint(-73.96212,40.675573),4326))
#
#  https://csabuilder.cartodb.com/api/v1/sql?api_key=ENV['CARTODB_KEY']&q=INSERT%20INTO%20users(name,the_geom)%20VALUES('Andrew',ST_SetSrid(st_makepoint(-73.96212,40.675573),4326))%20RETURNING%20cartodb_id
#
require 'faraday'

class Cartodb

  attr_reader :connection
  attr_accessor :user_id, :locations

  def initialize(*args)
    options = args.extract_options!
    @connection = Faraday.new('https://csabuilder.cartodb.com')
    @user_id = options[:user_id]
    @locations = options[:locations] || []
  end

  def create_user(name, longitude, latitude)
    response = @connection.get do |req|
      req.url '/api/v1/sql'
      req.headers['Accept'] = 'application/json'
      req.headers['Content-Type'] = 'application/json'
      req.params['api_key'] = ENV['CARTODB_KEY']
      req.params['q'] = cartodb_user_insert(name, longitude, latitude)
    end
    @user_id = JSON.parse(response.env[:body])['rows'].first['cartodb_id']
    self
  end

  def add_location(longitude, latitude)
    response = @connection.get do |req|
      req.url '/api/v1/sql'
      req.headers['Accept'] = 'application/json'
      req.headers['Content-Type'] = 'application/json'
      req.params['api_key'] = ENV['CARTODB_KEY']
      req.params['q'] = cartodb_user_insert(@user_id, longitude, latitude)
    end
    @locations << JSON.parse(response.env[:body])['rows'].first['cartodb_id']
    self
  end

  protected

  def cartodb_user_insert(name, longitude, latitude)
    "INSERT INTO users(name,the_geom) VALUES(" +
    "'#{name.to_s}'" +
    ",ST_SetSrid(st_makepoint(" +
    longitude.to_s +
    "," +
    latitude.to_s +
    "),4326)) RETURNING cartodb_id"
  end

  def cartodb_location_insert(user_id, longitude, latitude)
    "INSERT INTO user_locations(user_id,the_geom) VALUES(" +
    @user_id.to_s +
    ",ST_SetSrid(st_makepoint(" +
    longitude.to_s +
    "," +
    latitude.to_s +
    "),4326))"
  end

end

