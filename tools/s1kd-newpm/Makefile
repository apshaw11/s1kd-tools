.PHONY: docs clean maintainer-clean install uninstall

COMMON=../common

SOURCE=s1kd-newpm.c $(COMMON)/s1kd_tools.c

ifeq ($(OS),Windows_NT)
  OUTPUT=s1kd-newpm.exe
else
  OUTPUT=s1kd-newpm
endif

WARNING_FLAGS=-Wall -Werror -pedantic-errors
CFLAGS=$(WARNING_FLAGS) -I $(COMMON) `pkg-config --cflags libxml-2.0 libxslt`

ifeq ($(DEBUG),1)
  CFLAGS+=-g
else
  CFLAGS+=-O3
endif

LDFLAGS=`pkg-config --libs libxml-2.0 libxslt`

PREFIX=/usr/local
INSTALL_PREFIX=$(PREFIX)/bin
INSTALL=install -Ds

all: $(OUTPUT)

template.h: pm.xml $(COMMON)/to*.xsl
	> $@ && for f in $+; do xxd -i $$f >> $@; done

$(OUTPUT): $(SOURCE) template.h
	$(CC) $(CFLAGS) $(SOURCE) -o $(OUTPUT) $(LDFLAGS)

docs:
	$(MAKE) -C doc

clean:
	rm -f $(OUTPUT) template.h

maintainer-clean: clean
	$(MAKE) -C doc clean

install: $(OUTPUT)
	$(INSTALL) $(OUTPUT) $(INSTALL_PREFIX)/$(OUTPUT)
	$(MAKE) -C doc install

uninstall:
	rm -f $(INSTALL_PREFIX)/$(OUTPUT)
	$(MAKE) -C doc uninstall
