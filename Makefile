default: html css js clean-logs

.PHONY: js html css

js:
	elm make src/Main.elm --output build/main.js

html:
	cp templates/index.html build/index.html

css:
	cp templates/main.css build/main.css

clean-logs:
	ls src/npm-debug.log.* && rm src/npm-debug.log.* || echo
