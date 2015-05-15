require 'forwardable'

module SonJay
  include Enumerable

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

    def freeze
      super
      @entries.freeze
      self
    end

    def dup
      new_copy = super
      new_copy.instance_variable_set :@entries, @entries.dup
      new_copy
    end

    def clone
      new_copy = super
      new_copy.instance_variable_set :@entries, @entries.clone unless new_copy.frozen?
      new_copy
    end

    def_delegators :@entries, *[
      :[] ,
      :at ,
      :choice,
      :collect,
      :count ,
      :cycle ,
      :drop ,
      :drop_while ,
      :each ,
      :each_index,
      :empty? ,
      :entries ,
      :fetch ,
      :find_index ,
      :first ,
      :include? ,
      :index ,
      :last ,
      :length ,
      :map ,
      :product ,
      :size ,
      :to_json ,
      :to_yaml ,
      :zip
    ]

    alias to_a entries

  end
end
