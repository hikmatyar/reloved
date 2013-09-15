Reloved Web Services
=======

# Prerequisites

* Haxe 3.0 or later
* NodeJS 0.10.10 or later
* Mac OS X or Linux with Autotools (installed with XCode on Mac)

# Install

Use Config.hx.example as a template to create Config.hx and then compile all the applications with Autotools.

	# All apps, debug versions
	make
	
	# All apps, release versions
	make release
	
	# Only API
	make debug-api
	make api
	
	# Only Agent
	make debug-agent
	make agent

	# Clean-up
	make clean

The generated javascript files are used with NodeJS.

	cd build
	node api.js
	node agent.js

# Development

Using Autotools to recompile and deploy the applications can get time-consuming. So it's a good idea to install restart.

	sudo npm install -g restart

To start it:

	restart --watch src --exec node watch.js
