# Dereference MongoDB ids for model associations into the String 
# representations of the model for use in Nagios configurations.
#
module Extensions
  module DereferencedJson

    # return hash of options to be converted to json string
    def as_json(opts)
      for_json = super(opts)

      # pull out ids into Strings
      keys_to_deref = for_json.keys.select { |k| !! k.to_s.match(/._ids?$/) }
      keys_to_deref.each do |k|
        field = k.gsub(/_ids?/, '')
        next if field.blank?

        if k.match(/_ids$/)
          for_json[field.pluralize] = self.send(field.pluralize).collect(&:to_s) rescue nil
        else
          for_json[field] = self.send(field).to_s rescue nil
        end
      end

      for_json
    end
  end
end

