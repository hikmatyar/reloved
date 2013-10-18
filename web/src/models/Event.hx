/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;
import saffron.tools.JSON;

private typedef EventRow = {
    var id : DataIdentifier;
    var user_id : DataIdentifier;
    var media_id : DataIdentifier;
    var created : Int;
    var type : Int;
    var link : String;
    var meta : String;
}

class Event {
	public static inline var type_unknown = 0;
    public static inline var type_purchase = 1;
    public static inline var type_comment = 2;
    public static inline var type_commented = 3;
    
    public var id(default, null) : DataIdentifier;
    public var userId(default, null) : DataIdentifier;
    public var mediaId(default, null) : DataIdentifier;
    public var created(default, null) : Int;
    public var type(default, null) : Int;
    public var link(default, null) : String;
    public var meta(default, null) : String;
    
    public static function logComment(userId : DataIdentifier, postId : DataIdentifier, commentId : DataIdentifier) : Void {
    	Event.create(Event.type_comment, userId, null, '/post/' + postId + '#' + commentId, null, null);
    }
    
    public static function create(type : Int, userId : DataIdentifier, mediaId : DataIdentifier, link : String, meta : String, fn : DataError -> Void) : Void {
    	Data.query('INSERT INTO events (user_id, media_id, type, link, meta, created) VALUES (?, ?, ?, ?, ?, UNIX_TIMESTAMP(CURRENT_TIMESTAMP))', [ userId, mediaId, type, link, meta ], function(err, result) {
			if(fn != null) {
				fn(err);
			}
		});
    }
    
    public static function find(id : DataIdentifier, fn : DataError -> Event -> Void) : Void {
        Data.query('SELECT * FROM events WHERE id = ?', [ id ], function(err, result : Event) {
            fn(err, result);
        });
    }
    
    public static function findAll(user_id : DataIdentifier, timestamp : Int, fn : DataError -> Array<Event> -> Void) : Void {
    	if(timestamp != null) {
            Data.query('SELECT * FROM events WHERE user_id = ? AND created > ? ORDER BY created ASC', [ user_id, timestamp ], function(err, result : Array<Event>) {
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
        this.mediaId = row.media_id;
        this.created = row.created;
        this.type = row.type;
        this.link = row.link;
        this.meta = row.meta;
    }
    
    public function json() : String {
        return JSON.stringify({ id: this.id, media: this.mediaId, type: this.type, date: new saffron.tools.Date(this.created * 1000).toISOString(), link: this.link, meta: this.meta });
    }
}
