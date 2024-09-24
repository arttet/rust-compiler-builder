## ▸▸▸ Utility commands ◂◂◂

.PHONY: help
help:			## Show this help
	@fgrep -h "## " $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/## //'

.PHONY: clean
clean:			## Remove generated artifacts
	rm -rf rust/config.toml

.PHONY: prune
prune:			## Remove all downloaded artifacts
	rm -rf rust
