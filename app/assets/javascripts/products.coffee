# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".remove-btn").on "ajax:send", (e, data, status, xhr) ->
    $(this).parent().css('display','none')
    $(".remove-btn").data('newqty', $(this).data('newqty'))
