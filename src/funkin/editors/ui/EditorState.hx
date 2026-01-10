package funkin.editors.ui;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import funkin.jit.InjectedState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class EditorState extends InjectedState {
    public var hudGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
    public var tab:Tabs;

    override function new(script:String) {
        super(script);
    }

    override function create() {
        super.create();
        Main.fpsVar.y = 25;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (tab != null) tab.update(elapsed);
    }

    override function destroy() {
        super.destroy();
        Main.fpsVar.y = 3;
    }
}

class Tabs {
    public var editor:funkin.editors.ui.EditorState = cast funkin.CoolUtil.editor;

    public var bg:Array<FlxSprite> = [];
    public var texts:Array<FlxText> = [];
    public var tabLists:Array<TabList> = [];
    
    public function new(tabs:Array<String>, tabListOptions:Array<Array<String>>) {
        editor.hudGroup.add(new FlxSprite(0, 0).makeGraphic(FlxG.width, 20, 0xffBD99FF));

        var widthSum:Float = 0;
        for (i in 0...tabs.length) {
            var text = new FlxText(widthSum + 2, 0 + 4, 400, tabs[i], 12);
            text.wordWrap = false;
            text.autoSize = true;
            text.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            texts.push(text);
            var tab = new FlxSprite(widthSum, 0).makeGraphic(Std.int(4 + text.width), 20, FlxColor.BLACK);
            bg.push(tab);

            editor.hudGroup.add(tab);
            editor.hudGroup.add(text);
            
            var tabList:TabList = new TabList(widthSum, 20, tabListOptions[i]);
            tabLists.push(tabList);

            widthSum += text.width + 4;
        }
    }

    public function update(elapsed:Float) {
        var widthSum:Float = 0;

        for (i in 0...bg.length) {
            tabLists[i].update(elapsed);

            var hovering:Bool = FlxG.mouse.x > widthSum && FlxG.mouse.x < widthSum + bg[i].width && FlxG.mouse.y < 20;

            if (FlxG.mouse.justPressed) {
                if (hovering) tabLists[i].visible = !tabLists[i].visible;
                else tabLists[i].visible = false;
            }

            widthSum += bg[i].width;
        }
    }
}

class TabList {
    public var editor:funkin.editors.ui.EditorState = cast funkin.CoolUtil.editor;

    public var x:Float;
    public var y:Float;

    public var size:Int;
    public var onClick:Int -> Void = function (a:Int) { trace(a); };

    public var bg:FlxSprite;
    public var indicator:FlxSprite;
    public var texts:Array<FlxSprite> = [];
    var textHeight:Float = 0;

    public var visible:Bool = false;

    public function new(X:Float, Y:Float, options:Array<String>) {
        x = X;
        y = Y;

        size = options.length;

        bg = new FlxSprite(X, Y);
        indicator = new FlxSprite(X, Y);
        editor.hudGroup.add(bg);
        editor.hudGroup.add(indicator);

        var listWidth:Float = 0;

        for (i in 0...options.length) {
            var text = new FlxText(X + 2, Y + (textHeight + 2) * i + 2, 400, options[i], 12);
            text.wordWrap = false;
            text.autoSize = true;
            text.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            texts.push(text);

            if (listWidth < text.width) listWidth = text.width;
            if (textHeight == 0) textHeight = text.height;
        
            editor.hudGroup.add(text);
        }
        
        bg.makeGraphic(Math.ceil(listWidth + 4), Math.ceil(options.length * (textHeight + 2)));
        indicator.makeGraphic(Math.ceil(listWidth + 4), Math.ceil(textHeight + 2), 0xFF000000);
    }

    public function update(elapsed:Float) {
        for (i in texts) i.visible = visible;

        bg.visible = visible;
        indicator.visible = visible && FlxG.mouse.x > x && FlxG.mouse.x < x + bg.width && FlxG.mouse.y > y && FlxG.mouse.y < y + bg.height;

        indicator.y = y + Math.floor((FlxG.mouse.y - y) / (textHeight + 2)) * (textHeight + 2);

        if (FlxG.mouse.justPressed && visible) onClick(Math.floor((FlxG.mouse.y - y) / (textHeight + 2)));
    }
}