/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;

using apps.api.mixins.PostMixins;

class PostHandler extends Handler {
    public function search() {
    	this.exit(Error.unsupported_api);
    }
    
    public function list() {
    	this.exit(Error.unsupported_api);
    }
    
    public function states() {
    	this.exit(Error.unsupported_api);
    }
    
    public function details() {
    	this.exit(Error.unsupported_api);
    }
    
    public function comments() {
    	this.exit(Error.unsupported_api);
    }
    
    public function create() {
    	this.exit(Error.unsupported_api);
    }
    
    public function edit() {
    	this.exit(Error.unsupported_api);
    }
    
    public function comment() {
    	this.exit(Error.unsupported_api);
    }
}