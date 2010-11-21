include $(GOROOT)/src/Make.inc 

TARG=markdown
GOFILES=\
	markdown.go\
	output.go\
	parser.leg.go\

package:

include $(GOROOT)/src/Make.pkg

all: cmd

#
# mdtest runs MarkdownTests-1.0.3 that come with original C sources
#
mdtest: package cmd orig-c-src
	make -C cmd test

cmd: package
	make -C cmd


CLEANFILES=\
	parser.leg.go\
	_obj\
	,,c\
	,,fmt\

distclean: clean clean-sub
	rm -rf orig-c-src

clean-sub:
	for dir in cmd peg peg/leg; do make -C $$dir clean; done


#
# LEG parser generator stuff
#
LEG = ./peg/leg/leg
%.leg.go: %.leg $(LEG)
	$(LEG) $<

$(LEG):
	make -C peg all
	make -C peg/leg all

peg:


#
# access to original C source files
#
VCS = git
# also, if hggit extension is available:
# VCS = hg

orig-c-src:
	$(VCS) clone git://github.com/jgm/peg-markdown.git $@



include misc/devel.mk

.PHONY: \
	cmd\
	distclean\
	mdtest\
