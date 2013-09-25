/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;
import models.Post;

using apps.api.mixins.PostMixins;
using apps.api.mixins.PostCommentMixins;

class PostHandler extends Handler {
    public function search() {
    	this.exit(Error.unsupported_api);
    }
    
    public function list() {
    	var postIds = this.postIdentifiers();
    	
    	if(postIds != null && postIds.length > 0) {
    		Post.findAllForIdentifiers(postIds, function(err, posts) {
    			if(posts != null) {
    				Post.cacheRelationsForPosts(posts, function(err) {
    					if(err == null) {
    						this.begin(Error.http_ok);
							this.write('{ "error": 0, "cursor": "end", "state": ""');
							this.writePosts(posts);	
							this.end('}');
    					} else {
    						this.exit(Error.unknown, 'post relations');
    					}
    				});
    			} else {
    				this.exit(Error.unknown, 'posts');
    			}
    		});
    	} else {
    		this.exit(Error.missing_parameter, 'posts');
    	}
    }
    
    public function states() {
    	this.exit(Error.unsupported_api);
    }
    
    public function details() {
    	var postId = this.postIdentifier();
    	
    	if(postId != 0) {
    		Post.findAndCacheRelations(postId, function(err, post) {
    			if(post != null) {
    				PostComment.findAllPlusUsers(postId, function(err, comments, users) {
    					if(err == null) {
    						this.begin(Error.http_ok);
							this.write('{ "error": 0, "cursor": "end", "state": "", "post": ');
							this.write(post.json());
							this.writeComments(comments);
							this.writeUsers(users);			
							this.end('}');	
    					} else {
    						this.exit(Error.unknown, 'comments');
    					}
    				});
    			} else if(err != null) {
    				this.exit(Error.unknown, 'post');
    			} else {
    				this.exit(Error.invalid_parameter, 'post');
    			}
    		});
    	} else {
    		this.exit(Error.missing_parameter, 'post');
    	}
    }
    
    public function comments() {
    	var postId = this.postIdentifier();
    	
    	if(postId != 0) {
    		PostComment.findAllPlusUsers(postId, function(err, comments, users) {
    			if(err == null) {
    				this.begin(Error.http_ok);
    				this.write('{ "error": 0, "cursor": "end", "state": ""');
    				this.writeComments(comments);
    				this.writeUsers(users);			
    				this.end('}');
    			} else {
    				this.exit(Error.unknown, 'comments');
    			}
    		});
    	} else {
    		this.exit(Error.invalid_parameter, 'post id');
    	}
    }
    
    public function create() {
    	var conditionId = this.postConditionIdentifier();
		var typeId = this.postTypeIdentifier();
		var sizeId = this.postSizeIdentifier();
		var brandId = this.postBrandIdentifier();
		var colorIds = this.postColorIdentifiers();
		var mediaIds = this.postMediaIdentifiers();
		var materials = this.postMaterials();
		var title = this.postTitle();
		var fit = this.postFit();
		var notes = this.postNotes();
		var editorial = this.postEditorial();
		var price = this.postPrice();
		var priceOriginal = this.postPriceOriginal();
		var currency = this.postCurrency();
		var tags = this.postTags();
		
		if(conditionId != 0 && typeId != 0 && sizeId != 0 && brandId != 0 &&
		   colorIds != null && mediaIds != null && materials != null && title != null &&
		   fit != null && notes != null && price > 0 && priceOriginal > 0 && currency != null &&
		   tags != null) {
			var result = { post: null };
			
			async(function(sync) {
				Post.create({
					brand_id: brandId,
					user_id: this.user().id,
					size_id: sizeId,
					type_id: typeId,
					condition: conditionId,
					materials: materials,
					price: price,
					price_original: priceOriginal,
					currency: currency,
					title: title,
					fit: fit,
					notes: notes,
					editorial: (editorial != null && editorial.length > 0) ? editorial : null
				}, function(err, post) {
					if(err != null) {
						result.post = post;
						sync();
					} else {
						this.exit(Error.unknown, 'post');
					}
				});
			});
			
			async(function(sync) {
				PostMedia.create(result.post.id, mediaIds, function(err) {
					if(err != null) {
						this.exit(Error.unknown, 'media');
					} else {
						sync();
					}
				});
			});
			
			async(function(sync) {
				PostColor.create(result.post.id, colorIds, function(err) {
					if(err != null) {
						this.exit(Error.unknown, 'colors');
					} else {
						sync();
					}
				});
			});
			
			async(function(sync) {
				PostTag.create(result.post.id, tags, function(err) {
					if(err != null) {
						this.exit(Error.unknown, 'tags');
					} else {
						sync();
					}
				});
			});
			
			async(function(sync) {
				Post.cacheRelationsForPosts([ result.post ], function(err) {
					if(err == null) {
						result.post.publish();
						this.render(result.post.json());
					} else {
						this.exit(Error.unknown, 'relations');
					}
					
					sync();
				});
			});
		} else {
			this.exit(Error.invalid_parameter);
		}
    }
    
