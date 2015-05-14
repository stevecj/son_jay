require 'forwardable'

module SonJay
  class ObjectModel

    class ContentData
      extend Forwardable
      include Enumerable

      def initialize(data = {})
        @data = data.to_hash
      end

      def []=(name, value)
        name = "#{name}" unless String === name
        @data[name] = value
      end

      def fetch(name, *args)
        name = "#{name}" unless String === name
        block_given? ?
          @data.fetch(name, *args) { |*args| yield *args } :
          @data.fetch(name, *args)
      end

      def [](name)
        name = "#{name}" unless String === name
        @data[name]
      end

      def hash_merge(other)
        @data.dup.tap { |result|
          other.each do |name, value|
            name = "#{name}" unless String === name
            result[name] = value
          end
        }
      end

      def hash_merge(other)
        @data.dup.tap { |result|
          other.each do |name, value|
            result[name] = value
          end
        }
      end

      def freeze
        @data.freeze
        super
      end

      def to_h
        @data.dup
      end

      def dup
        self.class.new( @data.dup )
      end

      def clone
        new_copy = super
        unless new_copy.frozen?
          new_copy.instance_variable_set :@data, @data.clone
        end
        new_copy
      end

      def_delegators :@data, :each, :length, :keys, :has_key?, :empty?, :to_json

    end

  end
end
