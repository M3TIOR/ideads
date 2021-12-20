

// Types of keys:
// Control key (modifier) FN, Shift, Alt, Caps, Cmd / OS
// Dead key (modifies following keypress)
// Compose key (modifies following sequence)
// Held Alt List (A list of alternate characters to choose from when a normal
//                character is held.)
//
// Character key (regulars) a,b x, %, 5


const latinBasicKeyboardLayout = {
	globalKeyStyle: {
		height: "45px";
		width: "6%";
		max-width: "90px";
		margin: "3px";
		border-radius: "4px";
		border: "none";
		background: "rgba(255, 255, 255, 0.2)";
		color: "#ffffff";
		font-size: "1.05rem";
		outline: "none";
		cursor: "pointer";
		display: "inline-flex";
		align-items: "center";
		justify-content: "center";
		vertical-align: "top";
		padding: "0";
		-webkit-tap-highlight-color: "transparent";
		position: "relative";
		text-align: "center";
	}
	rows: [
		// GOALS: I want this keyboard layout configuration to be easy to read,
		//        simple, and fully featured.
		//
		// As a bi-product of using the W3C as our base, we know that we need to
		// have explicit shift and caps functionality.
		//
		// For rendering we'll have a cap "type" system, whereby there are multiple
		// predesigned key cap typs for uses to choose from. EX:
		//  * l\U   - lowercase graphic below upper case graphic.
		//  * Swap  - initial case is shown until shift or caps is activated,
		//            then upper case is shown. The same event happens for
		//            and meta-modifiers.
		//  * S.C. - A keycap with the corners all holding different control
		//           control character altered values. Shift will always be in the
		//           upper right corner, followed by FN in the upper left, then
		//           two custom modifier characters are in the bottom corners.
		//
		// TODO: implement HoldCap
		//
		// Caps are assumed to be l\U when more than one value is specified.
		// Caps are assumed to be Gt when only one is specified
		//
		// NOTE: LINKS
		//   https://en.wikipedia.org/wiki/AltGr_key
		//   https://en.wikipedia.org/wiki/Fn_key
		[
			["1"], ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["0"],
		],
		[
			// Key value [string || Object{code:int, label:string, icon:string}],
			// held alt list
			// individual key settings { style: { JS STYLE RULES... }, type: "sticky" | "toggle" | "deadkey" }
			["q"], ["w"], ["e"], ["r"], ["t"], ["y"], ["u"], ["i"], ["o"], ["p"],
			[ {code:8, icon:"backspace"}, false, { width: "12%" } ],
		],
		[
			[ {code:16, icon:"caps"}, false, { width: "12%" } ],
			["a"], ["s"], ["d"], ["f"], ["g"], ["h"], ["j"], ["k"], ["l"],
			[ {code:13, icon:"enter"}, false, { width: "12%" } ],
		],
		[
			[ {code:8, icon:"done"}, false, { width: "12%" } ],
			["z"], ["x"], ["c"], ["v"], ["b"], ["n"], ["m"],
			[",", { shift: "<" }],
			[".", { shift: ">" }],
			["/", { shift: "?" }],
		],
		[
			[ {code:32, icon:"space"}, false, { width: "36%" } ],
		],
	]
};

function isURL(string){
	let url;
	try { url = URL(string); }
	catch (_) { return false; }
	return true;
}

function layoutForLocale(locale){

}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function drawSwapCap(key) {

}


