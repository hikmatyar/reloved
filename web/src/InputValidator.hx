/* Copyright (c) 2013 Meep Factory OU */

import js.Node;
import saffron.tools.RegExp;

using StringTools;

class InputValidator {
	private static var emailRegex : RegExp = null;
	private static var webRegex : RegExp = null;
	
    public static function textByRemovingLinksFromText(text : String) : String {
    	if(emailRegex == null) {
    		emailRegex = new RegExp("([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4})", 'g');
    	}
    	
    	if(webRegex == null) {
    		webRegex = new RegExp("((http://)?www\\.[a-zA-Z0-9/.-]+\\.[a-zA-Z]{2,4})", 'g');
    	}
    	
    	if(text != null) {
    		untyped __js__("text = text.replace(InputValidator.emailRegex, '');");
    		untyped __js__("text = text.replace(InputValidator.webRegex, '');");
    	}
    	
        return text;
    }
}
