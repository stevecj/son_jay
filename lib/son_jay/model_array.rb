require 'forwardable'

module SonJay

  def self.ModelArray(entry_class)
    Class.new(ModelArray).tap{ |c|
      c.send :entry_class=, entry_class
    }
  end

  class ModelArray
    include ActsAsModel
    extend Forwardable

    class << self
      attr_accessor :entry_class
      private :entry_class=
    end

    def initialize
      @entries = []
    end

    def model_content
      self
    end

    def additional
      entry = self.class.entry_class.new
      @entries << entry
      entry
    end

    def load_data(data)
      data.each do |entry_data|
        additional.model_content.load_data entry_data
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
