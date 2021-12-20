import ipc from "node-ipc";

ipc.config.id = "soundboard";
ipc.config.retry = 1500;


ipc.serve(()=>{
	ipc.server.on("message", (data, socket) => {
		ipc.log('got a message : ', data);
		//this can be anything you want so long as
		//your client knows what world you're in.
		ipc.server.emit(socket, 'message', data+' world!');
	});
	ipc.server.on("derp", (a,b,c) => {
		ipc.log(`${a} - ${b} - ${c}`);
	});
	ipc.server.on('socket.disconnected', (socket, destroyedSocketID) => {
		ipc.log('client ' + destroyedSocketID + ' has disconnected!');
		ipc.log("killing server...");
		process.exit();
	});
});

ipc.server.start();
