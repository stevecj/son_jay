require 'son_jay/object_model/properties'

module SonJay
  class ObjectModel

    class PropertiesDefiner

      def initialize(names, property_models)
        @names           = names
        @property_models = property_models
      end

      def property(name, options={})
        name = "#{name}"
        @names << name
        @property_models[name] = options[:model]
      end

    end

    class << self

      def json_create(json)
        data = JSON.parse( json )
        instance = new
        instance.sonj_properties.load_data data
        instance
      end

      def properties(&property_initializations)
        @property_initializations = property_initializations
      end

      def property_names
        @property_names ||= begin
          names = []

          #TODO: Clean up this mess.
          @property_models ||= {}

          definer = PropertiesDefiner.new(names, @property_models)
          definer.instance_eval &@property_initializations
          names.each do |name|
            class_eval <<-CODE
              def #{name}         ; sonj_properties[#{name.inspect}]         ; end
              def #{name}=(value) ; sonj_properties[#{name.inspect}] = value ; end
            CODE
          end
          names
        end
      end

      attr_reader :property_models

    end

    attr_reader :sonj_properties

    def initialize
      prop_names = self.class.property_names
      property_models = self.class.property_models
      @sonj_properties = ObjectModel::Properties.new(prop_names, property_models)
    end

    def to_json(*args)
      sonj_properties.to_json(*args)
    end

  end
end
