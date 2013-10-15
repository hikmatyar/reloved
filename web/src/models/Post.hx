/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;
import saffron.tools.JSON;
    
private typedef PostRow = {
    var id : DataIdentifier;
    var user_id : DataIdentifier;
    var status : Int;
    var created : Int;
    var modified : Int;
    var brand_id : DataIdentifier;
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
	?status : Int
}

private typedef PostColorRow = {
    var post_id : DataIdentifier;
    var color_id : DataIdentifier;
}

class PostColor {
	public var postId(default, null) : DataIdentifier;
    public var colorId(default, null) : DataIdentifier;
    
    public static function findAllForIdentifiers(postIds : Array<DataIdentifier>, fn : DataError -> Array<PostColor> -> Void) : Void {
        Data.query('SELECT * FROM post_colors WHERE post_id IN (?)', [ postIds ], function(err, result : Array<PostColor>) {
            fn(err, result);
        });
    }
    
    public static function create(postId : DataIdentifier, colorIds : Array<DataIdentifier>, fn : DataError -> Void) : Void {
        var values : Array<Dynamic> = new Array<Dynamic>();
        
        for(colorId in colorIds) {
        	values.push([ postId, colorId ]); 
        }
        
        Data.query('INSERT INTO post_colors (post_id, color_id) VALUES ?', [ values ], function(err, result) {
        	fn(err);
        });
    }
    
    private function new(row : PostColorRow) {
        this.postId = row.post_id;
        this.colorId = row.color_id;
    }
}

private typedef PostTypeRow = {
    var post_id : DataIdentifier;
    var type_id : DataIdentifier;
}

class PostType {
	public var postId(default, null) : DataIdentifier;
    public var typeId(default, null) : DataIdentifier;
    
    public static function findAllForIdentifiers(postIds : Array<DataIdentifier>, fn : DataError -> Array<PostType> -> Void) : Void {
        Data.query('SELECT * FROM post_types WHERE post_id IN (?)', [ postIds ], function(err, result : Array<PostType>) {
            fn(err, result);
        });
    }
    
    public static function create(postId : DataIdentifier, typeIds : Array<DataIdentifier>, fn : DataError -> Void) : Void {
        var values : Array<Dynamic> = new Array<Dynamic>();
        
        for(typeId in typeIds) {
        	values.push([ postId, typeId ]); 
        }
        
        Data.query('INSERT INTO post_types (post_id, type_id) VALUES ?', [ values ], function(err, result) {
        	fn(err);
        });
    }
    
    private function new(row : PostTypeRow) {
        this.postId = row.post_id;
        this.typeId = row.type_id;
    }
}

private typedef PostUserRow = {
	var id : DataIdentifier;
	var name : String;
	var media_id : DataIdentifier;
};

class PostUser {
	public var id(default, null) : DataIdentifier;
    public var mediaId(default, null) : DataIdentifier;
    public var name(default, null) : String;
    
    public static function findAllForIdentifiers(postUserIds : Array<DataIdentifier>, fn : DataError -> Array<PostUser> -> Void) : Void {
        Data.query('SELECT id, first_name AS name, media_id FROM users WHERE id IN (?)', [ postUserIds ], function(err, result : Array<PostUser>) {
            fn(err, result);
        });
    }
    
	private function new(row : PostUserRow) {
        this.id = row.id;
        this.name = row.name;
        this.mediaId = row.media_id;
    }
    
    public function json() : String {
        return JSON.stringify({
            id: this.id,
            name: this.name,
            media: this.mediaId
        });
    }
}

typedef PostCommentAttributes_Create = {
	var message : String;
	var user_id : DataIdentifier;
};

typedef PostCommentAttributes_Update = {
	?status : Int,
	?message : String
};

private typedef PostCommentRow = {
	var id : DataIdentifier;
	var status : Int;
    var post_id : DataIdentifier;
    var user_id : DataIdentifier;
    var created : Int;
    var modified : Int;
    var message : String;
}

