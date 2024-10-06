# Where to find Factorio files
# TODO: add logic to detect OS and then use appropiate dir (maybe try to use steamtnkerlaunch/parse steam .vdf files to figure out factorio install dir)
# TODO: consider switching to justfiles

ifndef FACTORIO_ROOT
    $(error FACTORIO_ROOT is not set, exiting)
endif

# Output file format. PDF recommended.
# SVG can render tooltips - but they don't contain anything other than debug information.
OUTFORMAT=pdf

# LUA interpreter
LUA=lua

# GraphViz commands (brew install graphviz)
DOT=dot
UNFLATTEN=unflatten


all: recipes-all.$(OUTFORMAT) recipes-filtered.$(OUTFORMAT) techtree-all.$(OUTFORMAT)

recipes-all.$(OUTFORMAT):
	$(LUA) -e 'FACTORIO_ROOT=$(FACTORIO_ROOT)' recipes.lua | $(UNFLATTEN) | $(DOT) -T $(OUTFORMAT) -o $@

recipes-filtered.$(OUTFORMAT):
	$(LUA) -e 'FACTORIO_ROOT=$(FACTORIO_ROOT)' -e 'FILTER=true' recipes.lua | $(UNFLATTEN) | $(DOT) -T $(OUTFORMAT) -o $@

techtree-all.$(OUTFORMAT):
	$(LUA) -e 'FACTORIO_ROOT=$(FACTORIO_ROOT)' $? | $(DOT) -T $(OUTFORMAT) -o $@
	
clean:
	rm -f recipes-filtered.* recipes-all.* techtree-all.*
