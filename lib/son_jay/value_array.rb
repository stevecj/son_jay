module SonJay
  class ValueArray < ::Array
    include ActsAsModel

    def sonj_content
      self
    end

    alias load_data replace

  end
end
