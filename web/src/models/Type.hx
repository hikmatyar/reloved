/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;

private typedef TypeRow = {
    var id : DataIdentifier;
    var name : String;
}

class Type {
    public var id(default, null) : DataIdentifier;
    public var name(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> Type -> Void) : Void {
        Data.query('SELECT * FROM types WHERE id = ?', [ id ], function(err, result : Type) {
            fn(err, result);
        });
    }
    
    public static function findAll(fn : DataError -> Array<Type> -> Void) : Void {
        Data.query('SELECT * FROM types', function(err, result : Array<Type>) {
            fn(err, result);
        });
    }
    
    private function new(row : TypeRow) {
        this.id = row.id;
        this.name = row.name;
    }
}