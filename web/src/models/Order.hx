/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;
import saffron.tools.JSON;

typedef OrderAttributes_Create = {
	var post_id : DataIdentifier;
    var user_id : DataIdentifier;
    var delivery_id : DataIdentifier;
    var country_id : DataIdentifier;
    var price : Int;
    var amount : String;
    var currency : String;
    var stripe_token : String;
    var email : String;
    var phone : String;
    var first_name : String;
    var last_name : String;
    var city : String;
    var address : String;
    var zipcode : String;
}

typedef OrderAttributes_Update = {
	?status : Int,
	?service_fee : Int,
	?stripe_error : String
};

private typedef OrderRow = {
    var id : DataIdentifier;
    var status : Int;
    var post_id : DataIdentifier;
    var user_id : DataIdentifier;
    var delivery_id : DataIdentifier;
    var service_fee : Int;
    var price : Int;
    var amount : String;
    var currency : String;
    var stripe_token : String;
    var stripe_error : String;
    var created : Int;
    var modified : Int;
    var email : String;
    var phone : String;
    var first_name : String;
    var last_name : String;
    var country_id : DataIdentifier;
    var city : String;
    var address : String;
    var zipcode : String;
}

class Order {
	public static inline var status_cancelled = 0;
    public static inline var status_pending = 1;
    public static inline var status_declined = 2;
    public static inline var status_accepted = 3;
    public static inline var status_completed = 4;
    
    public var id(default, null) : DataIdentifier;
    public var status(default, null) : Int;
    public var postId(default, null) : DataIdentifier;
    public var userId(default, null) : DataIdentifier;
    public var deliveryId(default, null) : DataIdentifier;
    public var countryId(default, null) : DataIdentifier;
    public var serviceFee(default, null) : Int;
    public var price(default, null) : Int;
    public var amount(default, null) : String;
    public var currency(default, null) : String;
    public var stripeToken(default, null) : String;
    public var stripeError(default, null) : String;
    public var created(default, null) : Int;
    public var modified(default, null) : Int;
    public var email(default, null) : String;
    public var phone(default, null) : String;
    public var firstName(default, null) : String;
    public var lastName(default, null) : String;
    public var city(default, null) : String;
    public var address(default, null) : String;
    public var zipcode(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> Order -> Void) : Void {
        Data.query('SELECT * FROM orders WHERE id = ?', [ id ], function(err, result : Order) {
            fn(err, result);
        });
    }
    
    public static function findAll(fn : DataError -> Array<Order> -> Void) : Void {
        Data.query('SELECT * FROM orders', function(err, result : Array<Order>) {
            fn(err, result);
        });
    }
    
    public static function findAllForStatus(status : Int, fn : DataError -> Array<Order> -> Void) : Void {
        Data.query('SELECT * FROM orders WHERE status = ?', [ status ], function(err, result : Array<Order>) {
            fn(err, result);
        });
    }
    
    public static function create(attributes : OrderAttributes_Create, fn : DataError -> Order -> Void) : Void {
    	Data.query('INSERT INTO orders SET ?, status = 1, created = UNIX_TIMESTAMP(CURRENT_TIMESTAMP), modified = UNIX_TIMESTAMP(CURRENT_TIMESTAMP)', [ attributes ], function(err, result) {
            if(err == null && result != null) {
                Order.find(result.insertId, fn);
            } else {
                fn(err, null);
            }
        });
    }
    
    public static function update(id : DataIdentifier, attributes : OrderAttributes_Update, fn : DataError -> Void) : Void {
    	Data.query('UPDATE orders SET ?, modified = UNIX_TIMESTAMP(CURRENT_TIMESTAMP) WHERE id = ?', [ attributes, id ], function(err, result) {
            fn(err);
        });
    }
    
    private function new(row : OrderRow) {
        this.id = row.id;
        this.status = row.status;
        this.postId = row.post_id;
        this.userId = row.user_id;
        this.deliveryId = row.delivery_id;
        this.serviceFee = row.service_fee;
        this.price = row.price;
        this.amount = row.amount;
        this.currency = row.currency;
        this.stripeToken = row.stripe_token;
        this.stripeError = row.stripe_error;
        this.created = row.created;
        this.modified = row.modified;
        this.email = row.email;
        this.phone = row.phone;
        this.firstName = row.first_name;
        this.lastName = row.last_name;
        this.countryId = row.country_id;
        this.city = row.city;
        this.address = row.address;
        this.zipcode = row.zipcode;
    }
    
    public function publish() : Void {
    	if(this.id != null && this.status == Order.status_pending) {
    		Queue.create(Queue.task_stripe, this.id, null, function(err) { });
    	}
    }
    
    public function json() : String {
        return JSON.stringify({
        	id: this.id,
        	status: this.status,
        	post: this.postId
        });
    }
}