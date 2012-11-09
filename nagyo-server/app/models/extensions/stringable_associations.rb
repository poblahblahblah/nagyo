#   - will add the stringable_associations class_attribute
#   - will set stringable_associations based on model
#     - add association name if related-model has a Slugged field
#       if ModelClass.slugged_attributes exist and has one entry
#
#   - add the custom setter methods for those situations where field_id or 
#   field_ids is set manually (via console, scripts, etc)
#
#
module Extensions

  module StringableAssociations

    extend ActiveSupport::Concern

    included do

      # lookup id for an association class - can dereference model attribute 
      # values or slugged attributes into BSON ids.
      #
      def bson_from_stringable_id(value, model_name)
        return if value.blank?
        if Moped::BSON::ObjectId.legal?(value)
         return value
        end

        id_val = nil
        model_class = model_name.to_s.constantize rescue nil
        begin
          id_val = model_class.find(value).id
        rescue
          begin
            id_val = model_class.find_by(model_class.slugged_attributes.first => value).id
          rescue
            #
          end
        end
        id_val
      end

      ###

      #
      class_attribute :stringable_associations
      self.stringable_associations = determine_stringable_fields(self)

    end # included


    module ClassMethods



      def determine_stringable_fields(model)
        the_fields = []

        model.associations.each do |name, metadata|
          #logger.debug("DETERMINE_STRINGABLE #{model} ... #{name}, 
          ##{metadata}")
          assoc_model = metadata.class_name.constantize rescue nil
          next unless assoc_model
          # make sure it has some slug
          next if (assoc_model.slugged_attributes rescue []).blank?

          # ok - add to list
          the_fields << name

          # add the custom setter method per field
          #
          # NOTE: this defines a method in addition to the monkey patched 
          # RailsAdmin::MainController overrides that is used when *not* going 
          # through a RailsAdmin route.  However, it does not work with 
          # bare-association name, you must use the _id=/_ids= methods.
          #
          # Example in console to set Host.contacts:
          # > h = Host.last
          # > h.contact_ids = ["unix-sa"]
          #
          define_method("#{metadata.key}=") do |value|
            new_value = value
            if metadata.key.match(/_id$/)
              # single
              new_value = bson_from_stringable_id(value, metadata.class_name)
            elsif metadata.key.match(/_ids$/)
              # plural
              new_value = value.to_a.collect do |x|
                bson_from_stringable_id(x, metadata.class_name)
              end
            end

            super(new_value)
          end # define method


        end # each association

        the_fields
      end

    end

  end

end

