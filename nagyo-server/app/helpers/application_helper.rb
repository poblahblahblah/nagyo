module ApplicationHelper

  # create lists of nagios-compatible comma-separated options from an Array
  # Generates a list of comma-separated sequences for each option combined with 
  # *remaining* options in list.
  #
  #   nagios_options_from_array( %w{a b c} )
  #   => %w{ a
  #          a,b
  #          a,b,c
  #          b
  #          b,c
  #          c     }
  #
  def nagios_options_from_array(array)
    options = []
    (0..array.length).to_a.combination(2).map{|i,j| array[i...j]}.sort.each do |a|
      options << a.join(',')
    end
    return options
  end

end
