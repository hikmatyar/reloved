/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;
import models.Order;
import models.Post;
import models.User;
import saffron.Data;
import saffron.tools.JSON;

using apps.api.mixins.CheckoutMixins;

class CheckoutHandler extends Handler {
	public function index() {
		var postIds = this.checkoutPostIdentifiers();
    	
    	if(postIds != null && postIds.length > 0) {
			Post.findAllForIdentifiers(postIds, function(err, posts) {
				if(posts != null && posts.length > 0) {
					Post.cacheRelationsForPosts(posts, function(err) {
						if(err != null) {
							this.exit(ErrorCode.unknown, 'posts_cache');
							return;
						}
						
						for(post in posts) {
							if(post.status != Post.status_listed) {
								var delimiter = '';
    							
    							this.begin(ErrorCode.http_ok);
								this.write('{ "error": ' + ErrorCode.invalid_parameter);
								this.write(', "posts": [');
								
								for(post_ in posts) {
									this.write(delimiter);
									this.write(post_.json());
									delimiter = ',';
								}
								
								this.write(']');
								this.end('}');
								return;
							}
						}
												
						User.findExtended(this.user().id, function(err, user) {
							var delimiter = '';
    						
							if(err != null) {
								this.exit(ErrorCode.unknown, 'user');
								return;
							}
							
							this.begin(ErrorCode.http_ok);
							this.write('{ "error": ' + ErrorCode.none);
							
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
		} else {
			this.exit(ErrorCode.missing_parameter);
		}
	}
	
    public function create() {
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
    	var userId = this.user().id;
    	
    	if(postIds != null && postIds.length > 0 && deliveryId != 0 && stripeToken != null &&
    	   price > 0 && amount != null && currency != null && countryId != 0 &&
    	   email != null && phone != null &&
    	   firstName != null && lastName != null &&
    	   city != null && address != null && zipCode != null) {
    		Order.create({
    			user_id: userId,
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
    					this.renderOrder(order, postIds);
    					
    					// Try to fill empty user fields
    					User.findExtended(userId, function(err, user) {
    						if(user != null) {
    							var attributes : UserAttributes = { };
    							var found = false;
    							
    							if(user.email == null) {
    								attributes.email = email;
    								found = true;
    							}
    							
    							if(user.phone == null) {
    								attributes.phone = phone;
    								found = true;
    							}
    							
    							if(user.firstName == null) {
    								attributes.first_name = firstName;
    								found = true;
    							}
    							
    							if(user.lastName == null) {
    								attributes.last_name = lastName;
    								found = true;
    							}
    							
    							if(user.countryId == null) {
    								attributes.country_id = countryId;
    								found = true;
    							}
    							
    							if(user.city == null) {
    								attributes.city = city;
    								found = true;
    							}
    							
    							if(user.address == null) {
    								attributes.address = address;
    								found = true;
    							}
    							
    							if(user.zipcode == null) {
    								attributes.zipcode = zipCode;
    								found = true;
    							}
    							
    							if(found) {
    								User.update(userId, attributes, function(err) { });
    							}
    						}
    					});
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
    				OrderPost.findAllForOrder(orderId, function(err, orderPosts) {
    					var postIds = new Array<DataIdentifier>();
    					
    					if(err != null) {
    						this.exit(ErrorCode.unknown, 'order_posts');
    						return;
    					}
    					
    					if(orderPosts != null) {
    						for(orderPost in orderPosts) {
    							postIds.push(orderPost.postId);
    						}
    					}
    					
    					this.renderOrder(order, postIds);
    				});
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
    
    private function renderOrder(order : Order, postIds : Array<DataIdentifier>) : Void {
    	this.begin(ErrorCode.http_ok);
    	this.write('{ "id": ' + order.id);
    	this.write(', "status": ' + order.status);
    	this.write(', "date": "' + new saffron.tools.Date(order.created * 1000).toISOString() + '"');
    	
    	if(postIds != null) {
    		var delimiter = '';
    		
			this.write(', "posts": [');
		
			for(postId in postIds) {
				this.write(delimiter);
				this.write('' + postId);
				delimiter = ',';
			}
			
			this.write(']');
    	}
    	
    	if(order.status == Order.status_declined) {
    		this.write(', "notice": { "title": "Payment declined", "message": "The payment was not processed :(" }');
    	} else if(order.status == Order.status_accepted || order.status == Order.status_completed) {
    		this.write(', "notice": { "title": "Thank You"');
    		this.write(', "subject": "Your order has been placed"');
    		this.write(', "message": ' + JSON.stringify(
    			'An e-mail confirmation has been sent to you.\n' +
    			'Order Status:\n' +
    			//'Delivery estimate Jan 15, 2013' +
    			'To be shipped by Royal Mail\n\n' +
    			'Shipped to:\n\n' +
    			order.firstName + ' ' + order.lastName + '\n' +
    			order.address + '\n' +
    			order.city + ', ' + order.zipcode + '\n' +
    			// FIXME: Quick hack 28 countryId
    			((order.countryId == 28) ? 'United Kingdom' : '')));
    		this.write('}');
    	}
    	
    	this.end('}');
    }
}