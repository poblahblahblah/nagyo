# toggle-button class will have a trigger to toggle the next div with 
# toggle-section


$(document).ready ->
  $(".toggle-button, .toggleButton").click ->
    # div to replace
    toggle_div = $(this).data("toggle-div") || $(this).attr("id")
    $("#"+toggle_div).slideToggle('slow')


