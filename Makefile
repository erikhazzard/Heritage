#some pretty print stuff
DATE=$(shell date +%I:%M%p)
CHECK=\033[32m✔\033[39m
HR= ==================================================

#Manually specify the third party libs to include
THIRD_PARTY = \
	static/lib/underscore.js \
	static/lib/json2.js \
	static/lib/jquery.js \
	static/lib/d3.js \
	static/lib/backbone.js

JS_TARGETS = \
	static/coffee/copyright.txt \
	static/js/logger.js \
	static/js/models/model-world.js \
	static/js/views/view-world.js \
	static/js/main.js

LESS_FILES = static/less/style.less

# ---------------------------------------
#  Make
# ---------------------------------------
all: coffee less

#Coffee script
coffee:
	@echo "\n${HR}"
	@echo "Compiling Coffeejs"
	@echo "${HR}"
	@coffee --compile --output static/js static/coffee
	@coffee --compile --output static/js/views static/coffee/views
	@coffee --compile --output static/js/models static/coffee/models
	@coffee --compile --output static/js/spec static/coffee/spec
	@echo "Compiled coffeejs...	${CHECK} Done\n"
	@echo "${HR}"
	@echo "\n${HR}"
	
less: 
	@echo "\n${HR}"
	@echo "Combining Less Files"
	@cat $(LESS_FILES) > static/css/all.less
	@echo "${CHECK} Done"
	@echo "\n${HR}"
	@echo "Compiling CSS"
	@./node_modules/less/bin/lessc static/css/all.less static/css/style-all.css
	@rm static/css/all.less
	@echo "Running Less compiler... ${CHECK} Done"
	@echo "\n${HR}"

watch:
	@when-changed.py static/coffee/*.coffee static/coffee/views/*.coffee static/coffee/models/*.coffee static/coffee/spec/*.coffee -c make
# ---------------------------------------
# JS files
# ---------------------------------------
js:
	@echo "\n${HR}"
	@echo "${HR}\nRunning uglify\n${HR}"

	@cat $(JS_TARGETS) > static/js/build/game.js
	@./node_modules/uglify-js/bin/uglifyjs -nc static/js/build/game.js > static/js/build/game.min.js
	@echo "Compiling Our Scripts ${CHECK} Done"
	@echo "\n${HR}"
	@echo "Files successfully built at ${DATE}."
	@echo "${HR}\n"
# ---------------------------------------
# Third party file build step
# ---------------------------------------
third:
	@echo "${HR}\n"
	@echo "Compiling Third Party JS"
	@cat  $(THIRD_PARTY) > static/js/lib/all3rdjs.js
	@./node_modules/uglify-js/bin/uglifyjs -nc static/js/lib/all3rdjs.js > static/js/lib/all3rdjs.min.js
	@rm static/lib/all3rdjs.js
	@echo "Third party files successfully built at ${DATE}."
