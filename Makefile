GOVERSION := $(shell go version | cut -d ' ' -f 3 | cut -d '.' -f 2)

.PHONY: build build-plugin check fmt lint test test-race vet test-cover-html help generate-proto install
.DEFAULT_GOAL := build

build: ## build all
	@echo " > building"
	go build -o script .
	@echo " > build finished"

check: test fmt vet lint ## Run tests and linters

test: ## Run tests
	go test -race ./...

coverage: ## print code coverage
	go test -race -coverprofile coverage.txt -covermode=atomic ./... -tags=unit_test && go tool cover -html=coverage.txt

clean :
	rm -rf dist && rm script

fmt: ## Run gofmt linter
ifeq "$(GOVERSION)" "12"
	@for d in `go list` ; do \
		if [ "`gofmt -l -s $$GOPATH/src/$$d | tee /dev/stderr`" ]; then \
			echo "^ improperly formatted go files" && echo && exit 1; \
		fi \
	done
endif

lint: ## Run golint linter
	@for d in `go list` ; do \
		if [ "`golint $$d | tee /dev/stderr`" ]; then \
			echo "^ golint errors!" && echo && exit 1; \
		fi \
	done

vet: ## Run go vet linter
	@if [ "`go vet | tee /dev/stderr`" ]; then \
		echo "^ go vet errors!" && echo && exit 1; \
	fi

test-cover-html: ## Generate test coverage report
	go test -coverprofile=coverage.out -covermode=count
	go tool cover -func=coverage.out

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'