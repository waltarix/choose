ifeq ($(RUST_TARGET),)
	TARGET := ""
	RELEASE_SUFFIX := ""
else
	TARGET := $(RUST_TARGET)
	RELEASE_SUFFIX := "-$(TARGET)"
	export CARGO_BUILD_TARGET = $(RUST_TARGET)
endif

VERSION := $(word 3,$(shell grep -m1 "^version" Cargo.toml))
RELEASE := choose-$(VERSION)$(RELEASE_SUFFIX)

all: release

choose:
	cargo build --locked --release

bin:
	mkdir -p $@

bin/choose: choose bin
	cp -f target/$(TARGET)/release/choose $@

release: bin/choose
	tar -C bin -Jcvf $(RELEASE).tar.xz choose

.PHONY: all release
