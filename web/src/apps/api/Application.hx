/* Copyright (c) 2013 Meep Factory OU */

package apps.api;

import apps.api.handlers.*;
import models.User;
import saffron.Data;
import saffron.Server;
import saffron.tools.Express;

using apps.api.mixins.SessionMixins;

class Application {
	public static function auth(request : ExpressRequest, response : ExpressResponse, fn : Int -> Void) : Void {
        var session = request.sessionCode();
        var userId = request.sessionUser();
    	
        if(session != null && userId != null) {
            User.findForSession(userId, session, function(err, user) {
                if(err != null) {
                    fn(Error.unknown);
                } else if(user != null) {
                    if(user.session != null) {
                    	request.user = user;
                        fn(null);
                    } else {
                        fn(Error.session_expired);
                    }
                } else {
                    fn(Error.session_invalid);
                }
            });
        } else {
            fn(Error.session_required);
        }
    }
    
    public static function error(error : Dynamic, request : ExpressRequest, response : ExpressResponse, fn : Int -> Void) : Void {
    	response.json({ 'error': error });
    }
    
    public static function main() {
        var server = new Server();
        
        // Configuration
        server.config(auth, Application.auth);
        server.config(database, Config.mysql_adapter);
        server.config(error, Application.error);
        
        // Routes
        server.post('/login', LoginHandler);
        server.post('/logout', LogoutHandler);
        server.post('/browse', BrowseHandler, auth_required);
        
        // Start the server
        server.start(Config.port_api);
    }
}