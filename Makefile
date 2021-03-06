VERSION=1.6.0

REMOTE=ocaml go rust erlang
DISTDIR=radare2-r2pipe-$(VERSION)
ORIGIN=$(shell cat "$@/ORIGIN" 2> /dev/null)

all:
	@echo Nothing to do.

clean:
	for a in */Makefile ; do $(MAKE) -C $$a ; done
	-rm -rf */node_modules

dist:
	git clone . $(DISTDIR)
	$(MAKE) -C $(DISTDIR) rsync
	rm -rf $(DISTDIR)/.git
	tar czvf $(DISTDIR).tar.gz $(DISTDIR)
	rm -rf $(DISTDIR)

$(REMOTE):
	git clone "$(ORIGIN)" "$@.git"
	mv "$@/ORIGIN" .
	rm -rf "$@/"*
	cp -rf "$@.git/"* "$@/"
	rm -rf $@.git
	mv ORIGIN "$@"

sync: $(REMOTE)

.PHONY: sync rsync clean all $(REMOTE)
