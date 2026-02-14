package funkin.component.ui;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ButtonWidget extends flixel.FlxSprite {
    var onClick:Void -> Void;
    var text:FlxText;

    var stopSpam:Bool = false;

    public override function new(parent:flixel.group.FlxGroup.FlxTypedGroup<flixel.FlxBasic>, X:Float, Y:Float, buttonText:String, onClick:Void -> Void) {
        super(X, Y);
        
        text = new FlxText(X + 2, Y + 2, 400, buttonText, 18);
        text.wordWrap = false;
        text.autoSize = true;
        text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

        makeGraphic(Std.int(text.width) + 4, Std.int(text.height) + 4);

        parent.add(this);
        parent.add(text);
        this.onClick = onClick;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (CoolUtil.mouseInRange(x, x + width, y, y + height) && FlxG.mouse.justPressed && !stopSpam) {
            onClick(); // why you trigger twice
            stopSpam = true;
        }

        if (FlxG.mouse.justReleased) stopSpam = false;
    }

    public function setText(_text:String) {
        text.text = _text;
        makeGraphic(Std.int(text.width) + 4, Std.int(text.height) + 4);
    }

    public function getText() {
        return text.text;
    }
}