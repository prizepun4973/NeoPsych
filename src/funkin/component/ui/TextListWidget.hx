package funkin.component.ui;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;

import lime.ui.*;
import flixel.input.keyboard.FlxKey;

class TextListWidget extends TextBoxWidget {
    public var textHeight:Float;
    public var suggestions:Array<String> = [];

    var bg:FlxSprite;
    var texts:Array<FlxText> = [];

    public override function new(parent:flixel.group.FlxGroup.FlxTypedGroup<flixel.FlxBasic>, X:Float, Y:Float, width:Int, buttonText:String, suggestions:Array<String>, onChange:TextBoxWidget -> Void) {
        super(parent, X, Y, width, buttonText, onChange);
        textHeight = displayText.height;
        this.suggestions = suggestions;

        bg = new FlxSprite(X, Y + height).makeGraphic(Std.int(this.width), Std.int(textHeight + 2) * suggestions.length);
        parent.add(bg);

        for (i in 0...suggestions.length) {
            var text = new FlxText(X + 2, Y + height + (textHeight + 2) * i + 2, 400, suggestions[i], 18);
            text.wordWrap = false;
            text.autoSize = true;
            text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            texts.push(text);
            text.visible = false;
            text.alpha = 0.5;

            parent.add(text);
        }

        updateSuggestion();
    }

    override function update(elapsed:Float) {
        var prevEditing:Bool = editing;
        super.update(elapsed);
        for (i in texts) i.visible = editing;
        bg.visible = editing;

        if (FlxG.mouse.justReleased && prevEditing && !editing && FlxG.mouse.x > x && FlxG.mouse.x < x + width && FlxG.mouse.y > y + height && FlxG.mouse.y < y + height + bg.height) {
            displayText.text = texts[Math.floor((FlxG.mouse.y - y - height) / (textHeight + 2))].text;
            trace(Math.floor((FlxG.mouse.y - y - height) / (textHeight + 2)));
        }
    }

    override function onKeyDown(key:KeyCode, modifier:KeyModifier) {
        super.onKeyDown(key, modifier);
        updateSuggestion();
    }

    function updateSuggestion() {
        for (i in texts) i.alpha = StringTools.contains(i.text, displayText.text) || displayText.text == '' ? 1 : 0.25;
    }
}