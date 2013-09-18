/* Copyright (c) 2013 Meep Factory OU */

package apps.api.mixins;

class PostMixins {
    public static inline function postIdentifier(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.id);
    }
}