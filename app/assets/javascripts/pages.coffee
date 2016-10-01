# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
blocksSumHeight = ()-> 
    $('#top').outerHeight(true) + $('#middle').outerHeight(true) + $('#footer').outerHeight(true)

bottomControl = ()-> 
    sum_h = blocksSumHeight()
    window_h = $(window).height
    markOffset = $("#footerMark").offset().top
    new_middle_h = 0
    if (markOffset + $('#footer').outerHeight(true)) < window_h
        new_middle_h = window_h - $('#top').outerHeight(true) - $('#footer').outerHeight(true)
        $('#middle').height(new_middle_h)
        $('#footer').css('position', 'fixed').css('bottom', '0')
    else
        new_middle_h = markOffset - $('#top').outerHeight(true)
        $('#footer').css('position', 'relative').css('bottom', 'none')
        $('#middle').css('height', 'auto')#.height(new_middle_h)
    console.log "#{$('#top').outerHeight(true)} #{$('#middle').outerHeight(true)} #{$('#footer').outerHeight(true)}"


checkSBSizes = (s_boxes)->
    #for i in [0..s_boxes.length]
    #    img = $(s_boxes[i]).find('.s-box-bg-img')
    #    if img.height() isnt undefined
    #        $(s_boxes[i]).height(img.height())
            

r = ()->
    $(document).click ()-> bottomControl()
    $(document).mouseover ()-> bottomControl()
    $(window).resize ()-> bottomControl()
    notice = document.getElementById("notice")
 #   s_boxes = document.getElementsByClassName('s-box')
 #   if s_boxes.length > 0 then checkSBSizes(s_boxes)
    if notice isnt null
        if $(notice).text() isnt ''
            setTimeout (()-> $(notice).fadeOut(700)), 3000
        else $(notice).hide()
                
#    if notice isnt null
#        if $(notice).text() isnt ''
#			setTimeout (()-> $(notice).fadeOut(700)), 3000 
#		else $(notice).hide()
		
	

$(document).ready r
$(document).on "page:load", r