class NagiosOptionsInput < RailsAdmin::Config::Fields::Base

  register_instance_option(:partial) do
    :nagios_options
  end

  # from Enum
  register_instance_option(:enum_method) do
    @enum_method ||= (bindings[:object].class.respond_to?("#{name}_enum") || bindings[:object].respond_to?("#{name}_enum")) ? "#{name}_enum" : name
  end

  register_instance_option(:enum) do
    bindings[:object].class.respond_to?(enum_method) ? bindings[:object].class.send(enum_method) : bindings[:object].send(enum_method)
  end

  register_instance_option(:pretty_value) do
    if enum.is_a?(::Hash)
      enum.reject{|k,v| v.to_s != value.to_s}.keys.first.to_s.presence || value.presence || ' - '
    elsif enum.is_a?(::Array) && enum.first.is_a?(::Array)
      enum.find{|e|e[1].to_s == value.to_s}.try(:first).to_s.presence || value.presence || ' - '
    else
      value.presence || ' - '
    end
  end

  register_instance_option(:multiple?) do
    true
  end

end
