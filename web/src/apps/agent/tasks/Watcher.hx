/* Copyright (c) 2013 Meep Factory OU */

package apps.agent.tasks;

import js.Node;
import models.Post;

class Watcher extends Task {
    private var min : Int;
    private var max : Int;
    
    public function new() {
        super('Watcher', 60000);
        this.min = -1;
    }
    
    private override function onRun() : Void {
        if(this.min < 0) {
            Post.findForward(null, 1, function(err, posts) {
                if(posts != null && posts.length > 0) {
                    this.min = posts[0].modified;
                    this.max = this.min;
                    this.reschedule(true);
                } else {
                    this.reschedule();
                }
            });
        } else {
            Post.findChanges(this.min, this.max, function(err, changes) {
                if(changes != null && changes.length > 0) {
                	// TODO: Send emails
                    trace('detected a change');
                }
                
                this.reschedule();
            });
        }
    }
}