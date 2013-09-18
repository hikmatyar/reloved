/* Copyright (c) 2013 Meep Factory OU */

import models.User;
    
class Page extends saffron.Page {
    private inline function user() : User {
        return this.request.user;
    }
    
    private override function layout() : String {
    	return 'layout';
    }
}
