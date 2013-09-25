/* Copyright (c) 2013 Meep Factory OU */

package apps.api.mixins;

import saffron.Data;

using StringTools;

class PostMixins {
    public static inline function postIdentifier(handler : Handler) : DataIdentifier {
        return Std.parseInt(handler.request.body.id);
    }
    
    public static inline function postIdentifiers(handler : Handler) : Array<DataIdentifier> {
    	var _ids : String = handler.request.body.ids;
    	var ids : Array<DataIdentifier> = null;
    	
    	if(_ids != null && _ids.length > 0) {
    		ids = new Array<DataIdentifier>();
        	
        	for(_id in _ids.split(',')) {
        		ids.push(Std.parseInt(_id));
        	}
        }
        	
        return ids;
    }
    
    public static inline function postConditionIdentifier(handler : Handler) : DataIdentifier {
        return Std.parseInt(handler.request.body.condition);
    }
    
    public static inline function postStatus(handler : Handler) : DataIdentifier {
        return (handler.request.body.status != null && handler.request.body.status.length > 0) ? Std.parseInt(handler.request.body.status) : null;
    }
    
    public static inline function postTypeIdentifier(handler : Handler) : DataIdentifier {
        return Std.parseInt(handler.request.body.type);
    }
    
    public static inline function postSizeIdentifier(handler : Handler) : DataIdentifier {
        return Std.parseInt(handler.request.body.size);
    }
    
    public static inline function postBrandIdentifier(handler : Handler) : DataIdentifier {
        return Std.parseInt(handler.request.body.brand);
    }
    
    public static inline function postColorIdentifiers(handler : Handler) : Array<DataIdentifier> {
    	var _ids : String = handler.request.body.colors;
    	var ids : Array<DataIdentifier> = null;
    	
    	if(_ids != null && _ids.length > 0) {
    		ids = new Array<DataIdentifier>();
        	
        	for(_id in _ids.split(',')) {
        		ids.push(Std.parseInt(_id));
        	}
        }
        	
        return ids;
    }
    
    public static inline function postMediaIdentifiers(handler : Handler) : Array<DataIdentifier> {
    	var _ids : String = handler.request.body.media;
    	var ids : Array<DataIdentifier> = null;
    	
    	if(_ids != null && _ids.length > 0) {
    		ids = new Array<DataIdentifier>();
        	
        	for(_id in _ids.split(',')) {
        		ids.push(Std.parseInt(_id));
        	}
        }
        	
        return ids;
    }
    
    public static inline function postSearchTag(handler : Handler) : String {
        return handler.request.body.tag;
    }
    
    public static inline function postMaterials(handler : Handler) : String {
        return handler.request.body.materials;
    }
    
    public static inline function postTitle(handler : Handler) : String {
        return handler.request.body.title;
    }
    
    public static inline function postFit(handler : Handler) : String {
        return handler.request.body.fit;
    }
    
    public static inline function postNotes(handler : Handler) : String {
        return handler.request.body.notes;
    }
    
    public static inline function postEditorial(handler : Handler) : String {
        return handler.request.body.editorial;
    }
    
    public static inline function postPrice(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.price);
    }
    
    public static inline function postPriceOriginal(handler : Handler) : Int {
        return Std.parseInt(handler.request.body.price_original);
    }
    
    public static inline function postCurrency(handler : Handler) : String {
        return handler.request.body.currency;
    }
    
    public static inline function postTags(handler : Handler) : Array<String> {	
        var tagsRaw : String = handler.request.body.tags;
        var tags : Array<String> = null;
    	
    	if(tagsRaw != null && tagsRaw.length > 0) {
    		tags = new Array<String>();
    		
    		for(tag in tagsRaw.split(',')) {
        		tag = tag.trim().toLowerCase();
        		
        		if(tag.startsWith('#')) {
        			tag = tag.substring(1, tag.length - 1);
        		}
        		
        		if(tag.length > 1) {
        			tags.push(tag);
        		}
        	}
    	}
    	
    	return tags;
    }
}