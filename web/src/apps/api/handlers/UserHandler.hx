/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;

using apps.api.mixins.UserMixins;

class UserHandler extends Handler {
    public function edit() {
    	this.exit(Error.unsupported_api);
    }
}