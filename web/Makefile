
SRC_DIR=src
DST_DIR=build
MODULES_DIR=node_modules
MODULE_PATH_EXPRESS=$(MODULES_DIR)/express
MODULE_PATH_FORMIDABLE=$(MODULES_DIR)/formidable
MODULE_PATH_GENERIC_POOL=$(MODULES_DIR)/generic-pool
MODULE_PATH_JASMINE_NODE=$(MODULES_DIR)/jasmine-node
MODULE_PATH_MAPSTRACE=$(MODULES_DIR)/mapstrace
MODULE_PATH_MYSQL=$(MODULES_DIR)/mysql
MODULE_PATH_SEND=$(MODULES_DIR)/send
MODULE_PATH_WINSTON=$(MODULES_DIR)/winston
MAIN_CLASS=Application
CFLAGS=-dce full
LIBS=-lib nodejs -lib saffron -D nodejs -D server
DEBUG=

all: DEBUG = -debug
all: init
all: admin
all: agent
all: api

debug-admin: DEBUG = -debug
debug-admin: admin

debug-agent: DEBUG = -debug
debug-agent: agent

debug-api: DEBUG = -debug
debug-api: api

release: init
release: admin
release: agent
release: api

init:
	mkdir -p $(DST_DIR)/$(MODULES_DIR)
	test -d $(DST_DIR)/$(MODULE_PATH_EXPRESS) || ln -s /usr/local/lib/$(MODULE_PATH_EXPRESS) $(DST_DIR)/$(MODULE_PATH_EXPRESS)
	test -d $(DST_DIR)/$(MODULE_PATH_FORMIDABLE) || ln -s /usr/local/lib/$(MODULE_PATH_FORMIDABLE) $(DST_DIR)/$(MODULE_PATH_FORMIDABLE)
	test -d $(DST_DIR)/$(MODULE_PATH_GENERIC_POOL) || ln -s /usr/local/lib/$(MODULE_PATH_GENERIC_POOL) $(DST_DIR)/$(MODULE_PATH_GENERIC_POOL)
	test -d $(DST_DIR)/$(MODULE_PATH_JASMINE_NODE) || ln -s /usr/local/lib/$(MODULE_PATH_JASMINE_NODE) $(DST_DIR)/$(MODULE_PATH_JASMINE_NODE)
	test -d $(DST_DIR)/$(MODULE_PATH_MAPSTRACE) || ln -s /usr/local/lib/$(MODULE_PATH_MAPSTRACE) $(DST_DIR)/$(MODULE_PATH_MAPSTRACE)
	test -d $(DST_DIR)/$(MODULE_PATH_MYSQL) || ln -s /usr/local/lib/$(MODULE_PATH_MYSQL) $(DST_DIR)/$(MODULE_PATH_MYSQL)
	test -d $(DST_DIR)/$(MODULE_PATH_SEND) || ln -s /usr/local/lib/$(MODULE_PATH_SEND) $(DST_DIR)/$(MODULE_PATH_SEND)
	test -d $(DST_DIR)/$(MODULE_PATH_WINSTON) || ln -s /usr/local/lib/$(MODULE_PATH_WINSTON) $(DST_DIR)/$(MODULE_PATH_WINSTON)

admin:
	haxe $(DEBUG) $(LIBS) -js $(DST_DIR)/admin.js -cp $(SRC_DIR) -cp ../../src -main apps.admin.$(MAIN_CLASS) $(CFLAGS)

agent:
	haxe $(DEBUG) $(LIBS) -js $(DST_DIR)/agent.js -cp $(SRC_DIR) -cp ../../src -main apps.agent.$(MAIN_CLASS) $(CFLAGS)

api:
	haxe $(DEBUG) $(LIBS) -js $(DST_DIR)/api.js -cp $(SRC_DIR) -cp ../../src -main apps.api.$(MAIN_CLASS) $(CFLAGS)

.PHONY: clean
clean:
	rm -fr $(DST_DIR)
