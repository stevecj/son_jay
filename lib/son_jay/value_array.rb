module SonJay
  class ValueArray < ::Array
    include ActsAsModel

    def sonj_content
      self
    end

    def load_data(data)
      replace data
    end
  end
end
