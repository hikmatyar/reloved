/* Copyright (c) 2013 Meep Factory OU */

package apps.admin.pages;

class PostPage extends Page {
    public function create() : Void {
    	this.render({ posts: [ { id: 1, title: 'test' } ] });
    }
    
    public function edit(id : Int) : Void {
    	this.render({ });
    }
}