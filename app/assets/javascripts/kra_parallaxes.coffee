# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
pbClassName = 'kra-site-block'


prlxBlks = []



getBlocks = ->
    blcs = $(".#{pbClassName}")
    if blcs.length > 0 
        prlxBlks = new Array(blcs.length)
        blcs.each (i)->
            pBl = new parallaxBlock($(this))
            pBl.initPrlxBlock()
            prlxBlks[i] = pBl
        for i in [0..prlxBlks.length-1]
            console.log prlxBlks[i].bgId
             

goParallaxAction = ->
    for i in [0..prlxBlks.length-1]
        prlxBlks[i].calBgPosition()
  

myParalaxes = ->
    getBlocks()
    if prlxBlks.length > 0
        goParallaxAction()
        $(window).scroll ()->
            goParallaxAction()
        $(window).resize ()->
            goParallaxAction()

class parallaxBlock
    constructor: (
        @block = undefined              #блок
        @topOffset = 0                  #отступ блока от верхней границы документа
        @bgId = "img_wrapper"
        @cntSelectors = ".thumbnail, #kra-block-name"              #селекторы понятные jQuery
        @containsWrapper = false        #есть ли подложка
        @cTopOffset = 0                 #Отступ контента от верхней границы документа
        @blHeight = 0                   #высота блока
        @bgHeight = 0                   #высота подложки
        @heightCoeff = 0.0              #коэффициент изменения
        @startPoint = 0                 #начальная точка движения подложки
        @endPoint = 0                   #конечная точка движения подложки
        @speed = 1.0                    #скорость движения подложки
        @baseBgOffset = 0.0             #стартовый отступ
        @curScrlTop = 0                 #текущее положение вертикального скроллера
        @startPosition = ""
    )->
        @background = @block.find("##{@bgId}") #подложка
        @content = @block.find(@cntSelectors) #блок контента 
        
    
    initPrlxBlock: ->
        #@content.fadeOut()
        if @content.offset()? then @cTopOffset = @content.offset().top else @content = undefined
        @blHeight = @block.height()
        @bgHeight = @background.height()
        if @blHeight < @bgHeight
            if @background.attr('pb-speed')? then @speed = parseFloat(@background.attr('pb-speed')) #скорость
            if @background.attr('pb-start-position')? undefined
                @startPosition = @background.attr('pb-start-position')
                if @startPosition is 'out' then @baseBgOffset = (@bgHeight*@speed) / 2
            @containsWrapper = true
            @getHeightCoeff()
    
    getHeightCoeff: ->
        @getKeyPoints()
        @heightCoeff = (parseFloat(this.bgHeight-this.blHeight+this.baseBgOffset)) / parseFloat(this.endPoint-this.startPoint)
    
    getKeyPoints: ->
        @topOffset = @block.offset().top
        wHeight = $(window).height()
        startOffsets = parseFloat(wHeight)*0.2
        docHeight = $(document).height()
        blBotScrlTop = @blHeight + @topOffset
        @startPoint = if @topOffset<wHeight then 0 else @topOffset-wHeight
        @endPoint = if (docHeight-wHeight)<blBotScrlTop then docHeight-wHeight else blBotScrlTop-startOffsets
    
    calBgPosition: ->
        @curScrlTop = $(window).scrollTop()
        if @curScrlTop>=@startPoint and @curScrlTop<@endPoint and @containsWrapper is true
            span = @startPoint - @curScrlTop
            bgTop = parseFloat(span)*@heightCoeff*@speed+@baseBgOffset
            if bgTop > @bgHeight
                bgTop = @bgHeight+@baseBgOffset
            else if bgTop > @baseBgOffset
                bgTop = @baseBgOffset
            if @background.hasClass('pB-top-to-bot') then @background.css('top', "#{bgTop}px") else @background.css('bottom', "#{bgTop}px")
            if @content?
                @content.each ->
                    $(this).fadeIn(2000)

                        

$(document).on "turbolinks:load", myParalaxes

