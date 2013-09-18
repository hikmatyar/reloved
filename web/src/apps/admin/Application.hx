/* Copyright (c) 2013 Meep Factory OU */

package apps.admin;

import apps.api.pages.*;
import models.User;
import saffron.Data;
import saffron.Server;
import saffron.tools.Express;

class Application {
    public static function main() {
        var server = new Server();
        
        // Configuration
        //server.config(auth, Application.auth);
        server.config(database, Config.mysql_adapter);
        //server.config(error, Application.error);
        
        // Routes
        
        // Start the server
        server.start(Config.port_api);
    }
}