class MouseProxyPanel extends HTMLDivElement {
	constructor(){
		super(); // initialize extended class using it's constructor.

		// Calc highest value within javascript scope (should carry to CSS)
	 	let zIndex = 1; for(; zIndex>0; zIndex = (zIndex<<1)+1);

		Object.assign(this.style, {
			position: "fixed",
			padding: "0px", margin: "0px",
			top: "0px", left: "0px",
			width: "100%", height: "100%",
			opacity: "0",
			pointerEvents: "unset",
			zIndex,
		});

		function interceptEvent(eventname, lambda) {
			this.addEventListener(eventname, async (e) => {
				e.stopPropagation(); // prevent downwards bubbling because we're moding

				// Allow elementFromPoint to get elements below our overlay;
				this.style.pointerEvents="none";

				const target = document.elementFromPoint(e.screenX, e.screenY);

				// Reset overlay event capturing.
				this.style.pointerEvents="unset";

				const targetRect = target.getBoundingClientRect();
				const clientX = e.screenX - targetRect.x;
				const clientY = e.screenY - targetRect.y;

				const newEventInfo = {
					screenX: e.screenX, screenY: e.screenY,
					button: e.button, buttons: e.buttons,
					clientX, clientY,
					// Register keys from keyboard with focus here.
					ctrlKey: false,
					shiftKey: false,
					metaKey: false,
					altKey: false,
				};

				// Since the new event is
				if (lambda) await lambda(target, e, newEventInfo);

				// Override key methods
				const newEvent = new MouseEvent(eventname, newEventInfo);
				newEvent.preventDefault = () => {
					e.preventDefault();
					newEvent.defaultPrevented = true;
				};

				target.dispatchEvent(newEvent);

				// set after lambda so they're properly in the next event fired.
				this._lastClientX = clientX;
				this._lastClientY = clientY;
				this._lastTarget = target;
			});
		}

		// NOTE: order mousedown, mouseup, click;

		// [] mousedown  -
		// [] mouseup    -
		// [] mouseenter - https://developer.mozilla.org/en-US/docs/Web/API/Element/mouseenter_event
		// [] mouseexit  -
		// [] mouseover  - https://developer.mozilla.org/en-US/docs/Web/API/Element/mouseover_event
		// [] mouseout   -

		// Firing order is already calculated for these events.
		interceptEvent("mousedown");
		interceptEvent("mouseup");
		interceptEvent("mouseclick");

		interceptEvent("mousemove", (target, originalEvent, newEventInfo) => {
			// NOTE: this is probably where most of the event mimicry will happen
			//   due to how the enter, exit, over, and out events work.

			// NOTE: was going to implement a calc method for mousemove to trigger
			//   the mouse over and enter events for each element between the
			//   last known pointer location and the current location. But when
			//   I was playing around with Firefox I noticed that the mouse movement
			//   event is on a timer. It's only fired ever few millis so if you're
			//   moving the mouse fast enough you can avoid triggering mouseover
			//   and enter events for elements between the previous mouse location
			//   and the current mouse location. I still need to validate this is
			//   to spec with the W3C but it looks like I won't have too much here
			//   after all.
			//
			// const vecX = newEventInfo.clientX - this._lastClientX;
			// const vecY = newEventInfo.clientY - this._lastClientY;
		});

		interceptEvent("mouseenter", (target, originalEvent, newEventInfo) => {
			// NOTE:
			//   Event doesn't bubble.
			//   Gets sent to each element upon enter in the heirarchy, but doesn't
			//     get sent again when a decendent of the target is left.

		});
	},
	setKeyboard(keyboard)
}

// NOTE: for testing https:?/histo.io

class VirtualKeyboard extends HTMLDivElement {
	// Kinda pointless to add constructor arguments since
	// using the parent constructor is Illegal. Must register with
	// customElements.define and fetch info from <element> and style
	constructor() {
		super(); // initialize extended class using it's constructor.

		// shadow can be used as manager element to dispatch events at host.
		// may need to use event.preventDefault and event.stopPropagation together.
		const shadow = this.attachShadow({ mode: "open", delegatesFocus: false });

		// Shadow target uses custom events with specialized data.
		shadow.addEventListener("vk-press", (event) => {
			// NOTE: need to send both keydown and keypress together as to mimic
			//       native behavior per W3C standards within this function.
		});

		shadow.addEventListener("vk-release", (event) => {

		});


		this._capStyleController = document.createElement("style");
		const layoutLocale = this.getAttribute("data-locale");
		const keyColor = this.getAttribute("data-key-color");
		const darkMode = this.getAttribute("data-color-mode");
		const proxyMouse = this.getAttribute("data-mods-mouse");


		// TODO: will contain a map to each function that handles keycode action logic;
		this.keycodeActionMap = new Map();
		// this.properties = {
		// 	// pre-designated by W3C design spec. So there are no issues with these
		// 	// internal states being defined. Any further states being defined
		// 	// which go outside the spec are a challenging design decision.
		// 	// I wan the keyboard to be easy to use.
		// 	//
		// 	// These will be the only hard coded modifier keys defined because they're
		// 	// the only keys recognized by the browser and are required to be
		// 	// transmitted via the OS. All other keys will be registered as
		// 	// meta-modifiers since we can intercept their events without needing to
		// 	// effect the rest of the application environment.
		// 	caps: false
		// 	shift: false
		// 	alt: false
		// 	meta: false
		// 	ctrl: false
		// };

		this.locales = {};

		style.innerHTML = (`
			button:active {
				background: rgba(255, 255, 255, 0.12);
			}

			.wide {
				width: 12%;
			}

			.extra-wide {
				width: 36%;
				max-width: 500px;
			}

			.keyboard__key--activatable::after {
				content: '';
				top: 10px;
				right: 10px;
				position: absolute;
				width: 8px;
				height: 8px;
				background: rgba(0, 0, 0, 0.4);
				border-radius: 50%;
			}

			.keyboard__key--active::after {
				background: #08ff00;
			}

			.keyboard__key--dark {
				background: rgba(0, 0, 0, 0.25);
			}
		`);


		// Check if data-layout is URL;
		if (typeof layout === "string") {
			let locale = null;
			if (isURL(layout)) return loadExternalLayout(layout);
			else if (locale = localeOf(layout)) return loadLocale(locale);
			else console.error(`"${layout}" is not a proper URL or locale`);
		}
		else {
			return;
		}


		shadow.appendChild(style);
	},

