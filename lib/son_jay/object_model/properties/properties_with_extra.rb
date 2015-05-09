module SonJay
  class ObjectModel
    module Properties

      class PropertiesWithExtra < Abstract

        def extra
          @extra ||= ObjectModel::ExtraData.new
        end

        def each
          @data.each do |(name, value)|
            yield name, value
          end
          @extra.each do |(name, value)|
            yield name, value
          end
        end

        private

        def load_extra_property(name_string, value)
          extra[ name_string ] = value
        end

        def hash_for_json
          extra.empty? ?
            @data :
            extra.hash_merge( @data )
        end

      end

    end
  end
end
