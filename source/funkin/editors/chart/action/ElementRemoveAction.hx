package funkin.editors.chart.action;

import funkin.editors.chart.ChartEditorState;
import funkin.editors.chart.ChartEditorState.GuiElement;
import funkin.editors.chart.ChartEditorState.EditorAction;
import funkin.editors.chart.ChartEditorState.SelectIndicator;
import funkin.editors.chart.action.NoteAddAction;
import funkin.editors.chart.element.*;
import funkin.game.component.Note.EventNote;
import flixel.FlxG;

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
    private var elements:Array<GuiElement> = new Array();
    public var datas:Array<ElementRemoveData> = new Array();
    public var relatedActions:Array<EditorAction> = new Array();

    public function new(elements:Array<GuiElement>) {
        super();

        for (element in elements) {
            var selected:Bool = false;
            ChartEditorState.INSTANCE.selectIndicator.forEachAlive(function (indicator:SelectIndicator) {
                if (indicator.target == element) selected = true;
            });

            var data:ElementRemoveData = {
                events: [],
                strumTime: 0,
                noteData: 0,
                susLength: 0,
                noteType: "",
                relatedAction: null,
                wasSelected: false
            };
            if (Std.isOfType(element, GuiNote)) {
                var note:GuiNote = cast (element, GuiNote);

                data = {
                    events: null,
                    strumTime: note.strumTime,
                    noteData: note.noteData,
                    susLength: note.susLength,
                    noteType: note.noteType,
                    relatedAction: note.relatedAction,
                    wasSelected: selected
                };

            }
            if (Std.isOfType(element, GuiEventNote)) {
                var event = cast (element, GuiEventNote);

                data = {
                    events: event.events,
                    strumTime: event.strumTime,
                    noteData: 0,
                    susLength: 0,
                    noteType: "",
                    relatedAction: null,
                    wasSelected: selected
                };
            }

            datas.push(data);
            this.elements.push(element);
        }

        redo();
    }

    override function redo() {
        for (element in elements) {
            relatedActions.push(element.relatedAction);

            ChartEditorState.INSTANCE.selectIndicator.forEachAlive(function (indicator:SelectIndicator) {
                if (indicator.target == element) ChartEditorState.INSTANCE.selectIndicator.remove(indicator);
            });

            if (Std.isOfType(element, GuiNote)) ChartEditorState.INSTANCE.renderNotes.remove((cast (element, GuiNote)).susTail);
            ChartEditorState.INSTANCE.renderNotes.remove(element);
            // note = null;
        }
    }

    override function undo() {
        for (data in datas) {
            trace(data);

            if (data.events == null) {
                var note:GuiNote = new GuiNote(data.strumTime, data.noteData, data.susLength, data.relatedAction);
                note.noteType = data.noteType;
                
                elements.push(note);
                trace(note);

                if (data.wasSelected) ChartEditorState.INSTANCE.selectIndicator.add(new SelectIndicator(note));
            }
            else {
                var event:GuiEventNote = new GuiEventNote(data.strumTime, data.events);
                
                elements.push(event);
                trace(event);

                ChartEditorState.INSTANCE.renderNotes.add(event);
                if (data.wasSelected) ChartEditorState.INSTANCE.selectIndicator.add(new SelectIndicator(event));
            }
        }
    }
}