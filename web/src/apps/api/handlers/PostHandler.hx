/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;
import models.Event;
import models.Post;
import models.User;

using apps.api.mixins.PostMixins;
using apps.api.mixins.PostCommentMixins;

class PostHandler extends Handler {
    public function search() {
    	var tag = this.postSearchTag();
    	
    	if(tag != null && tag.length > 2) {
    		Post.findAllForTag(tag, function(err, posts) {
    			if(posts != null) {
    				Post.cacheRelationsForPosts(posts, function(err) {
    					if(err == null) {
    						this.begin(ErrorCode.http_ok);
							this.write('{ "error": 0, "cursor": "end", "state": ""');
							this.writePosts(posts);	
							this.end('}');
    					} else {
    						this.exit(ErrorCode.unknown, 'post relations');
    					}
    				});
    			} else {
    				this.exit(ErrorCode.unknown, 'posts');
    			}
    		});
    	} else {
    		this.exit(ErrorCode.none);
    	}
    }
    
    public function list() {
    	var postIds = this.postIdentifiers();
    	
    	if(postIds != null && postIds.length > 0) {
    		Post.findAllForIdentifiers(postIds, function(err, posts) {
    			if(posts != null) {
    				Post.cacheRelationsForPosts(posts, function(err) {
    					if(err == null) {
    						this.begin(ErrorCode.http_ok);
							this.write('{ "error": 0, "cursor": "end", "state": ""');
							this.writePosts(posts);	
							this.end('}');
    					} else {
    						this.exit(ErrorCode.unknown, 'post relations');
    					}
    				});
    			} else {
    				this.exit(ErrorCode.unknown, 'posts');
    			}
    		});
    	} else {
    		this.exit(ErrorCode.missing_parameter, 'posts');
    	}
    }
    
    public function states() {
    	var postIds = this.postIdentifiers();
    	
    	if(postIds != null && postIds.length > 0) {
    		Post.findAllForIdentifiers(postIds, function(err, posts) {
    			if(err == null) {
					this.begin(ErrorCode.http_ok);
					this.write('{ "error": 0');
					this.writePosts(posts);	
					this.end('}');
				} else {
					this.exit(ErrorCode.unknown, 'posts');
				}
    		});
    	} else {
    		this.exit(ErrorCode.missing_parameter, 'posts');
    	}
    }
    
    public function details() {
    	var postId = this.postIdentifier();
    	
    	if(postId != 0) {
    		Post.findAndCacheRelations(postId, function(err, post) {
    			if(post != null) {
    				PostComment.findAllPlusUsers(postId, function(err, comments, users) {
    					if(err == null) {
    						this.begin(ErrorCode.http_ok);
							this.write('{ "error": 0, "cursor": "end", "state": "", "post": ');
							this.write(post.json());
							this.writeComments(comments);
							this.writeUsers(users);			
							this.end('}');	
    					} else {
    						this.exit(ErrorCode.unknown, 'comments');
    					}
    				});
    			} else if(err != null) {
    				this.exit(ErrorCode.unknown, 'post');
    			} else {
    				this.exit(ErrorCode.invalid_parameter, 'post');
    			}
    		});
    	} else {
    		this.exit(ErrorCode.missing_parameter, 'post');
    	}
    }
    
    public function comments() {
    	var postId = this.postIdentifier();
    	
    	if(postId != 0) {
    		PostComment.findAllPlusUsers(postId, function(err, comments, users) {
    			if(err == null) {
    				this.begin(ErrorCode.http_ok);
    				this.write('{ "error": 0, "cursor": "end", "state": ""');
    				this.writeComments(comments);
    				this.writeUsers(users);			
    				this.end('}');
    			} else {
    				this.exit(ErrorCode.unknown, 'comments');
    			}
    		});
    	} else {
    		this.exit(ErrorCode.invalid_parameter, 'post id');
    	}
    }
    
