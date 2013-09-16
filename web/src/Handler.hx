/* Copyright (c) 2013 Meep Factory OU */

import models.User;
    
class Handler extends saffron.Handler {
    private inline function user() : User {
        return this.request.user;
    }
    
    private inline function exit(code : Int, ?reason : String) : Void {
    	this.response.json((code == Error.none) ? 200 : (((Error.isSecurityRelated(code))) ? 403 : 500), { 'error': code });
    }
}
