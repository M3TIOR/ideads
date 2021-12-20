#!/usr/bin/env node
const ipc = require("node-ipc");
const { ArgumentParser } = require("argparse");

ipc.config.id = 'global-keypress';
ipc.config.retry = 1500;
ipc.config.maxRetries = 3;


const parser = new ArgumentParser({
	description: "Uses IPC to send global Windows keypresses to the soundboard.\n" +
	             "NOTE: Should not be called directly by the user!",
	add_help: true,
});

parser.add_argument('KEY', { action: 'store', type: String });

const arguments = parser.parse_args();



ipc.connectTo('soundboard', () => {
	ipc.of.soundboard.on('connect', () => {
		ipc.log('Connected to soundboard');
		ipc.of.soundboard.emit('key', arguments.KEY);
		ipc.disconnect("soundboard");
	});
	ipc.of.soundboard.on('disconnect', () => {
		ipc.log('disconnected from soundboard');
	});
});
