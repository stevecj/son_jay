require 'son_jay/object_model/content/abstract'
require 'son_jay/object_model/content/content_without_extra'
require 'son_jay/object_model/content/content_with_extra'

module SonJay
  class ObjectModel

    module Content

      def self.new(property_definitions, allow_extra)
        klass = allow_extra ?
          self::ContentWithExtra :
          self::ContentWithoutExtra
        klass.new( property_definitions )
      end

    end

  end
end
