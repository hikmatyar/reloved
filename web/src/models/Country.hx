/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;
import saffron.tools.JSON;

private typedef CountryRow = {
    var id : DataIdentifier;
    var code : String;
    var name : String;
}

class Country {
    public var id(default, null) : DataIdentifier;
    public var code(default, null) : String;
    public var name(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> Country -> Void) : Void {
        Data.query('SELECT * FROM countries WHERE id = ?', [ id ], function(err, result : Country) {
            fn(err, result);
        });
    }
    
    public static function findAll(fn : DataError -> Array<Country> -> Void) : Void {
        Data.query('SELECT * FROM countries', function(err, result : Array<Country>) {
            fn(err, result);
        });
    }
    
    private function new(row : CountryRow) {
        this.id = row.id;
        this.code = row.code;
        this.name = row.name;
    }
    
    public function json() : String {
        return JSON.stringify({ id: this.id, name: this.name, code: this.code });
    }
}