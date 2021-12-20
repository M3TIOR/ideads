
// TODO: average results later.

console.time("generator-range");
console.time("generator-range_setup");
function* generatorRange(start, stop, step=1) {
	if (stop == null) {
		// one param defined
		stop = start;
		start = 0;
	}

	for (var i = start; step > 0 ? i < stop : i > stop; i += step)
		yield i;
}
console.timeEnd("generator-range_setup");

console.time("generator-range_initial-call");
for (let l=0; l < 10000000; l++) Array.from(generatorRange(1));
console.timeEnd("generator-range_initial-call");

console.time("generator-range_test-100");
for (let l=0; l < 10000000; l++) Array.from(generatorRange(100));
console.timeEnd("generator-range_test-100");

console.time("generator-range_test-10to110");
for (let l=0; l < 10000000; l++) Array.from(generatorRange(10, 110));
console.timeEnd("generator-range_test-10to110");
console.timeEnd("generator-range");

console.time("prealloc-array-constructor-range");
console.time("prealloc-array-constructor-range_setup");
function preAllocConstructorRange(start, stop, step=1){
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
}
console.timeEnd("prealloc-array-constructor-range_setup");

console.time("prealloc-array-constructor-range_initial-call");
for (let l=0; l < 10000000; l++) preAllocConstructorRange(1);
console.timeEnd("prealloc-array-constructor-range_initial-call");

console.time("prealloc-array-constructor-range_test-100");
for (let l=0; l < 10000000; l++) preAllocConstructorRange(100);
console.timeEnd("prealloc-array-constructor-range_test-100");

console.time("prealloc-array-constructor-range_test-10to110");
for (let l=0; l < 10000000; l++) preAllocConstructorRange(10,110);
console.timeEnd("prealloc-array-constructor-range_test-10to110");
console.timeEnd("prealloc-array-constructor-range");


console.time("prealloc-array-constructor-range-w\\-seal");
console.time("prealloc-array-constructor-range-w\\-seal_setup");
function preAllocConstructorRangewSeal(start, stop, step=1){
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
	Object.seal(result);
	// populate post allocation.
	for (let i=0, v=start; i < length; v += step, i++)
		result[i] = v;

	return result;
}
console.timeEnd("prealloc-array-constructor-range-w\\-seal_setup");

console.time("prealloc-array-constructor-range-w\\-seal_initial-call");
for (let l=0; l < 10000000; l++) preAllocConstructorRangewSeal(1);
console.timeEnd("prealloc-array-constructor-range-w\\-seal_initial-call");

console.time("prealloc-array-constructor-range-w\\-seal_test-100");
for (let l=0; l < 10000000; l++) preAllocConstructorRangewSeal(100);
console.timeEnd("prealloc-array-constructor-range-w\\-seal_test-100");

console.time("prealloc-array-constructor-range-w\\-seal_test-10to110");
for (let l=0; l < 10000000; l++) preAllocConstructorRangewSeal(10,110);
console.timeEnd("prealloc-array-constructor-range-w\\-seal_test-10to110");
console.timeEnd("prealloc-array-constructor-range-w\\-seal");
