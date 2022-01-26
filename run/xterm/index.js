//index.js
const http = require("http");
const SocketService = require("./SocketService");
const express = require('express');
const path = require("path")

// utils
const { getPathFromUrl } = require("../utils");
const inMemoryConfig = require("../runtime.datastore");
const inMemoryConfigFromInputs = require('../runtime.datastore.config');
const runtimeOptions = new inMemoryConfig(inMemoryConfigFromInputs, true);

// grab env/cmdline vars
// web server config
let serverOptions = runtimeOptions.config.web;
// console
var consoleOptions = runtimeOptions.config.console;

//let STARTUP_MSG = "\t RUNTIME OPTIONS: "+ JSON.stringify(inMemoryConfigFromInputs, undefined, 2);
//console.log(STARTUP_MSG);

// server(s)
const app     = express();
const server  = http.Server(app);

if(consoleOptions && consoleOptions.enabled) {
  server.listen(consoleOptions.port, function() {
    console.log("[started ] Xterm Socket Server on port ", consoleOptions.port);
    const socketService = new SocketService();
    let serverOptions;
    if(consoleOptions && consoleOptions.url) {
      let _pathFromUrl = getPathFromUrl(consoleOptions.url)
      if(_pathFromUrl) {
        serverOptions = {
          path: _pathFromUrl
        }
      }
    }
    // We are going to pass server to socket.io in SocketService.js
    socketService.attachServer(server, serverOptions);
  });
} else {
  console.log("console is not enabled: \n"+ JSON.stringify(consoleOptions));
}