/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;
import models.Order;

using apps.api.mixins.CheckoutMixins;

class CheckoutHandler extends Handler {
    public function index() {
    	var postId = this.checkoutPostIdentifier();
    	var deliveryId = this.checkoutDeliveryIdentifier();
    	var stripeToken = this.checkoutStripeToken();
    	var price = this.checkoutPrice();
    	var amount = this.checkoutAmount();
    	var currency = this.checkoutCurrency();
    	var countryId = this.checkoutCountryIdentifier();
    	var email = this.checkoutEmail();
    	var phone = this.checkoutPhone();
    	var firstName = this.checkoutFirstName();
    	var lastName = this.checkoutLastName();
    	var city = this.checkoutCity();
    	var address = this.checkoutAddress();
    	var zipCode = this.checkoutZipCode();
    	
    	if(postId != 0 && deliveryId != 0 && stripeToken != null &&
    	   price > 0 && amount != null && currency != null && countryId != 0 &&
    	   email != null && phone != null &&
    	   firstName != null && lastName != null &&
    	   city != null && address != null && zipCode != null) {
    		Order.create({
    			user_id: this.user().id,
    			post_id: postId, delivery_id: deliveryId, stripe_token: stripeToken,
    			price: price, amount: amount, currency: currency, country_id: countryId,
    			email: email, phone: phone,
    			first_name: firstName, last_name: lastName,
    			city: city, address: address, zipcode: zipCode
    		}, function(err, order) {
    			if(order != null) {
    				order.publish();
    				this.render(order.json());
    			} else {
    				this.exit(ErrorCode.unknown, 'order');
    			}
    		});
    	} else {
    		this.exit(ErrorCode.missing_parameter, 'order');
    	}
    }
    
    public function status() {
    	var orderId = this.checkoutIdentifier();
    	
    	if(orderId != 0) {
    		Order.find(orderId, function(err, order) {
    			if(order != null && order.userId == this.user().id) {
    				this.render(order.json());
    			} else if(err != null) {
    				this.exit(ErrorCode.unknown, 'order');
    			} else {
    				this.exit(ErrorCode.access_denied, 'order');
    			}
    		});
    	} else {
    		this.exit(ErrorCode.missing_parameter, 'order');
    	}
    }
}