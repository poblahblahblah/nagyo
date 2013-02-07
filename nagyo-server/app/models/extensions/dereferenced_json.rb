# Dereference MongoDB ids for model associations into the String 
# representations of the model for use in Nagios configurations.
#
module Extensions
  module DereferencedJson
    # Dereference Nagyo model ids into Nagios String representations for the JSON output
    module NagyoIds

      # return hash of options to be converted to json string, converting nagyo 
      # model ids into model slugged strings
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

    # Combine Command and Command Arguments into single string output
    #
    # FIXME: TODO: should we store command_arguments as Array in mongo? String with delimeter?
    #              how to edit in rails_admin forms?
    #
    module NagyoCommandArgs

      # add the command arguments to command names
      def as_json(opts)
        for_json = super(opts)

        # find those single command keys ...  e.g. Host.check_command
        command_keys = for_json.keys.select { |k| !! k.to_s.match(/._command?$/) }
        command_keys.each do |k|
          arg_field = k + "_arguments"
          next if for_json[arg_field].blank?

          begin
            # combine command name with arguments
            for_json[k] = (
              [self.send(k).to_s] + self.send(arg_field).to_a
            ).join("!")
          rescue
            for_json[k] = self.send(k).to_s rescue nil
          end
        end

        for_json
      end

    end


    # NOTE: Id deref needs to occur before Command args additions
    include NagyoIds
    include NagyoCommandArgs
  end
end

