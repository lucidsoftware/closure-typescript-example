deps: build/.clutz \
	build/.node \
	build/.npm-install \
	build/.tsickle \
	build/.closure-compiler \
	build/.closure-externs \
	build/.closure-library \
	build/.gradle \
	build/.rxjs \
	build/.angular \
	build/.symbol-observable

clean-deps: clean-build/.clutz \
	clean-build/.node \
	clean-build/.npm-install \
	clean-build/.tsickle \
	clean-build/.closure-compiler \
	clean-build/.closure-externs \
	clean-build/.closure-library \
	clean-build/.gradle \
	clean-build/.rxjs \
	clean-build/.angular \
	clean-build/.symbol-observable
	rm -rf $(CLOSURE_NODE_MODULES_ROOT)

# clutz
CLUTZ_ROOT := deps/clutz
CLUTZ_PATH := $(CLUTZ_ROOT)/clutz
CLUTZ := $(abspath $(CLUTZ_PATH)/build/install/clutz/bin/clutz)
CLUTZ_VERSION := $(CLUTZ_ROOT)/clutz.version

build/.clutz: $(CLUTZ_VERSION) build/.gradle
	rm -rf $(CLUTZ_PATH)
	mkdir -p $(CLUTZ_PATH)
	curl -L `cat $<` | tar xz -C $(CLUTZ_PATH) --strip-components=1
	cd $(CLUTZ_PATH) && $(GRADLE) build installDist || exit 1
	@> $@

clean-build/.clutz: clean-clutz
	rm -rf $(CLUTZ_PATH) build/.clutz

# node and npm
NODE_ROOT := deps/node
NODE_PATH := $(NODE_ROOT)/node

NODE_VERSION := $(NODE_ROOT)/node.version
ifeq ($(UNAME_S),Darwin)
	NODE_VERSION := $(NODE_ROOT)/node.version.darwin
endif

NODE := $(abspath $(NODE_PATH)/bin/node)
NPM := $(abspath node_modules/.bin/npm) --nodedir=$(abspath $(NODE_PATH))

build/.node: $(NODE_VERSION)
	rm -rf $(NODE_PATH)
	mkdir -p $(NODE_PATH)
	curl -L `cat $<` | tar xJ -C $(NODE_PATH) --strip-components=1
	$(NODE_PATH)/bin/npm install npm@3.9.6
	@> $@

clean-build/.node:
	rm -rf $(NODE_PATH) build/.node

build/.npm-install: package.json build/.node build/.angular build/.rxjs build/.symbol-observable
	$(NPM) install
	@> $@

clean-build/.npm-install:
	rm -rf node_modules build/.npm-install

# tsickle
TSICKLE_ROOT := deps/tsickle
TSICKLE_PATH := $(TSICKLE_ROOT)/tsickle
TSICKLE := $(NODE) $(abspath $(TSICKLE_PATH)/build/src/main.js)
TSICKLE_VERSION := $(TSICKLE_ROOT)/tsickle.version

build/.tsickle: $(TSICKLE_VERSION) build/.node
	rm -rf $(TSICKLE_PATH)
	mkdir -p $(TSICKLE_PATH)
	curl -L `cat $<` | tar xz -C $(TSICKLE_PATH) --strip-components=1
	cd $(TSICKLE_PATH) && $(NPM) install || exit 1
	@> $@

clean-build/.tsickle:
	rm -rf $(TSICKLE_PATH) build/.tsickle

# closure compiler
CLOSURE_COMPILER_ROOT := deps/closure-compiler
CLOSURE_COMPILER_PATH := $(CLOSURE_COMPILER_ROOT)/closure-compiler
CLOSURE_JAR := $(CLOSURE_COMPILER_PATH)/closure-compiler.jar
CLOSURE_COMPILE := java -jar $(CLOSURE_JAR)
CLOSURE_COMPILER_VERSION := $(CLOSURE_COMPILER_ROOT)/closure-compiler.version

