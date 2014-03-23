module SonJay
  module Properties
    class Value < Properties::Property
      attr_accessor :value
      alias load_data value=

    end
  end
end
