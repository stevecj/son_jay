require 'json'
require 'son_jay/version'
require 'son_jay/acts_as_model'
require 'son_jay/object_model'
require 'son_jay/model_array'
require 'son_jay/value_array'

module SonJay

  class InfiniteRegressError < StandardError ; end
  class DisabledMethodError  < NameError     ; end

  class PropertyNameError < KeyError
    def initialize(name)
      super "No such property name as %s" % name.inspect
    end
  end

end
