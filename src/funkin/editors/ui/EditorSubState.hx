package funkin.editors.ui;

import funkin.jit.InjectedSubState;
import flixel.util.FlxColor;
import funkin.component.ui.*;

class EditorSubState extends funkin.jit.InjectedSubState {
    override public function new(script:String) {
        super(script);
    }

    public function addButton(X:Float, Y:Float, text:String, onClick:Void -> Void) {
        new ButtonWidget(this, X, Y, text, onClick);
    }

    public function addTextBox(X:Float, Y:Float, width:Int, buttonText:String, onChange:Void -> Void) {
        new TextBoxWidget(this, X, Y, width, buttonText, onChange);
    }
}