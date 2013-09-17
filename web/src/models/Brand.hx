/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;

private typedef BrandRow = {
    var id : DataIdentifier;
    var name : String;
}

class Brand {
    public var id(default, null) : DataIdentifier;
    public var name(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> Brand -> Void) : Void {
        Data.query('SELECT * FROM brands WHERE id = ?', [ id ], function(err, result : Brand) {
            fn(err, result);
        });
    }
    
    public static function findAll(fn : DataError -> Array<Brand> -> Void) : Void {
        Data.query('SELECT * FROM brands', function(err, result : Array<Brand>) {
            fn(err, result);
        });
    }
    
    private function new(row : BrandRow) {
        this.id = row.id;
        this.name = row.name;
    }
}
