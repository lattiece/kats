# kats - Language Analyzer Tool

*Fast, simple tool to analyze programming language structure in projects with precise percentages*

## Installation

### One-line install (macOS/Linux)
```bash
curl -sSL https://raw.githubusercontent.com/lattiece/kats/main/install.sh | bash
```

### Windows Installation
```powershell
# Run in PowerShell as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/lattiece/kats/main/windows/install_windows.ps1" -OutFile "install_windows.ps1"
."install_windows.ps1"
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

### Windows Manual Install
```powershell
# Download the repository
git clone https://github.com/lattiece/kats.git
cd kats

# Run directly
powershell.exe -ExecutionPolicy Bypass -File .\windows\kats.ps1

# Or install globally (run as Administrator)
."windows\install_windows.ps1"
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

kats recognizes 80+ file types across multiple language categories:

### Web & Frontend
- **HTML / CSS** (.html, .htm, .css)
- **JavaScript** (.js, .mjs, .cjs)
- **TypeScript** (.ts, .tsx)
- **Vue** (.vue)
- **Svelte** (.svelte)
- **Astro** (.astro)
- **SolidJS** (.solid)

### Backend & Server-Side
- **Python** (.py)
- **PHP** (.php)
- **Ruby** (.rb)
- **Go** (.go)
- **Rust** (.rs)
- **Java** (.java)
- **Kotlin** (.kt, .kts)
- **C#** (.cs)
- **Razor / ASP.NET** (.cshtml, .razor)
- **Swift** (.swift)
- **Dart** (.dart)

### Systems & Low-Level
- **C** (.c, .h)
- **C++** (.cpp, .cxx, .cc, .hpp, .hxx, .hh)
- **Objective-C** (.m, .mm)
- **Assembly** (.asm, .s)
- **D** (.d)
- **Nim** (.nim)
- **V** (.v)
- **Zig** (.zig)

### Functional & Scripting
- **Haskell** (.hs, .lhs)
- **Clojure** (.clj, .cljs, .cljc)
- **Elixir** (.ex, .exs)
- **Erlang** (.erl, .hrl)
- **F#** (.fs)
- **OCaml** (.ml, .mli)
- **ReScript** (.res)
- **PureScript** (.purs)
- **Racket / Scheme** (.rkt, .scm)
- **Lua** (.lua)
- **Perl** (.pl, .pm)
- **R** (.r)
- **CoffeeScript** (.coffee)

### Markup & Data Formats
- **XML** (.xml)
- **JSON** (.json)
- **YAML** (.yaml, .yml)
- **TOML** (.toml)
- **Markdown** (.md, .markdown)
- **XAML / Avalonia** (.xaml, .axaml)
- **QML** (.qml)
- **SQL** (.sql)

### Build & Configuration
- **Dockerfile** (Dockerfile)
- **Makefile** (makefile)
- **Gradle** (.gradle)
- **Groovy** (.groovy, .gvy, .gy, .gsp)
- **PowerShell** (.ps1, .psm1, .psd1)
- **Batch** (.bat, .cmd)
- **Config / INI** (.cfg, .conf, .ini)

### .NET & Microsoft
- **Visual Studio** (.sln, .csproj)
- **VB / VBScript** (.vb, .vbs)
- **Scala** (.scala)

### Other
- **Text** (.txt, .text)

## Why kats?

* **Accurate** - Precise line and file counting
* **No dependencies** - Just bash and standard tools
* **Open source** - Apache 2.0 licensed, free forever

## Requirements

* **Windows**: PowerShell 5.1 or later
* **macOS/Linux**: bash and standard Unix tools

## Contributing

Found a bug? Want to add a language? Open an issue or Pull Request!

```bash
git clone https://github.com/lattiece/kats.git
cd kats
# Make your changes and submit a PR!
```

# Star History

[![Star History Chart](https://api.star-history.com/svg?repos=lattiece/kats&type=Date)](https://star-history.com/#lattiece/kats)

---

**kats - Because every project deserves a quick language check!** 🐱
