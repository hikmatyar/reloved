/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;
import saffron.tools.JSON;

private typedef EventRow = {
    var id : DataIdentifier;
    var user_id : DataIdentifier;
    var created : Int;
    var type : Int;
    var link : String;
    var meta : String;
}

class Event {
	public static inline var type_unknown = 0;
    public static inline var type_comment = 1;
    public static inline var type_purchase = 2;
    
    public var id(default, null) : DataIdentifier;
    public var userId(default, null) : DataIdentifier;
    public var created(default, null) : Int;
    public var type(default, null) : Int;
    public var link(default, null) : String;
    public var meta(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> Event -> Void) : Void {
        Data.query('SELECT * FROM events WHERE id = ?', [ id ], function(err, result : Event) {
            fn(err, result);
        });
    }
    
    public static function findAll(user_id : DataIdentifier, timestamp : Int, fn : DataError -> Array<Event> -> Void) : Void {
    	if(timestamp != null) {
            Data.query('SELECT * FROM events WHERE user_id = ? AND created > ? ORDER BY created ASC LIMIT ?', [ user_id, timestamp ], function(err, result : Array<Event>) {
                fn(err, result);
            });
        } else {
            Data.query('SELECT * FROM events WHERE user_id = ? ORDER BY created DESC LIMIT 10', [ user_id ], function(err, result : Array<Event>) {
                fn(err, result);
            });
        }
    }
    
    private function new(row : EventRow) {
        this.id = row.id;
        this.userId = row.user_id;
        this.created = row.created;
        this.type = row.type;
        this.link = row.link;
        this.meta = row.meta;
    }
    
    public function json() : String {
        return JSON.stringify({ id: this.id, type: this.type, date: new saffron.tools.Date(this.created * 1000).toISOString(), link: this.link, meta: this.meta });
    }
}
