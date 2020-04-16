package ;

import tink.testrunner.*;
import tink.testadapter.*;

class RunTests {
	static function main() {
		Runner.run(HaxeUnit.makeBatch([
			new MyTestCase(),
		])).handle(function(result) {
			var expectedNumErrors = 2;
			Helper.exit(result.summary().failures.length == expectedNumErrors ? 0 : 1);
		});
	}
}

class MyTestCase extends haxe.unit.TestCase {
	public function testInt() {
		assertTrue(this != null);
		assertTrue(true);
	}
	public function testFailure() {
		assertTrue(false);
	}
	public function testEmpty() {
	}
	
	public function testFail() {
		fail('failed');
	}
	
	// can't handle arbitary throw
	// public function testThrow() {
	// 	throw 'arbitary value';
	// }
	
	function fail(msg:String, ?c : haxe.PosInfos) {
		currentTest.done = true;
		currentTest.success = false;
		currentTest.error = msg;
		currentTest.posInfos = c;
		throw currentTest;
	}
}