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
import saffron.Data;
import saffron.tools.JSON;

using apps.api.mixins.FeedMixins;

private typedef BrowseHandlerGlobals = {
	?brands : Array<Brand>,
	?colors : Array<Color>,
	?countries : Array<Country>,
	?currencies : Array<Currency>,
	?deliveries : Array<Delivery>,
	?sizes : Array<Size>,
	?types : Array<Type>
}

class BrowseHandler extends Handler {
	public static inline var direction_forward = 'future';
    public static inline var direction_backward = 'past';
    
    public function index() : Void {
    	// TODO: Cache brands, currencies, countries etc
    	var globals : BrowseHandlerGlobals = { };
    	
    	var forward = (this.feedDirection() != BrowseHandler.direction_forward) ? true : false;
    	var limit = this.feedLimit();
    	var state = this.feedState();
    	var range = (state != null) ? { min: state.min, max: state.max } : null;
    	
    	if(state == null) {
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
				Delivery.findAll(function(err, deliveries) {
					if(deliveries != null) {
						globals.deliveries = deliveries;
						sync();
					} else {
						this.exit(Error.unknown, 'deliveries');
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
			
			async(function() {
				var delimiter = '';
            	
				this.begin(Error.http_ok);
				this.write('{ "brands": [');
				
				for(brand in globals.brands) {
					this.write(delimiter);
					this.write(brand.json());
					delimiter = ',';
				}
				
				delimiter = '';
				this.write('], "colors": [');
				
				for(color in globals.colors) {
					this.write(delimiter);
					this.write(color.json());
					delimiter = ',';
				}
				
				delimiter = '';
				this.write('], "countries": [');
				
				for(country in globals.countries) {
					this.write(delimiter);
					this.write(country.json());
					delimiter = ',';
				}
				
				delimiter = '';
				this.write('], "currencies": [');
				
				for(country in globals.countries) {
					this.write(delimiter);
					this.write(country.json());
					delimiter = ',';
				}
				
				delimiter = '';
				this.write('], "deliveries": [');
				
				for(delivery in globals.deliveries) {
					this.write(delimiter);
					this.write(delivery.json());
					delimiter = ',';
				}
				
				delimiter = '';
				this.write('], "sizes": [');
				
				for(size in globals.sizes) {
					this.write(delimiter);
					this.write(size.json());
					delimiter = ',';
				}
				
				delimiter = '';
				this.write('], "types": [');
				
				for(type in globals.types) {
					this.write(delimiter);
					this.write(type.json());
					delimiter = ',';
				}
				
				this.write('],');
			});
    	} else {
    		async(function() {	
				this.begin(Error.http_ok);
				this.write('{');
			});
    	}
    	
    	async(function(sync) {
            var writePostFields = function(err : DataError, posts : Array<Post>) : Void {
                if(err == null) {
                    sync(posts);
                } else {
                    this.exit(Error.unknown, 'posts');
                }
            };
            
            if(state != null) {
                if(forward) {
                    Post.findForward(state.max, limit, writePostFields);
                } else {
                    Post.findBackward(state.min, limit, writePostFields);
                }
            } else {
                Post.findForward(null, limit, writePostFields);
            }
        });
        
        async(function(sync, posts : Array<Post>) {
            Post.cacheRelationsForPosts(posts, function(err) {
                if(err == null) {
                    sync(posts);
                } else {
                    this.end('"error": ' + Error.unknown + '}');
                }
            });
        });
    	
    	async(function(sync, posts : Array<Post>) {
            var delimiter = '';
            
            if(state == null) {
                state = new State();
            	
            	if(posts != null && posts.length > 0) {
                    state.min = posts[0].modified;
                    state.max = state.min;
                }
            }
            
            if(posts != null && posts.length > 0) {
                this.write(' "posts": [');
                
                for(post in posts) {
                    if(post.modified < state.min) {
                        state.min = post.modified;
                    } else if(post.modified > state.max) {
                        state.max = post.modified;
                    }
                    
                    this.write(delimiter);
                    this.write(post.json());
                    delimiter = ',';
                }
                
                this.write('],\n');
                
                if(range == null) {
                    this.write(' "cursor": "start", \n');
                } else if(posts.length == limit) {
                    this.write(' "cursor": "middle", \n');
                } else {
                    this.write(' "cursor": "end", \n');
                }
            } else {
                this.write(' "cursor": "end", \n');
            }
            
            if(Config.media_prefix != null) {
                this.write(' "prefix": "' + Config.media_prefix + '", \n');
            }
            
            if(range != null) {
                Post.findChanges(range.min, range.max, function(err, changes) {
                    if(changes != null && changes.length > 0) {
                        delimiter = '';
                        this.write(' "delta": [');
                        
                        for(change in changes) {
                            this.write(delimiter);
                            this.write(JSON.stringify(change));
                            delimiter = ',';
                        }
                        
                        this.write('],\n');
                    }
                    
                    sync(true);
                });
            } else {
                sync(true);
            }
        });
        
        async(function(sync, success : Bool) {
            if(success && state != null) {
                this.write(' "state": ' + state.json() + '\n');
            }
            
            this.end('}');
            sync();
        });
    }
}