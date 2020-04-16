package haxe.unit;

import haxe.PosInfos;
import tink.testrunner.Assertion;

@:keepSub
@:publicFields
class TestCase {
	public var currentTest:TestStatus;
	public var assertions:Array<Assertion>;

	public function new() {}

	public function setup():Void {}

	public function tearDown():Void {}

	function print(v:Dynamic) {}
	
	function assertTrue(b:Bool, ?c:PosInfos):Void {
		currentTest.done = true;
		if (b != true) {
			currentTest.success = false;
			currentTest.error = "expected true but was false";
			currentTest.posInfos = c;
			throw currentTest;
		} else {
			assertions.push(new Assertion(b, 'assertTrue', c));
		}
	}

	/**
		Succeeds if `b` is `false`.
	**/
	function assertFalse(b:Bool, ?c:PosInfos):Void {
		currentTest.done = true;
		if (b == true) {
			currentTest.success = false;
			currentTest.error = "expected false but was true";
			currentTest.posInfos = c;
			throw currentTest;
		} else {
			assertions.push(new Assertion(!b, 'assertFalse', c));
		}
	}

	/**
		Succeeds if `expected` and `actual` are equal.
	**/
	function assertEquals<T>(expected:T, actual:T, ?c:PosInfos):Void {
		currentTest.done = true;
		if (actual != expected) {
			currentTest.success = false;
			currentTest.error = "expected '" + expected + "' but was '" + actual + "'";
			currentTest.posInfos = c;
			throw currentTest;
		} else {
			assertions.push(new Assertion(expected == actual, 'assertEquals: $expected == $actual', c));
		}
	}
}
