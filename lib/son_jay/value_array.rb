module SonJay
  class ValueArray < ::Array
    Array = SonJay::ModelArray(self)

    def self.array_class
      self::Array
    end

    def sonj_content
      self
    end

    def load_data(data)
      replace data
    end
  end
end
