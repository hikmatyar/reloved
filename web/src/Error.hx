/* Copyright (c) 2013 Meep Factory OU */

package;

class Error {
    public static inline var none = 0;
    public static inline var invalid_parameter = 1000;
    public static inline var missing_parameter = 1010;
    public static inline var limit_exceeded = 1018;
    public static inline var access_denied = 1019;
    public static inline var session_required = 1020;
    public static inline var session_expired = 1021;
    public static inline var session_invalid = 1022;
    public static inline var unknown = 2000;
    public static inline var unsupported_api = 4000;
    
    public static inline var http_403 = 403;
    public static inline var http_404 = 404;
    public static inline var http_500 = 500;
    
    public static inline function isSecurityRelated(err : Int) : Bool {
        return err == Error.session_required ||
               err == Error.session_expired ||
               err == Error.session_invalid ||
               err == Error.access_denied;
    }
    
    public static inline function toString(err : Int) : String {
        return 'API: ' + err;
    }
}
