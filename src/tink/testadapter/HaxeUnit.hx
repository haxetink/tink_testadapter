package tink.testadapter;

import haxe.unit.*;
import tink.testrunner.Batch;
import tink.testrunner.Suite;
import tink.testrunner.Case;
import tink.testrunner.Assertion;
import tink.testrunner.Assertions;
import haxe.PosInfos;

using tink.CoreApi;

class HaxeUnit {
	public static function makeBatch(cases:Array<TestCase>, ?pos):Batch {
		return cases.map(makeSuite.bind(_, pos));
	}

	static function makeSuite(caze:TestCase, ?pos):Suite {
		return new HaxeSuite(caze, pos);
	}
}

class HaxeSuite implements SuiteObject {
	var haxecase:TestCase;

	public var info:SuiteInfo;
	public var cases:Array<Case>;

	public function new(haxecase, ?pos) {
		this.haxecase = haxecase;
		info = {
			name: Type.getClassName(Type.getClass(haxecase)),
			pos: pos,
		}
		cases = {
			var t = haxecase;

			// mostly copied from haxe.unit.TestRunner

			var cl = Type.getClass(t);
			var fields = Type.getInstanceFields(cl);

			var arr:Array<Case> = [];

			for (f in fields) {
				var fname = f;
				var field = Reflect.field(t, f);
				if (StringTools.startsWith(fname, "test") && Reflect.isFunction(field))
					arr.push(new HaxeCase(this, t, fname, field));
			}
			arr;
		}
	}

	public function setup():Promise<Noise> {
		haxecase.setup();
		return Promise.NOISE;
	}

	public function before():Promise<Noise> {
		return Promise.NOISE;
	}

	public function after():Promise<Noise> {
		return Promise.NOISE;
	}

	public function teardown():Promise<Noise> {
		haxecase.tearDown();
		return Promise.NOISE;
	}
}

class HaxeCase implements CaseObject {
	public var suite:Suite;
	public var info:CaseInfo;
	public var timeout:Int;
	public var include:Bool;
	public var exclude:Bool;
	public var pos:PosInfos;

	var haxecase:TestCase;
	var fname:String;
	var field:Dynamic;
	var status:TestStatus;

	public function new(suite, haxecase, fname, field) {
		this.suite = suite;
		var cname = Type.getClassName(Type.getClass(haxecase));
		this.info = {
			name: '$cname#$fname',
			description: '',
			pos: null,
		}
		status = new TestStatus();
		status.classname = cname;
		status.method = fname;
		this.haxecase = haxecase;
		this.fname = fname;
		this.field = field;
	}

	public function execute():Assertions {
		var t = haxecase;

		// mostly copied from haxe.unit.TestRunner

		t.currentTest = status;
		t.assertions = [];

		try {
			Reflect.callMethod(t, field, new Array());
		} catch (e:TestStatus) {
			t.assertions.push(new Assertion(false, e.error, e.posInfos));
		}
		// can't handle arbitary throw
		// catch (e:Dynamic) {}
		return t.assertions;
	}
}