    public function create() {
    	var conditionId = this.postConditionIdentifier();
		var sizeId = this.postSizeIdentifier();
		var brandId = this.postBrandIdentifier();
		var typeIds = this.postTypeIdentifiers();
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
		var email = this.postEmail();
    	var phone = this.postPhone();
    	var firstName = this.postFirstName();
    	var lastName = this.postLastName();
    	var user = this.user();
    	
    	if(email != null || phone != null || firstName != null || lastName != null) {
    		var attributes : UserAttributes = { };
    		var found = false;
    		
    		if(user.email != email) {
				attributes.email = email;
				found = true;
			}
			
			if(user.phone != phone) {
				attributes.phone = phone;
				found = true;
			}
			
			if(user.firstName != firstName) {
				attributes.first_name = firstName;
				found = true;
			}
			
			if(user.lastName != lastName) {
				attributes.last_name = lastName;
				found = true;
			}
			
			if(found) {
				User.update(user.id, attributes, function(err) { });
    		}
    	}
    	
		if(conditionId != 0 && typeIds != null && sizeId != 0 && brandId != 0 &&
		   colorIds != null && mediaIds != null && materials != null && title != null &&
		   fit != null && notes != null && price > 0 && priceOriginal > 0 && currency != null &&
		   tags != null) {
			var result = { post: null };
			
			title = InputValidator.textByRemovingLinksFromText(title);
			notes = InputValidator.textByRemovingLinksFromText(notes);
			
			async(function(sync) {
				Post.create({
					brand_id: brandId,
					user_id: user.id,
					size_id: sizeId,
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
						this.exit(ErrorCode.unknown, 'post');
					} else {
						result.post = post;
						sync();
					}
				});
			});
			
			async(function(sync) {
				PostMedia.create(result.post.id, mediaIds, function(err) {
					if(err != null) {
						this.exit(ErrorCode.unknown, 'media');
					} else {
						sync();
					}
				});
			});
			
			async(function(sync) {
				PostColor.create(result.post.id, colorIds, function(err) {
					if(err != null) {
						this.exit(ErrorCode.unknown, 'colors');
					} else {
						sync();
					}
				});
			});
			
			async(function(sync) {
				PostType.create(result.post.id, typeIds, function(err) {
					if(err != null) {
						this.exit(ErrorCode.unknown, 'types');
					} else {
						sync();
					}
				});
			});
			
			async(function(sync) {
				PostTag.create(result.post.id, tags, function(err) {
					if(err != null) {
						this.exit(ErrorCode.unknown, 'tags');
					} else {
						sync();
					}
				});
			});
			
			async(function(sync) {
				Post.cacheRelationsForPosts([ result.post ], function(err) {
					if(err == null) {
						result.post.publish();
						this.begin(ErrorCode.http_ok);
						this.end(result.post.json());
					} else {
						this.exit(ErrorCode.unknown, 'relations');
					}
					
					sync();
				});
			});
		} else {
			this.exit(ErrorCode.invalid_parameter);
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
							this.exit(ErrorCode.access_denied);
						}
					} else {
						this.exit(ErrorCode.unknown, 'find');
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
							this.exit(ErrorCode.unknown, 'update');
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
						this.begin(ErrorCode.http_ok);
						this.end(result.post.json());
					} else {
						this.exit(ErrorCode.unknown, 'edit');
					}
					
					sync();
				});
			});
    	} else {
    		this.exit(ErrorCode.invalid_parameter);
    	}
    }
    
    public function comment() {
    	var postId = this.postIdentifier();
    	var commentId = this.postCommentIdentifier();
    	var emoticonId = this.postCommentEmoticonIdentifier();
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
						this.exit(ErrorCode.unknown, 'post');
					} else {
						this.exit(ErrorCode.invalid_parameter, 'post');
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
									this.exit(ErrorCode.access_denied, 'comment');
								}
							} else if(err != null) {
								this.exit(ErrorCode.unknown, 'comment');
							} else {
								this.exit(ErrorCode.invalid_parameter, 'comment');
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
						
						if(emoticonId != 0) {
							attributes.emoticon_id = emoticonId;
						}
						
						PostComment.update(commentId, attributes, function(err) {
							if(err == null) {
								// Return all the comments!
								this.comments();
							} else {
								this.exit(ErrorCode.unknown, 'update comment');
							}
						});
					});
				} else {
					async(function() {
						this.exit(ErrorCode.missing_parameter, 'status or message');
					});
				}
			// Create
			} else if(status == null && message != null) {
				async(function() {
					PostComment.create(postId, { user_id: this.user().id, message: message, emoticon_id: (emoticonId != 0) ? emoticonId : null }, function(err, cid) {
						if(err == null) {
							Event.logComment(result.post.userId, result.post.id, cid);
							
							// Return all the comments!
							this.comments();
						} else {
							this.exit(ErrorCode.unknown, 'create comment');
						}
					});
				});
			} else {
				this.exit(ErrorCode.missing_parameter, 'message');
			}
    	} else {
    		this.exit(ErrorCode.missing_parameter, 'post');
    	}
    }
    
    private function writePosts(posts : Array<Post>) : Void {
    	var delimiter = '';
    	
    	if(posts != null) {
			this.write(', "posts": [');
			
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
			this.write(', "comments": [');
			
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
			this.write(', "users": [');
			
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