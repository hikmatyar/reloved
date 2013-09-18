/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;
import saffron.tools.JSON;
    
private typedef PostRow = {
    var id : DataIdentifier;
    var status : Int;
    var created : Int;
    var modified : Int;
    var brand_id : DataIdentifier;
    var type_id : DataIdentifier;
    var size_id : DataIdentifier;
    var condition : Int;
    var materials : String;
    var price : Int;
    var price_original : Int;
    var currency : String;
    var title : String;
    var fit : String;
    var notes : String;
    var editorial : String;
}

typedef PostChange = {
	id : DataIdentifier,
	?status : Int,
	?mediaIds : String
}

class Post {
	public static inline var condition_new_unused = 1;
	public static inline var condition_new_tags = 2;
	public static inline var condition_new_used = 3;
	
	public static inline var delta_status = 1;
    public static inline var delta_media = 2;
    public static inline var delta_contents = 3;
    
    public static inline var status_deleted = 0;
    public static inline var status_unlisted = 1;
    public static inline var status_listed = 2;
    public static inline var status_listed_pending_purchase = 3;
    public static inline var status_listed_bought = 4;
    public static inline var status_unlisted_bought = 5;
    
    public var id(default, null) : DataIdentifier;
    public var userId(default, null) : DataIdentifier;
    public var status(default, null) : Int;
    public var created(default, null) : Int;
    public var modified(default, null) : Int;
    public var brandId(default, null) : DataIdentifier;
    public var typeId(default, null) : DataIdentifier;
    public var sizeId(default, null) : DataIdentifier;
    public var condition(default, null) : Int;
    public var materials(default, null) : String;
    public var price(default, null) : Int;
    public var priceOriginal(default, null) : Int;
    public var currency(default, null) : String;
    public var title(default, null) : String;
    public var fit(default, null) : String;
    public var notes(default, null) : String;
    public var editorial(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> Post -> Void) : Void {
        Data.query('SELECT * FROM posts WHERE id = ?', [ id ], function(err, result : Post) {
            fn(err, result);
        });
    }
    
    public static function findChanges(min : Int, max : Int, fn : DataError -> Array<PostChange> -> Void) : Void {
        Data.query('SELECT DISTINCT posts.id, posts.status, post_log.delta AS delta FROM post_log INNER JOIN posts ON post_log.post_id = posts.id WHERE post_log.created > ? AND posts.created >= ? AND posts.created <= ?', [ max, min, max ], function(err, result) {
        	if(err == null && result != null && result.length > 0) {
                var changes = new Array<PostChange>();
                var cache : Dynamic = { };
                
                for(row in result.rows()) {
                    var change : PostChange = cache[row.id];
                    
                    if(change == null) {
                        change = { id: row.id };
                        cache[row.id] = change;
                        changes.push(change);
                    }
                    
                    if((row.delta & Post.delta_status) != 0) {
                        cache.status = row.status;
                    } else if((row.delta & Post.delta_media) != 0) {
                        // TODO: Media ids ?!
                    }
                }
                
                fn(null, changes);
            } else {
                fn(err, null);
            }   			
        });
    }
    
    public static function findForward(timestamp : Int, limit : Int, fn : DataError -> Array<Post> -> Void) : Void {
        if(timestamp != null) {
            Data.query('SELECT * FROM posts WHERE status = 2 AND created > ? ORDER BY created ASC LIMIT ?', [ timestamp, limit ], function(err, result : Array<Post>) {
                fn(err, result);
            });
        } else {
            Data.query('SELECT * FROM posts WHERE status = 2 ORDER BY created DESC LIMIT ?', [ limit ], function(err, result : Array<Post>) {
                fn(err, result);
            });
        }
    }
    
    public static function findBackward(timestamp : Int, limit : Int, fn : DataError -> Array<Post> -> Void) : Void {
        Data.query('SELECT * FROM posts WHERE status = 2 AND created < ? ORDER BY created DESC LIMIT ?', [ timestamp, limit ], function(err, result : Array<Post>) {
            fn(err, result);
        });
    }
    
    public static function findAll(fn : DataError -> Array<Post> -> Void) : Void {
        Data.query('SELECT * FROM posts WHERE status <> 0 ORDER BY created DESC', function(err, result : Array<Post>) {
            fn(err, result);
        });
    }
    
    public static function findAllForIdentifiers(postIds : Array<DataIdentifier>, fn : DataError -> Array<Post> -> Void) : Void {
        Data.query('SELECT * FROM posts WHERE id IN (?)', [ postIds ], function(err, result : Array<Post>) {
            fn(err, result);
        });
    }
    
    public static function findAllForUser(userId : DataIdentifier, fn : DataError -> Array<Post> -> Void) : Void {
        Data.query('SELECT * FROM posts WHERE user_id = ? AND status <> 0', [ userId ], function(err, result : Array<Post>) {
        	fn(err, result);
        });
    }
    
    public static function cacheRelationsForPosts(posts : Array<Post>, fn : DataError -> Void) : Void {
    	var postIds = new Array<Int>();
        var cache : Dynamic = { };
        
        if(posts == null || posts.length == 0) {
            fn(null);
            return;
        }
        
        for(post in posts) {
            postIds.push(post.id);
            cache[untyped post.id] = post;
        }
        
        // TODO: Cache media ids, color ids etc
        fn(null);
    }
    
    private function new(row : PostRow) {
		this.id = row.id;
		this.status = row.status;
		this.created = row.created;
		this.modified = row.modified;
		this.brandId = row.brand_id;
		this.typeId = row.type_id;
		this.sizeId = row.size_id;
		this.condition = row.condition;
		this.materials = row.materials;
		this.price = row.price;
		this.priceOriginal = row.price_original;
		this.currency = row.currency;
		this.title = row.title;
		this.fit = row.fit;
		this.notes = row.notes;
		this.editorial = row.editorial;
    }
    
    public function json() : String {
        var json : Dynamic = {
            id: this.id,
            s: this.status,
            t: this.title,
            n: this.notes
        };
        
        return JSON.stringify(json);
    }
}
