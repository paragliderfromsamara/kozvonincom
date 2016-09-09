# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
photoPathFieldId = "phContent"
fVisible=-1
lVisible=-1
maxVBlocks=7
offset = (maxVBlocks-1) / 2
sumPagWidth = 0
blC = 0
height = 0
width = 0
photo = null

goToLink = (link)->
    if link isnt '' && link isnt undefined then document.location.href = link
    
updScrIndexes = (f)->
    if f is 'left'
        if (lVisible-(maxVBlocks-1)) >= 0
            fVisible = lVisible-(maxVBlocks-1)
        else
           fVisible = 0
           lVisible = maxVBlocks-1
    else if f is 'right'
        if fVisible+(maxVBlocks-1) < blC
            lVisible = fVisible+(maxVBlocks-1)
        else
            fVisible = blC - maxVBlocks-1
            lVisible = blC-1
    if fVisible is 0 then $(".ph-arr-left").css("visibility", "hidden") else $(".ph-arr-left").css("visibility", "visible")
    if lVisible is (blC-1) then $(".ph-arr-right").css("visibility", "hidden") else $(".ph-arr-right").css("visibility", "visible")



updPhotoPaginate = (f)->
    j=0
    $(".ph-paginate").each (i)->
        if f is 'init'
            if not $(this).hasClass('ph-h')
                fVisible=i
                updScrIndexes('right')
                return false
        else
            if (j<fVisible) or (lVisible < j) then $(this).addClass('ph-h') else $(this).removeClass('ph-h')
        j++

initPhotoPage = ()->
    blC = $(".ph-paginate").length
    if blC > maxVBlocks
        updPhotoPaginate('init')
        $(".ph-arrows").removeClass('ph-h')
    else
        sumPagWidth = blC*($(".ph-paginate").outerWidth(true)+1+parseInt($(".ph-paginate").css("border-width"))*2)
        $("#paginationLine").width(sumPagWidth)
    $(document).keyup (event)->
        if event.keyCode is 37 then goToLink $("#prev-photo-link").attr('href')
        else if event.keyCode is 39 then goToLink $("#next-photo-link").attr('href')

r = ()->
    initPhotoPage()
    $(".ph-arr-right").click ()->
        if fVisible+(maxVBlocks-1) isnt blC-1
            fVisible++
            updScrIndexes('right')
            updPhotoPaginate('upd')
    $(".ph-arr-left").click ()->
        if lVisible-(maxVBlocks-1) isnt 0
            lVisible--
            updScrIndexes('left')
            updPhotoPaginate('upd')
       
$(document).on "turbolinks:load", r
