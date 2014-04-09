require 'forwardable'

module SonJay

  def self.ModelArray(entry_class)
    Class.new(ModelArray).tap{ |c|
      c.send :entry_class=, entry_class
    }
  end

  class ModelArray
    extend Forwardable

    class << self
      attr_accessor :entry_class

      def array_class
        #TODO: Factor out duplication w/ ObjectModel::array_class
        @array_class ||= begin
          klass = SonJay::ModelArray(self)
          const_set :Array, klass
        end
      end
    end

    def initialize
      @entries = []
    end

    def sonj_content
      self
    end

    def additional
      entry = self.class.entry_class.new
      @entries << entry
      entry
    end

    def load_data(data)
      data.each do |entry_data|
        additional.sonj_content.load_data entry_data
      end
    end

    def_delegators :@entries, *[
      :[] ,
      :empty? ,
      :entries ,
      :length ,
      :to_json ,
    ]

  end
end
