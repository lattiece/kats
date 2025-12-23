# kats - Language Analyzer Tool

kats is a simple command-line tool that analyzes a project directory and shows the percentage distribution of different programming languages.

## Installation

### Quick Install (macOS/Linux)

```bash
curl -sSL https://raw.githubusercontent.com/lattiece/kats/main/install.sh | bash
```

### Manual Install

1. Download the `kats` script from the GitHub repository
2. Make it executable: `chmod +x kats`
3. Move it to your PATH: `sudo mv kats /usr/local/bin/`

### GitHub Repository

The source code is available at: https://github.com/lattiece/kats

## Usage

```bash
# Analyze current directory
kats

# Analyze specific directory
kats /path/to/project

# Show help
kats --help

# Show version
kats --version
```

## Example Output

```
Scanning directory: my_project

Analysis Results:
================

Total files analyzed: 42
Total lines of code: 1250

Language Distribution (by lines of code):
----------------------------------------
Rust                :   850 lines (68.00%)
C                   :   300 lines (24.00%)
Python              :   100 lines (8.00%)

Language Distribution (by file count):
--------------------------------------
Rust                :     20 files (47.62%)
C                   :     15 files (35.71%)
Python              :      7 files (16.67%)

Analysis complete!
```

## Supported Languages

- Rust (.rs)
- C (.c, .h)
- C++ (.cpp, .cxx, .cc, .hpp, .hxx, .hh)
- Python (.py)
- JavaScript (.js, .mjs, .cjs)
- TypeScript (.ts, .tsx)
- Java (.java)
- Go (.go)
- Ruby (.rb)
- PHP (.php)
- Swift (.swift)
- Kotlin (.kt, .kts)
- Shell (.sh, .bash, .zsh, .fish)
- HTML (.html, .htm)
- CSS (.css)
- SQL (.sql)
- JSON (.json)
- YAML (.yaml, .yml)
- XML (.xml)
- Markdown (.md, .markdown)
- Text (.txt, .text)

## Requirements

- bash
- curl (for installation)
- bc (for percentage calculations)
- standard Unix tools (find, grep, sed, sort, wc)

## License

MIT License
