
// Plug's api isn't immediately available. Wait until it is.
var waitForAPI = function(callback){
  var t = setInterval(function(){
    if(!!window.API){
      clearInterval(t);
      callback(window.API);
    }
  }, 500)
};

// Wait for a DOM element to become available.
var waitForSelector = function(selector, callback){
  var interval = setInterval(function(){
    panel = document.querySelector(selector);
    if(!!panel){
      clearInterval(interval);
      callback(panel);
    }
  }, 500)
}


waitForSelector("#header-panel-bar", function(panel){
  // Inject a stats button that will display content in the .app-right panel
  var statsBtn = $("<div class='header-panel-button' id='stats-button'><span class='fa fa-bar-chart fa-lg'></span></div>")
  $(panel).append(statsBtn);

  // Show the stats panel when the stats button is clicked
  $("#stats-button").on('click', function(){
    $(".header-panel-button").removeClass("selected");
    $(".app-right > div:not(#stats)").hide()
    $("#stats").show();
    $(this).addClass("selected");
  })

  // Hide the stats panel when another tab is selected
  $(".header-panel-button:not(#stats-button)").on('click', function(){
    $(".header-panel-button").removeClass("selected");
    $("#stats").hide();
    $(this).addClass("selected");
  })
})



waitForAPI(function(API){
  waitForSelector("#plug-stats", function(frame){

    setTimeout(function(){
      // Load the stast panel with initial history (past 50 plays).
      API.on(API.HISTORY_UPDATE, function(history){
        API.off(API.HISTORY_UPDATE);
        history.shift() // Shed currently playing track
        frame.contentWindow.postMessage({event: "history", history: history}, location.origin);
      })

      // Continue adding plays each time a new song is played
      API.on(API.ADVANCE, function(){
        plays = API.getHistory();
        plays.shift() // Shed currently playing track
        var play = plays.shift() // Get the last track played
        frame.contentWindow.postMessage({event: "play", play: play}, location.origin);
      })
    }, 3000);

  });

});

