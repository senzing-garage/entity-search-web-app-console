//SocketService.js

const socketIO = require("socket.io");
const PTYService = require("./PTYService");

class SocketService {
  constructor() {
    this.socket = null;
    this.pty = null;
  }

  attachServer(server, options) {
    if (!server) {
      throw new Error("[error] no server to attach socket.io listener to..");
    }
    let io;
    if(options) {
      io = socketIO(server, options);
      console.log("[listening on "+ options.path +"] socket.io server waiting for client connections..");
    } else {
      io = socketIO(server);
      console.log("[listening] socket.io server waiting for client connections..");
    }
    
    // "connection" event happens when any client connects to this io instance.
    io.on("connection", socket => {
      console.log("[connected] client connected to socket.io server", socket.id);

      this.socket = socket;

      this.socket.on("disconnect", () => {
        console.log("[disconnected] client disconnected from socket.io server", socket.id);
      });

      // Create a new pty service when client connects.
      this.pty = new PTYService(this.socket);

     // Attach event listener for socket.io
      this.socket.on("input", input => {
        // Runs this listener when socket receives "input" events from socket.io client.
        // input event is emitted on client side when user types in terminal UI
        this.pty.write(input);
      });
    });
  }
}

module.exports = SocketService;