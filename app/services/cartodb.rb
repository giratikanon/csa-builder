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
  # ActiveAttr::Model
  #   includes from ActiveAttr:
  #     ActiveAttr::BasicModel
  #     ActiveAttr::Attributes
  #     ActiveAttr::AttributeDefaults
  #     ActiveAttr::QueryAttributes
  #     ActiveAttr::Typecasting
  #     ActiveAttr::TypecastedAttributes
  #     ActiveAttr::Logger
  #     ActiveAttr::ChainableInitialization
  #     ActiveAttr::BlockInitialization
  #     ActiveAttr::MassAssignment
  #     ActiveAttr::MassAssignmentSecurity
  #   includes from ActiveModel:
  #     ActiveModel::Naming
  #     ActiveModel::AttributeMethods
  #     ActiveModel::Conversion
  #     ActiveModel::Validations
  #     ActiveModel::Translation
  #     ActiveModel::MassAssignmentSecurity
  #     ActiveModel::Serialization
  #     ActiveModel::Serializers::JSON
  #     ActiveModel::Serializers::Xml
  include ActiveAttr::Model
  include ActiveModel::Dirty
  extend  ActiveModel::Callbacks

  attribute :user_id, :type => Integer
  attribute :locations, :type => Object

  attr_reader :connection, :errors

  def initialize(*)
    super
    self.locations ||= []
    @connection = Faraday.new('https://csabuilder.cartodb.com')
    @errors = ActiveModel::Errors.new(self)
  end

  def persisted?
    false
  end

  def create_user(name, email)
    response = @connection.get do |req|
      req.url '/api/v1/sql'
      req.headers['Accept'] = 'application/json'
      req.headers['Content-Type'] = 'application/json'
      req.params['api_key'] = ENV['CARTODB_KEY']
      req.params['q'] = cartodb_user_insert(name, email)
    end
    self.user_id = JSON.parse(response.env[:body])['rows'].first['cartodb_id']
    self
  end

  def add_location(longitude, latitude)
    return self if user_id.nil?
    response = @connection.get do |req|
      req.url '/api/v1/sql'
      req.headers['Accept'] = 'application/json'
      req.headers['Content-Type'] = 'application/json'
      req.params['api_key'] = ENV['CARTODB_KEY']
      req.params['q'] = cartodb_location_insert(user_id, longitude, latitude)
    end
    self.locations << JSON.parse(response.env[:body])['rows'].first['cartodb_id']
    self
  end

  protected

  def cartodb_user_insert(name, email)
    "INSERT INTO users(name,email) " +
    "VALUES('#{name.to_s}','#{email.to_s}') " +
    "RETURNING cartodb_id"
  end

  def cartodb_location_insert(user_id, longitude, latitude)
    "INSERT INTO user_locations(user_id,the_geom) VALUES(" +
    user_id.to_s +
    ",ST_SetSrid(st_makepoint(" +
    longitude.to_s +
    "," +
    latitude.to_s +
    "),4326)) RETURNING cartodb_id"
  end

end

