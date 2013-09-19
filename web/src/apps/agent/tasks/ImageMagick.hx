/* Copyright (c) 2013 Meep Factory OU */

package apps.agent.tasks;

import js.Node;
import models.Media;

typedef ImageMagickParameter = {
    var id : String;
    var crop : Bool;
    var width : Int;
    var height : Int;
    var format : String;
};

class ImageMagick extends Task {
	public static inline var format_png = 'png';
    public static inline var format_jpg = 'jpg';
    
    private static inline var tool_identify = 'identify';
    private static inline var tool_mogrify = 'mogrify';
    private static inline var tool_user = 0;
    private static inline var tool_group = 0;
    
    private var processes : Array<Int>;
    private var numberOfProcesses : Int;
    private var parameters : Array<ImageMagickParameter>;
    
    public function new(numberOfProcesses : Int = 2, parameters : Array<ImageMagickParameter> = null) {
        super('ImageMagick', 1000);
        this.processes = new Array<Int>();
        this.numberOfProcesses = numberOfProcesses;
        this.parameters = parameters;
        
        if(this.parameters == null) {
            this.parameters = new Array<ImageMagickParameter>();
            this.parameters.push({ id: 't1', width: 32, height: 32, format: ImageMagick.format_jpg, crop: true });
            this.parameters.push({ id: 't2', width: 64, height: 64, format: ImageMagick.format_jpg, crop: true });
            this.parameters.push({ id: 'i1', width: 320, height: 480, format: ImageMagick.format_jpg, crop: false });
            this.parameters.push({ id: 'i2', width: 640, height: 1136, format: ImageMagick.format_jpg, crop: false });
            this.parameters.push({ id: 'i3', width: 1024, height: 1024, format: ImageMagick.format_jpg, crop: false });
            this.parameters.push({ id: 'i4', width: 2048, height: 2048, format: ImageMagick.format_jpg, crop: false });
        }
    }
    
    private function onIdentify(media : Media, fn : Int -> Int -> Int -> Void) : Void {
        var dir = Node.path.join(Media.root(), media.path);
        var arguments = new Array<String>();
        var options : Dynamic = { cwd: dir };
        var state = { data: '' };
        var process;
        
        arguments.push('-format');
        arguments.push('%w,%h');
        arguments.push(Node.path.join(dir, '0'));
        
        if(ImageMagick.tool_user != 0) {
            options.uid = ImageMagick.tool_user;
        }
        
        if(ImageMagick.tool_group != 0) {
            options.gid = ImageMagick.tool_group;
        }
        
        process = Node.childProcess.spawn(ImageMagick.tool_identify, arguments, options);
        process.stdout.on('data', function(data) {
            state.data = state.data + data;
        });
    
        process.on('error', function(error : String, stdout : NodeReadStream, stderr : NodeReadStream) {
            if(stdout != null) {
                this.error('onIdentify: ' + stdout, { id: media.id });
            }
            
            if(stderr != null) {
                this.error('onIdentify: ' + stderr, { id: media.id });
            }
            
            if(error != null) {
                this.error('onIdentify: ' + error, { id: media.id });
            }
            
            fn(-1, 0, 0);
        });
        
        process.on('close', function(code : Int) {
            if(code == 0) {
                var wh = state.data.split(',');
                
                fn(null, (wh.length == 2) ? Std.parseInt(wh[0]) : 0, (wh.length == 2) ? Std.parseInt(wh[1]) : 0);
            } else {
                fn(code, 0, 0);
            }
        });                                
    }
    
    private function onMogrify(media : Media, parameters : Array<ImageMagickParameter>, fn : Int -> Void) : Void {
        var parameter = (parameters != null && parameters.length > 0) ? parameters.shift() : null;
        
        if(parameter != null) {
            var dir = Node.path.join(Media.root(), media.path);
            var arguments = new Array<String>();
            var options : Dynamic = { cwd: dir };
            var process;
            
            if(ImageMagick.tool_user != 0) {
                options.uid = ImageMagick.tool_user;
            }
            
            if(ImageMagick.tool_group != 0) {
                options.gid = ImageMagick.tool_group;
            }
            
            arguments.push('-resize');
            
            if(parameter.crop) {
                arguments.push('' + parameter.width + 'x' + parameter.height + '^');
                arguments.push('-background');
                arguments.push('white');
                arguments.push('-gravity');
                arguments.push('center');
                arguments.push('-crop');
                arguments.push('' + parameter.width + 'x' + parameter.height + '!+0+0');
            } else {
                arguments.push('' + parameter.width + 'x' + parameter.height);
            }
            
            arguments.push('-format');
            arguments.push(parameter.format);
            arguments.push('-quality');
            arguments.push('75');
            
            arguments.push('-write');
            arguments.push(Node.path.join(dir, parameter.id));
            arguments.push(Node.path.join(dir, '0'));
            
            process = Node.childProcess.spawn(ImageMagick.tool_mogrify, arguments, options);
            process.on('error', function(error : String, stdout : NodeReadStream, stderr : NodeReadStream) {
                if(stdout != null) {
                    this.error('onMogrify: ' + stdout, { id: media.id });
                }
                
                if(stderr != null) {
                    this.error('onMogrify: ' + stderr, { id: media.id });
                }
                
                if(error != null) {
                    this.error('onMogrify: ' + error, { id: media.id });
                }
            });
            process.on('exit', function(code) {
                if(code == 0) {
                    this.onMogrify(media, parameters, fn);
                } else {
                    fn(code);
                }
            });
        } else {
            fn(null);
        }
    }
    
    private override function onRun() : Void {
        if(this.processes.length < this.numberOfProcesses) {
            Media.findAll(Media.status_uploaded, this.numberOfProcesses - this.processes.length, function(err, medias) {
                if(err == null && medias != null && medias.length > 0) {
                    for(media in medias) {
                        if(media.mime == Media.mime_png || media.mime == Media.mime_jpg) {
                            this.processes.push(media.id);
                            this.onIdentify(media, function(err, width, height) {
                                if(err == null && width > 0 && height > 0) {
                                    var parameters = new Array<ImageMagickParameter>();
                                    
                                    for(parameter in this.parameters) {
                                        if(parameter.crop || parameter.width < width || parameter.height < height) {
                                            parameters.push(parameter);
                                        }
                                    }
                                    
                                    this.onMogrify(media, parameters, function(err) {
                                        if(err != null) {
                                            this.error('onIdentify: ' + err, { id: media.id });
                                        }
                                        
                                        Media.update(media.id, { status: (err == null) ? Media.status_active : Media.status_invalid }, function(err, result) {
                                            this.processes.remove(media.id);
                                            this.reschedule();
                                        });
                                    });
                                } else {
                                    this.error('onIdentify: ' + err, { id: media.id });
                                    
                                    Media.update(media.id, { status: Media.status_invalid }, function(err, result) {
                                        this.processes.remove(media.id);
                                        this.reschedule();
                                    });
                                }
                            });
                        } else {
                            this.error('Invalid mime type for image: ' + media.id);
                        }
                    }
                } else {
                    this.reschedule();
                }
            });
        } else {
            this.reschedule();
        }
    }
}