// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require motion-ui
//= require foundation-sites
//= require turbolinks
//= require_tree .


    var readyFunc = function()
    {
        $(document).foundation();
    }
    document.addEventListener("turbolinks:load", readyFunc);
    
function waitbar(id, text)
    {
        var wl = $("#" + id);
        var tNull = 130;
        var loopTime = 0;
        var itemsNumber = 5;
        var wlBlocks = '';
        for(var i=0; i<itemsNumber; i++) wlBlocks += "<div class = 'wl-item'></div>";
        wlBlocks = "<div class = 'wl'>" + wlBlocks + "</div>";
        if (text !== undefined) wlBlocks = "<div class = 'wl-text'>" + text + "</div>" + wlBlocks;
        wl.html(wlBlocks);
        loopTime = wl.find(".wl-item").length*tNull + tNull;
        this.interval = null;
        this.startInterval = function () {
                                wl.fadeIn(200);
                                this.interval = setInterval(function() {
    							var t = tNull;
                                
    							wl.find(".wl-item").css("background-color", "gray");
							
    							wl.find(".wl-item").each(function(i){
    																	var el = $(this);
    																	setTimeout(
    																				function() {
    																							el.css("background-color", "black");
    																						   }, t
    																			  );
    																	t += tNull;
    															   });
    						   }, loopTime);}
        
        this.stopInterval = function()
        {
            if (this.interval !== null) {clearInterval(this.interval); wl.fadeOut(200);}
        }
        
    }
    