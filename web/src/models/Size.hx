/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;
import saffron.tools.JSON;

private typedef SizeRow = {
    var id : DataIdentifier;
    var name : String;
}

class Size {
    public var id(default, null) : DataIdentifier;
    public var name(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> Size -> Void) : Void {
        Data.query('SELECT * FROM sizes WHERE id = ?', [ id ], function(err, result : Size) {
            fn(err, result);
        });
    }
    
    public static function findAll(fn : DataError -> Array<Size> -> Void) : Void {
        Data.query('SELECT * FROM sizes', function(err, result : Array<Size>) {
            fn(err, result);
        });
    }
    
    private function new(row : SizeRow) {
        this.id = row.id;
        this.name = row.name;
    }
    
    public function json() : String {
        return JSON.stringify({ id: this.id, name: this.name });
    }
}