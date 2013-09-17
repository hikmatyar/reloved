/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;
    
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

class Post {
	public static inline var condition_new_unused = 1;
	public static inline var condition_new_tags = 2;
	public static inline var condition_new_used = 3;
	
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
}
