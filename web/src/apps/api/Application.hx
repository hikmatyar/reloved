/* Copyright (c) 2013 Meep Factory OU */

package apps.api;

import apps.api.handlers.*;
import saffron.Data;
import saffron.Server;

class Application {
    public static function main() {
        var server = new Server();
        
        // Configuration
        Data.adapter = Config.mysql_adapter;
        
        // Routes
        server.post('/login', LoginHandler);
        server.post('/logout', LogoutHandler);
        
        // Start the server
        server.start(Config.port_api);
    }
}