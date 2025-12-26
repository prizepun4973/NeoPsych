package funkin.jit.script;

import flixel.FlxState;

abstract class Script {
    public var target:FlxState;
    public function new(scriptName:String, target:FlxState) {}
    public function set(name:String, value:Any) {}
    public function call(name:String, args:Array<Dynamic>) {}
    public function stop() {}
}