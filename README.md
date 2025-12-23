# kats - Language Analyzer Tool

*Fast, simple tool to analyze language distribution in projects*

## Installation

### One-line install (macOS/Linux)
```bash
curl -sSL https://raw.githubusercontent.com/lattiece/kats/main/install.sh | bash
```

### Manual install
```bash
# Download the script
git clone https://github.com/lattiece/kats.git
cd kats

# Install globally
cp kats ~/bin/kats
chmod +x ~/bin/kats
```

## Usage

```bash
# Analyze current directory
kats

# Analyze specific project
kats /path/to/project

# Show help
kats --help

# Show version
kats --version
```

## Supported Languages

### Core Languages
* **Rust** (.rs) - Systems programming
* **C** (.c, .h) - Classic systems language
* **C++** (.cpp, .hpp, etc.) - High performance
* **Python** (.py) - Scripting & data science
* **JavaScript/TypeScript** (.js, .ts, .tsx) - Web development
* **Java** (.java) - Enterprise applications
* **Go** (.go) - Cloud & backend
* **Ruby** (.rb) - Web & scripting
* **PHP** (.php) - Web development
* **Swift** (.swift) - iOS/macOS development

### Modern & Functional
* **Kotlin** (.kt, .kts) - Android & JVM
* **Scala** (.scala) - JVM functional
* **Dart** (.dart) - Flutter apps
* **Elixir** (.ex, .exs) - Erlang VM
* **Erlang** (.erl, .hrl) - Concurrent systems
* **Haskell** (.hs, .lhs) - Pure functional
* **Clojure** (.clj, .cljs) - Lisp on JVM
* **Racket** (.rkt) - Scheme dialect
* **Nim** (.nim) - Python-like performance
* **Zig** (.zig) - Modern systems language

### Web & Frontend
* **Vue** (.vue) - Progressive framework
* **Svelte** (.svelte) - Reactive components
* **Astro** (.astro) - Content-focused sites
* **CoffeeScript** (.coffee) - JavaScript alternative
* **HTML/CSS** (.html, .htm, .css) - Web fundamentals

### Data & Scripting
* **R** (.r) - Statistical computing
* **Lua** (.lua) - Embedded scripting
* **Perl** (.pl, .pm) - Text processing
* **Shell** (.sh, .bash, .zsh) - System scripting
* **SQL** (.sql) - Database queries

### Configuration & Build
* **JSON** (.json) - Data interchange
* **YAML/TOML** (.yaml, .yml, .toml) - Config files
* **XML** (.xml) - Data markup
* **Makefile** (makefile) - Build automation
* **Dockerfile** (dockerfile) - Container config
* **Markdown** (.md) - Documentation

## Why kats?

* **Accurate** - Precise line and file counting
* **No dependencies** - Just bash and standard tools
* **Open source** - MIT licensed, free forever

## Requirements

* bash (not sh)
* curl (for installation)
* bc (for percentage calculations)
* Standard Unix tools (find, grep, sed, sort, wc)

## License

MIT License - Free to use, modify, and distribute

## Contributing

Found a bug? Want to add a language? Open an issue or PR!

```bash
git clone https://github.com/lattiece/kats.git
cd kats
# Make your changes and submit a PR!
```

# Star History

[![Star History Chart](https://api.star-history.com/svg?repos=lattiece/kats&type=Date)](https://star-history.com/#lattiece/kats)

---

**kats - Because every project deserves a quick language check!** 🐱💻
