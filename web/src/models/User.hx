/* Copyright (c) 2013 Meep Factory OU */

package models;

import js.Node;
import saffron.Data;

using mixins.StringMixins;

private typedef UserRow = {
    id : DataIdentifier,
    session : String,
    ?token : String,
    ?size_id : DataIdentifier,
    ?media_id : DataIdentifier,
    ?email : String,
    ?phone : String,
    ?first_name : String,
    ?last_name : String,
    ?country_id : DataIdentifier,
    ?city : String,
    ?address : String,
    ?zipcode : String
}

typedef UserAttributes = {
    ?size_id : DataIdentifier,
    ?media_id : DataIdentifier,
    ?email : String,
    ?phone : String,
    ?first_name : String,
    ?last_name : String,
    ?country_id : DataIdentifier,
    ?city : String,
    ?address : String,
    ?zipcode : String
}

private typedef UserSessionRow = {
    var user_id : DataIdentifier;
    var application : String;
    var code : String;
    var expires : Int;
}

class UserSession {
    private var userId(default, null) : DataIdentifier;
    private var application(default, null) : String;
    private var code(default, null) : String;
    private var expires(default, null) : Int;
    
    public static function create(userId : DataIdentifier, application : String, session : String, sessionLength : Int, fn : DataError -> Void) {
        Data.query('INSERT INTO user_sessions (user_id, application, code, expires) VALUES(?, ?, ?, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL ? SECOND)) ON DUPLICATE KEY UPDATE code = ?, expires = DATE_ADD(CURRENT_TIMESTAMP, INTERVAL ? SECOND)', [ userId, application, session, sessionLength, session, sessionLength ], function(err, result) {
            fn(err);
        });
    }
    
    public static function delete(userId : String, session : String, fn : DataError -> Bool -> Void) {
        Data.query('DELETE FROM user_sessions WHERE user_id = ? AND code = ?', [ userId, session ], function(err, result) {
            fn(err, (err == null) ? true : false);
        });
    }
    
    private function new(row : UserSessionRow) {
        this.userId = row.user_id;
        this.application = row.application;
        this.code = row.code;
        this.expires = row.expires;
    }
}

class User {
	public static inline var scope_mobile = 'mobile';
	
	public static inline var type_auto = 'auto';
    public static inline var type_email = 'email';
    public static inline var type_external = 'ext';
    
    public var id(default, null) : DataIdentifier;
    public var token(default, null) : String;
    public var session(default, null) : String;
    public var permissions(default, null) : Array<Permission>;
    public var sizeId(default, null) : DataIdentifier;
    public var mediaId(default, null) : DataIdentifier;
    public var email(default, null) : String;
    public var phone(default, null) : String;
    public var firstName(default, null) : String;
    public var lastName(default, null) : String;
    public var countryId(default, null) : DataIdentifier;
    public var city(default, null) : String;
    public var address(default, null) : String;
    public var zipcode(default, null) : String;
    
    public static function generateSession() : String {
        var a : String = untyped Node.process.uptime().toString();
        var b : String = untyped Math.random().toString();
        
        return (Config.mysql_salt + a + b).sha1();
    }
    
    public static function create(type : String, token : String, secret : String, app : String, sessionLength : Int, fn : DataError -> User -> Void) : Void {
        var user = new User({ id: null, session: User.generateSession() });
        
        Data.query('INSERT INTO users (created, type, token, secret) VALUES(CURRENT_TIMESTAMP, ?, ?, ?)', [ type, token, (Config.mysql_salt + secret).sha1() ], function(err, result) {
            if(err == null) {
                user.id = result.insertId;
                
                UserSession.create(user.id, app, user.session, sessionLength, function(err) {
                    fn(err, (err == null) ? user : null);
                });
            } else {
                fn(err, null);
            }
        });
    }
    
    public static function login(type : String, token : String, secret : String, application : String, sessionLength : Int, fn : DataError -> User -> Void) : Void {
        Data.query('SELECT id, secret FROM users WHERE type = ? AND token = ?', [ type, token ], function(err, result) {
            if(err == null && result != null && result.length == 1) {
                if(result[0].secret == (Config.mysql_salt + secret).sha1()) {
                    var user = new User(result[0]);
                    
                    user.session = User.generateSession();
                    
                    UserSession.create(user.id, application, user.session, sessionLength, function(err) {
                        fn(err, (err == null) ? user : null);
                    });
                } else {
                    fn({ code: Error.toString(Error.access_denied), fatal: false }, null);
                }
            } else {
                fn(err, null);
            }
        });
    }
    
    public static function logout(userId : String, session : String, fn : DataError -> Bool -> Void) {
        UserSession.delete(userId, session, fn);
    }
    
    public static function hasPermission(userId : DataIdentifier, permission : String, fn : DataError -> Bool -> Void) {
        Data.query('SELECT permissions.id FROM permissions INNER JOIN role_permissions ON (permissions.id = role_permissions.permission_id) INNER JOIN user_roles ON (role_permissions.role_id = user_roles.role_id) WHERE permissions.code = ? AND user_roles.user_id = ?', [ permission, userId ], function(err, result) {
            fn(err, (err == null && result != null && result.length == 1) ? true : false);
        });
    }
    
    public static function find(id : DataIdentifier, fn : DataError -> User -> Void) : Void {
        Data.query('SELECT id FROM users WHERE id = ?', [ id ], function(err, result : User) {
        	fn(err, result);
        });
    }
    
    public static function findForSession(userId : String, session : String, fn : DataError -> User -> Void) : Void {
        Data.query('SELECT users.id AS id, user_sessions.code AS session FROM users LEFT JOIN user_sessions ON users.id = user_id WHERE users.id = ? AND user_sessions.code = ? AND CURRENT_TIMESTAMP < user_sessions.expires', [ userId, session ], function(err, result : User) { fn(err, result); });
    }
    
    public static function findOfType(id : DataIdentifier, type : String, fn : DataError -> User -> Void) : Void {
        Data.query('SELECT id, token FROM users WHERE id = ? AND type = ?', [ id, type ], function(err, result : User) {
        	fn(err, result);
        });
    }
    
    public static function findAllOfType(type : String, fn : DataError -> Array<User> -> Void) {
    	Data.query('SELECT id, token FROM users WHERE type = ? ORDER BY token ASC', [ type ], function(err, users : Array<User>) {
    		fn(err, users);
    	});
    }
    
    public static function update(id : DataIdentifier, attributes : UserAttributes, fn : DataError -> Void) : Void {
        Data.query('UPDATE users SET ?, modified = UNIX_TIMESTAMP(CURRENT_TIMESTAMP) WHERE id = ?', [ attributes, id ], function(err, result) {
            fn(err);
        });
    }
    
    private function new(row : UserRow) {
        // Basic attributes
        this.id = row.id;
        this.token = row.token;
        this.session = row.session;
        
        // Extended attributes
        this.sizeId = row.size_id;
        this.mediaId = row.media_id;
        this.email = row.email;
        this.phone = row.phone;
        this.firstName = row.first_name;
        this.lastName = row.last_name;
        this.countryId = row.country_id;
        this.city = row.city;
        this.address = row.address;
        this.zipcode = row.zipcode;
    }
}
