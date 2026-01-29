# Resume Builder

A modular LaTeX resume system that lets you maintain a master database of experiences, skills, and projects, then mix-and-match them into targeted resume versions for different companies.

## Quick Start

```bash
# Build all versions
make

# Build a specific version
make general

# Create a new version for a company
./bin/new-version company-a --build

# Live preview with auto-reload
make watch-general
```

## Project Structure

```
resume/
├── content/                  # Master database of all your content
│   ├── jobs/                 # Work experience entries
│   │   ├── fortinet.tex
│   │   ├── linksys.tex
│   │   └── globeunion.tex
│   ├── projects/             # Side projects
│   │   ├── voicechat.tex
│   │   └── objectdetect.tex
│   ├── skills/               # Skills by category
│   │   ├── languages.tex     # JavaScript, TypeScript, Java, Python
│   │   ├── frontend.tex      # React, Angular, MUI, HTML/CSS
│   │   ├── backend.tex       # Node.js, Spring Boot, REST APIs
│   │   ├── cloud.tex         # AWS, Docker, CI/CD, Kubernetes
│   │   ├── testing.tex       # Jest, Supertest, TDD
│   │   └── ai-ml.tex         # Machine Learning, YOLOv8
│   ├── education/            # Degrees
│   │   ├── nchu-ms.tex
│   │   └── ksu-bs.tex
│   ├── certifications/       # Professional certifications
│   │   └── aws.tex
│   └── publications/         # Papers, conferences
│       └── rice-blast.tex
├── common/                   # Shared formatting & header
│   ├── preamble.tex          # LaTeX packages, fonts, colors
│   ├── header.tex            # Name and contact info
│   └── summary.tex           # Professional summary
├── versions/                 # Resume versions (pick & choose content)
│   └── general.tex           # General-purpose resume
├── bin/                      # Helper scripts
│   └── new-version           # Create new resume version
├── out/                      # Generated PDFs
├── Makefile                  # Build automation
└── README.md
```

## Make Commands

| Command | Description |
|---------|-------------|
| `make` | Build all resume versions |
| `make <version>` | Build specific version (e.g., `make company-a`) |
| `make watch-<version>` | Live preview with auto-rebuild (e.g., `make watch-general`) |
| `make list` | List all available versions |
| `make clean` | Remove all generated files |
| `make help` | Show help |

## Creating a New Resume Version

### Using the Script (Recommended)

```bash
# Create new version from general.tex template
./bin/new-version company-a

# Create and build immediately
./bin/new-version company-b --build

# Show help and list existing versions
./bin/new-version --help
```

### Manual Method

1. Copy an existing version:
   ```bash
   cp versions/general.tex versions/newcompany.tex
   ```

2. Edit `versions/newcompany.tex` to select content:
   ```latex
   % Pick skill categories
   \section{Key Skills}
   \begin{tabular}{...}
   \input{../content/skills/cloud} \\      % Include cloud skills
   \input{../content/skills/backend} \\    % Include backend skills
   % \input{../content/skills/frontend}    % Comment out to exclude
   \end{tabular}

   % Pick jobs
   \section{Professional Experience}
   \input{../content/jobs/linksys}
   % \input{../content/jobs/globeunion}    % Comment out to exclude
   ```

3. Build:
   ```bash
   make newcompany
   ```

## Adding New Content

### Add a New Job

Create `content/jobs/newcompany.tex`:

```latex
\textbf{Job Title} | Company Name | MM/YYYY -- MM/YYYY
\begin{itemize}
  \item Achievement with quantifiable impact
  \item Another accomplishment
\end{itemize}
```

### Add a New Project

Create `content/projects/myproject.tex`:

```latex
\textbf{Project Name}\\
Description of the project and technologies used.
```

### Add a New Skill Category

Create `content/skills/newcategory.tex`:

```latex
\textbf{Category:} & Skill1, Skill2, Skill3
```

Then include it in your version file:
```latex
\input{../content/skills/newcategory} \\
```

## Customization

### Fonts

Edit `common/preamble.tex`. Default is Helvetica Neue Light. To change:

```latex
\setmainfont{Your Font Name}[
  UprightFont = *-Regular,
  BoldFont = *-Bold,
  ...
]
```

### Colors

Edit the color definitions in `common/preamble.tex`:

```latex
\definecolor{primary}{RGB}{30, 60, 90}      % Headings
\definecolor{accent}{RGB}{70, 100, 130}     % Accents
\definecolor{darkgray}{RGB}{60, 60, 60}     % Body text
```

### Contact Info

Edit `common/header.tex` with your details.

### Professional Summary

Edit `common/summary.tex` for the default summary, or override it per-version.

## Requirements

- TeX Live (with XeLaTeX)
- latexmk (for watch mode)

### macOS Installation

```bash
brew install texlive
brew install latexmk
```

## Tips

1. **One page resumes**: If your resume exceeds one page, reduce content by commenting out less relevant items

2. **Targeted versions**: Create specific versions for different roles highlighting relevant skills and experiences

3. **Keep content updated**: Add new jobs/projects to `content/` as you complete them, even if not using them yet

4. **Version control**: The modular structure works great with git - track changes to individual components
