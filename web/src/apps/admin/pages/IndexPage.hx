/* Copyright (c) 2013 Meep Factory OU */

package apps.admin.pages;

import models.Post;

class IndexPage extends Page {
    public function index() : Void {
    	Post.findAll(function(err, posts) {
    		this.render({ posts: posts });
    	});
    }
}