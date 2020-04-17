package haxe.unit;

import haxe.CallStack;
import haxe.PosInfos;

class TestStatus {
	public var done : Bool;
	public var success : Bool;
	public var error : String;
	public var method : String;
	public var classname : String;
	public var posInfos : PosInfos;
	public var backtrace : String;
	public function new() 	{
		done = false;
		success = false;
	}
}