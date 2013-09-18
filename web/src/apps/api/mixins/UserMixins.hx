/* Copyright (c) 2013 Meep Factory OU */

package apps.api.mixins;

class UserMixins {
    public static inline function userIdentifier(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.id);
    }
}