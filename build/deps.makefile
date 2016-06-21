deps: build/.clutz \
	build/.node \
	build/.tsickle \
	build/.closure-compiler \
	build/.closure-externs \
	build/.closure-library \
	build/.gradle \
	build/.npm-install

clean-deps: clean-clutz \
	clean-node \
	clean-tsickle \
	clean-closure-compiler \
	clean-closure-externs \
	clean-closure-library \
	clean-gradle

# clutz
CLUTZ_ROOT := deps/clutz
CLUTZ_PATH := $(CLUTZ_ROOT)/clutz
CLUTZ := $(CLUTZ_PATH)/build/install/clutz/bin/clutz
CLUTZ_VERSION := $(CLUTZ_ROOT)/clutz.version

build/.clutz: $(CLUTZ_VERSION) build/.gradle
	rm -rf $(CLUTZ_PATH)
	mkdir -p $(CLUTZ_PATH)
	curl -L `cat $<` | tar xz -C $(CLUTZ_PATH) --strip-components=1
	cd $(CLUTZ_PATH) && ../../../$(GRADLE) build installDist
	@> $@

clean-clutz-install: clean-clutz
	rm -rf $(CLUTZ_PATH) build/.clutz

# node and npm
NODE_ROOT := deps/node
NODE_PATH := $(NODE_ROOT)/node

NODE_VERSION := $(NODE_ROOT)/node.version
ifeq ($(UNAME_S),Darwin)
	NODE_VERSION := $(NODE_ROOT)/node.version.darwin
endif

NODE := $(NODE_PATH)/bin/node
NPM := $(NODE_PATH)/bin/npm

build/.node: $(NODE_VERSION)
	rm -rf $(NODE_PATH)
	mkdir -p $(NODE_PATH)
	curl -L `cat $<` | tar xJ -C $(NODE_PATH) --strip-components=1
	@> $@

clean-node:
	rm -rf $(NODE_PATH) build/.node build/.npm-install
	rm -rf node_modules

build/.npm-install: package.json build/.node
	$(NPM) install
	@> $@

# tsickle
TSICKLE_ROOT := deps/tsickle
TSICKLE_PATH := $(TSICKLE_ROOT)/tsickle
TSICKLE := $(NODE) $(TSICKLE_PATH)/build/src/main.js
TSICKLE_VERSION := $(TSICKLE_ROOT)/tsickle.version

build/.tsickle: $(TSICKLE_VERSION) build/.npm-install
	rm -rf $(TSICKLE_PATH)
	mkdir -p $(TSICKLE_PATH)
	$(JS_ROOTS:%='%/**.js')
	curl -L `cat $<` | tar xz -C $(TSICKLE_PATH) --strip-components=1
	cd $(TSICKLE_PATH) && npm install
	@> $@

clean-tsickle:
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

clean-closure-compiler:
	rm -rf $(CLOSURE_COMPILER_PATH) build/.closure-compiler

# closure compiler externs
CLOSURE_EXTERNS_ROOT := deps/closure-externs
CLOSURE_EXTERNS_PATH := $(CLOSURE_EXTERNS_ROOT)/closure-externs
CLOSURE_EXTERNS_DESTINATION := $(JS_EXTERNS_ROOT)/closure
CLOSURE_EXTERNS_VERSION := $(CLOSURE_EXTERNS_ROOT)/closure-externs.version

build/.closure-externs: $(CLOSURE_EXTERNS_VERSION)
	rm -rf $(CLOSURE_EXTERNS_PATH) $(CLOSURE_EXTERNS_DESTINATION)
	mkdir -p $(CLOSURE_EXTERNS_PATH) $(JS_EXTERNS_ROOT)
	curl -L `cat $<` | tar xz -C $(CLOSURE_EXTERNS_PATH) --strip-components=1
	cp -r $(CLOSURE_EXTERNS_PATH)/externs/ $(CLOSURE_EXTERNS_DESTINATION)
	@> $@

clean-closure-externs:
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

clean-closure-library:
	rm -rf $(CLOSURE_LIBRARY_PATH) build/.closure-library

# gradle
GRADLE_ROOT := deps/gradle
GRADLE_PATH := $(GRADLE_ROOT)/gradle
GRADLE := $(GRADLE_PATH)/bin/gradle
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

clean-gradle:
	rm -rf $(GRADLE_PATH) build/.gradle
