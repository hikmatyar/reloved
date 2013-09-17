/* Copyright (c) 2013 Meep Factory OU */

package models;

import js.Node;
import saffron.Data;

using StringTools;

private typedef RoleRow = {
    var id : DataIdentifier;
    var status : Int;
    var name : String;
}

class Role {
    public static inline var status_inactive = 0;
    public static inline var status_active = 1;
    public static inline var status_active_locked = 2;
    
    public var id(default, null) : DataIdentifier;
    public var status(default, null) : Int;
    public var name(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> Role -> Void) : Void {
        Data.query('SELECT * FROM roles WHERE id = ?', [ id ], function(err, result : Role) {
            fn(err, result);
        });
    }
    
    private function new(row : RoleRow) {
        this.id = row.id;
        this.status = row.status;
        this.name = row.name;
    }
}