/* Copyright (c) 2013 Meep Factory OU */

package apps.agent.tasks;

import js.Node;

class Processor extends Task {
    private var min : Int;
    private var max : Int;
    
    public function new() {
        super('Processor', 1000);
        this.min = -1;
    }
    
    private override function onRun() : Void {
        this.reschedule();
    }
}