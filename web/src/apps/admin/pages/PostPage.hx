/* Copyright (c) 2013 Meep Factory OU */

package apps.admin.pages;

import js.Node;
import models.Brand;
import models.Color;
import models.Media;
import models.Post;
import models.Size;
import models.Type;
import models.User;
import saffron.Data;
import saffron.Locale;
import saffron.tools.Formidable;

using StringTools;

typedef PostPageMedia = {
	var mime : String;
	var size : Int;
	var csum : String;
	var path : String;
};

class PostPage extends Page {
	private static inline var template_complete = 'post.complete';
	private static inline var template_error = 'post.error';
	
    public function create() : Void {
    	var context : Dynamic = { };
    	
    	context.conditions = [
    		{ id: Post.condition_new_unused, name: Locale.str('post.label.condition.new_unused') },
    		{ id: Post.condition_new_tags, name: Locale.str('post.label.condition.new_tags') },
    		{ id: Post.condition_new_used, name: Locale.str('post.label.condition.new_used') }
    	];
    	
    	async(function(sync) {
			User.findAllOfType(User.type_external, function(err, users) {
				context.users = users;
				sync();
			});
    	});
    	
    	async(function(sync) {
			Brand.findAll(function(err, brands) {
				context.brands = brands;
				sync();
			});
    	});
    	
    	async(function(sync) {
			Color.findAll(function(err, colors) {
				context.colors = colors;
				sync();
			});
    	});
    	
    	async(function(sync) {
			Size.findAll(function(err, sizes) {
				context.sizes = sizes;
				sync();
			});
    	});
    	
    	async(function(sync) {
			Type.findAll(function(err, types) {
				context.types = types;
				sync();
			});
    	});
    	
    	async(function() {
    		this.render(context);
    	});
    }
    
    public function create_post() : Void {
    	var files : Array<FormidableFile> = this.request.files.upload;
        var userId = Std.parseInt(this.request.body.user);
        var conditionId = Std.parseInt(this.request.body.condition);
        var typeId = Std.parseInt(this.request.body.type);
        var sizeId = Std.parseInt(this.request.body.size);
        var brandId = Std.parseInt(this.request.body.brand);
        var materials = this.request.body.materials;
        var title = this.request.body.title;
        var fit = this.request.body.fit;
        var notes = this.request.body.notes;
        var editorial : String = this.request.body.editorial;
        var price = Std.parseInt(this.request.body.price) * 100;
        var price_original = Std.parseInt(this.request.body.price_original) * 100;
        var currency = this.request.body.currency;
        var tagsRaw : String = this.request.body.tags;
        var colors : Array<String> = this.request.body.colors_list;
        
        if(userId != null && conditionId != null && typeId != null &&
           sizeId != null && brandId != null && title != null &&
           files != null && colors != null && files.length > 0 && tagsRaw != null) {
        	var colorIds = new Array<DataIdentifier>();
        	var tags = new Array<String>();
        	
        	for(color in colors) {
        		colorIds.push(Std.parseInt(color));
        	}
        	
        	for(tag in tagsRaw.split(',')) {
        		tag = tag.trim().toLowerCase();
        		
        		if(tag.startsWith('#')) {
        			tag = tag.substring(1, tag.length - 1);
        		}
        		
        		if(tag.length > 1) {
        			tags.push(tag);
        		}
        	}
           
        	async(function(sync) {
				Post.create({
					brand_id: brandId,
					user_id: userId,
					size_id: sizeId,
					type_id: typeId,
					condition: conditionId,
					materials: materials,
					price: price,
					price_original: price_original,
					currency: currency,
					title: title,
					fit: fit,
					notes: notes,
					editorial: (editorial != null && editorial.length > 0) ? editorial : null
				}, function(err, post) {
					if(err != null) {
						this.render({ reason: 'bad_data' }, template_error);
						return;
					} else {
						sync(post);
					}
				});
			});
			
			async(function(sync, post : Post) {
				var uploads : Array<PostPageMedia> = [ ];
				var mediaIds : Array<DataIdentifier> = [ ];
				
				sync();
				
        		for(file in files) {
					if((file.type == Media.mime_png || file.type == Media.mime_jpg) &&
						file.size > 0 && file.hash != null && file.hash.length == Media.checksum_length) {
						uploads.push({ mime: file.type, csum: file.hash, size: file.size, path: file.path });
					} else {
						this.render({ reason: 'media' }, template_error);
						return;
					}
				}
				
				User.findOfType(userId, User.type_external, function(err, user) {
					if(user == null) {
						this.render({ reason: 'user' }, template_error);
						return;
					}
				
					for(upload in uploads) {
						this.postMediaUpload(mediaIds, user, upload);
					}
					
					async(function(sync) {
						PostMedia.create(post.id, mediaIds, function(err) {
							if(err != null) {
								this.render({ reason: 'post_media' }, template_error);
								return;
							}
							
							sync();
						});
					});
					
					async(function(sync) {
						PostColor.create(post.id, colorIds, function(err) {
							if(err != null) {
								this.render({ reason: 'post_colors' }, template_error);
								return;
							}
							
							sync();
						});
					});
					
					async(function(sync) {
						PostTag.create(post.id, tags, function(err) {
							if(err != null) {
								this.render({ reason: 'post_tags' }, template_error);
								return;
							}
							
							sync();
						});
					});
					
					async(function() {
						this.render({ user: user.token, post: post }, template_complete);
					});
				});
        	});
        } else {
        	this.render({ reason: 'no_data' }, template_error);
        }       
    }
    
