# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

checkSBSizes = (s_boxes)->
    #for i in [0..s_boxes.length]
    #    img = $(s_boxes[i]).find('.s-box-bg-img')
    #    if img.height() isnt undefined
    #        $(s_boxes[i]).height(img.height())
            

r = ()->
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