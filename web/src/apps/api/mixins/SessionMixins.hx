/* Copyright (c) 2013 Meep Factory OU */

package apps.api.mixins;

import saffron.tools.Express;

class SessionMixins {
    public static inline function sessionCode(request : ExpressRequest) : String {
        return request.body._s;
    }
    
    public static inline function sessionUser(request : ExpressRequest) : String {
        return request.body._u;
    }
}