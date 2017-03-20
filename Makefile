default: html css js

.PHONY: js html css

js:
	elm make src/Main.elm --output build/main.js

html:
	cp templates/index.html build/index.html

css:
	cp templates/main.css build/main.css
