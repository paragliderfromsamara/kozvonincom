# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class FilterMenu
    constructor: (
                    @fElement = null,
                    @fLocale = 'ru',
                    @opnFilterLinkId = "open-filter",
                    @fMenuId = 'filter-menu',
                    @tagListId = 'tags-list-field',
                    @selTagsListId = 'selected-tags-field',
                    @tagList = null,
                    @selTagsList = null,
                    @selTagLinkClassName = 'filter-select-tag',
                    @selectedClassName = 'selected',
                    @applyFilterButId = 'apply-filter-but',
                    @applyBut = null,
                    @resetFilterButId = 'reset-filter-but',
                    @resetBut = null,
                    @photosLoadLink = '/photos',
                    @photosTargetElementId = 'middle',
                    @targetElement = null,
                    @lastQuery = '',
                    @selCategoryClassName = 'category-filter-item',
                    @categoriesListId ="categoryList",
                    @catList = null,
                    @photoTagListItemClassName = 'filter-tag-in-list',
                    @resetFilterPath = '/reset_filter',
                    @filteringResultRowId = 'filtering-result',
                    @filterResultRow = null,
                    @receivedData = null,
                    @phLoadStep = 4, #количество подгружаемых фотографий
                    @firstFilteringWlId = "first-filtering",
                    @firstLoadingMsg = {ru: "Идёт поиск", com: "Searching"},
                    @loadingMsg = {ru: "Загрузка", com: "Loading"},
                    @filterHeader = {ru: "Результат поиска", com: "Filtering Result"},
                    @firstUploadProcElId = "first-upload-wl",
                    @noPhotosMsg = {ru: "Нет фотографий удовлетворяющих выбранным критериям", com: "No photos meet the selected criteria"},
                    @showMoreButName = {ru: "Ещё %d", com: "%d more"},
                    @showMoreButId = 'filter-show-more',
                    @headerEl = "<div class=\"row tb-pad-s\"><div class=\"small-12 columns\"><h1>%h</h1></div></div>",
                    @noPhotosMessageBlock = "<div class = \"small-12 columns\"><p>%m</p></div>"
                  )-> 
    
    isCompletedFilter: ->
        sTags = @selectedTags()
        sCats = @selectedCategories()
        if sTags.length is 0 && sCats.length is 0 then @applyBut.addClass('disabled') else @applyBut.removeClass('disabled')
        if sTags.length > 0 then @selTagsList.find("#empty-tag-list-msg").hide() else @selTagsList.find("#empty-tag-list-msg").show() 
    
    applyFilter: ()->
        _this = this
        sTags = @selectedTags()
        sCats = @selectedCategories()
        tags = cats = ''
        newQuery = {}
        if sTags.length > 0 or sCats.length > 0
            sTags.each (i)->
                tags += "[#{$(this).attr 'tag-id'}]"
            sCats.each (i)->
                cats += "[#{$(this).attr 'category-id'}]"
            newQuery = "tags=#{tags}&categories=#{cats}"
            if newQuery isnt @lastQuery
                @checkFilterResultRow()
                @addFirstLoadWaitLine()
                @fillHeader()
                wl = new waitbar(@firstFilteringWlId,  @firstLoadingMsg[@fLocale])
                wl.startInterval()
                @lastQuery = newQuery
                #getPhotosFromJson(newQuery, @photosTargetElementId)
                $.ajax {
                        dataType: "json"
                        type: "GET"
                        url: '/photos'
                        data: newQuery
                        success: (data)->
                            wl.stopInterval()
                            _this.filterResultRow.empty()
                            _this.receivedData = data
                            _this.drawByPageNumber(true)
                            $('.orbit').hide()
                        
                }
    fillHeader: ()->
        h = $('h1')
        if h.length is 0
            t = @headerEl.replace("%h", @filterHeader[@fLocale])
            @fElement.after t
        else
            $(h[0]).text @filterHeader[@fLocale]
    addFirstLoadWaitLine: ()->
        @filterResultRow.html("<div class = 'small-12 columns'><div id = \"#{@firstFilteringWlId}\"></div></div>")
            
    checkFilterResultRow: ()->
        t = document.getElementById @photosTargetElementId
        b = document.getElementById @filteringResultRowId
        if t is null 
            console.error "Target filer element with id = #{@photosTargetElementId} doesn't exist!" 
        else
            @targetElement = $(t)
            if b is null 
                @targetElement.html "<div id = \"#{@filteringResultRowId}\" class = \"row small-up-4\"></div>"
                @filterResultRow = @targetElement.find("##{@filteringResultRowId}")
            else
                @filterResultRow = $(b)
    
    delShowMoreBut: ()->
       $("##{@showMoreButId}").parents('.row').remove()     
               
    initShowMoreBut: (d)->
        _this = this
        b = document.getElementById(@showMoreButId)
        if b is null
            @targetElement.append("<div class = \"row\"><div class = \"small-12 columns\"><a id = \"#{@showMoreButId}\" class = \"button secondary\">#{@showMoreButName[@fLocale].replace("%d", d)}</a></div></div>")
            b = $("##{@showMoreButId}")
        else 
            b = $(b)
        b.unbind('click').bind "click", ()->
            _this.delShowMoreBut()
            _this.drawByPageNumber()
                
                                
    drawByPageNumber: ()->
        v = ''
        s = $(".filter-result").length #количество отбраженных фотографий
        fs = if @receivedData is undefined or @receivedData is null then 0 else @receivedData.length #общее количество полученных фотографий
        if fs isnt 0
            e = if s + @phLoadStep < fs then s + @phLoadStep-1 else fs-1
            for i in [s..e]
                url = "/photos/"+@receivedData[i].id
                url += if @lastQuery.length is 0 then "" else "?#{@lastQuery}&index=#{i}"
                v += @drawPhotoThumb(@receivedData[i], url)
            @filterResultRow.append v
            s = $(".filter-result").length
            if s isnt fs
                d = if s + @phLoadStep >= fs then fs-s else @phLoadStep  
                @initShowMoreBut(d)
            else
                @delShowMoreBut()
        else
            m = @noPhotosMessageBlock.replace "%m", @noPhotosMsg[@fLocale]
            @filterResultRow.html m
            @delShowMoreBut()
        console.log "s=#{s} fs=#{fs}"
               
                 
    drawPhotoThumb: (photo, url)->
        "<div class=\"column\"><a target = \"_blank\" href = \"#{url}\"><img class = \"thumbnail filter-result\" src = \"#{photo.link.medium_sq.url}\"></a></div>"

    reset: ->
        _this = this
        sTags = @selectedTags()
        sCats = @selectedCategories()
        if sTags.length > 0 then sTags.click()
        if sCats.length > 0 then sCats.click()
        $.ajax {
                dataType: 'json'
                type: "GET"
                url: _this.resetFilterPath
                data: "categories=&tags="
                success: (data)->
                    if data isnt 'success' then console.error data
                        
        }
            
    init: ->
        _this = this
        @fLocale = if @fElement.attr('locale') isnt undefined then @fElement.attr('locale') else 'ru'
        l = document.getElementById(@opnFilterLinkId)
        if l is null then console.error("Open filter link with id = #{@opnFilterLinkId} doesn't exist!!!") else $(l).bind 'click', ()-> _this.toggle()
        @initTagsSelectElement()
        @initCategorySelectElement()
        aBut = document.getElementById @applyFilterButId
        rBut = document.getElementById @resetFilterButId
        if aBut is null 
            console.error "Apply button with id = #{@applyFilterButId} doesn't exist!!!" 
        else 
            @applyBut = $(aBut)
            @applyBut.bind "click", ()-> if !$(this).hasClass("disabled") then _this.applyFilter()
            @isCompletedFilter()
        if rBut is null
           console.error "Reset button with id = #{@resetFilterButId} doesn't exist!!!"
        else
            @resetBut = $(rBut)
            @resetBut.bind "click", ()-> _this.reset()
        #при нажатии на тэг из списка под фотографией, ниже указанный код произведет поиск по нажатому тэгу
        $("a.#{@photoTagListItemClassName}").click ()->
            id = $(this).attr 'tag-id'
            tags = _this.tagsList.find("a.#{_this.selTagLinkClassName}")
            _this.reset()
            _this.open(true)
            v = false
            tags.each ()->
                if $(this).attr('tag-id') is id
                    $(this).click()
                    v = true
                    return true
            if v then _this.applyFilter()
               
            
        #console.log "Filter menu started"
    
    initCategorySelectElement: ->
        _this = this
        @catList = document.getElementById(@categoriesListId)
        if @catList is null 
            console.error("Список категорий с id = %s не найден", @categoriesListId)
        else
            @catList = $(@catList)
            badgeNotSelectedClass = "primary"
            badgeSelectedClass = "success"
            fiSel = 'fi-check'
            fiNotSel = 'fi-plus'
            @catList.find("a").click ()->
                el = $(this)
                b = $(this).find('.badge')
                if el.hasClass(_this.selectedClassName)
                    el.removeClass(_this.selectedClassName)
                    b.find('i').removeClass(fiSel).addClass(fiNotSel)
                    b.removeClass(badgeSelectedClass).addClass(badgeNotSelectedClass)
                else
                    el.addClass(_this.selectedClassName)
                    b.find('i').removeClass(fiNotSel).addClass(fiSel)
                    b.removeClass(badgeNotSelectedClass).addClass(badgeSelectedClass)
                _this.isCompletedFilter()

    selectedCategories: ->
        @catList.find "a.#{@selectedClassName}"
                     
        
    initTagsSelectElement: -> 
        _this = this
        el = @fElement 
        tList = document.getElementById(@tagListId)
        stList = document.getElementById(@selTagsListId)
        if tList is null then console.error("Tag list with id = #{@tagListId} doesn't exist!!!") else @tagsList = $(tList)
        if stList is null then console.error("Selected Tags list with id = #{@selTagsListId} doesn't exist!!!") else @selTagsList = $(stList)
        if @selTagsList.find('ul').length is 0 then @selTagsList.append("<ul></ul>")
        selectedList = @selTagsList.find('ul')
        selectedList.find('a').unbind().bind 'click', ()-> _this.removeTagFromList(this)
        @tagsList.find("a.#{@selTagLinkClassName}").bind 'click', ()->
            if $(this).hasClass(_this.selectedClassName) then _this.removeTagFromList(this) else _this.selectTagToList(this)
        #console.log "2. Tags menu initialized"
        
        
    toggle: ->
        if @fElement.css('display') is 'none' then @open() else @close()   
    close: (isQuick)->
        if isQuick is true
            @fElement.hide()
        else
            if @fElement.css('display') isnt 'none' then @fElement.slideUp(500) 
    open: (isQuick)-> 
        if isQuick is true
            @fElement.show()
        else
            if @fElement.css('display') is 'none' then @fElement.slideDown(500) 
           
    selectedTags: ->
        @selTagsList.find("a")
        
    selectTagToList: (e)->
        _this = this
        e = $(e)
        e.addClass(@selectedClassName)
        e.find("p").prepend @selectedBadge()
        selectedList = @selTagsList.find("ul")
        if selectedList.find("[tag-id=#{e.attr('tag-id')}]").length is 0
            selectedList.append(@buildSelectedTagElement(e.attr('tag-id'), e.text()))
            selectedList.find('a').unbind().bind 'click', ()-> _this.removeTagFromList(this)
            e.parents('li').removeClass('active')
            @isCompletedFilter()
        #console.log "it's selectTagToList func"
        
    removeTagFromList: (e)->
        e = $(e)
        listEl = @tagsList.find("[tag-id=#{e.attr('tag-id')}]")
        listEl.removeClass(@selectedClassName)
        listEl.find('.badge').remove()
        @selTagsList.find("[tag-id=#{e.attr('tag-id')}]").parents('li').remove()
        if @selTagsList.find('li').length is 0 
            @isCompletedFilter()
        #console.log "it's removeTagFromList func"
    
    buildSelectedTagElement: (id, val)->
        "<li><span>#{val} <a tag-id = \"#{id}\"><i class = \"fi-x fi-medium\"></i></a></span></li>"  
            
    selectedBadge: ->
        "<span class=\"badge success\"><i class = \"fi-check\"></i></span> "



r = ->
    fMenu = new FilterMenu() 
    fMenuEl = document.getElementById(fMenu.fMenuId)
    if fMenuEl isnt null
        fMenu.fElement = $(fMenuEl) 
        fMenu.init()
    else fMenu = null
    

$(document).on "turbolinks:load", r