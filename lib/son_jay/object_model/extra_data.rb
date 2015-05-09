require 'forwardable'

module SonJay
  class ObjectModel

    class ExtraData
      extend Forwardable
      include Enumerable

      def initialize
        @data = {}
      end

      def []=(name, value)
        name = "#{name}" unless String === name
        @data[name] = value
      end

      def [](name)
        name = "#{name}" unless String === name
        @data[name]
      end

      def hash_merge(other)
        @data.merge( other )
      end

      def to_h
        @data.dup
      end

      def_delegators :@data, :empty?, :each

    end

  end
end
