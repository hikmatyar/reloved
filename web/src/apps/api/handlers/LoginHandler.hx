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
            	var contact : Dynamic = null;
            	
            	if(user.firstName != null || user.lastName != null || user.email != null || user.phone != null) {
            		contact = { };
            		
            		if(user.firstName != null) {
            			contact.first_name = user.firstName;
            		}
            		
            		if(user.lastName != null) {
            			contact.last_name = user.lastName;
            		}
            		
            		if(user.email != null) {
            			contact.email = user.email;
            		}
            		
            		if(user.phone != null) {
            			contact.phone = user.phone;
            		}
            	}
            	
                this.render({ 'session': user.session, 'user': user.id, 'contacts': contact });
            } else if(err != null && err.fatal == false) {
                this.exit(ErrorCode.access_denied);
            } else {
                this.exit(ErrorCode.unknown);
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
            this.exit(ErrorCode.missing_parameter, (secret != null) ? 'token' : 'secret');
        }
    }
}