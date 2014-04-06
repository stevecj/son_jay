module SonJay
  class ValueArray < ::Array

    def sonj_content
      self
    end

    def load_data(data)
      replace data
    end
  end
end
