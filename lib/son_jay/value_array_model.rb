require 'delegate'

module SonJay
  class ValueArrayModel < DelegateClass(Array)

    def self.json_create(json)
      new_instance = new
      new_instance.load_json json
      new_instance
    end

    def initialize(options={})
      array = options[:internal_array] || []
      super array
    end

    def to_a
      __getobj__.dup
    end

    def to_json
      as_json.to_json
    end

    def load_json(json)
      load_data( JSON.parse(json) )
    end

    alias load_data replace

    # Returns the internal array directly for performance reasons,
    # and assumes the caller will not modify the array.
    alias as_json __getobj__

    protected :__getobj__, :__setobj__

  end
end
