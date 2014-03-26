require 'json'
require "son_jay/version"
require "son_jay/object_model"
require "son_jay/value_array_model"
require "son_jay/model_array"
require "son_jay/properties"
require "son_jay/classish_proc"

module SonJay

  def self.[]
    ClassishProc.new{ SonJay::ValueArrayModel.new }
  end

end
