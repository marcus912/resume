# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
make                  # Build all resume versions
make general          # Build specific version (outputs to out/general.pdf)
make watch-general    # Auto-recompile on changes (requires latexmk)
make list             # Show available versions
make clean            # Remove out/ directory
```

Requires XeLaTeX (via `brew install texlive` on macOS).

## Architecture

Modular LaTeX resume system. Version files in `versions/` compose content via `\input`:

```
versions/general.tex          # Main file - selects what to include
    └── \input common/        # Shared: preamble, header, summary
    └── \input content/jobs/  # Pick which jobs
    └── \input content/skills/# Pick which skill categories
```

**Key directories:**
- `common/` - Shared LaTeX (preamble.tex defines fonts/colors, header.tex has contact info)
- `content/` - Content database (jobs/, skills/, education/, projects/)
- `versions/` - Resume variants that mix-and-match content
- `ref/` - Reference materials (job descriptions in ref/jd/)

## Custom LaTeX Commands

Defined in `common/preamble.tex`:

```latex
\entry{Title}{Location}{Organization}{Dates}
\entrygap  % Vertical spacing between entries (configurable via \entryspacing)
```

- `\entry` - Formats job/education entries with title and org on left, location and dates on right
- `\entrygap` - Adds consistent vertical spacing between entries (adjust `\entryspacing` in preamble.tex)

## Writing Job Content

Bullet point formula:
1. **Action verb** - Led, Architected, Implemented, Spearheaded, etc.
2. **Specific/Quantifiable details** - technologies, scale, numbers
3. **Results** - impact, outcome, business value

Example: "Led the Apple token project, delivering MFi tokens for over 4 million devices, enabling seamless HomeKit integration via cloud APIs."

## Creating Versions

```bash
bin/new-version acme          # Creates versions/acme.tex from general.tex
bin/new-version acme --build  # Creates and builds immediately
```

Then edit `versions/acme.tex` to comment/uncomment `\input` lines for desired content.

## Git Rules

- Do NOT commit or push changes without explicit user permission
- Do NOT create pull requests without explicit user permission
- Do NOT include Claude keywords in commit messages (no "Claude", "AI-generated", "Co-Authored-By: Claude", etc.)
