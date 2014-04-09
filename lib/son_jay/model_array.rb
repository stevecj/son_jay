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
    end

    def initialize
      @entries = []
    end

    def additional
      entry = self.class.entry_class.new
      @entries << entry
      entry
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
