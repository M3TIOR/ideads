/**
 * @file helper-functions.js
 * @author Ruby Allison Rose
 * @summary Contains functions intended to enable algorithmic compression of the
 *          Regular Expression helpers contained herein.
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
	range: (start, stop, step=1) => {
		let length;

		if (stop == null) {
			// one param defined
			stop = start;
			start = 0;
		}

		if (step < 0) {
			if (start <= stop) return [];
			length = Math.abs(Math.floor((stop - start) / Math.abs(step)));
		}
		else if (step > 0) {
			if (start >= stop) return [];
			length = Math.abs(Math.ceil((stop - start) / Math.abs(step)));
		}
		else {
			length = stop - start;
		}

		// allocate array
		const result = Array(length);
		// populate post allocation.
		for (let i=0, v=start; i < length; v += step, i++)
			result[i] = v;

		return result;
	},
};
