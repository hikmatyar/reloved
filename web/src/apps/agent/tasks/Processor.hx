/* Copyright (c) 2013 Meep Factory OU */

package apps.agent.tasks;

import js.Node;
import models.Order;
import models.Post;
import models.Queue;
import saffron.tools.Stripe;

class Processor extends Task {
	private var stripe : Stripe;
	
    public function new() {
        super('Processor', 1000);
        this.stripe = Stripe.create(Config.stripe_key);
    }
    
    private function onOrderCleanup(order : Order, posts : Array<Post>, status : Int, error : String) : Void {
    	Order.update(order.id, (error != null) ?
    		{ stripe_error: error, status: status } : { status: status }, function(err) { });
    	
    	if(posts != null) {
			for(post in posts) {
				if(post.status == Post.status_listed_pending_purchase) {
					Post.update(post.id, {
						status: (status == Order.status_accepted) ? Post.status_listed_bought : Post.status_listed
					}, function(err) { });
				}
			}
		}
    }
    
    private function onQueueItem(queue : Queue) : Void {
    	async(function(sync) {
    		if(queue.task == Queue.task_publish) {
    			Post.findStatus(queue.data1, function(err, status, ready) {
    				if(err != null) {
    					this.error('queue publish error: ' + err);
    					sync();
    				} else {
    					if(status == Post.status_unlisted && ready == true) {
    						Post.update(queue.data1, { status: Post.status_listed }, function(err) {
    							if(err != null) {
    								this.error('queue post update error: ' + err);
    								sync();
    							} else {
    								Queue.delete(queue.id, function(err) {
										sync();
									});
								}
    						});
    					} else if(status != Post.status_unlisted) {
    						Queue.delete(queue.id, function(err) {
								sync();
							});
    					} else {
    						sync();
    					}
    				}
    			});
    		} else if(queue.task == Queue.task_stripe) {
    			Order.find(queue.data1, function(err, order) {
    				if(err != null) {
    					this.error('queue order error: ' + err);
    					sync();
    					return;
    				}
    				
    				if(order.status == Order.status_pending) {
						Post.findAllForOrder(order.id, function(err, posts) {
							var mismatch = false;
							var price = 0;
							
							if(err != null || posts == null) {
								this.error('queue order posts error: ' + err);
								sync();
								return;
							}
							
							for(post in posts) {
								price += post.price;
								
								if(post.status != Post.status_listed && post.status != Post.status_listed_pending_purchase) {
									mismatch = true;
								}
							}
							
							if(mismatch) {
								this.error('order post status mismatch ' + err);
								this.onOrderCleanup(order, posts, Order.status_declined, 'reloved: post status');
								Queue.delete(queue.id, function(err) { sync(); });
								return;
							}
							
							if(order.price != price || order.serviceFee < 0 || order.amount < order.price) {
								this.error('order price mismatch ' + err);
								this.onOrderCleanup(order, posts, Order.status_declined, 'reloved: price mismatch');
								Queue.delete(queue.id, function(err) { sync(); });
								return;
							}
							
							if(order.stripeToken == null) {
								this.error('order missing stripe token ');
								this.onOrderCleanup(order, posts, Order.status_declined, 'reloved: no stripe token');
								Queue.delete(queue.id, function(err) { sync(); });
								return;
							}
							
							this.stripe.charges.create({
								amount: order.amount,
								currency: order.currency,
								description: 'Order #' + order.id
							}).then(function(result) {
								this.onOrderCleanup(order, posts, Order.status_accepted, null);
								Queue.delete(queue.id, function(err) { sync(); });
							}, function(err) {
								this.error('stripe declined payment (' + order.id + ')');
								this.onOrderCleanup(order, posts, Order.status_declined, '' + err);
								Queue.delete(queue.id, function(err) { sync(); });
							});
						});
					} else {
						Queue.delete(queue.id, function(err) {
							sync();
						});
					}
    			});
    		} else {
    			this.error('queue task error: (' + queue.task + ')');
    			
    			Queue.delete(queue.id, function(err) {
    				sync();
    			});
    		}
    	});
    }
    
    private override function onRun() : Void {
    	Queue.findAll(function(err, queue) {
    		if(err != null) {
    			this.error('queue error: ' + err);
        		this.reschedule();
        		return;
        	}
        	
        	if(queue == null || queue.length == 0) {
        		this.reschedule();
        		return;
        	}
        	
        	for(q in queue) {
        		this.onQueueItem(q);
        	}
        	
        	async(function() {
        		this.reschedule(true);
        	});
    	});
    }
}