require 'forwardable'

module SonJay
  class ObjectModel
    class Properties
      class NameError < KeyError
        def initialize(name)
          super "No such property name as %s" % name.inspect
        end
      end

      extend Forwardable

      def initialize( property_names )
        @data = {}
        property_names.each do |prop_name|
          @data[prop_name] = nil
        end
      end

      def_delegators :@data, :length
      def_delegator :@data, :has_key?, :has_name?

      def [](name)
        name = "#{name}"
        @data.fetch(name)
      rescue KeyError
        raise NameError.new(name)
      end

      def []=(name, value)
        name = "#{name}"
        raise NameError.new(name) unless @data.has_key?(name)
        @data[name] = value
      end

      def has_name?(name)
        @data.has_key?( "#{name}" )
      end

      def to_json(*args)
        @data.to_json(*args)
      end

    end
  end
end
