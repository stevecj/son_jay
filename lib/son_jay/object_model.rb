require 'set'
require 'son_jay/object_model/properties'
require 'son_jay/object_model/property_definition'
require 'son_jay/object_model/properties_definer'
require 'son_jay/object_model/disseminator'

module SonJay
  class ObjectModel
    include ActsAsModel

    attr_reader :sonj_content

    def initialize
      definitions = self.class.property_definitions
      @sonj_content = ObjectModel::Properties.new( definitions )
    end

    def to_json(*args)
      sonj_content.to_json( *args )
    end

    def disseminate_to(*args)
      sonj_content.disseminate_to *args
    end

    class << self

      def properties(&property_initializations)
        @property_initializations = property_initializations
      end

      def property_definitions
        @property_definitions ||= nil
        return @property_definitions if @property_definitions

        definitions = []

        definer = PropertiesDefiner.new( definitions )
        definer.instance_eval &@property_initializations
        @property_definitions = definitions

        validate_model_dependencies!

        definitions.each do |d|
          name = d.name
          class_eval <<-CODE
            def #{name}         ; sonj_content[#{name.inspect}]         ; end
            def #{name}=(value) ; sonj_content[#{name.inspect}] = value ; end
          CODE
        end

        @property_definitions
      end

      def assimilate(source_obj)
        instance = new
        instance.sonj_content.assimilate source_obj
        instance
      end

      private

      def validate_model_dependencies!(dependants=Set.new)
        raise InfiniteRegressError if dependants.include?(self)
        dependants << self
        hard_model_dependencies.each do |d|
          next unless d.respond_to?( :validate_model_dependencies!, true )
          d.send :validate_model_dependencies!, dependants
        end
      end

      def hard_model_dependencies
        property_definitions.map( &:model_class ).compact.uniq
      end
    end

  end
end
