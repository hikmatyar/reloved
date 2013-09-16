/* Copyright (c) 2013 Meep Factory OU */

package mixins;

import js.Node;

class StringMixins {
    public static inline function sha1(str : String) : String {
        var hash = Node.crypto.createHash('sha1');
        
        hash.update(str);
        
        return hash.digest('hex');
    }
}