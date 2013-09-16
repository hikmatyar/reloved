/* Copyright (c) 2013 Meep Factory OU */

package apps.api.mixins;

class LoginMixins {
    public static inline function loginScope(handler : Handler) : String {
        return handler.request.body.scope;
    }
    
    public static inline function loginSessionLength(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.length);
    }
    
    public static inline function loginType(handler : Handler) : String {
        return handler.request.body.type;
    }
    
    public static inline function loginToken(handler : Handler) : String {
        return handler.request.body.token;
    }
    
    public static inline function loginSecret(handler : Handler) : String {
        return handler.request.body.secret;
    }
}