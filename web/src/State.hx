/* Copyright (c) 2013 Meep Factory OU */

import js.Node;
import saffron.tools.JSON;

class State {
    public var timestamp(default, default) : Int;
    public var min(default, default) : Int;
    public var max(default, default) : Int;
    
    public static function parse(data : String) : State {
        if(data != null) {
            data = new NodeBuffer(data, 'base64').toString('ascii');
        }
        
        if(data != null) {
           data = JSON.parse(data);
        }
        
        return (Std.is(data, Dynamic)) ? new State(data) : null;
    }
    
    public function new(?json : Dynamic) {
        if(json != null) {
            this.min = (Std.is(json.a, Int)) ? json.a : 0;
            this.max = (Std.is(json.b, Int)) ? json.b : 0;
            this.timestamp = (Std.is(json.t, Int)) ? json.t : null;
        } else {
            this.min = 0;
            this.max = 0;
        }
    }
    
    private function jsonRaw() : Dynamic {
        var json : Dynamic = { a: this.min, b: this.max };
        
        if(this.timestamp != null) {
            json.t = this.timestamp;
        }
        
        return json;
    }
    
    public function json() : String {
        return '"' + new NodeBuffer(JSON.stringify(this.jsonRaw())).toString('base64') + '"';
    }
}
