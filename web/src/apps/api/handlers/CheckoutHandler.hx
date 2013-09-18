/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;

using apps.api.mixins.CheckoutMixins;

class CheckoutHandler extends Handler {
    public function index() {
    	this.exit(Error.unsupported_api);
    }
    
    public function status() {
    	this.exit(Error.unsupported_api);
    }
}