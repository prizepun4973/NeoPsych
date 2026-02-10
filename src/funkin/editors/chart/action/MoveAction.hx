package funkin.editors.chart.action;

import funkin.editors.chart.ChartEditorState;
import funkin.editors.chart.element.*;
import flixel.FlxG;
import flixel.FlxSprite;

class MoveAction extends EditorAction {
    public var datas:Array<Int> = [];
    public var targets:Array<GuiElement> = [];
    public var removed:Array<Int> = [];
    public var dataPre:Array<Map<String, Dynamic>> = [];
    public var deltaTime:Float;
    public var deltaData:Int = 0;

    public function new(targets:Array<GuiElement>) {
        super();

        this.targets = targets;

        for (i in targets) {
            datas.push(i.dataID);
            dataPre.push(ChartEditorState.data[i.dataID]);
        }

        deltaTime = editor.crosshair.getMousePos() - editor.crosshair.dragTarget.strumTime;
        if (Std.isOfType(editor.crosshair.dragTarget, GuiNote)) deltaData = Math.floor((FlxG.mouse.x - editor.gridBG.x) / ChartEditorState.GRID_SIZE) - (cast (editor.crosshair.dragTarget, GuiNote)).noteData;

        redo();
    }

    override function redo() {
        for (i in datas) {
            var data = ChartEditorState.data[i];
            if (data.get('strumTime') + deltaTime > FlxG.sound.music.length || data.get('strumTime') + deltaTime < 0) {
                remove(i);
                continue;
            }

            data.set('strumTime', data.get('strumTime') + deltaTime);
            data.set('noteData', data.get('noteData') + deltaData);

            if (data.get('events') == null) {
                if (data.get('noteData') < 0 || data.get('noteData') > 7) { // TODO: multikey mb
                    remove(i);
                    continue;
                }
            }

            // editor.renderNotes.forEachAlive(function (spr:FlxSprite) {
            //     if (Std.isOfType(spr, GuiNote)) (cast (spr, GuiNote)).updateAnim();
            // });
        }
    }

    override function undo() {
        for (i in datas) {
            var data = ChartEditorState.data[i];
            data.set('noteData', data.get('noteData') - deltaData);
            data.set('strumTime', data.get('strumTime') - deltaTime);

            if (removed.contains(i)) {
                var note:GuiNote = new GuiNote(false, data.get('strumTime'), data.get('noteData'), data.get('susLength'));
                note.noteType = data.get('noteType');
                note.dataID = i;
                editor.addElement(note);
            }
        }
    }

    function remove(data:Int) {
        removed.push(data);
        editor.removeElementByDataID(data);
    }
}