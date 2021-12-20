import ipc from "node-ipc";

ipc.config.id = 'hello';
ipc.config.retry = 1500;

ipc.connectTo('soundboard', () => {
	ipc.of.soundboard.on('connect', () => {
		ipc.log('## connected to world ##', ipc.config.delay);

		//any event or message type your server listens for
		ipc.of.soundboard.emit('message', 'hello');
		ipc.of.soundboard.emit("derp", 1, 5, null);
	});
	ipc.of.soundboard.on('disconnect', () => {
		ipc.log('disconnected from world');
	});
	//any event or message type your server listens for
	ipc.of.soundboard.on('message', (data) => {
		ipc.log('got a message from world : ', data);
		process.exit();
	});
});
