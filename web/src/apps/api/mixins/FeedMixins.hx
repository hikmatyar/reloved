/* Copyright (c) 2013 Meep Factory OU */

package apps.api.mixins;

class FeedMixins {
    public static inline function feedDirection(handler : Handler) : String {
        return handler.request.body.direction;
    }
    
    public static inline function feedLimit(handler : Handler) : Int {
        var limit = Std.parseInt(handler.request.body.limit);
        
        return (limit > 0) ? limit : 100;
    }
    
    public static inline function feedState(handler : Handler) : State {
        return State.parse(handler.request.body.state);
    }
}