class PostComment {
	public static inline var status_deleted = 0;
    public static inline var status_active = 1;
    public static inline var status_inactive = 2;
    
	public var id(default, null) : DataIdentifier;
	public var status(default, null) : Int;
    public var postId(default, null) : DataIdentifier;
    public var userId(default, null) : DataIdentifier;
    public var created(default, null) : Int;
    public var modified(default, null) : Int;
    public var message(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> PostComment -> Void) : Void {
        Data.query('SELECT * FROM post_comments WHERE id = ?', [ id ], function(err, result : PostComment) {
            fn(err, result);
        });
    }
    
	public static function findAll(postId : DataIdentifier, fn : DataError -> Array<PostComment> -> Void) : Void {
        Data.query('SELECT * FROM post_comments WHERE post_id = ? AND status = 1 ORDER BY created ASC', [ postId ], function(err, result : Array<PostComment>) {
            fn(err, result);
        });
    }
    
    public static function findAllPlusUsers(postId : DataIdentifier, fn : DataError -> Array<PostComment> -> Array<PostUser> -> Void) : Void {
    	Data.query('SELECT * FROM post_comments WHERE post_id = ? AND status = 1 ORDER BY created ASC', [ postId ], function(err, comments : Array<PostComment>) {
    		if(comments != null && comments.length > 0) {
    			var userIdentifiers = new Array<DataIdentifier>();
                var cache : Dynamic = { };
                
                for(comment in comments) {
                    if(cache[comment.userId] == null) {
                    	cache[comment.userId] = true;
                    	userIdentifiers.push(comment.userId);
                    }
                }
                
                PostUser.findAllForIdentifiers(userIdentifiers, function(err, users) {
                	fn(err, comments, users);
                });
    		} else {
            	fn(err, comments, null);
            }
        });
    }
    
    public static function create(postId : DataIdentifier, attributes : PostCommentAttributes_Create, fn : DataError -> DataIdentifier -> Void) : Void {
    	Data.query('INSERT INTO post_comments SET ?, post_id = ?, status = 1, created = UNIX_TIMESTAMP(CURRENT_TIMESTAMP), modified = UNIX_TIMESTAMP(CURRENT_TIMESTAMP)', [ attributes, postId ], function(err, result) {
            if(err == null && result != null) {
                if(err == null) {
            		PostLog.create(postId, Post.delta_comments, null);
            	}
            	
            	fn(null, result.insertId);
            } else {
                fn(err, null);
            }
        });
    }
    
    public static function update(id : DataIdentifier, attributes : PostCommentAttributes_Update, fn : DataError -> Void) : Void {
        Data.query('UPDATE post_comments SET ?, modified = UNIX_TIMESTAMP(CURRENT_TIMESTAMP) WHERE id = ?', [ attributes, id ], function(err, result) {
            fn(err);
        });
    }
    
    private function new(row : PostCommentRow) {
        this.id = row.id;
        this.status = row.status;
        this.postId = row.post_id;
        this.userId = row.user_id;
        this.created = row.created;
        this.modified = row.modified;
        this.message = row.message;
    }
    
    public function json() : String {
        return JSON.stringify({
            id: this.id,
            user: this.userId,
            date: this.created,
            mod: this.modified,
            message: this.message
        });
    }
}

private typedef PostMediaRow = {
    var post_id : DataIdentifier;
    var media_id : DataIdentifier;
}

class PostMedia {
	public var postId(default, null) : DataIdentifier;
    public var mediaId(default, null) : DataIdentifier;
    
    public static function findAllForIdentifiers(postIds : Array<DataIdentifier>, fn : DataError -> Array<PostMedia> -> Void) : Void {
        Data.query('SELECT * FROM post_media WHERE post_id IN (?) ORDER BY media_id ASC', [ postIds ], function(err, result : Array<PostMedia>) {
            fn(err, result);
        });
    }
    