    public function edit(id : Int) : Void {
    	var render = function(post, status, toast) {
			var createStatus = function(id : Int, name : String, ref : Int) : Dynamic {
				return { id: id, name: Locale.str(name), selected: (id == ref) ? ' selected="selected"' : '' };
			};
			
			this.render({
				post: post,
				toast: toast,
				statuses: [
					createStatus(Post.status_deleted, 'post.label.status.deleted', status),
					createStatus(Post.status_unlisted, 'post.label.status.unlisted', status),
					createStatus(Post.status_listed, 'post.label.status.listed', status),
					createStatus(Post.status_listed_pending_purchase, 'post.label.status.listed_pending_purchase', status),
					createStatus(Post.status_listed_bought, 'post.label.status.listed_bought', status),
					createStatus(Post.status_unlisted_bought, 'post.label.status.unlisted_bought', status)
				]
			});
		};
		
    	Post.find(id, function(err, post) {
    		var status = this.request.body.status;
    		
			if(this.request.method == 'POST' && status != null) {
				Post.update(post.id, { status: Std.parseInt(status) }, function(err) {
					render(post, Std.parseInt(status), (err == null) ? Locale.str('post.toast.updated') : null);
				});
			} else {
				render(post, post.status, null);
			}
		});
    }
    
    private function postMediaUpload(identifiers : Array<Int>, user : User, upload : PostPageMedia) : Void {
		async(function(sync : Dynamic -> Void) {
			Media.create(user.id, upload.mime, upload.csum, upload.size, function(err, media) {
				if(err != null) {
					this.render({ reason: 'media_db' }, template_error);
					return;
				}
				
				identifiers.push(media.id);
				sync(media);
			});
		});
		
		async(function(sync, media : Media) {		
			Media.replaceFile(upload.path, media.path, function(err) {
				if(err != null) {
					this.render({ reason: 'media_cp' }, template_error);
					return;
				}
				
				sync(media);
			});
		});
		
		async(function(sync, media : Media) {
			Media.update(media.id, { status: Media.status_uploaded }, function(err, result) {
				if(err != null) {
					this.render({ reason: 'media_db' }, template_error);
					return;
				}
				
				sync();
			});
		});
	}
}