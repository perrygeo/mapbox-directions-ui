GITREF := $(git rev-parse --abbrev-ref HEAD)

default: clean-logs js static

.PHONY: js static clean-logs publish format

js: format
	elm make src/Main.elm --output build/main.js

static:
	cp -r static/* build/

clean-logs:
	find . -name 'npm-debug.log.*' | xargs rm

.PHONY: publish
publish: clean-logs js static
	ghp-import -n -p -f build/ -c directions.perrygeo.com -m "update docs at $(GITREF)"

format:
	elm-format --yes src/

try:
	elm make _try.elm --output /tmp/try.html
	open /tmp/try.html
