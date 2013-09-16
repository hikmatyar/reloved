/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;
import models.User;
import saffron.Data;

using apps.api.mixins.LoginMixins;

class LoginHandler extends Handler {
    public function index() : Void {
        var type = this.loginType();
        var token = this.loginToken();
        var secret = this.loginSecret();
        var scope = this.loginScope();
        
        if(scope == null) {
            scope = User.scope_mobile;
        }
        
        var writeUser = function(err : DataError, user : User) {
            if(user != null) {
                this.render({ 'session': user.session, 'user': user.id });
            } else if(err != null && err.fatal == false) {
                this.exit(Error.access_denied);
            } else {
                this.exit(Error.unknown);
            }
        }
        
        if(type == User.type_auto && token != null && secret != null) {
            var sessionLength = this.loginSessionLength();
            
            if(sessionLength <= 0 || sessionLength >= Config.session_length * 2) {
                sessionLength = Config.session_length;
            }
            
            User.login(type, token, secret, scope, sessionLength, function(err, user) {
                if(err == null && user == null && type == User.type_auto) {
                    User.create(type, token, secret, scope, sessionLength, writeUser);
                } else {
                    writeUser(err, user);
                }
            });
        } else {
            this.exit(Error.missing_parameter, (secret != null) ? 'token' : 'secret');
        }
    }
}