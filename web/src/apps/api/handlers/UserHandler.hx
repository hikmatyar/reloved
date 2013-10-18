/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;
import models.User;

using apps.api.mixins.UserMixins;

class UserHandler extends Handler {
	public function details() {
		User.findExtended(this.user().id, function(err, user) {
			if(user != null) {
				this.begin(ErrorCode.http_ok);
				this.end(user.json());
			} else {
				this.exit((err == null) ? ErrorCode.none : ErrorCode.unknown);
			}
		});
	}
	
    public function edit() {
    	var attributes : UserAttributes = { };
    	var sizeId = this.userSizeIdentifier();
    	var mediaId = this.userMediaIdentifier();
    	var countryId = this.userCountryIdentifier();
    	var email = this.userEmail();
    	var phone = this.userPhone();
    	var firstName = this.userFirstName();
    	var lastName = this.userLastName();
    	var city = this.userCity();
    	var address = this.userAddress();
    	var zipCode = this.userZipCode();
    	
    	if(sizeId != null) {
    		attributes.size_id = sizeId;
    	}
    	
    	if(mediaId != null) {
    		attributes.media_id = mediaId;
    	}
    	
    	if(countryId != null) {
    		attributes.country_id = countryId;
    	}
    	
    	if(email != null) {
    		attributes.email = email;
    	}
    	
    	if(phone != null) {
    		attributes.phone = phone;
    	}
    	
    	if(firstName != null) {
    		attributes.first_name = firstName;
    	}
    	
    	if(lastName != null) {
    		attributes.last_name = lastName;
    	}
    	
    	if(city != null) {
    		attributes.city = city;
    	}
    	
    	if(address != null) {
    		attributes.address = address;
    	}
    	
    	if(zipCode != null) {
    		attributes.zipcode = zipCode;
    	}
    	
    	User.update(this.user().id, attributes, function(err) {
    		this.exit((err == null) ? ErrorCode.none : ErrorCode.unknown);
    	});
    }
}