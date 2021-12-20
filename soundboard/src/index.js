"use-strict";
/* External Library Imports */
const { app, BrowserWindow, ipcMain, globalShortcut } = require("electron");
const ipcNode = require("node-ipc");
const { Client, VolumeInterface,  } = require("discord.js");

/* Internal Library Imports */
//...

/* Standard Library Imports */
const path = require('path');
const fs = require('fs');
const os = require('os');



// GLOBALS
let win = null;
let discordClient = new Client();
ipc.config.id = "soundboard";
ipc.config.retry = 1500;



function startGlobalShortcutIPC(){
	ipc.serve(()=>{
		ipc.server.on("key", (key, socket) => {
			win.webContents.send("windows-hotkey", );
		});
		ipc.server.on('socket.disconnected', (socket, destroyedSocketID) => {
			ipc.log('client ' + destroyedSocketID + ' has disconnected!');
			ipc.log("killing server...");
			process.exit();
		});
	});

	ipc.server.start();
}

function safelyClose(){
	globalShortcut.unregisterAll(); // Builtin global shortcut handle
	if (ipc.server) ipc.stop();
	win = null;
	app.exit(0);
}


app.on("ready", () => {
	win = new BrowserWindow({
		minWidth: 640, width: 1920,
		minHeight: 360, height: 1200,
		frame: true,
		closable: true,
		autoHideMenuBar: true,
		webPreferences: {
			// NOTE:
			//    For anti-mod hardening, I suggest this is moved into the
			//    the development only webpack build chain.
			devTools: true,
			// This was disabled by default for security only because third party
			// navigation can expose the native process to mallicious actors.
			// Since we're a singe page Javascript application, this is fine.
			nodeIntegration: false,
			preload: "./ui-preload-ipc.js",
		}
	});

	win.loadURL(`file://${__dirname}/index.html`);

	// Should only be exectued once since we never navigate off the page.
	// We're a single page javascript application.
	win.webContents.on("dom-ready", windowReady);
});

win.on("close", safelyClose);
app.on("window-all-closed", safelyClose);

discordClient.on("ready", () => {
	console.log("Discord client has been initialized and is ready for connection.");
});
