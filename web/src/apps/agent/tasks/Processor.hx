/* Copyright (c) 2013 Meep Factory OU */

package apps.agent.tasks;

import js.Node;
import models.Post;
import models.Queue;

class Processor extends Task {
	
    public function new() {
        super('Processor', 1000);
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
        		this.reschedule();
        	});
    	});
    }
}