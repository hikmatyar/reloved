/* Copyright (c) 2013 Meep Factory OU */

package apps.agent;

#if !macro
import js.Node;
import saffron.Async;
import saffron.tools.JSON;
#else
import haxe.macro.Context;
import haxe.macro.Expr;
#end

class Task {
	macro public function async(ethis : Expr, fn : Expr, ?parallel : Bool, ?nextTick : Bool) : Expr {
        return saffron.Macros.generateAsync(ethis, fn, parallel, nextTick);
    }
    
#if !macro
    public static var state_directory = 'tasks';
    
    private static var loggers : Dynamic = { };
    
    public var name(default, null) : String;
    public var running(default, null) : Bool;
    private var _async : Dynamic;
    private var _heartbeat : Int;
    private var _timer : Int;
    private var _state : Dynamic;
    
    private static function getLogger(name : String) : Logger {
        var logger : Logger = Task.loggers[untyped name];
        
        if(logger == null) {
            logger = new Logger(Node.path.join(Config.log_root, name), Config.log_level);
            Task.loggers[untyped name] = logger;
        }
        
        return logger;
    }
    
    private function debug(description : String, ?meta : Dynamic) : Void {
        Task.getLogger(this.name).debug(description, meta);
    }
    
    private function error(description : String, ?meta : Dynamic) : Void {
        Task.getLogger(this.name).error(description, meta);
    }
    
    public function start() : Void {
        if(!this.running) {
            this.running = true;
            this.onStart();
        }
    }
    
    public function stop() : Void {
        if(this.running) {
            this.running = false;
            this.onStop();
        }
    }
    
    public function status() : Dynamic {
        return null;
    }
    
    private function getStatePath() : String {
        var dir = Node.path.join(Node.__dirname, Task.state_directory);
        
        if(!Node.fs.existsSync(dir)) {
            Node.fs.mkdirSync(dir);
        }
        
        return Node.path.join(dir, this.name + '.task');
    }
    
    private function load() : Void {
        if(this._state == null) {
            var path = this.getStatePath();
            
            if(Node.fs.existsSync(path)) {
                try {
                    this._state = JSON.parse(Node.fs.readFileSync(path, 'utf8'));
                }
                catch(e : Dynamic) {
                    trace('Unable to load "' + path + '":\n\t' + e + '\n', true);
                }
            }
            
            if(this._state == null) {
                this._state = { };
            }
        }
    }
    
    private function save() : Void {
        var path = this.getStatePath();
        var data = "{}";
        
        if(this._state == null) {
            this._state = { };
        }
        
        try {
            data = JSON.stringify(this._state);
        }
        catch(e : Dynamic) {
            trace('Unable to save"' + path + '":\n\t' + e + '\n', true);
        }
        
        Node.fs.writeFile(path, data, function(err) {
            if(err != null) {
                trace('Unable to save "' + path + '":\n\t' + err + '\n', true);
            }
        });
    }
    
    private function onStart() : Void {
        Node.process.nextTick(function() {
            this.onRun();
        });
    }
    
    private function onStop() : Void {
        if(this._timer != 0) {
            Node.clearTimeout(this._timer);
            this._timer = 0;
        }
    }
    
    private function onRun() : Void {
    }
    
    private function reschedule(nextTick : Bool = false) : Void {
        if(this._heartbeat > 0 && nextTick != true) {
            this._timer = Node.setTimeout(function() {
                this._timer = 0;
                
                if(this.running) {
                    this.onRun();
                }
            }, this._heartbeat);
        } else {
            Node.process.nextTick(function() {
                if(this.running) {
                    this.onRun();
                }
            });
        }
    }
    
    private function new(name : String, heartbeat : Int = 60000) {
        this._async = new Async();
        this._heartbeat = heartbeat;
        this._timer = 0;
        this.name = name;
        this.running = false;
        this.load();
    }
#end
}