module SonJay
  class ObjectModel
    module Content

      class ContentWithExtra < Abstract

        def extra
          @extra ||= ObjectModel::ContentData.new
        end

        def each
          @data.each do |(name, value)|
            yield name, value
          end
          @extra.each do |(name, value)|
            yield name, value
          end
        end

        def freeze
          super
          @extra.freeze
          self
        end

        def dup
          new_copy = super
          new_copy.instance_variable_set :@extra, @extra.dup if defined? @extra
          new_copy
        end

        def clone
          new_copy = super
          if (defined? @extra) && (! new_copy.frozen?)
            p new_copy.frozen?
            new_copy.instance_variable_set :@extra, @extra.clone
          end
          new_copy
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
