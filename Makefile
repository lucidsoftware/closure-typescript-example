.DEFAULT_GOAL := run

all: js

define HELP_TEXT
all          -   js
run          -   compile and execute main.js

js           -   compile all js
ts           -   compile all ts
clutz        -   generate ts definition file from closure js
deps         -   locally install all dependencies

clean-app    -   remove all generated files - does NOT uninstall dependencies
clean        -   remove all generated files and uninstalls all dependencies
clean-*      -   remove files created by target *
help         -   print this message
endef
export HELP_TEXT

.PHONY: help
help:
	$(info $(HELP_TEXT))

UNAME_S := $(shell uname -s)

LEFT_PAREN := (
RIGHT_PAREN := )

# js
JS_ROOT := js/app
TS_OUTPUT_DIR := $(JS_ROOT)/ts
JS_BIN_PATH := js/bin
JS_CLUTZ_PATH := $(JS_ROOT)/clutz-mock
JS_EXTERNS_ROOT := $(JS_ROOT)/externs
CLUTZ_EXTERNS_ROOT := js/clutz-externs
JS_CLOSURE_LIBRARY_ROOTS := js/closure-library/closure/goog

JS_SOURCES = $(sort \
	$(shell find $(JS_ROOT) \
		-not -path "$(JS_CLUTZ_PATH)/*" \
		-type f \
		-name "*.js" \
	) \
)
JS_SOURCES_NO_TS = $(sort \
	$(shell find $(JS_ROOT) \
		-not -path "$(TS_OUTPUT_DIR)/*" \
		-type f \
		-name "*.js" \
	) \
)
BASE_JS = $(sort \
	$(shell find $(JS_CLOSURE_LIBRARY_ROOTS) \
		-not -name "*_test.js" \
		-type f \
		-name "base.js" \
	) \
)
JS_EXTERNS = $(shell find $(JS_EXTERNS_ROOT) -type f -name '*.js')
CLUTZ_EXTERNS = $(shell find $(CLUTZ_EXTERNS_ROOT) -type f -name '*.js')

js: $(JS_BIN_PATH)/main.js
.PHONY: $(JS_BIN_PATH)/main.js
$(JS_BIN_PATH)/main.js: $(JS_SOURCES) $(JS_EXTERNS) build/.ts-output build/.closure-compiler build/.npm-install
	mkdir -p $(JS_BIN_PATH)
	$(CLOSURE_COMPILE) \
		$(JS_EXTERNS:%=--externs %) \
		--externs=$(TS_EXTERNS_PATH) \
		--js_output_file=$(JS_BIN_PATH)/main.js \
		--language_in=ES6_STRICT \
		--language_out=ES5 \
		--compilation_level=WHITESPACE_ONLY \
		--closure_entry_point="js.app.ts.bootstrap" \
		--variable_renaming_report=$(JS_BIN_PATH)/variable_renaming_report \
		--property_renaming_report=$(JS_BIN_PATH)/property_renaming_report \
		$(JS_ROOT:%='%/**.js') \
		'!$(JS_CLUTZ_PATH)/**.js' \
		'node_modules/@angular/core/esm/**.js' \
		'node_modules/@angular/common/esm/**.js' \
		'node_modules/@angular/compiler/esm/**.js' \
		'node_modules/@angular/platform-browser/esm/**.js' \
		'node_modules/rxjs-closure/**.js' \
		'node_modules/symbol-observable/**.js'

clean-js:
	rm -rf $(JS_BIN_PATH)

# ts
TS_ROOT := ts/app
TS_DEFINITIONS_ROOT := $(TS_ROOT)/definitions/clutz
TS_SOURCES := $(shell find $(TS_ROOT) \
	-type f \
	-name '*.ts' \
	-not -name "*.ngfactory.ts" \
)
TSCONFIG := $(shell find $(TS_ROOT) -type f -name 'tsconfig.json')
TS_EXTERNS_PATH := js/tsickle_externs.js

# TypeScript compiler options are in ts/tsconfig.json
ts: build/.ts-output
build/.ts-output: build/.npm-install build/.tsickle $(TS_SOURCES) $(TSCONFIG) build/.clutz-output build/.npm-install ngc
	mkdir -p $(TS_OUTPUT_DIR)
	$(TSICKLE) --externs=$(TS_EXTERNS_PATH) -- --project $(TS_ROOT)
	@> $@

clean-ts:
	rm -rf build/.ts-output $(TS_EXTERNS_PATH) $(TS_OUTPUT_DIR)

clean: clean-deps \
	clean-js \
	clean-ts

clean-app: clean-clutz \
	clean-js \
	clean-ts

# external makefiles
include build/deps.makefile

run: js
	$(NODE) $(JS_BIN_PATH)/main.js


ngc: build/.ngc-output
build/.ngc-output: $(TS_SOURCES)
	node_modules/.bin/ngc -p $(TS_ROOT)
	@> $@

clean-ngc:
	rm -f $(TS_ROOT)/*.ngfactory.ts build/.ngc-output

CLUTZ_OUTPUT_PATH := $(TS_DEFINITIONS_ROOT)/main.d.ts
CLUTZ_CLOSURE_DEF_PATH := $(TS_DEFINITIONS_ROOT)/closure.lib.d.ts

clutz: build/.clutz-output
build/.clutz-output: build/.clutz build/.closure-library build/.closure-externs $(CLUTZ_EXTERNS) $(JS_SOURCES_NO_TS)
	mkdir -p $(TS_DEFINITIONS_ROOT)
	$(CLUTZ) $(foreach extern, $(CLUTZ_EXTERNS), --externs $(extern)) \
		-o $(CLUTZ_OUTPUT_PATH) $(sort $(BASE_JS) $(JS_SOURCES_NO_TS))
	cp $(CLUTZ_PATH)/src/resources/closure.lib.d.ts $(CLUTZ_CLOSURE_DEF_PATH)
	@> $@

clean-clutz:
	rm -f $(CLUTZ_OUTPUT_PATH) $(CLUTZ_CLOSURE_DEF_PATH) build/.clutz-output
