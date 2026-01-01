package funkin.game.jit.event;

typedef ChartEvent = {
    var name:String;
    var params:Array<Dynamic>;
}

class EventGameEvent extends Cancellable {
    public var event:ChartEvent;

    public function new(_name:String, value1:String, value2:String) {
        super();
        event = {
            name: _name,
            params: [value1, value2]
        }
    }
}