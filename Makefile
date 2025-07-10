# Makefile for auto-installer-debian

SHELL := /bin/bash

# Paths
INSTALLER := ./install.sh
TEST_SCRIPT := ./test/basic_test.sh
LOG_DIR := ./logs

# Default target
.PHONY: all
all: help

.PHONY: run
run:
	sudo $(INSTALLER)

.PHONY: test
test:
	bash $(TEST_SCRIPT)

.PHONY: lint
lint:
	find . -type f -name "*.sh" -exec shellcheck {} +

.PHONY: logs
logs:
	@echo ""
	@echo "=== Recent log files ==="
	@ls -lt $(LOG_DIR) | head -n 10
	@echo ""

.PHONY: clean
clean:
	@echo "Deleting logs and backups..."
	@rm -rf $(LOG_DIR)/*
	@rm -rf ./backup/*
	@echo "Cleanup completed."

.PHONY: help
help:
	@echo ""
	@echo "Available commands:"
	@echo "  make run      -> Runs the main installer"
	@echo "  make test     -> Runs the project's basic tests"
	@echo "  make lint     -> Runs shellcheck on all .sh scripts"
	@echo "  make logs     -> Shows the latest generated logs"
	@echo "  make clean    -> Deletes generated logs and backups"
	@echo ""
