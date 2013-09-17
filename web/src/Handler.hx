/* Copyright (c) 2013 Meep Factory OU */

import models.User;
    
class Handler extends saffron.Handler {
    private inline function user() : User {
        return this.request.user;
    }
    
    private inline function exit(code : Int, ?reason : String) : Void {
#if debug
		if(reason != null) {
			trace('{ "error": ' + code + ', "reason": "' + reason + '" }');
		}
#end
    	this.response.json((code == Error.none) ? 200 : (((Error.isSecurityRelated(code))) ? 403 : 500), { 'error': code });
    }
    
    private inline function begin(code : Int) : Void {
    	this.response.writeHead(code, { 'Content-Type': 'application/json' });
    }
    
    private inline function write(msg : String) {
        this.response.write(msg);
    }
    
    private inline function end(?msg : String) {
        this.response.end(msg);
    }
}
