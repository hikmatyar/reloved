/* Copyright (c) 2013 Meep Factory OU */

package models;

import js.Node;
import saffron.Data;

using StringTools;

private typedef PermissionRow = {
    var id : DataIdentifier;
    var status : Int;
    var name : String;
    var code : String;
}

class Permission {
    public static inline var root_access = 'reloved.admin.*';
    public static inline var admin_access = 'reloved.admin.access';
    
    public static inline var status_inactive = 0;
    public static inline var status_active = 1;
    public static inline var status_active_locked = 2;
    
    public var id(default, null) : DataIdentifier;
    public var status(default, null) : Int;
    public var name(default, null) : String;
    public var code(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> Permission -> Void) : Void {
        Data.query('SELECT * FROM permissions WHERE id = ?', [ id ], function(err, result : Permission) { fn(err, result); });
    }
    
    private function new(row : PermissionRow) {
        this.id = row.id;
        this.status = row.status;
        this.name = row.name;
        this.code = row.code;
    }
}
