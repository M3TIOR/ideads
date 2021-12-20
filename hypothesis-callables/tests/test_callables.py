# coding=utf-8
#
# hypothesis_callables: A callable generator extension for the hypothesis lib.
# Copyright (C) 2018 Ruby Allison Rose
#
# This Source Code Form is subject to the terms of the Mozilla Public License,
# v. 2.0. If a copy of the MPL was not distributed with this file, You can
# obtain one at http://mozilla.org/MPL/2.0/.
#
# END HEADER

# make sure we can do these tests in < python2.7 & > python3
from __future__ import division, print_function, absolute_import
if __debug__: import pdb

# make sure when we run pytest outside of setup, we can still run this.
import sys
import os.path as path
srcdir = path.abspath(path.join(path.dirname(repr(__file__)[1:-1]), "../"))
sys.path.append(srcdir)

from hypothesis import given, settings, HealthCheck as hc
import hypothesis.errors as he
from hypothesis.internal.compat import PY3, text_type, getfullargspec

from hypothesis.strategies import *
from hypothesis_callables import *

from hypothesis_callables import _supported_binding_regex

import pytest # test library
import pdb # debugger

import re

_unsupported_binding_regex = re.compile(r"^(?!%s).*\Z" \
	% (_supported_binding_regex.pattern[1:-2]))

@composite
def primitives(draw):
	"""DOCUMENT ME!!!"""
	# NOTE:
	#	Could make this more complex and support recursion for itterables,
	#	but I'm too lazy atm.
	return draw(one_of( # lol, this couldn't be more direct.
		#none(),
		integers(),
		floats(),
		characters(),
		tuples(),
		lists()
	))

def primitives_w_bindings(automatic, manual, fail, min_size=None, max_size=50):
	"""DOCUMENT ME!!!"""
	bindings = []

	if fail: bindings.append( from_regex(_unsupported_binding_regex) )
	if manual: bindings.append( from_regex(_supported_binding_regex) )
	if automatic: bindings.append( integers() )

	return dictionaries(
		one_of(*bindings), # bindings
		primitives(), # child values
		max_size=max_size,
		min_size=min_size
	)

class TestClassStrategy(object):
	"""DOCUMENT ME!!!"""

	@given(data())
	@settings(suppress_health_check=[hc.data_too_large])
	def test_automatic_child_binding_assignment(self, data):
		children = data.draw(primitives_w_bindings(True, False, False))
		product = data.draw(classes(
			children={key: just(value) for key, value in children.items()}
		))

		children_produced = len(children)
		children_assigned = 0
		for value in children.values():
			for attribute in dir(product):
				if getattr(product, attribute) is value:
					children_assigned += 1;
					break; # break inner

		assert children_assigned == children_produced

	@given(data())
	@settings(suppress_health_check=[hc.data_too_large])
	def test_manual_child_binding_assignment(self, data):
		children = data.draw(primitives_w_bindings(False, True, False))
		product = data.draw(classes(
			children={key: just(value) for key, value in children.items()}
		))

		for binding, value in children.items():
			assert getattr(product, binding) is value

	@given(data())
	@settings(suppress_health_check=[hc.data_too_large])
	def test_combined_child_binding_assignment(self, data):
		children = data.draw(primitives_w_bindings(True, True, False))
		product = data.draw(classes(
			children={key: just(value) for key, value in children.items()}
		))

		children_produced = len(children)
		children_assigned = 0
		for key, value in children.items():
			if isinstance(key, int):
				for attribute in dir(product):
					if getattr(product, attribute) is value:
						children_assigned += 1; break;
			else:
				assert getattr(product, key) is value
				children_assigned += 1

		assert children_assigned == children_produced

	@given(data())
	@settings(suppress_health_check=[hc.too_slow, hc.data_too_large])
	def test_ancestory_inheritance(self, data):
		unique_children = data.draw(lists(
			primitives_w_bindings(False, True, False)
		))
		unique_ancestors = [ data.draw(classes(
			children = {key:just(value) for key, value in mapping.items()}
		)) for mapping in unique_children ]

		product = data.draw(classes(inherits=unique_ancestors))

		product_elements = {}
		for mapping in unique_children: product_elements.update(mapping)

		assert all(
			getattr(product, key) is value \
				for key, value in product_elements.items()
		)

	@given(data())
	def test_bad_child_keys(self, data):
		"""DOCUMENT ME!!!"""
		with pytest.raises(he.InvalidArgument):
			good_children = data.draw(primitives_w_bindings( \
				True, True, False))

			bad_children = data.draw(primitives_w_bindings( \
				False, False, True, min_size=1 ))

			product = data.draw(classes( \
				children = good_children.update(bad_children) ))

	#def test_bad_ancestor(self, data):
	#	NOTE: Can't really have a bad ancestor because of how inheritance works

	#def test_bad_binding_regex(self):
	#	NOTE: Can't have bad binding regex

	@given(data())
	def test_good_instance(self):
		pass

class TestCallableStrategies(object):
	pass

class TestParameterStrategy(object):
	pass
