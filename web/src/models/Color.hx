/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;
import saffron.tools.JSON;

private typedef ColorRow = {
    var id : DataIdentifier;
    var name : String;
}

class Color {
    public var id(default, null) : DataIdentifier;
    public var name(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> Color -> Void) : Void {
        Data.query('SELECT * FROM colors WHERE id = ?', [ id ], function(err, result : Color) {
            fn(err, result);
        });
    }
    
    public static function findAll(fn : DataError -> Array<Color> -> Void) : Void {
        Data.query('SELECT * FROM colors', function(err, result : Array<Color>) {
            fn(err, result);
        });
    }
    
    private function new(row : ColorRow) {
        this.id = row.id;
        this.name = row.name;
    }
    
    public function json() : String {
        return JSON.stringify({ id: this.id, name: this.name });
    }
}