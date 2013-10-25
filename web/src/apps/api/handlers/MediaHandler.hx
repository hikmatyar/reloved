/* Copyright (c) 2013 Meep Factory OU */

package apps.api.handlers;

import js.Node;
import models.Media;
import models.User;
import saffron.tools.Formidable;
import saffron.tools.JSON;

using StringTools;
using apps.api.mixins.MediaMixins;

class MediaHandler extends Handler {
    private function writeMedia(media : Media) : Void {
        Node.fs.stat(Node.path.join(Media.root(), media.path), function(err, stats) {
            this.render((media.status == Media.status_uploading && stats == null) ?
                { error: ErrorCode.none, id: media.id } :
                { error: ErrorCode.none, id: media.id, status: media.status, size: (stats != null) ? stats.size : 0 }
            );
        });
    }
    
    private function writeMediaUploaded(media : Media) : Void {
        Media.update(media.id, { status: Media.status_uploaded }, function(err, result) {
            if(err == null) {
                this.render({ error: ErrorCode.none, status: Media.status_uploaded, size: media.fileSize });
            } else {
                this.exit(ErrorCode.unknown);
            }
        });
    }
    
    public function status() : Void {
        var id = this.mediaIdentifier();
        var user = this.user();
        
        if(id != 0 && user != null) {
            Media.find(id, function(err, media) {
                if(media != null) {
                    if(media.userId == user.id) {
                        this.writeMedia(media);
                    } else {
                        this.exit(ErrorCode.access_denied);
                    }
                } else if(err == null) {
                    this.exit(ErrorCode.invalid_parameter);
                } else {
                    this.exit(ErrorCode.unknown);
                }
            });
        } else {
            this.exit(ErrorCode.missing_parameter);
        }
    }
    
    public function create() : Void {
        var user = this.user();
        var mime = this.mediaMime();
        var csum = this.mediaChecksum();
        var size = this.mediaFileSize();
        
        if(user != null && mime != null && csum != null && size != 0) {
            if(csum.length == Media.checksum_length && size > 0 && (mime == Media.mime_png || mime == Media.mime_jpg)) {
                Media.create(user.id, mime.toLowerCase(), csum.toLowerCase(), size, function(err, media) {
                    if(media != null) {
                        this.render({ error: ErrorCode.none, id: media.id });
                    } else {
                        this.exit(ErrorCode.unknown);
                    }
                });
            } else {
                this.exit(ErrorCode.invalid_parameter);
            }
        } else {
            this.exit(ErrorCode.missing_parameter);
        }
    }
    
    public function upload() : Void {
        var id = this.mediaIdentifier();
        var offset = this.mediaFileOffset();
        var files : Array<FormidableFile> = this.request.files.data;
        var file = (files != null && files.length > 0) ? files[0] : null;
        var user = this.user();
        
        if(id != 0 && user != null && file != null && file.size > 0) {
            Media.find(id, function(err, media) {
                if(media != null) {
                    if(media.userId == user.id) {
                        // Must be waiting for an upload
                        if(media.status != Media.status_uploading) {
                            this.exit(ErrorCode.invalid_parameter);
                        // Great! Full upload!
                        } else if(file.size == media.fileSize) {
                        	Media.replaceFile(file.path, media.path, function(err) {
								if(err == null) {
									this.writeMediaUploaded(media);
								} else {
									this.exit(ErrorCode.unknown);
								}
							});
                        // A chunk or resumed upload
                        } else {
                            Node.fs.stat(Node.path.join(Media.root(), media.path, '0'), function(err, stats) {
                                var osize = (stats != null) ? stats.size : 0;
                                
                                if(((stats != null && osize == offset) || (stats == null && offset == 0)) &&
                                    osize + file.size <= media.fileSize) {
                                    var ws = Node.fs.createWriteStream(Node.path.join(Media.root(), media.path, '0'), untyped { flags: 'a+', start: offset });
                                    var rs = Node.fs.createReadStream(file.path);
                                    
                                    ws.on('end', function() {
                                        if(osize + file.size == media.fileSize) {
                                            this.writeMediaUploaded(media);
                                        } else {
                                            this.writeMedia(media);
                                        }
                                    });
                                    
                                    rs.pipe(ws);
                                } else {
                                    this.exit(ErrorCode.invalid_parameter);
                                }
                            });
                        }
                    } else {
                        this.exit(ErrorCode.access_denied);
                    }
                } else if(err == null) {
                    this.exit(ErrorCode.invalid_parameter);
                } else {
                    this.exit(ErrorCode.unknown);
                }
            });
        } else {
            this.exit(ErrorCode.missing_parameter);
        }
    }
    
    public function download(id : Int) : Void {
        if(id != 0) {
            var preferredSize = this.mediaPreferredSize();
            var sizeSeries = 'o';
            var sizeIndex = 0;
            
            if(preferredSize != null && preferredSize.length > 0) {
                sizeSeries = preferredSize;
                
                if(preferredSize.length == 2) {
                    sizeIndex = Std.parseInt(preferredSize.charAt(1));
                    
                    if(sizeIndex != 0) {
                        sizeSeries = preferredSize.charAt(1);
                    }
                }
            }
            
            if(sizeSeries == 'o') {
                sizeSeries = '0';
            }
            
            Media.find(id, function(err, media) {
                if(media == null || media.status == Media.status_uploaded) {
                	this.response.send(ErrorCode.http_404);
                } else if(media.status == Media.status_active) {
                    var send : NodeHttpServerReq -> String -> NodeReadStream = untyped require('send');
                    var sendMedia = function(p) {
                        this.response.setHeader('Content-Type', media.mime);
                        send(this.request, Node.path.join(Media.root(), media.path, p)).pipe(this.response);
                    };
                    
                    if(sizeSeries != '0') {
                        Node.fs.readdir(Node.path.join(Media.root(), media.path), function(err, paths) {
                            var sizeIndex_ = 0;
                            
                            if(err == null) {
                                // Find a direct match
                                for(path in paths) {
                                    if(path == preferredSize) {
                                        sendMedia(path);
                                        return;
                                    }
                                }
                                
                                preferredSize = null;
                                
                                // Approximate match
                                if(sizeSeries.length == 1) {
                                    for(path in paths) {
                                        if(path.length == 2 && path.startsWith(sizeSeries)) {
                                            var sizeIndex__ = Std.parseInt(path.charAt(1));
                                            
                                            if(sizeIndex__ <= sizeIndex && sizeIndex__ > sizeIndex_) {
                                                sizeIndex_ = sizeIndex__;
                                                preferredSize = path.charAt(1);
                                            }
                                        }
                                    }
                                }
                                
                                // Final attempt!
                                sendMedia((preferredSize != null) ? sizeSeries + preferredSize : '0');
                            } else {
                                this.response.send(ErrorCode.http_500);
                            }
                        });
                    } else {
                        sendMedia('0');
                    }
                } else {
                    this.response.send(ErrorCode.http_403);
                }
            });
        } else {
            this.response.send(ErrorCode.http_404);
        }
    }
}