build/.closure-compiler: $(CLOSURE_COMPILER_VERSION)
	rm -rf $(CLOSURE_COMPILER_PATH)
	mkdir -p $(CLOSURE_COMPILER_PATH)
	curl -L `cat $<` -o $(CLOSURE_JAR)
	@> $@

clean-build/.closure-compiler:
	rm -rf $(CLOSURE_COMPILER_PATH) build/.closure-compiler

# closure compiler externs
CLOSURE_EXTERNS_ROOT := deps/closure-externs
CLOSURE_EXTERNS_PATH := $(CLOSURE_EXTERNS_ROOT)/closure-externs
CLOSURE_EXTERNS_DESTINATION := $(CLUTZ_EXTERNS_ROOT)/closure
CLOSURE_EXTERNS_VERSION := $(CLOSURE_EXTERNS_ROOT)/closure-externs.version

build/.closure-externs: $(CLOSURE_EXTERNS_VERSION)
	rm -rf $(CLOSURE_EXTERNS_PATH) $(CLOSURE_EXTERNS_DESTINATION)
	mkdir -p $(CLOSURE_EXTERNS_PATH) $(JS_EXTERNS_ROOT) $(CLOSURE_EXTERNS_DESTINATION)
	curl -L `cat $<` | tar xz -C $(CLOSURE_EXTERNS_PATH) --strip-components=1
	cp -r $(CLOSURE_EXTERNS_PATH)/externs/ $(CLOSURE_EXTERNS_DESTINATION)
	@> $@

clean-build/.closure-externs:
	rm -rf $(CLOSURE_EXTERNS_PATH) \
	 $(CLOSURE_EXTERNS_DESTINATION) \
	 build/.closure-externs

# closure library
CLOSURE_LIBRARY_ROOT := deps/closure-library
CLOSURE_LIBRARY_PATH := js/closure-library
CLOSURE_LIBRARY_VERSION := $(CLOSURE_LIBRARY_ROOT)/closure-library.version

build/.closure-library: $(CLOSURE_LIBRARY_VERSION)
	rm -rf $(CLOSURE_LIBRARY_PATH)
	mkdir -p $(CLOSURE_LIBRARY_PATH)
	curl -L `cat $<` | tar xz -C $(CLOSURE_LIBRARY_PATH) --strip-components=1
	@> $@

clean-build/.closure-library:
	rm -rf $(CLOSURE_LIBRARY_PATH) build/.closure-library

# gradle
GRADLE_ROOT := deps/gradle
GRADLE_PATH := $(GRADLE_ROOT)/gradle
GRADLE := $(abspath $(GRADLE_PATH)/bin/gradle)
GRADLE_ZIP := $(GRADLE_ROOT)/gradle.zip
GRADLE_VERSION := $(GRADLE_ROOT)/gradle.version

