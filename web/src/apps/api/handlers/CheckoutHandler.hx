/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;
import models.Order;
import models.Post;
import models.User;

using apps.api.mixins.CheckoutMixins;

class CheckoutHandler extends Handler {
	public function index() {
		var postIds = this.checkoutPostIdentifiers();
    	
    	if(postIds != null && postIds.length > 0) {
			Post.findAllForIdentifiers(postIds, function(err, posts) {
				if(posts != null && posts.length > 0) {
					// Quickly validate posts
					for(post in posts) {
						if(post.status != Post.status_listed) {
							this.exit(ErrorCode.invalid_parameter);
							return;
						}
					}
					
					Post.cacheRelationsForPosts(posts, function(err) {
						if(err != null) {
							this.exit(ErrorCode.unknown, 'posts_cache');
							return;
						}
						
						User.find(this.user().id, function(err, user) {
							var delimiter = '';
    						
							if(err != null) {
								this.exit(ErrorCode.unknown, 'user');
								return;
							}
							
							this.begin(ErrorCode.http_ok);
							this.write('{ "error": 0"');
							
							this.write(', "user": ' + user.json());
							this.write(', "fees": { "GBP": 500 }');
							this.write(', "posts": [');
							
							for(post in posts) {
								this.write(delimiter);
								this.write(post.json());
								delimiter = ',';
							}
							
							this.write(']');
							this.end('}');
						});
					});
				} else if(err != null) {
					this.exit(ErrorCode.unknown, 'posts');
				} else {
					this.exit(ErrorCode.invalid_parameter);
				}
			});
		}
	}
	
    public function commit() {
    	var postIds = this.checkoutPostIdentifiers();
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
    	
    	if(postIds != null && postIds.length > 0 && deliveryId != 0 && stripeToken != null &&
    	   price > 0 && amount != null && currency != null && countryId != 0 &&
    	   email != null && phone != null &&
    	   firstName != null && lastName != null &&
    	   city != null && address != null && zipCode != null) {
    		Order.create({
    			user_id: this.user().id,
    			delivery_id: deliveryId, stripe_token: stripeToken,
    			price: price, amount: amount, currency: currency, country_id: countryId,
    			email: email, phone: phone,
    			first_name: firstName, last_name: lastName,
    			city: city, address: address, zipcode: zipCode
    		}, function(err, order) {
    			if(order != null) {
    				OrderPost.create(order.id, postIds, function(err) {
    					if(err != null) {
    						this.exit(ErrorCode.unknown, 'order_posts');
    						return;
    					}
    					
    					order.publish();
    					this.begin(ErrorCode.http_ok);
    					this.end(order.json());
    				});
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
    				this.begin(ErrorCode.http_ok);
    				this.end(order.json());
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