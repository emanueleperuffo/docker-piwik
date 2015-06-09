NAME = emanueleperuffo/piwik
VERSION = 1

.PHONY: all build test release

all: build

build:
	docker build -t $(NAME):$(VERSION) --rm image

test:
	env NAME=$(NAME) VERSION=$(VERSION) ./test/runner.sh

release:
	git tag -a $(VERSION) -m "Version $(VERSION)" test tag_latest
	git push origin $(VERSION)