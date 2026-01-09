package funkin.editors.chart.action;

import funkin.editors.chart.ChartEditorState;
import funkin.editors.chart.ChartEditorState.GuiElement;
import funkin.editors.chart.ChartEditorState.EditorAction;
import funkin.editors.chart.ChartEditorState.SelectIndicator;
import funkin.editors.chart.action.NoteAddAction;
import funkin.editors.chart.element.*;
import funkin.game.component.Note.EventNote;
import flixel.FlxG;
import flixel.FlxSprite;

typedef ElementRemoveData = {
    var events:Array<EventNote>;
    var strumTime:Float;
    var noteData:Int;
    var susLength:Float;
    var noteType:String;
    var relatedAction:EditorAction;
    var wasSelected:Bool;
}

class ElementRemoveAction extends ChartEditorState.EditorAction {
    public var elements:Array<GuiElement> = new Array();
    public var datas:Array<Int> = new Array();

    public function new(elements:Array<GuiElement>) {
        super();

        for (i in elements) datas.push(i.dataID);

        redo();
    }

    override function redo() {
        for (i in datas) {
            editor.renderNotes.forEach(function (spr:FlxSprite) {
                if (Std.isOfType(spr, GuiElement)) {
                    var element:GuiElement = cast (spr, GuiElement);
                    if (((Std.isOfType(element, GuiNote) && editor.data[i].exists('noteData')) || (Std.isOfType(element, GuiEventNote) && !editor.data[i].exists('noteData')))
                        && element.strumTime == editor.data[i].get('strumTime')) editor.renderNotes.remove(element);
                }
            });
        }
    }

    override function undo() {
        for (i in datas) {
            var data = editor.data[i];
            if (editor.data[i].exists('noteData')) {
                var note:GuiNote = new GuiNote(false, data.get('strumTime'), data.get('noteData'), data.get('susLength'));
                note.noteType = data.get('noteType');
                note.dataID = i;
                editor.addElement(note);
            } else {
                var event:GuiEventNote = new GuiEventNote(false, data.get('strumTime'), null);
                event.events = data.get('events');
                event.dataID = i;
                editor.addElement(event);
            }
        }
    }
}