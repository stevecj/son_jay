require 'son_jay/object_model/properties/abstract'
require 'son_jay/object_model/properties/properties_without_extra'
require 'son_jay/object_model/properties/properties_with_extra'

module SonJay
  class ObjectModel

    module Properties

      def self.new(property_definitions, allow_extra)
        klass = allow_extra ?
          self::PropertiesWithExtra :
          self::PropertiesWithoutExtra
        klass.new( property_definitions )
      end

    end

  end
end
