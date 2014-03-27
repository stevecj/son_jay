require 'json'
require "son_jay/version"
require "son_jay/object_model"
require "son_jay/value_array_model"
require "son_jay/model_array"
require "son_jay/properties"
require "son_jay/model_factory"

module SonJay
end

def SonJay(&b)
  SonJay::ModelFactory.new(&b)
end
