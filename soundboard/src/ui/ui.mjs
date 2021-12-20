

import VirtualKeyboard from "./lib-js/keyboard.mjs";

window.addEventListener("DOMContentLoaded", function () {
	const keyboardContainer = document.getElementById("keyboard");
	window.vk = new VirtualKeyboard(keyboardContainer, [
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "backspace",
		"q", "w", "e", "r", "t", "y", "u", "i", "o", "p",
		"caps", "a", "s", "d", "f", "g", "h", "j", "k", "l", "enter",
		"done", "z", "x", "c", "v", "b", "n", "m", ",", ".", "?",
		"space"
	]);
});
