package funkin.editors.chart.action;

import funkin.editors.chart.ChartEditorState;
import funkin.editors.chart.action.NoteAddAction;
import funkin.editors.chart.element.GuiEventNote;
import funkin.game.component.Note.EventNote;
import flixel.FlxG;

class EventAddAction extends ChartEditorState.EditorAction {
    public var _event:GuiEventNote;

    public var strumTime:Float;
    public var events:Array<EventNote>;
    public var wasSelected:Bool = false;

    public function new(strumTime, events = null) {
        super();

        this.strumTime = strumTime;
        this.events = events != null ? events : new Array();

        ChartEditorState.INSTANCE.selectIndicator.forEachAlive(function (indicator:SelectIndicator) {
            if (indicator.target == _event) wasSelected = true;
        });

        redo();
    }

    override function redo() {
        _event = new GuiEventNote(strumTime, events, this);
        if (wasSelected) ChartEditorState.INSTANCE.selectIndicator.add(new SelectIndicator(_event));
        ChartEditorState.INSTANCE.renderNotes.add(_event);
    }

    override function undo() {
        ChartEditorState.INSTANCE.selectIndicator.forEachAlive(function (indicator:SelectIndicator) {
            if (indicator.target == _event) {
                wasSelected = true;
                ChartEditorState.INSTANCE.selectIndicator.remove(indicator);
            }
        });

        events = _event.events;
        ChartEditorState.INSTANCE.renderNotes.remove(_event);
    }
}