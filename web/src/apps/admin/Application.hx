/* Copyright (c) 2013 Meep Factory OU */

package apps.admin;

import apps.admin.pages.*;
import models.User;
import saffron.Data;
import saffron.Locale;
import saffron.Server;
import saffron.tools.Express;

class Application {
	public static function auth(request : ExpressRequest, response : ExpressResponse, fn : Int -> Void) : Void {
		// TODO: Proper auth (using mock atm)
    	User.find(1, function(err, user) {
			request.user = user;
			fn(null);
		});
    }
    
    public static function main() {
        var server = new Server();
        
        // Add localizations
        Locale.register('en', Strings.en);
        
        // Configuration
        server.config(temp_root, 'tmp');
        server.config(file_root, 'static');
        server.config(database, Config.mysql_adapter);
        server.express.use(Express.basicAuth('reloved', 'hello world'));
        
        // Routes
        server.get('/posts/:action', PostPage);
        
        // Start the server
        server.start(Config.port_admin);
    }
}