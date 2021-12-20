
from sh import node
import subprocess, re, math, pdb, json

#value_template = re.compile(r"(\d+).(\d+) ?(ms|s|m|h|d|y|(?:\(m:ss.mm\)))")
#value_template = re.compile(r"(\d+\.\d+) ?(ms)")

passes = 10000

# Print iterations progress
def printProgressBar (iteration, prefix = '', length = 80):
	"""
	Call in a loop to create terminal progress bar
	@params:
		iteration   - Required  : current iteration (Int)
		prefix      - Optional  : prefix string (Str)
		length      - Optional  : character length of bar (Int)

	"""
	#printEnd    - Optional  : end character (e.g. "\r", "\r\n") (Str)
	percent = ("{0:.1f}").format(100 * (iteration / float(passes)))
	filledLength = int(length * iteration // passes)
	bar = '@' * filledLength + '-' * (length - filledLength)
	# Use of control character to overwrite last progress bar.
	print(f'\r{prefix} |{bar}| {percent}%', end = "\r")
	# Print New Line on Complete
	if iteration == passes:
		print()


tests = []
for test in range(passes):
	printProgressBar(test+1, prefix="Running Tests")
	proc = subprocess.run(["node", "./testRangeSpeed.js"], stdout=subprocess.PIPE)
	tests.append(proc.stdout.decode("utf-8"))
	# tests = (node(["./testRangeSpeed.js"]).stdout.decode("utf-8")
	# 	for _ in range(passes))


categorized_results = { }
for index, raw_results in enumerate(tests):
	printProgressBar(index+1, passes, prefix="Categorizing Test Results")
	lines = raw_results.split("\n")
	#pdb.set_trace()
	lines = filter(lambda x: len(x)!=0, lines)

	for line in lines:
		section, value = line.split(" ")
		section = section.rstrip(":")
		# NOTE: bad idea for long term because Node's timer output is funky.
		#       should to try using a regex extract parser to ms l8r.
		value = value.rstrip("ms")
		# This method results in far less computation later.
		#pdb.set_trace()
		if section in categorized_results:
			categorized_results[section].append(float(value))
		else:
			categorized_results[section] = [float(value)]


print("Calculating final results...")
# Now we can do math on the results!
# Averages
averages = {}
for category, values in categorized_results.items():
	#pdb.set_trace()
	value_categories = {}
	value_categories['average'] = math.fsum(values) / passes
	value_categories['max'] = max(values)
	value_categories['min'] = min(values)

	averages[category] = value_categories


print(json.dumps(averages, indent=2, sort_keys=True))