	async useExternalLayout(location) {
		// TODO: add fetch for remote layout in a different domain /
		//       not embedded into the javascript application.
	},

	async useLocaleLayout(string) {
		let locale = Intl.getCanonicalLocales(string)[0];

		let layout;
		switch (locale) {
			case "EN-US": layout = latinBasicKeyboardLayout; break;
			default:
				// console.error(`Does not yet support locale ${locale}.`);
				// return false;
		}

		await _draw(layout);
	},

	// down = new KeyboardEvent("keydown", { key: "k" });
	// press = new KeyboardEvent("keypress", { key: "k" });
	// up = new KeyboardEvent("keyup", { key: "k" });
	// document.dispatchEvent(new FocusEvent("focus", {relatedTarget:x}));
	// document.dispatchEvent(down);
	// x.dispatchEvent(new InputEvent("beforeinput"));
	// document.dispatchEvent(press);
	// x.dispatchEvent(new InputEvent("input", {data: "k", inputType:"insertText"}));
	// document.dispatchEvent(up);

	async useLayoutJSON(string) {
		// parser.parseFromString(string, "text/xml")
		const layout = JSON.parse(string);

		// TODO: add in preprocessing so our errors happen here
		//       and not within the renderer process.
		// const globalStyle = layout.globalKeyStyle;
		//
		// for (const row of layout.rows) {
		// 	for (const key of row) {
		// 		validateKey.apply(this, key);
		// 	}
		// }

		return await this._draw(layout);
	},

	// Not intended to be called by the user.
	_draw(layout) {
		const self = this;
		const renderedKeys = [];
		const globalStyle = layout.globalKeyStyle;

		this.capMap = new Map();

		// NOTE: Even control key presses send singluar events to the
		//       browser, so we can just caputure all key states while
		//       we're dispatching their events.
		this.stateMap = new Map();

		const generateCap = (key) => {

		};

		const drawCap = (initialValue, settings) => {
			const cap = document.createElement("button");
			cap.setAttribute("type", "button");

			// TODO: do more to prevent focus from accidentally leaving important
			//       elements of the screen.
			// LINKS:
			//      https://www.w3.org/html/wg/next/markup/
			//      https://www.w3.org/WAI/policies/
			//      https://css-tricks.com/focus-management-and-inert/
			cap.setAttribute("tabindex", "-1"); // prevent tab focus assertion.

			if (!settings || settings.cap==="swap") {
				cap.classList = "swap";
				// NOTE: planning on using css selectors to optimize graphics performace.
				// https://www.w3.org/wiki/Dynamic_style_-_manipulating_CSS_with_JavaScript

				let code = key.code || key.charCodeAt(0);

				if (typeof key === "string") { cap.innerText = key; }
				else if (typeof key === "object") {
					if (key.icon) {
						const iconContainer = document.createElement("i");
						iconContainer.classList = "material-icons";
						iconContainer.innerText = key.icon;
						cap.appendChild(iconContainer);
					}
					else {
						cap.innerText = key.label;
					}
				}
			}
		};

		for (const row of layout.rows) {
			for (const key of row) {
				drawCap.apply(this, key);
			}
		}

		// Send keys to actually be rendered. Destroy old layout first.
		// TODO: add animation to make seemless / look pretty.
		requestAnimationFrame (() => {
			self.shadow.replaceChildren(...renderedKeys);
		});
	},

