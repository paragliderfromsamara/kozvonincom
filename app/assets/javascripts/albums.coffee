# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

editPhotosContainer = "#edit_photos_container"
counter = 0
trbLinkReadyFlag = false



initAlbumForm = (c)->
	form = $(c).find("form.edit_album, form.new_album")
	if form.hasClass("edit_album")
        aId = form.attr("id").replace "edit_album_", ""
        link = "/edit_photos?album_id=#{aId} #{editPhotosContainer}"
    $("#submitAlbumForm").hover (()-> $("#album_status_id").val 2), (()-> $("#album_status_id").val 1) 
	$("#edit_photos_wrapper").load link, ()-> 
        initPhotoButEvents()
    drInit(link)
	
drInit = (loadLink)->
    console.log loadLink
    $("form#drop").dropzone({
        method: "POST"
        paramName: "photo[link]"
        success: (file, response)->
            $("#edit_photos_wrapper").load loadLink, ()->
                initPhotoButEvents()
                $(".dz-preview").each ()->
                    if $(this).hasClass('dz-complete') 
                        $(this).remove()
                        Dropzone.reset()
                    
            })

initPhotoFormListners = ()->
    f = $("#editPhotoForm").find('form')
    f.find('a').click ()-> rmvTagFromList(this)
    f.find('input.new_tag_field').change ()-> 
        updTagNames(this)
        console.log "555"
    f.on "ajax:success", (e, data, status, xhr)->
        _this = this
        $(this).find(".success").fadeIn(350)
        setTimeout ()-> 
            $(_this).find(".success").fadeOut(350)
        , 3000
    f.on "ajax:error", (e, data, status, xhr)->
        _this = this
        $(this).find(".alert").fadeIn(350)
        setTimeout ()-> 
            $(_this).find(".alert").fadeOut(350)
        , 3000
    f.find("input, textarea").bind "change", ()->
        if !$(this).hasClass("new_tag_field") then $(this).parents("form").submit()
    
initPhotoButEvents = ->
	$("a.ph-rmv").on "ajax:success", (e, data, status, xhr) ->
		$(this).parents(".column").fadeOut 700, ()-> $(this).remove()
	$("a.ph-edit").bind "click", () ->
        _this = this
        $("#editPhotoForm div").load "/photos/#{$(this).attr('ph-id')}/edit .photo-form", ()-> 
            $('#editPhotoForm').foundation('open')
            initPhotoFormListners()		


            
newTagFieldButEnterClick = (el)->
	updTagNames(el)

rmvTagFromList = (el)->
	tagNameList = $('#editPhotoForm').find("#tag_names_list")
	$(el).parents('li').hide(500, ()-> 
        $(this).remove()
        updTagNameField(tagNameList))
	
	
updTagNameField = (tagNameList)->
    ru_val = com_val = ""
    f_ru = $('#editPhotoForm').find("#photo_ru_tag_names")
    f_com = $('#editPhotoForm').find("#photo_com_tag_names")
    vals = tagNameList.find('span')
    if vals.length > 0
        vals.each (i)->
            t = $.trim($(this).text())
            if t.length > 0
                if $(this).attr('locale') is 'com'
                    com_val += "[#{t}]"
                else
                    ru_val += "[#{t}]"
    f_ru.val ru_val
    f_com.val com_val
    $(tagNameList).parents("form").submit()
    console.log "#{f_ru.val()}"
    console.log "#{f_com.val()}"


updTagNames = (el)->
	tagNameList = $(el).parents('form').find("#tag_names_list")
	tagNameList.prepend "<li><span locale = \"#{$(el).attr('locale')}\">#{$(el).val()} <a><i class = \"fi-x fi-medium\"></i></a></span></li>"
	$(el).val ""
	updTagNameField(tagNameList)
	tagNameList.find('a').unbind("click")
	tagNameList.find('a').bind "click", ()->
		rmvTagFromList(this)		
	
	
r = ()->
    c = document.getElementById("albumFormContainer")
    if c isnt null then initAlbumForm(c)
    $("#editPhotoForm").on "closed.zf.reveal", ()-> $(this).find('div').html('')

trbLinkReadyFunc = ->
    trbLinkReadyFlag = true
    r()

#docReadyFunc = ->
#    if !trbLinkReadyFlag then r()
    
#$(document).ready docReadyFunc()
$(document).on "turbolinks:load", trbLinkReadyFunc
