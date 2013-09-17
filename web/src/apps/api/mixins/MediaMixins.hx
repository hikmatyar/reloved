/* Copyright (c) 2013 Meep Factory OU */

package apps.api.mixins;

class MediaMixins {
    public static inline function mediaMime(handler : Handler) : String {
        return handler.request.body.mime;
    }
    
    public static inline function mediaChecksum(handler : Handler) : String {
        return handler.request.body.csum;
    }
    
    public static inline function mediaFileOffset(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.offset);
    }
    
    public static inline function mediaIdentifier(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.id);
    }
    
    public static inline function mediaFileSize(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.size);
    }
    
    public static inline function mediaPreferredSize(handler : Handler) : String {
        return handler.request.body.size;
    }
}