	/**
	 * Override if you wish to add custom functionality for specific character
	 * codes.
	 */
	registerControlCode(code) {

	},

	/**
	 * Override if you wish to add custom functionality for specific control
	 * characters.
	 */
	registerControlCharacter(name) {

	}

	open(initialValue) {
		this.properties.value = initialValue || "";

		this.dispatchEvent(new CustomEvent("virtual-keyboard:open", {
			detail: {
				target: this.elements.main, // the firing element
				initialValue,
			}
		}));

		this.elements.main.classList.remove("keyboard--hidden");
	},

	close() {
		this.properties.value = "";

		this.dispatchEvent(new CustomEvent("virtual-keyboard:close", {
			detail: {
				target: this.elements.main, // the firing element
				initialValue,
			}
		}));

		this.elements.main.classList.add("keyboard--hidden");
	},

	_createKeys(keyLayout) {
		const fragment = document.createDocumentFragment();

		// Creates HTML for an icon
		const createIconHTML = (icon_name) => {
			return `<i class="material-icons">${icon_name}</i>`;
		};

		keyLayout.forEach(key => {
			const keyElement = document.createElement("button");
			const insertLineBreak = ["backspace", "p", "enter", "?"].indexOf(key) !== -1;

			// Add attributes/classes
			keyElement.setAttribute("type", "button");

			switch (key) {
				case "backspace":
					keyElement.classList.add("wide");
					keyElement.innerHTML = createIconHTML("backspace");

					keyElement.addEventListener("click", () => {
						this.properties.value = this.properties.value.substring(0, this.properties.value.length - 1);
						this._triggerEvent("oninput");
					});

					break;

				case "caps":
					keyElement.classList.add("wide", "keyboard__key--activatable");
					keyElement.innerHTML = createIconHTML("keyboard_capslock");

					keyElement.addEventListener("click", () => {
						this._toggleCapsLock();
						keyElement.classList.toggle("keyboard__key--active", this.properties.capsLock);
					});

					break;

				case "enter":
					keyElement.classList.add("keyboard__key--wide");
					keyElement.innerHTML = createIconHTML("keyboard_return");

					keyElement.addEventListener("click", () => {
						this.properties.value += "\n";
						this._triggerEvent("oninput");
					});

					break;

				case "space":
					keyElement.classList.add("keyboard__key--extra-wide");
					keyElement.innerHTML = createIconHTML("space_bar");

					keyElement.addEventListener("click", () => {
						this.properties.value += " ";
						this._triggerEvent("oninput");
					});

					break;

				case "done":
					keyElement.classList.add("keyboard__key--wide", "keyboard__key--dark");
					keyElement.innerHTML = createIconHTML("check_circle");

					keyElement.addEventListener("click", () => {
						this.close();
						this._triggerEvent("onclose");
					});

					break;

				default:
					keyElement.textContent = key.toLowerCase();

					keyElement.addEventListener("click", () => {
						this.properties.value += this.properties.capsLock ? key.toUpperCase() : key.toLowerCase();
						this._triggerEvent("oninput");
					});

					break;
			}

			fragment.appendChild(keyElement);

			if (insertLineBreak) {
				fragment.appendChild(document.createElement("br"));
			}
		});

		return fragment;
	},

	_toggleCapsLock() {
		this.properties.capsLock = !this.properties.capsLock;

		for (const key of this.elements.keys) {
			if (key.childElementCount === 0) {
				key.textContent = this.properties.capsLock ? key.textContent.toUpperCase() : key.textContent.toLowerCase();
			}
		}
	},
}

customElements.define('virtual-keyboard', VirtualKeyboard, { extends: 'div' });
customElements.define('mouse-proxy', MouseProxyPanel, { extends: 'div' });
export VirutalKeyboard;
