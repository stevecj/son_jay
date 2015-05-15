module SonJay
  class ValueArray < ::Array
    include ActsAsModel

    def model_content
      self
    end

    def to_json(options = ::JSON::State.new)
      options = ::JSON::State.new(options) unless options.kind_of?(::JSON::State)
      super options
    end

    alias load_data replace

  end
end
