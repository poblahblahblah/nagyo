module ApplicationHelper

  # create lists of nagios-compatible comma-separated options from an Array
  # Generates a list of comma-separated sequences for each option combined with 
  # *remaining* options in list.
  #
  #   nagios_options_from_array( %w{a b c} )
  #   => %w{ a
  #          a,b
  #          a,b,c
  #          a,c
  #          b
  #          b,c
  #          c     }
  #
  # TODO: maybe a different interface for selection is more appropriate: try an 
  # embedded document? Array of Strings? and make checkboxes for each possible 
  # option, just selecting/deselecting and then collapsing to comma-sep string
  #
  def nagios_options_from_array(input)
    options = []
    (1..input.length).to_a.each do |k|
      options += input.sort.combination(k).to_a.collect {|x| x.join(',') }
    end
    return options
  end


  # determine if any of the passed model  is current_page?
  def any_is_current_page?(models_names)
    current = false
    models_names.each do |model|
      current ||= current_page?(send("#{model}_path"))
    end
    return current
  end

end
