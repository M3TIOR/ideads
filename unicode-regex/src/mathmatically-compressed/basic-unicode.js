/**
 * @file basic-unicode.js
 * @author Ruby Allison Rose
 * @license
 *   <p><strong>Copyright (c) 2019 Ruby Allison Rose (aka: M3TIOR)</strong></p>
 *
 *   <p>
 *   Permission is hereby granted, free of charge, to any person obtaining a copy
 *   of this software and associated documentation files (the "Software"), to deal
 *   in the Software without restriction, including without limitation the rights
 *   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *   copies of the Software, and to permit persons to whom the Software is
 *   furnished to do so, subject to the following conditions:
 *
 *   <ul style="list-style-type: disc;">
 *     <li>
 *       The above copyright notice and this permission notice shall be included in all
 *       copies or substantial portions of the Software.
 *     </li>
 *
 *     <li>
 *       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *       IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *       FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *       AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *       LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *       OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *       SOFTWARE.
 *     </li>
 *   </ul></p>
 */

export default {
	latinExtendedUpperA: // editor issue fix
		range(28).map((e)=>`\\u0${(e*2+256).toString(16)}`).join("") +
		range(8).map((e)=>`\\u0${(e*2+313).toString(16)}`).join("") +
		range(24).map((e)=>`\\u0${(e*2+330).toString(16)}`).join("") +
		"\\u0179\\u017b\\u017d";


	latinExtendedLowerA: // editor issue fix
		range(28).map((e)=>`\\u0${(e*2+257).toString(16)}`).join("") +
		range(9).map((e)=>`\\u0${(e*2+312).toString(16)}`).join("") +
		range(24).map((e)=>`\\u0${(e*2+329).toString(16)}`).join("") +
		"\\u017a\\u017c\\u017e\\u017f"
};