    public static function create(postId : DataIdentifier, mediaIds : Array<DataIdentifier>, fn : DataError -> Void) : Void {
        var values : Array<Dynamic> = new Array<Dynamic>();
        
        for(mediaId in mediaIds) {
        	values.push([ postId, mediaId ]); 
        }
        
        Data.query('INSERT INTO post_media (post_id, media_id) VALUES ?', [ values ], function(err, result) {
        	fn(err);
        });
    }
    
    private function new(row : PostMediaRow) {
        this.mediaId = row.media_id;
        this.postId = row.post_id;
    }
    
    public function json() : String {
        return JSON.stringify({
            id: this.mediaId,
            post: this.postId
        });
    }
}

private typedef PostTagRow = {
    var post_id : DataIdentifier;
    var name : String;
}

class PostTag {
	public var postId(default, null) : DataIdentifier;
    public var name(default, null) : String;
    
    public static function findAllPopular(limit : Int, fn : DataError -> Array<PostTag> -> Void) : Void {
    	Data.query('SELECT DISTINCT name FROM post_tags GROUP BY name ORDER BY COUNT(name) DESC LIMIT ?', [ limit ], function(err, result : Array<PostTag>) {
            fn(err, result);
        });
    }
    
    public static function findAllForIdentifiers(postIds : Array<DataIdentifier>, fn : DataError -> Array<PostTag> -> Void) : Void {
        Data.query('SELECT * FROM post_tags WHERE post_id IN (?)', [ postIds ], function(err, result : Array<PostTag>) {
            fn(err, result);
        });
    }
    
    public static function create(postId : DataIdentifier, tags : Array<String>, fn : DataError -> Void) : Void {
        var values : Array<Dynamic> = new Array<Dynamic>();
        
        for(tag in tags) {
        	values.push([ postId, tag ]); 
        }
        
        Data.query('INSERT INTO post_tags (post_id, name) VALUES ?', [ values ], function(err, result) {
        	fn(err);
        });
    }
    
    private function new(row : PostTagRow) {
        this.postId = row.post_id;
        this.name = row.name;
    }
}

class PostLog {
	public static function create(id : DataIdentifier, delta : Int, fn : DataError -> Void) {
    	Data.query('INSERT INTO post_log (post_id, created, delta) VALUES (?, UNIX_TIMESTAMP(CURRENT_TIMESTAMP), ?)', [ id, delta ], function(err, result) {
			if(fn != null) {
				fn(err);
			}
		});
	}
}

typedef PostAttributes_Create = {
	brand_id : DataIdentifier,
	user_id : DataIdentifier,
	size_id : DataIdentifier,
	condition : Int,
	materials : String,
	price : Int,
	price_original : Int,
	currency : String,
	title : String,
	fit : String,
	notes : String,
	editorial : String
}

private class PostFeed {
	public static inline var identifier_all = 'all';
    public static inline var identifier_only_editorial = 'only_editorial';
    public static inline var identifier_only_new = 'only_new';
    
    private static inline var prefix_color = 'color';
    private static inline var prefix_type = 'type';
    
    public var id(default, null) : String;
    public var colors(default, null) : Array<DataIdentifier>;
    public var types(default, null) : Array<DataIdentifier>;
    
    public function new(str : String) {
    	if(str != null) {
    		for(part in str.split('+')) {
        		if(part == '' ||
        		   part == PostFeed.identifier_all) {
        			this.id = PostFeed.identifier_all;
        		} else if(part == PostFeed.identifier_only_editorial ||
        				  part == PostFeed.identifier_only_new) {
        			this.id = part;
        		} else {
        			var ids = new Array<DataIdentifier>();
        			var mode : String = null;
        			
        			for(_v in part.split(',')) {
        				if(mode == null) {
        					mode = _v;
        				} else {
        					ids.push(Std.parseInt(_v));
        				}
        			}
        			
        			if(ids.length > 0) {
        				if(mode == PostFeed.prefix_color) {
        					this.colors = ids;
        				} else if(mode == PostFeed.prefix_type) {
        					this.types = ids;
        				}
        			}
        		}
        	}
    	} else {
    		this.id = PostFeed.identifier_all;
    	}
    }
}

