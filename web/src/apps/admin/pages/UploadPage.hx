/* Copyright (c) 2013 Meep Factory OU */

package apps.admin.pages;

import js.Node;
import models.Media;
import models.User;
import saffron.tools.Formidable;

typedef UploadPageMedia = {
	var mime : String;
	var size : Int;
	var csum : String;
	var path : String;
};

class UploadPage extends Page {
	private static inline var template_complete = 'upload.complete';
	private static inline var template_error = 'upload.error';
	
    public function index() : Void {
    	User.findAllOfType(User.type_external, function(err, users) {
    		this.render({ users: users });
    	});
    }
    
    public function post() : Void {
    	var files : Array<FormidableFile> = this.request.files.upload;
        var userId : Int = Std.parseInt(this.request.body.user);
        
        if(userId != null && files != null && files.length > 0) {
        	var uploads : Array<UploadPageMedia> = [ ];
			var identifiers : Array<Int> = [ ];
			
			for(file in files) {
				if((file.type == Media.mime_png || file.type == Media.mime_jpg) &&
					file.size > 0 && file.hash != null && file.hash.length == Media.checksum_length) {
					uploads.push({ mime: file.type, csum: file.hash, size: file.size, path: file.path });
				} else {
					this.render({ reason: 'media' }, template_error);
					return;
				}
			}
			
        	User.findOfType(userId, User.type_external, function(err, user) {
        		if(user == null) {
        			this.render({ reason: 'user' }, template_error);
        			return;
        		}
        		
				for(upload in uploads) {
					this.postMediaUpload(identifiers, user, upload);
				}
        		
        		async(function() {
        			this.render({ user: user.token, identifiers: identifiers }, template_complete);
        		});
			});
        } else {
        	this.render({ reason: 'no_data' }, template_error);
        }       
    }
    
    private function postMediaUpload(identifiers : Array<Int>, user : User, upload : UploadPageMedia) : Void {
		async(function(sync : Dynamic -> Void) {
			Media.create(user.id, upload.mime, upload.csum, upload.size, function(err, media) {
				if(err != null) {
					this.render({ reason: 'media_db' }, template_error);
					return;
				}
				
				identifiers.push(media.id);
				sync(media);
			});
		});
		
		async(function(sync, media : Media) {		
			Media.replaceFile(upload.path, media.path, function(err) {
				if(err != null) {
					this.render({ reason: 'media_cp' }, template_error);
					return;
				}
				
				sync(media);
			});
		});
		
		async(function(sync, media : Media) {
			Media.update(media.id, { status: Media.status_uploaded }, function(err, result) {
				if(err != null) {
					this.render({ reason: 'media_db' }, template_error);
					return;
				}
				
				sync();
			});
		});
	}
}