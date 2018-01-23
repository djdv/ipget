# Minimum version numbers for software required to build IPFS
IPFS_MIN_GO_VERSION = 1.7
IPFS_MIN_GX_VERSION = 0.12.1
IPFS_MIN_GX_GO_VERSION = 1.6

dist_root=/ipfs/QmfFqk8QBzV1nynPwUgiqmkqLLMt57vMiANT9gmeRGUBCw
gx_bin=bin/gx-v0.12.1
gx-go_bin=bin/gx-go-v1.6.0

# use things in our bin before any other system binaries
export PATH := bin:$(PATH)
export IPFS_API ?= v04x.ipfs.io

go_check:
	@bin/check_go_version $(IPFS_MIN_GO_VERSION)

bin/gx-v%:
	@echo "installing gx $(@:bin/gx-%=%)"
	@bin/dist_get ${dist_root} gx $@ $(@:bin/gx-%=%)
	rm -f bin/gx
	ln -s $(@:bin/%=%) bin/gx

bin/gx-go-v%:
	@echo "installing gx-go $(@:bin/gx-go-%=%)"
	@bin/dist_get ${dist_root} gx-go $@ $(@:bin/gx-go-%=%)
	rm -f bin/gx-go
	ln -s $(@:bin/%=%) bin/gx-go

gx_check: ${gx_bin} ${gx-go_bin}

path_check:
	@bin/check_go_path $(realpath $(shell pwd)) $(realpath $(GOPATH)/src/github.com/ipfs/ipget)

deps: go_check gx_check path_check
	${gx_bin} --verbose install --global

install: deps
	go install

build: deps
	go build

clean:
	rm -rf ./ipget

uninstall:
	go clean github.com/ipfs/ipget

PHONY += help gx_check
PHONY += go_check deps install build clean

##############################################################
# A semi-helpful help message

help:
	@echo 'DEPENDENCY TARGETS:'
	@echo ''
	@echo '  gx_check        - Installs or upgrades gx and gx-go'
	@echo '  deps            - Download dependencies using gx'
	@echo ''
	@echo 'BUILD TARGETS:'
	@echo ''
	@echo '  help         - print this help message'
	@echo '  build        - Build binary'
	@echo '  install      - Build binary and install into $$GOPATH/bin'
	@echo ''
	@echo 'CLEANING TARGETS:'
	@echo ''
	@echo '  clean        - Remove binary from build directory'
	@echo ''
	@echo 'TESTING TARGETS:'
	@echo ''
	@echo '  COMING SOON(TM)'
	@echo ''

PHONY += help

.PHONY: $(PHONY)
