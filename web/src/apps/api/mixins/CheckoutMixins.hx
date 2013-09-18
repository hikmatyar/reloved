/* Copyright (c) 2013 Meep Factory OU */

package apps.api.mixins;

class CheckoutMixins {
    public static inline function checkoutIdentifier(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.id);
    }
}