default: clean-logs html

.PHONY: js html css clean-logs publish

js:
	elm make src/Main.elm --output build/main.js

html: js css
	cp templates/index.html build/index.html

css:
	cp templates/main.css build/main.css

clean-logs:
	ls src/npm-debug.log.* && rm src/npm-debug.log.* || echo

publish: html
	aws s3 sync build/ s3://perrygeo-test/mapbox-directions-ui/ --acl public-read
	echo "open https://s3.amazonaws.com/perrygeo-test/mapbox-directions-ui/index.html"
