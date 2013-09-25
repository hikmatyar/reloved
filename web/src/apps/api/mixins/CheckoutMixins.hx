/* Copyright (c) 2013 Meep Factory OU */

package apps.api.mixins;

class CheckoutMixins {
	public static inline function checkoutIdentifier(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.order);
    }
    
    public static inline function checkoutPostIdentifier(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.post);
    }
    
    public static inline function checkoutDeliveryIdentifier(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.delivery);
    }
    
    public static inline function checkoutStripeToken(handler : Handler) : String {
        return handler.request.body.stripe;
    }
    
    public static inline function checkoutPrice(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.price);
    }
    
    public static inline function checkoutAmount(handler : Handler) : String {
        return handler.request.body.amount;
    }
    
    public static inline function checkoutCurrency(handler : Handler) : String {
        return handler.request.body.stripe;
    }
    
    public static inline function checkoutCountryIdentifier(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.country);
    }
    
    public static inline function checkoutEmail(handler : Handler) : String {
        return handler.request.body.email;
    }
    
    public static inline function checkoutPhone(handler : Handler) : String {
        return handler.request.body.phone;
    }
    
    public static inline function checkoutFirstName(handler : Handler) : String {
        return handler.request.body.first_name;
    }
    
    public static inline function checkoutLastName(handler : Handler) : String {
        return handler.request.body.last_name;
    }
    
    public static inline function checkoutCity(handler : Handler) : String {
        return handler.request.body.city;
    }
    
    public static inline function checkoutAddress(handler : Handler) : String {
        return handler.request.body.address;
    }
    
    public static inline function checkoutZipCode(handler : Handler) : String {
        return handler.request.body.zipcode;
    }
}