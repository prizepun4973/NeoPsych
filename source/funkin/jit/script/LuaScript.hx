package funkin.jit.script;

import llua.State;

class LuaScript extends Script {
    public static var Function_Stop:Dynamic = "##PSYCHLUA_FUNCTIONSTOP";
	public static var Function_Continue:Dynamic = "##PSYCHLUA_FUNCTIONCONTINUE";
	public static var Function_StopLua:Dynamic = "##PSYCHLUA_FUNCTIONSTOPLUA";

    public var lua:State = LuaL.newstate();

    public var scriptName:String = '';
    
    public function new(script:String, target:FlxState) {
        this.target = target;

        LuaL.openlibs(lua);
		Lua.init_callbacks(lua);

        if (!FileSystem.exists(Paths.getStateLua(script))) {
			lua = null;
			return;
		}

        var result:Dynamic = LuaL.dofile(lua, Paths.getStateLua(script));

		if (Lua.tostring(lua, result) != null && result != 0) {
			trace("Failed to load " + script);
			lua = null;
			return;
		}

        scriptName = script;
        trace('Loaded lua: ' + script);
    }
}