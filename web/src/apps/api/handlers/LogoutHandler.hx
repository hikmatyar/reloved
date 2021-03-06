/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;
import models.User;

using apps.api.mixins.SessionMixins;

class LogoutHandler extends Handler {
    public function index() {
    	var session = this.request.sessionCode();
        var userId = this.request.sessionUser();
        
        if(session != null && userId != null) {
            User.logout(userId, session, function(err, result) {
                this.exit((result) ? ErrorCode.none : ErrorCode.unknown);
            });
        } else {
            this.exit(ErrorCode.missing_parameter, 'session');
        }
    }
}