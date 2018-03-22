# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".remove-btn").on "ajax:send", (e, data, status, xhr) ->
    $(this).parent().css('display','none')
    qty = $(this).data('qty')
    price = $(this).data('price')
    totalqty = $(this).data('totalqty')
    totalprice = $(this).data('totalprice')
    newqty = totalqty - qty
    newprice = totalprice - price
    $('#totalqty').html(newqty)
    $('#totalprice').html(newprice)
