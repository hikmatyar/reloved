/* Copyright (c) 2013 Meep Factory OU */

package apps.api.mixins;

import saffron.Data;

using StringTools;

class PostCommentMixins {
    public static inline function postCommentIdentifier(handler : Handler) : DataIdentifier {
        return Std.parseInt(handler.request.body.cid);
    }
    
    public static inline function postCommentStatus(handler : Handler) : DataIdentifier {
        return (handler.request.body.status != null && handler.request.body.status.length > 0) ? Std.parseInt(handler.request.body.status) : null;
    }
    
    public static inline function postCommentEmoticonIdentifier(handler : Handler) : DataIdentifier {
    	return Std.parseInt(handler.request.body.emoticon);
    }
    
    public static inline function postCommentMessage(handler : Handler) : String {
        return handler.request.body.message;
    }
}