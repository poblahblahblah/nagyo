#   - will add the stringable_associations class_attribute
#   - will set stringable_associations based on model
#     - add association name if related-model has a Slugged field
#       if ModelClass.slugged_attributes exist and has one entry
#
#   - add the custom setter methods for those situations where field_id or 
#   field_ids is set manually (via console, scripts, etc)
#
module Extensions

  module StringableAssociations

    extend ActiveSupport::Concern

    included do
      #
      class_attribute :stringable_associations

      #
      self.stringable_associations = determine_stringable_fields(self)

      # lookup id for an association class - can dereference slugged ids into 
      # BSON ids
      def bson_from_stringable_id(value, model_name)
        Moped::BSON::ObjectId.legal?(value) ? value : (model_name.to_s.constantize.find(value).id rescue nil)
      end

    end


    module ClassMethods

      def determine_stringable_fields(model)
        logger.debug("DETERMINE_STRINGABLE for #{model}")
        the_fields = []

        model.associations.each do |name, metadata|
          assoc_model = metadata.class_name.constantize rescue nil
          next unless assoc_model
          # make sure it has some slug
          next if (assoc_model.slugged_attributes rescue []).blank?

          # ok - add to list
          the_fields << name

          # add the custom setter method per field
          #
          # NOTE: this defines a method in addition to the 
          # RailsAdmin::MainController overrides that is used when *not* going 
          # through RailsAdmin.  But, it does not work with bare-association 
          # name, must use _id=/_ids= methods.
          #
          # Example in console to set Host.contacts:
          # > h = Host.last
          # > h.contact_ids = ["unix-sa"]
          #
          define_method("#{metadata.key}=") do |value|
            new_value = nil
            if metadata.key.match(/_id$/)
              # single
              new_value = bson_from_stringable_id(value, metadata.class_name)
            elsif metadata.key.match(/_ids$/)
              # plural
              new_value = value.to_a.collect do |x|
                bson_from_stringable_id(x, metadata.class_name)
              end
            end

            # set it
            super(new_value)

          end # define method


        end # each association

        the_fields
      end

    end

  end

end

