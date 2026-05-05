CLAUDE_DIR ?= $(HOME)/.claude
REPO_DIR   := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SRC        := $(REPO_DIR)/claude

.DEFAULT_GOAL := help

.PHONY: help install uninstall status

help:
	@echo "Targets:"
	@echo "  install    Symlink everything under claude/ into $(CLAUDE_DIR)/"
	@echo "  uninstall  Remove symlinks under $(CLAUDE_DIR)/ that point into this repo"
	@echo "  status     Show install state and any conflicts"
	@echo ""
	@echo "Override CLAUDE_DIR=/path/to/dest to install elsewhere (e.g. for testing)."

# Symlink every top-level entry under claude/ into $(CLAUDE_DIR).
# - Top-level files (e.g. settings.json) are linked directly.
# - Top-level directories (commands/, skills/, ...) are descended one level so
#   each child is linked individually. That way ~/.claude/skills can mix repo
#   skills with skills installed by other tools without clobbering either side.
install:
	@mkdir -p "$(CLAUDE_DIR)"
	@if [ ! -d "$(SRC)" ]; then echo "error: $(SRC) does not exist"; exit 1; fi
	@set -e; shopt -s nullglob 2>/dev/null || true; \
	link_one() { \
	  local src dst target; \
	  src="$$1"; dst="$$2"; \
	  if [ -L "$$dst" ]; then \
	    target=$$(readlink "$$dst"); \
	    if [ "$$target" = "$$src" ]; then echo "  ok    $$dst"; return 0; fi; \
	    echo "  skip  $$dst (symlink -> $$target)"; return 0; \
	  fi; \
	  if [ -e "$$dst" ]; then echo "  skip  $$dst (exists, not a symlink)"; return 0; fi; \
	  ln -s "$$src" "$$dst"; echo "  link  $$dst"; \
	}; \
	for src in "$(SRC)"/* "$(SRC)"/.[!.]*; do \
	  [ -e "$$src" ] || continue; \
	  name=$$(basename "$$src"); \
	  dst="$(CLAUDE_DIR)/$$name"; \
	  if [ -d "$$src" ] && [ ! -L "$$src" ]; then \
	    mkdir -p "$$dst"; \
	    for child in "$$src"/* "$$src"/.[!.]*; do \
	      [ -e "$$child" ] || continue; \
	      link_one "$$child" "$$dst/$$(basename $$child)"; \
	    done; \
	  else \
	    link_one "$$src" "$$dst"; \
	  fi; \
	done

# Remove only symlinks under $(CLAUDE_DIR) whose target lives inside this repo.
# Anything else (real files, links to other locations) is left alone.
uninstall:
	@if [ ! -d "$(CLAUDE_DIR)" ]; then echo "$(CLAUDE_DIR) does not exist; nothing to do"; exit 0; fi
	@find "$(CLAUDE_DIR)" -maxdepth 2 -type l -print 2>/dev/null | while IFS= read -r link; do \
	  target=$$(readlink "$$link"); \
	  case "$$target" in \
	    "$(SRC)"/*|"$(SRC)") rm "$$link"; echo "  rm    $$link" ;; \
	  esac; \
	done

status:
	@echo "Source: $(SRC)"
	@echo "Dest:   $(CLAUDE_DIR)"
	@echo ""
	@if [ ! -d "$(SRC)" ]; then echo "(source missing)"; exit 0; fi
	@set -e; \
	report() { \
	  local src dst target; \
	  src="$$1"; dst="$$2"; \
	  if [ -L "$$dst" ]; then \
	    target=$$(readlink "$$dst"); \
	    if [ "$$target" = "$$src" ]; then echo "  installed   $$dst"; \
	    else echo "  conflict    $$dst (symlink -> $$target)"; fi; \
	  elif [ -e "$$dst" ]; then echo "  conflict    $$dst (exists, not a symlink)"; \
	  else echo "  missing     $$dst"; fi; \
	}; \
	for src in "$(SRC)"/* "$(SRC)"/.[!.]*; do \
	  [ -e "$$src" ] || continue; \
	  name=$$(basename "$$src"); \
	  dst="$(CLAUDE_DIR)/$$name"; \
	  if [ -d "$$src" ] && [ ! -L "$$src" ]; then \
	    for child in "$$src"/* "$$src"/.[!.]*; do \
	      [ -e "$$child" ] || continue; \
	      report "$$child" "$(CLAUDE_DIR)/$$name/$$(basename $$child)"; \
	    done; \
	  else \
	    report "$$src" "$$dst"; \
	  fi; \
	done
