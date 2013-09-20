/* Copyright (c) 2013 Meep Factory OU */

package apps.api.mixins;

class UserMixins {
    public static inline function userIdentifier(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.id);
    }
    
    public static inline function userSizeIdentifier(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.size);
    }
    
    public static inline function userMediaIdentifier(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.media);
    }
    
    public static inline function userCountryIdentifier(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.country);
    }
    
    public static inline function userEmail(handler : Handler) : String {
        return handler.request.body.email;
    }
    
    public static inline function userPhone(handler : Handler) : String {
        return handler.request.body.phone;
    }
    
    public static inline function userFirstName(handler : Handler) : String {
        return handler.request.body.first_name;
    }
    
    public static inline function userLastName(handler : Handler) : String {
        return handler.request.body.last_name;
    }
    
    public static inline function userCity(handler : Handler) : String {
        return handler.request.body.city;
    }
    
    public static inline function userAddress(handler : Handler) : String {
        return handler.request.body.address;
    }
    
    public static inline function userZipCode(handler : Handler) : String {
        return handler.request.body.zipcode;
    }
}