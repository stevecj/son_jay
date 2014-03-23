require 'forwardable'

module SonJay
  class ValueArrayModel

    def self.json_create(json)
      new_instance = new
      new_instance.load_json json
      new_instance
    end

    extend Forwardable

    def initialize(options={})
      @array = options[:internal_array] || nil
    end

    def_delegators :array, *(
      Array.instance_methods - Object.instance_methods - [:to_a, :to_ary]
    )

    def to_a
      array.dup
    end

    def to_json
      as_json.to_json
    end

    def load_json(json)
      load_data( JSON.parse(json) )
    end

    def load_data(data)
      array.replace data
    end

    # Returns the internal array directly for performance reasons,
    # and assumes the caller will not modify the array.
    def as_json
      array
    end

    def ===(other)
      if other.kind_of?( self.class )
        array == other.array
      elsif other.respond_to?( :to_ary )
        array == other.to_ary
      else
        false
      end
    end

    protected

    def array
      @array ||= []
    end
  end
end
