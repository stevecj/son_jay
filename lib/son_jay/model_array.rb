require 'forwardable'

module SonJay
  class ModelArray
    extend Forwardable

    def initialize( element_factory, initial_length )
      @element_factory = element_factory
      @_array = Array.new( initial_length ){ |i| element_factory.call }
    end

    def_delegators :_array, *[
      :empty? ,
      :fetch ,
      :first ,
      :last ,
      :length ,
      :== ,
      :[] ,
    ]

    def push!
      element = element_factory.call
      _array << element
      element
    end

    def unshift!
      element = element_factory.call
      _array.unshift element
      element
    end

    def to_json
      as_json.to_json
    end

    protected

    attr_reader :_array, :element_factory

    alias as_json _array

  end
end
