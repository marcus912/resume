.PHONY: all clean watch list help

LATEX = xelatex
LATEXFLAGS = -output-directory=../out
VERSIONS_DIR = versions
OUT_DIR = out

# Find all version files
VERSIONS = $(wildcard $(VERSIONS_DIR)/*.tex)
PDFS = $(patsubst $(VERSIONS_DIR)/%.tex,$(OUT_DIR)/%.pdf,$(VERSIONS))

# Default: build all versions
all: $(PDFS)

# Build a specific version: make general, make startup, etc.
%: $(OUT_DIR)/%.pdf
	@echo "Built $<"

# Pattern rule for building PDFs
$(OUT_DIR)/%.pdf: $(VERSIONS_DIR)/%.tex $(wildcard common/*.tex) $(wildcard content/**/*.tex)
	@mkdir -p $(OUT_DIR)
	cd $(VERSIONS_DIR) && $(LATEX) $(LATEXFLAGS) $*.tex
	cd $(VERSIONS_DIR) && $(LATEX) $(LATEXFLAGS) $*.tex

# Watch a specific version: make watch-general, make watch-startup
watch-%:
	cd $(VERSIONS_DIR) && latexmk -xelatex -pvc -output-directory=../$(OUT_DIR) $*.tex

# Clean all generated files
clean:
	rm -rf $(OUT_DIR)

# List available versions
list:
	@echo "Available versions:"
	@for f in $(VERSIONS_DIR)/*.tex; do basename "$$f" .tex; done

# Help
help:
	@echo "Usage:"
	@echo "  make              - Build all resume versions"
	@echo "  make <version>    - Build specific version (e.g., make general)"
	@echo "  make watch-<ver>  - Watch and rebuild on changes (e.g., make watch-general)"
	@echo "  make list         - List available versions"
	@echo "  make clean        - Remove all generated files"
