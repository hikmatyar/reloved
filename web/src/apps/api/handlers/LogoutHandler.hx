/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;

class LogoutHandler extends Handler {
    public function index() {
    	this.exit(Error.unsupported_api);
    }
}