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
const HealthCheckUtility = require("../health");
const healthChecker = new HealthCheckUtility(runtimeOptions);

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
// ----------------- start config endpoints -----------------
  let _confBasePath = '';
  if(runtimeOptions.config && 
    runtimeOptions.config.web && 
    runtimeOptions.config.web.path && runtimeOptions.config.web.path !== '/') {
      _confBasePath = runtimeOptions.config.web.path;
  }
  // adds a "/health" path for checking the status of 
  // relevant operation status
  app.get(_confBasePath+'/health', (req, res, next) => {
    let currentStatus = healthChecker.status;
    let retCode = 500;
    if(currentStatus && Object.values(currentStatus)){
        let allHealthy = Object.values(currentStatus).every((value) => value);
        retCode = allHealthy ? 200 : 503;
    }
    res.status(retCode).json( currentStatus );
  });
  // part where we start the actual server up
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