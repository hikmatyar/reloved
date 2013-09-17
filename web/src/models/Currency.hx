/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;

private typedef CurrencyRow = {
    var id : DataIdentifier;
    var code : String;
    var country : String;
}

class Currency {
    public var id(default, null) : DataIdentifier;
    public var code(default, null) : String;
    public var country(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> Currency -> Void) : Void {
        Data.query('SELECT * FROM currencies WHERE id = ?', [ id ], function(err, result : Currency) {
            fn(err, result);
        });
    }
    
    public static function findAll(fn : DataError -> Array<Currency> -> Void) : Void {
        Data.query('SELECT * FROM currencies', function(err, result : Array<Currency>) {
            fn(err, result);
        });
    }
    
    private function new(row : CurrencyRow) {
        this.id = row.id;
        this.code = row.code;
        this.country = row.country;
    }
}