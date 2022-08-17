const http = require('http');
let EventEmitter = require('events').EventEmitter;
const { replacePortNumber } = require("../utils");

class HealthCheckerUtility extends EventEmitter {
    inMemoryConfig;
    isXtermSocketAlive  = false;
    isWebServerAlive    = false;
    canG2ToolsExec      = false;
    pingTime = 30000;

    constructor(inMemoryConfigObj) {
        super();

        if(inMemoryConfigObj) {
            this.inMemoryConfig = inMemoryConfigObj;
        }
        // set up interval timers to check status
        this.isXTermServerAliveTimer    = setInterval(this.checkIfXtermAlive.bind(this), this.pingTime);
        this.isWebServerAliveTimer      = setInterval(this.checkIfWebServerAlive.bind(this), this.pingTime);
        this.canG2ToolsExecTimer        = setInterval(this.checkIfG2ToolsExec.bind(this), this.pingTime);
        // immediately perform checks
        this.checkIfXtermAlive();
        this.checkIfWebServerAlive();
        this.checkIfG2ToolsExec();
    }
    get status() {
        return {
            "isXtermSocketAlive": this.isXtermSocketAlive,
            "isWebServerAlive": this.isWebServerAlive,
            "canG2ToolsExec": this.canG2ToolsExec
        }
    }
    get config() {
        return this.inMemoryConfig.config;
    }
    checkIfXtermAlive() {
        /** 
         * @TODO fill out logic here that actually opens up a web socket
         * and checks for a response.
         */
        this.isXtermSocketAlive = true;
    }
    checkIfWebServerAlive() {
        /** 
         * @TODO fill out logic here that actually opens up a http request
         * and checks for a response.
         */
        this.isWebServerAlive = false;
    }
    checkIfG2ToolsExec() {
        /** 
         * @TODO fill out logic here that actually opens up a PTY and 
         * executes a G2Command to smoke test
         */
        this.canG2ToolsExec = true;
    }
}

module.exports = HealthCheckerUtility;