/* Copyright (c) 2013 Meep Factory OU */

package models;

import saffron.Data;

private typedef QueueRow = {
    var id : DataIdentifier;
    var task : String;
    var data1 : Int;
    var data2 : String;
}

class Queue {
	public static inline var task_email = 'email';
	public static inline var task_publish = 'publish';
	public static inline var task_stripe = 'stripe';
	
    public var id(default, null) : DataIdentifier;
    public var task(default, null) : String;
    public var data1(default, null) : DataIdentifier;
    public var data2(default, null) : String;
    
    public static function findAll(fn : DataError -> Array<Queue> -> Void) : Void {
        Data.query('SELECT * FROM queue', function(err, result : Array<Queue>) {
            fn(err, result);
        });
    }
    
    public static function delete(id : DataIdentifier, fn : DataError -> Void) : Void {
    	Data.query('DELETE FROM queue WHERE id = ?', [ id ], function(err, result) {
            fn(err);
        });
    }
    
    private function new(row : QueueRow) {
        this.id = row.id;
        this.task = row.task;
        this.data1 = row.data1;
        this.data2 = row.data2;
    }
}