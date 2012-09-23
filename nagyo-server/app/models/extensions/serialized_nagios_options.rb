# This extension can serialize an array of simple string options into a 
# comma-separated String for nagios usage.
#
# Usage in model:
#
#    field :host_notification_options, :type => String
#    serialize_nagios_options :host_notification_options, %w{d u r}
#
module Extensions

  module SerializedNagiosOptions
    extend ActiveSupport::Concern

    included do


      protected 

      def comma_serialize_options(choices)
        # if it's an array, serialize, else leave alone
        if choices.is_a?(Array)
          choices = choices.reject(&:blank?).sort.join(",")
        end
        choices
      end

    end

    module ClassMethods
      # add a class-level method to set up the class-level accessor overrides
      def serialize_nagios_options(field, opts={})
        class_eval do

          define_method("#{field}=") do |val|
            super(comma_serialize_options(val))
          end

          define_method("#{field}_enum") do
            opts[:valid]
          end

          # check options against valid list
          validate do |record|
            chosen = record.send(field).to_a.collect {|e| e.split(',') }.flatten.uniq
            valid  = record.send("#{field}_enum").to_a
            unless (chosen - valid).empty?
              record.errors.add(field, "Invalid selection, valid options are: #{valid.join(', ')}.")
            end
          end

          # handle defaults after initialization
          unless opts[:default].blank?
            after_initialize do
              if send(field).blank?
                send("#{field}=", opts[:default])
              end
            end
          end
          #
        end # class_eval

      end # serialize_nagios_options
    end

  end
end

