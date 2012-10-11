module Extensions

  module StringableAssociations

    extend ActiveSupport::Concern

    included do
      #
      class_attribute :stringable_associations

      #
      self.stringable_associations = determine_stringable_fields(self)
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
        end

        the_fields
      end

    end

  end

end

