class NagiosOptionsInput < Formtastic::Inputs::CheckBoxesInput

protected

  # override the make_selected_options to split a String
  def make_selected_values
    if object.respond_to?(method)
      vals = object.send(method)
      if vals.is_a?(String)
        selected_items = vals.split(',')
      else
        selected_items = [vals].compact.flatten
      end

      [*selected_items.map { |o| send_or_call_or_object(value_method, o) }].compact
    else
      []
    end
  end
    
end
