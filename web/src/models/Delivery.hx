/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;
import saffron.tools.JSON;

private typedef DeliveryRow = {
    var id : DataIdentifier;
    var name : String;
    var country : String;
    var price : Int;
    var currency : String;
}

class Delivery {
    public var id(default, null) : DataIdentifier;
    public var name(default, null) : String;
    public var country(default, null) : String;
    public var price(default, null) : Int;
    public var currency(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> Delivery -> Void) : Void {
        Data.query('SELECT * FROM deliveries WHERE id = ?', [ id ], function(err, result : Delivery) {
            fn(err, result);
        });
    }
    
    public static function findAll(fn : DataError -> Array<Delivery> -> Void) : Void {
        Data.query('SELECT * FROM deliveries', function(err, result : Array<Delivery>) {
            fn(err, result);
        });
    }
    
    private function new(row : DeliveryRow) {
        this.id = row.id;
        this.name = row.name;
        this.country = row.country;
        this.price = row.price;
        this.currency = row.currency;
    }
    
    public function json() : String {
        return JSON.stringify({ id: this.id, name: this.name, country: this.country, price: this.price, currency: this.currency });
    }
}