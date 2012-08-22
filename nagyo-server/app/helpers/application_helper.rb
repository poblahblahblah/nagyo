module ApplicationHelper

  def options_from_array(array)
    options = []
    (0..array.length).to_a.combination(2).map{|i,j| array[i...j]}.sort.each do |a|
      options << a.join(',')
    end
    return options
  end

end
