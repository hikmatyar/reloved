/* Copyright (c) 2013 Meep Factory OU */

package models;

import js.Node;
import saffron.Data;
import saffron.tools.Date;
import saffron.tools.JSON;

using StringTools;

private typedef MediaRow = {
    var id : Int;
    var user_id : Int;
    var status : Int;
    var filesize : Int;
    var mime : String;
    var path : String;
    var csum : String;
}

class Media {
    public static inline var checksum_length = 32;
    
    public static inline var mime_jpg = 'image/jpeg';
    public static inline var mime_png = 'image/png';
    
    public static inline var status_inactive = 0;
    public static inline var status_uploading = 1;
    public static inline var status_uploaded = 2;
    public static inline var status_active = 3;
    public static inline var status_invalid = 4;
    
    private static var root_directory = null;
    private static var root_date = null;
    
    public var id(default, null) : DataIdentifier;
    public var userId(default, null) : DataIdentifier;
    public var status(default, null) : Int;
    public var fileSize(default, null) : Int;
    public var mime(default, null) : String;
    public var path(default, null) : String;
    public var csum(default, null) : String;
    
    public static function root() : String {
        // Create the media directory if needed
        if(Media.root_directory == null) {
            Media.root_directory = Node.path.join(Node.__dirname, Config.media_root);
            
            if(!Node.fs.existsSync(Media.root_directory)) {
                Node.fs.mkdirSync(Media.root_directory);
            }
        }
        
        return Media.root_directory;
    }
    
    private static function generatePath(depth : Int, fn : String -> Void) : Void {
        var path = Node.path.join(Media.root_directory, Media.root_date, ('' + Std.random(999999999)).lpad('0', 9));
        
        Node.fs.mkdir(path, function(err) {
            if(err == null) {
                Node.fs.open(Node.path.join(path, '0'), 'wx', function(err, fd) {
                    if(err != null) {
                        if(depth > 100) {
                            fn(null);
                        } else {
                            Media.generatePath(depth + 1, fn);
                        }
                    } else {
                        Node.fs.close(fd, function(err) { fn((err == null) ? path.substr(Media.root().length + 1) : null); });
                    }
                });
            } else {
                fn(null);
            }
        });
    }
    
    private static function createPath(fn : String -> Void) : Void {
        var today = new Date();
        var date = '' + today.getFullYear() + '-' + Std.string(today.getMonth() + 1).lpad('0', 2) + '-' + Std.string(today.getDate()).lpad('0', 2);
        
        Media.root();
        
        // Create a folder for the current date if needed
        if(date != Media.root_date) {
            Media.root_date = date;
            
            if(!Node.fs.existsSync(Node.path.join(Media.root_directory, Media.root_date))) {
                Node.fs.mkdirSync(Node.path.join(Media.root_directory, Media.root_date));
            }
        }
        
        // Create a random file
        Media.generatePath(0, fn);    
    }
    
    public static function create(userId : DataIdentifier, mime : String, csum : String, fileSize : Int, fn : DataError -> Media -> Void) : Void {
        Media.createPath(function(path) {
            if(path != null) {
                Data.query('INSERT INTO media SET user_id = ?, mime = ?, csum = ?, filesize = ?, status = 1, path = ?, created = CURRENT_TIMESTAMP, modified = CURRENT_TIMESTAMP', [ userId, mime, csum, fileSize, path ], function(err, result) {
                    if(err == null && result != null) {
                        Media.find(result.insertId, fn);
                    } else {
                        fn(err, null);
                    }
                });
            } else {
                fn({ code: 'bad_media_path', fatal: true }, null);
            }
        });
    }
    
    public static function find(id : DataIdentifier, fn : DataError -> Media -> Void) : Void {
        Data.query('SELECT * FROM media WHERE id = ?', [ id ], function(err, result : Media) {
            fn(err, result);
        });
    }
    
    public static function findAll(status : Int, limit : Int, fn : DataError -> Array<Media> -> Void) : Void {
        Data.query('SELECT * FROM media WHERE status = ? ORDER BY created ASC LIMIT ?', [ status, limit ], function(err, result : Array<Media>) {
            fn(err, result);
        });
    }
    
    public static function update(id : DataIdentifier, attributes : Dynamic, fn : DataError -> DataResult -> Void) : Void {
        Data.query('UPDATE media SET ?, modified = CURRENT_TIMESTAMP WHERE id = ?', [ attributes, id ], function(err, result) {
        	fn(err, result);
        });
    }
    
    private function new(row : MediaRow) {
        this.id = row.id;
        this.userId = row.user_id;
        this.status = row.status;
        this.fileSize = row.filesize;
        this.mime = row.mime;
        this.path = row.path;
        this.csum = row.csum;
    }
    
    public function json() : String {
        return JSON.stringify({
            status: this.status,
            size: this.fileSize
        });
    }
}