    public function edit() {
    	var id = this.postIdentifier();
    	var status = this.postStatus();
    	
    	if(id != 0) {
    		var result = { post: null };
			
			async(function(sync) {
				Post.find(id, function(err, post) {
					if(post != null) {
						if(post.userId == this.user().id) {
							result.post = post;
							sync();
						} else {
							this.exit(Error.access_denied);
						}
					} else {
						this.exit(Error.unknown, 'find');
					}
				});
			});
			
			async(function(sync) {
				if(status != null && result.post.status != status &&
				  (result.post.status == Post.status_unlisted || result.post.status == Post.status_listed) &&
				  (status == Post.status_unlisted || status == Post.status_listed)) {
					Post.update(result.post.id, { status: status }, function(err) {
						if(err == null) {
							sync();
						} else {
							this.exit(Error.unknown, 'update');
						}
					});
				} else {
					sync();
				}
			});
			
			async(function(sync) {
				Post.cacheRelationsForPosts([ result.post ], function(err) {
					if(err == null) {
						result.post.publish();
						this.render(result.post.json());
					} else {
						this.exit(Error.unknown, 'edit');
					}
					
					sync();
				});
			});
    	} else {
    		this.exit(Error.invalid_parameter);
    	}
    }
    
    public function comment() {
    	var postId = this.postIdentifier();
    	var commentId = this.postCommentIdentifier();
    	var status = this.postCommentStatus();
    	var message = this.postCommentMessage();
    	
    	if(status != null && status != PostComment.status_inactive) {
			status = null;
    	}
    	
    	if(message != null) {
    		message = InputValidator.textByRemovingLinksFromText(message);
    	}
    	
    	if(postId != 0) {
    		var result = { post: null };
    		
    		async(function(sync) {
				Post.find(postId, function(err, post) {
					if(post != null && post.status != Post.status_deleted) {
						result.post = post;
						sync();
					} else if(err != null) {
						this.exit(Error.unknown, 'post');
					} else {
						this.exit(Error.invalid_parameter, 'post');
					}
				});
			});
			
			// Edit
			if(commentId != 0) {
				if(status != null || message != null) {				
					async(function(sync) {
						PostComment.find(commentId, function(err, comment) {
							if(comment != null) {
								if(comment.userId == this.user().id) {
									sync();
								} else {
									this.exit(Error.access_denied, 'comment');
								}
							} else if(err != null) {
								this.exit(Error.unknown, 'comment');
							} else {
								this.exit(Error.invalid_parameter, 'comment');
							}
						});
					});
					
					async(function() {
						var attributes : PostCommentAttributes_Update = { };
						
						if(status != null) {
							attributes.status = status;
						}
						
						if(message != null) {
							attributes.message = message;
						}
						
						PostComment.update(commentId, attributes, function(err) {
							if(err == null) {
								// Return all the comments!
								this.comments();
							} else {
								this.exit(Error.unknown, 'update comment');
							}
						});
					});
				} else {
					async(function() {
						this.exit(Error.missing_parameter, 'status or message');
					});
				}
			// Create
			} else if(status == null && message != null) {
				async(function() {
					PostComment.create(postId, { user_id: this.user().id, message: message }, function(err, cid) {
						if(err == null) {
							// Return all the comments!
							this.comments();
						} else {
							this.exit(Error.unknown, 'create comment');
						}
					});
				});
			} else {
				this.exit(Error.missing_parameter, 'message');
			}
    	} else {
    		this.exit(Error.missing_parameter, 'post');
    	}
    }
    
    private function writePosts(posts : Array<Post>) : Void {
    	var delimiter = '';
    	
    	if(posts != null) {
			this.write(', "posts": ["');
			
			for(post in posts) {
				this.write(delimiter);
				this.write(post.json());
				delimiter = ',';
			}
			
			this.write(']');
		}
    }
    
    private function writeComments(comments : Array<PostComment>) : Void {
    	var delimiter = '';
    	
    	if(comments != null) {
			this.write(', "comments": ["');
			
			for(comment in comments) {
				this.write(delimiter);
				this.write(comment.json());
				delimiter = ',';
			}
			
			this.write(']');
		}
    }
    
    private function writeUsers(users : Array<PostUser>) : Void {
    	var delimiter = '';
    	
    	if(users != null) {
			this.write(', "users": ["');
			
			delimiter = '';
			
			for(user in users) {
				this.write(delimiter);
				this.write(user.json());
				delimiter = ',';
			}
			
			this.write(']');
		}
    }
}