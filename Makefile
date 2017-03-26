default: clean-logs js static

.PHONY: js static clean-logs publish format

js: format
	elm make src/Main.elm --output build/main.js

static:
	cp -r static/* build/

clean-logs:
	find . -name 'npm-debug.log.*' | xargs rm

publish: clean-logs js static
	aws s3 sync --delete build/ s3://perrygeo-test/mapbox-directions-ui/ --acl public-read
	echo "open https://s3.amazonaws.com/perrygeo-test/mapbox-directions-ui/index.html"

format:
	elm-format --yes src/

try:
	elm make _try.elm --output /tmp/try.html
	open /tmp/try.html
