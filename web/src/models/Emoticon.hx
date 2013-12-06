/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;
import saffron.tools.JSON;

private typedef EmoticonRow = {
    var id : DataIdentifier;
    var media_id : DataIdentifier;
    var name : String;
}

class Emoticon {
    public var id(default, null) : DataIdentifier;
    public var mediaId(default, null) : DataIdentifier;
    public var name(default, null) : String;
    
    public static function find(id : DataIdentifier, fn : DataError -> Emoticon -> Void) : Void {
        Data.query('SELECT * FROM emoticons WHERE id = ?', [ id ], function(err, result : Emoticon) {
            fn(err, result);
        });
    }
    
    public static function findAll(fn : DataError -> Array<Emoticon> -> Void) : Void {
        Data.query('SELECT * FROM emoticons', function(err, result : Array<Emoticon>) {
            fn(err, result);
        });
    }
    
    private function new(row : EmoticonRow) {
        this.id = row.id;
        this.mediaId = row.media_id;
        this.name = row.name;
    }
    
    public function json() : String {
        return JSON.stringify({ id: this.id, name: this.name, media: this.mediaId });
    }
}