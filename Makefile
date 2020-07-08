OSTYPE := $(shell uname -s)
ifeq ($(OSTYPE),Linux)
	TARGET := x86_64-unknown-linux-musl
else ifeq ($(OSTYPE),Darwin)
	TARGET := x86_64-apple-darwin
else
$(error "Unsupported OSTYPE: $(OSTYPE)")
endif

VERSION := $(word 3,$(shell grep -m1 "^version" Cargo.toml))
RELEASE := choose-$(VERSION)-$(shell echo $(OSTYPE) | tr "[:upper:]" "[:lower:]")

all: release

choose:
	cargo build --locked --release --target=$(TARGET)

bin:
	mkdir -p $@

bin/choose: choose bin
	cp -f target/$(TARGET)/release/choose $@

release: bin/choose
	tar -C bin -Jcvf $(RELEASE).tar.xz choose

.PHONY: all release
