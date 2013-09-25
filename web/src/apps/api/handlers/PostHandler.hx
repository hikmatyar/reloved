/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;
import models.Post;

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
    	this.exit(Error.unsupported_api);
    }
    
    public function comment() {
    	this.exit(Error.unsupported_api);
    }
}