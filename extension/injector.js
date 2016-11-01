// Loads local and remote scripts in the host page
function load_script(filepath, local){
  var j = document.createElement('script');
  if(local){
    j.src = chrome.extension.getURL(filepath);
  } else {
    j.src = filepath;
  }
  j.onload = function() {
    this.remove();
  };
  (document.head||document.documentElement).appendChild(j);
}

// Inject scripts into the host page
load_script("https://use.fontawesome.com/6edbd69083.js")
load_script("init.js", true)

var frame = document.createElement("iframe");
// Frame Style
frame.id = "plug-stats";
frame.style.width = "100%";
frame.style.zIndex = "2";
frame.style.height = "100%";
frame.frameBorder = 0;
frame.scrolling = "no";

// Stats is the tab body. Holds the iframe with the extension content
var stats = document.createElement("div");
stats.id = "stats";
stats.style.display = "none";


// Wait for an element to become available. Plug seems to do some lazy loading and
// we need to know when elements exist to attach to them.
var waitForSelector = function(selector, callback){
  var interval = setInterval(function(){
    panel = document.querySelector(selector);
    if(!!panel){
      clearInterval(interval);
      callback(panel);
    }
  }, 500)
}


// Create a stats panel and add it to plug. The iframe gets loaded
// into the stats element once it's in the dom.
waitForSelector(".app-right", function(panel){
  panel.appendChild(stats);
  stats.appendChild(frame);
  loadIframe()
});


// Write content to the iframe. For some reason, plug was not a very nice host to
// my elm app. To get around this, we isolate the elm app in an iframe and use
// postMessage to communicate back and forth from the host (init.js).
var loadIframe = function(){
  var doc = frame.contentDocument || frame.contentWindow.document;
  var html = `
    <!DOCTYPE html>
    <html>

      <style>
        html, body { background-color: rgba(28, 31, 37, 1);}
        main { width: 100%; }
      </style>
      <head>
        <link rel="stylesheet" href="${chrome.extension.getURL('css/style.css')}" />
        <script src="${chrome.extension.getURL('plug-stats.js')}"></script>
      </head>

      <body>
        <div id="main"></div>
      </body>

      <script>
        var node = document.getElementById('main');
        var app = Elm.Main.embed(node);

        var receiveMessage = function(event){
          var message = event.data;
          switch(message.event){
            case "history":
              message.history.map(function(play){
                app.ports.plugplay.send(JSON.stringify(play));
              })
              break;
            case "play":
              app.ports.plugplay.send(JSON.stringify(message.play));
              break;
          }

        };

        window.addEventListener("message", receiveMessage, false);

      </script>

    </html>
  `;
  doc.write(html);
  doc.close();
};
