/* Copyright (c) 2013 Meep Factory OU */

package;

class ErrorCode {
    public static inline var none = 0;
    public static inline var invalid_parameter = 1000;
    public static inline var missing_parameter = 1001;
    public static inline var limit_exceeded = 1018;
    public static inline var access_denied = 1019;
    public static inline var session_required = 1020;
    public static inline var session_expired = 1021;
    public static inline var session_invalid = 1022;
    public static inline var unknown = 2000;
    public static inline var unsupported_api = 4000;
    
    public static inline var http_ok = 200;
    public static inline var http_403 = 403;
    public static inline var http_404 = 404;
    public static inline var http_500 = 500;
    
    public static inline function isSecurityRelated(err : Int) : Bool {
        return err == ErrorCode.session_required ||
               err == ErrorCode.session_expired ||
               err == ErrorCode.session_invalid ||
               err == ErrorCode.access_denied;
    }
    
    public static inline function toString(err : Int) : String {
        return 'API: ' + err;
    }
}
