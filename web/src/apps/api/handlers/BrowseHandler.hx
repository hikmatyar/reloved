/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;
import models.Brand;
import models.Color;
import models.Country;
import models.Currency;
import models.Delivery;
import models.Post;
import models.Size;
import models.Type;

using apps.api.mixins.FeedMixins;

private typedef BrowseHandlerGlobals = {
	?brands : Array<Brand>,
	?colors : Array<Color>,
	?countries : Array<Country>,
	?currencies : Array<Currency>,
	?sizes : Array<Size>,
	?types : Array<Type>
}

class BrowseHandler extends Handler {
	public static inline var direction_forward = 'future';
    public static inline var direction_backward = 'past';
    
    public function index() : Void {
    	// TODO: Cache brands, currencies, countries etc
    	var globals : BrowseHandlerGlobals = { };
    	
    	var direction = this.feedDirection();
    	var limit = this.feedLimit();
    	var state = this.feedState();
    	
    	if(state != null) {
			async(function(sync) {
				Brand.findAll(function(err, brands) {
					if(brands != null) {
						globals.brands = brands;
						sync();
					} else {
						this.exit(Error.unknown, 'brands');
					}
				});
			});
		
			async(function(sync) {
				Color.findAll(function(err, colors) {
					if(colors != null) {
						globals.colors = colors;
						sync();
					} else {
						this.exit(Error.unknown, 'colors');
					}
				});
			});
		
			async(function(sync) {
				Country.findAll(function(err, countries) {
					if(countries != null) {
						globals.countries = countries;
						sync();
					} else {
						this.exit(Error.unknown, 'countries');
					}
				});
			});
		
			async(function(sync) {
				Currency.findAll(function(err, currencies) {
					if(currencies != null) {
						globals.currencies = currencies;
						sync();
					} else {
						this.exit(Error.unknown, 'currencies');
					}
				});
			});
		
			async(function(sync) {
				Size.findAll(function(err, sizes) {
					if(sizes != null) {
						globals.sizes = sizes;
						sync();
					} else {
						this.exit(Error.unknown, 'sizes');
					}
				});
			});
		
			async(function(sync) {
				Type.findAll(function(err, types) {
					if(types != null) {
						globals.types = types;
						sync();
					} else {
						this.exit(Error.unknown, 'types');
					}
				});
			});
			
			
    	} else {
    		
    	}
    	
    	async(function() {	
    		this.exit(Error.none);
    	});
    }
}