build/.gradle: $(GRADLE_VERSION)
	rm -rf $(GRADLE_PATH)
	mkdir -p $(GRADLE_PATH)
	curl -o $(GRADLE_ZIP) -L `cat $<`
	unzip -d $(GRADLE_PATH) $(GRADLE_ZIP)
	mv $(GRADLE_PATH)/gradle-*/* $(GRADLE_PATH)
	rm -f $(GRADLE_ZIP)
	@> $@

clean-build/.gradle:
	rm -rf $(GRADLE_PATH) build/.gradle

# angular
ANGULAR_ROOT := deps/angular
ANGULAR_PATH := $(ANGULAR_ROOT)/angular
ANGULAR_VERSION := $(ANGULAR_ROOT)/angular.version
ANGULAR_DEST := $(CLOSURE_NODE_MODULES_ROOT)/angular

build/.angular: $(ANGULAR_VERSION) build/.node
	rm -rf $(ANGULAR_PATH)
	mkdir -p $(ANGULAR_PATH)
	curl -L `cat $<` | tar xz -C $(ANGULAR_PATH) --strip-components=1
	cd $(ANGULAR_PATH) && $(NPM) install && ./build.sh
	for pkg in `find $(ANGULAR_PATH)/dist/packages-dist -name package.json`; do \
		sed -i 's/0.0.0-PLACEHOLDER/2.0.0-rc.4-snap/g' $$pkg; \
		sed -i 's/5.0.0-beta.6/5.0.0-beta.9/g' $$pkg; \
	done
	mkdir -p $(ANGULAR_DEST)
	cp -r $(ANGULAR_PATH)/dist/packages-dist/* $(ANGULAR_DEST)
	cp -r $(ANGULAR_PATH)/dist/tools/@angular/tsc-wrapped $(ANGULAR_DEST)
	@> $@

clean-build/.angular:
	rm -rf $(ANGULAR_PATH) $(ANGULAR_DEST) build/.angular

# rxjs
RXJS_ROOT := deps/rxjs
RXJS_PATH := $(RXJS_ROOT)/rxjs
RXJS_VERSION := $(RXJS_ROOT)/rxjs.version
RXJS_DEST := $(CLOSURE_NODE_MODULES_ROOT)/rxjs-closure

build/.rxjs: $(RXJS_VERSION) build/.tsickle build/.node
	rm -rf $(RXJS_PATH)
	mkdir -p $(RXJS_PATH)
	curl -L `cat $<` | tar xz -C $(RXJS_PATH) --strip-components=1
	cd $(RXJS_PATH) && \
	$(NPM) install $(abspath $(TSICKLE_PATH)) && \
	$(NPM) install && \
	for js in `find dist/closure -name "*.js"`; do \
		sed -i "s/goog.module('dist.closure/goog.module('rxjs/g" $$js; \
		sed -i "s/goog.require('dist.closure/goog.require('rxjs/g" $$js; \
		sed -i "s/(this && this.__assign) ||//g" $$js; \
		sed -i "s/(this && this.__decorate) ||//g" $$js; \
		sed -i "s/(this && this.__metadata) ||//g" $$js; \
		sed -i "s/(this && this.__awaiter) ||//g" $$js; \
		sed -i "s/(this && this.__param) ||//g" $$js; \
		sed -i "s/(this && this.__extends) ||//g" $$js; \
	done
	mkdir -p $(RXJS_DEST) && cp -r $(RXJS_PATH)/dist/closure/* $(RXJS_DEST)
	@> $@

clean-build/.rxjs:
	rm -rf $(RXJS_PATH) $(RXJS_DEST) build/.rxjs

# symbol-observable
SYMBOL_OBSERVABLE_ROOT := deps/symbol-observable
SYMBOL_OBSERVABLE_PATH := $(SYMBOL_OBSERVABLE_ROOT)/symbol-observable
SYMBOL_OBSERVABLE_VERSION := $(SYMBOL_OBSERVABLE_ROOT)/symbol-observable.version
SYMBOL_OBSERVABLE_DEST := $(CLOSURE_NODE_MODULES_ROOT)/symbol-observable

build/.symbol-observable: $(SYMBOL_OBSERVABLE_VERSION) build/.node
	rm -rf $(SYMBOL_OBSERVABLE_PATH)
	mkdir -p $(SYMBOL_OBSERVABLE_PATH)
	curl -L `cat $<` | tar xz -C $(SYMBOL_OBSERVABLE_PATH) --strip-components=1
	cd $(SYMBOL_OBSERVABLE_PATH) && \
	$(NPM) install
	mkdir -p $(SYMBOL_OBSERVABLE_DEST) && cp -r $(SYMBOL_OBSERVABLE_PATH)/* $(SYMBOL_OBSERVABLE_DEST)
	@> $@

clean-build/.symbol-observable:
	rm -rf $(SYMBOL_OBSERVABLE_PATH) $(SYMBOL_OBSERVABLE_DEST) build/.symbol-observable
