/* Copyright (c) 2013 Meep Factory OU */

package;

import js.Node;
import saffron.tools.Winston;

typedef LoggerOptions = {
    var console : Bool;
    var json : Bool;
    var maxSize : Int;
    var maxFiles : Int;
};

class Logger {
    public static inline var level_debug = 0;
    public static inline var level_info = 1;
    public static inline var level_warning = 2;
    public static inline var level_error = 3;
    public static inline var level_fatal = 4;
    
#if debug
    private static inline var level_generic = 1;
#else
    private static inline var level_generic = 3;
#end
    
    private var winston : Winston;
    public var level : Int;
    
    public function new(path : String, level : Int = Logger.level_generic, options : LoggerOptions = null) {
        var transports = new Array<WinstonTransport>();
        var dir = Node.path.dirname(path);
        
        if(options == null) {
            options = { console: false, json: false, maxSize: 1024 * 1024, maxFiles: 1 };
        }
        
        if(dir != null && dir.length > 0 && !Node.fs.existsSync(dir)) {
            Node.fs.mkdirSync(dir);
        }
        
        if(options.console == true) {
            transports.push(Winston.createConsoleTransport({
                timestamp: true
            }));
        }
        
        transports.push(Winston.createFileTransport({
            filename: path + '.log',
            json: options.json,
            maxsize: options.maxSize,
            maxFiles: options.maxFiles
        }));
        
        this.level = level;
        this.winston = Winston.createLogger({
            level: 'debug',
            transports: transports,
            exitOnError: false
        });
    }
    
    public function debug(line : String, ?meta : Dynamic) : Void {
        if(this.level <= Logger.level_debug) {
            this.winston.debug(line, meta);
        }
    }
    
    public function info(line : String, ?meta : Dynamic) : Void {
        if(this.level <= Logger.level_info) {
            this.winston.info(line, meta);
        }
    }
    
    public function warning(line : String, ?meta : Dynamic) : Void {
        if(this.level <= Logger.level_warning) {
            this.winston.warning(line, meta);
        }
    }
    
    public function error(line : String, ?meta : Dynamic) : Void {
        if(this.level <= Logger.level_error) {
            this.winston.error(line, meta);
        }
    }
    
    public function fatal(line : String, ?meta : Dynamic) : Void {
        if(this.level <= Logger.level_fatal) {
            this.winston.crit(line, meta);
        }
    }
}