class Post {
	public static inline var condition_new_unused = 1;
	public static inline var condition_new_tags = 2;
	public static inline var condition_new_used = 3;
	
	public static inline var delta_status = 1;
    public static inline var delta_media = 2;
    public static inline var delta_contents = 4;
    public static inline var delta_comments = 8;
    
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
    
    private var _colors : Array<PostColor>;
    private var _types : Array<PostType>;
    private var _media : Array<PostMedia>;
    private var _tags : Array<PostTag>;
    
    public static function find(id : DataIdentifier, fn : DataError -> Post -> Void) : Void {
    	Data.query('SELECT * FROM posts WHERE id = ?', [ id ], function(err, result : Post) {
    		fn(err, result);
        });
    }
    
    public static function findAndCacheRelations(id : DataIdentifier, fn : DataError -> Post -> Void) : Void {
    	Post.find(id, function(err, post) {
    		if(post != null) {
    			Post.cacheRelationsForPosts([ post ], function(err) {
    				fn(err, (err == null) ? post : null);
    			});
    		} else {
    			fn(err, null);
    		}
    	});
    }
    
    public static function findStatus(id : DataIdentifier, fn : DataError -> Int -> Bool -> Void) : Void {
    	Data.query('SELECT posts.status AS postStatus, media.status AS mediaStatus FROM posts ' +
    				'LEFT JOIN post_media ON post_media.post_id = posts.id ' +
    				'LEFT JOIN media ON (post_media.media_id = media.id) ' +
    					'WHERE posts.id = ?', [ id ], function(err, result) {
    		var status = Post.status_deleted;
    		var ready = false;
    		
    		if(err == null && result != null && result.length > 0) {
    			ready = true;
    			
    			for(row in result.rows()) {
    				status = row.postStatus;
    				
    				if(row.mediaStatus != null && (row.mediaStatus == Media.status_uploading || row.mediaStatus == Media.status_uploaded)) {
    					ready = false;
    					break;
    				}
    			}
    		}
    		
    		fn(err, status, ready);
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
                        change.status = row.status;
                    } else if((row.delta & Post.delta_media) != 0 ||
                    		  (row.delta & Post.delta_contents) != 0 ||
                    		  (row.delta & Post.delta_comments) != 0) {
                        // Do nothing?
                    }
                }
                
                fn(null, changes);
            } else {
                fn(err, null);
            }   			
        });
    }
    
    public static function findForward(identifier : String, timestamp : Int, limit : Int, fn : DataError -> Array<Post> -> Void) : Void {
    	var feed = new PostFeed(identifier);
    	var order = (feed.id == PostFeed.identifier_all) ? 'created' : 'modified';
    	var editorial = (feed.id == PostFeed.identifier_only_editorial) ? ' AND editorial <> NULL' : '';
    	var fcriteria = '';
    	var ftables = '';
    	
    	if(feed.colors != null) {
    		ftables = ' INNER JOIN post_colors ON post_colors.post_id = posts.id ';
    		fcriteria = ' AND post_colors.color_id IN (' + feed.colors.join(',') + ')';
    	}
    	
    	if(feed.types != null) {
    		ftables = ftables + ' INNER JOIN post_types ON post_types.post_id = posts.id ';
    		fcriteria = fcriteria + ' AND post_types.type_id IN (' + feed.types.join(',') + ')';
    	}
    	
        if(timestamp != null) {
            Data.query('SELECT posts.* FROM posts ' + ftables + ' WHERE status = 2 AND ' + order + ' > ? ' + editorial + fcriteria + ' ORDER BY ' + order + ' ASC LIMIT ?', [ timestamp, limit ], function(err, result : Array<Post>) {
                fn(err, result);
            });
        } else {
            Data.query('SELECT posts.* FROM posts ' + ftables + ' WHERE status = 2 ' + editorial + fcriteria + ' ORDER BY ' + order + ' DESC LIMIT ?', [ limit ], function(err, result : Array<Post>) {
                fn(err, result);
            });
        }
    }
    
    public static function findBackward(identifier : String, timestamp : Int, limit : Int, fn : DataError -> Array<Post> -> Void) : Void {
    	var feed = new PostFeed(identifier);
    	var order = (feed.id == PostFeed.identifier_only_new) ? 'created' : 'modified';
    	var editorial = (feed.id == PostFeed.identifier_only_editorial) ? ' AND editorial <> NULL' : '';
    	var fcriteria = '';
    	var ftables = '';
    	
    	if(feed.colors != null) {
    		ftables = ' INNER JOIN post_colors ON post_colors.post_id = posts.id ';
    		fcriteria = ' AND post_colors.color_id IN (' + feed.colors.join(',') + ')';
    	}
    	
    	if(feed.types != null) {
    		ftables = ftables + ' INNER JOIN post_types ON post_types.post_id = posts.id ';
    		fcriteria = fcriteria + ' AND post_types.type_id IN (' + feed.types.join(',') + ')';
    	}
    	
        Data.query('SELECT posts.* FROM posts ' + ftables + ' WHERE status = 2 AND ' + order + ' < ? ' + editorial + fcriteria + ' ORDER BY ' + order + ' DESC LIMIT ?', [ timestamp, limit ], function(err, result : Array<Post>) {
            fn(err, result);
        });
    }
    
    public static function findAll(fn : DataError -> Array<Post> -> Void) : Void {
        Data.query('SELECT * FROM posts WHERE status <> 0 ORDER BY created DESC', function(err, result : Array<Post>) {
            fn(err, result);
        });
    }
    
    public static function findAllForTag(tag : String, fn : DataError -> Array<Post> -> Void) : Void {
    	Data.query('SELECT DISTINCT posts.* FROM posts INNER JOIN post_tags ON post_tags.post_id = posts.id WHERE posts.status IN (2,3,4) AND post_tags.name = ? ORDER BY created DESC', [ tag ], function(err, result : Array<Post>) {
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
    
    public static function create(attributes : PostAttributes_Create, fn : DataError -> Post -> Void) : Void {
        Data.query('INSERT INTO posts SET ?, status = 1, created = UNIX_TIMESTAMP(CURRENT_TIMESTAMP), modified = UNIX_TIMESTAMP(CURRENT_TIMESTAMP)', [ attributes ], function(err, result) {
            if(err == null && result != null) {
                Post.find(result.insertId, fn);
            } else {
                fn(err, null);
            }
        });
    }
    
    public static function update(id : DataIdentifier, attributes : Dynamic, fn : DataError -> Void) : Void {
        Data.query('UPDATE posts SET ?, modified = UNIX_TIMESTAMP(CURRENT_TIMESTAMP) WHERE id = ?', [ attributes, id ], function(err, result) {
            if(err == null) {
                var delta = 0;
                
                if(Std.is(attributes.status, Int)) {
                    delta |= Post.delta_status;
                }
                
                if(attributes.media != null) {
                    delta |= Post.delta_media;
                }
                
                PostLog.create(id, delta, fn);
            } else {
                fn(err);
            }
        });
    }
    
    public static function cacheRelationsForPosts(posts : Array<Post>, fn : DataError -> Void) : Void {
    	var postIds = new Array<DataIdentifier>();
        var cache : Dynamic = { };
        
        if(posts == null || posts.length == 0) {
            fn(null);
            return;
        }
        
        for(post in posts) {
            postIds.push(post.id);
            post._colors = [];
            post._tags = [];
            post._types = [];
            post._media = [];
            cache[untyped post.id] = post;
        }
        
        PostType.findAllForIdentifiers(postIds, function(err, types) {
        	if(err != null) {
				fn(err);
				return;
			}
			
			if(types != null) {
				for(type in types) {
					var post_ = cache[untyped type.postId];
				
					if(post_ != null) {
						post_._types.push(type);
					}
				}
			}
			
			PostColor.findAllForIdentifiers(postIds, function(err, colors) {
				if(err != null) {
					fn(err);
					return;
				}
			
				if(colors != null) {
					for(color in colors) {
						var post_ = cache[untyped color.postId];
					
						if(post_ != null) {
							post_._colors.push(color);
						}
					}
				}
			
				PostMedia.findAllForIdentifiers(postIds, function(err, media) {
					if(err != null) {
						fn(err);
						return;
					}
				
					if(media != null) {
						for(m in media) {
							var post_ = cache[untyped m.postId];
					
							if(post_ != null) {
								post_._media.push(m);
							}
						}
					}
				
					PostTag.findAllForIdentifiers(postIds, function(err, tags) {
						if(err != null) {
							fn(err);
							return;
						}
					
						if(tags != null) {
							for(tag in tags) {
								var post_ = cache[untyped tag.postId];
					
								if(post_ != null) {
									post_._tags.push(tag);
								}
							}
						}
					
						fn(null);
					});
				});
			});
		});
    }
    
    private function new(row : PostRow) {
		this.id = row.id;
		this.userId = row.user_id;
		this.status = row.status;
		this.created = row.created;
		this.modified = row.modified;
		this.brandId = row.brand_id;
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
    
    @:keep public function reference() : String {
    	return '' + (100000 + this.id);
    }
    
    public function publish() : Void {
    	if(this.id != null && this.status == Post.status_unlisted) {
    		Queue.create(Queue.task_publish, this.id, null, function(err) { });
    	}
    }
    
    /*
    "id": 1,
					"user": 10,
					"status": 1,
					"date": "2013-12-30T12:00:00.000Z",
					"mod": "2013-12-30T12:00:00.000Z",
					"brand": 1,
					"colors": [ 1 ],
					"condition": 1,
					"types": [ 1 ],
					"size": 1,
					"materials": "...",
					"price": 12345,
					"price_o": 23456,
					"currency": "GBP",
					"title": "...",
					"fit": "...",
					"notes": "...",
					"media": [ 1 ],
					// Optional
					"editorial": "..."*/
	
    public function json() : String {
        var json : Dynamic = {
            id: this.id,
            user: this.userId,
            status: this.status,
            brand: this.brandId,
            size: this.sizeId,
            condition: this.condition,
            title: this.title,
            materials: this.materials,
            notes: this.notes,
            fit: this.fit,
            price: this.price,
            price_o: this.priceOriginal,
            currency: this.currency,
            date: new saffron.tools.Date(this.created * 1000).toISOString(),
            mod: new saffron.tools.Date(this.modified * 1000).toISOString()
        };
        var arr : Array<DataIdentifier>;
        
        if(this.editorial != null) {
        	json.editorial = this.editorial;
        }
        
        if(this._types != null) {
        	arr = new Array<DataIdentifier>();
        	
        	for(type in this._types) {
        		arr.push(type.typeId);
        	}
        	
        	json.types = arr;
        }
        
        if(this._colors != null) {
        	arr = new Array<DataIdentifier>();
        	
        	for(color in this._colors) {
        		arr.push(color.colorId);
        	}
        	
        	json.colors = arr;
        }
        
        if(this._media != null) {
        	arr = new Array<DataIdentifier>();
        	
        	for(media in this._media) {
        		arr.push(media.mediaId);
        	}
        	
        	json.media = arr;
        }
        
        if(this._tags != null) {
        	var tags = new Array<String>();
        	
        	for(tag in this._tags) {
        		tags.push(tag.name);
        	}
        	
        	json.tags = tags;
        }
        
        return JSON.stringify(json);
    }
}
