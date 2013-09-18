var app = (process.argv.length > 2) ? process.argv[2] : 'api'

require('child_process').exec('make debug-' + app, function(error, stdout, stderr) {
	if(stderr !== '') {
		console.log(stderr);
	} else if(stdout !== '') {
		console.log(stdout);
		require('./build/' + app + '.js');
	}
	
	if(error !== null) {
		console.log('error: \n[' + error + ']');
	}
});