<#
    kats - Ultra-Fast Language Analyzer Tool v1.1 (Windows Edition)
    Analyzes a project directory and shows percentage of different programming languages
    PowerShell version for Windows compatibility
#>

# Function to show help
function Show-Help {
    Write-Host "Usage: kats.ps1 [directory]"
    Write-Host ""
    Write-Host "Analyzes a project directory and shows percentage of different programming languages."
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -h, --help    Show this help message"
    Write-Host "  -v, --version Show version information"
    Write-Host ""
    Write-Host "If no directory is specified, the current directory is analyzed."
}

# Function to show version
function Show-Version {
    Write-Host "kats v1.1 (Windows Edition)"
    Write-Host "Enhanced language analyzer with --top option and modern language support"
}

# Default settings
$TOP_LANGUAGES = 10
$TARGET_DIR = $null

# Parse command line arguments
for ($i = 0; $i -lt $args.Length; $i++) {
    $arg = $args[$i]
    
    switch ($arg) {
        "-h" {
            Show-Help
            exit 0
        }
        "--help" {
            Show-Help
            exit 0
        }
        "-v" {
            Show-Version
            exit 0
        }
        "--version" {
            Show-Version
            exit 0
        }
        "--top" {
            $i++
            if ($i -lt $args.Length -and $args[$i] -match "^\d+$") {
                $TOP_LANGUAGES = [int]$args[$i]
            } else {
                Write-Host "Error: --top requires a number"
                Show-Help
                exit 1
            }
            break
        }
        default {
            if ($arg -match "^-") {
                Write-Host "Unknown option: $arg"
                Show-Help
                exit 1
            } elseif ($null -eq $TARGET_DIR) {
                $TARGET_DIR = $arg
            } else {
                Write-Host "Error: Only one directory can be specified"
                Show-Help
                exit 1
            }
        }
    }
}

# Set target directory (default to current directory)
if ($null -eq $TARGET_DIR) {
    $TARGET_DIR = "."
}

# Check if directory exists
if (-not (Test-Path -Path $TARGET_DIR -PathType Container)) {
    Write-Host "Error: Directory '$TARGET_DIR' does not exist"
    exit 1
}

# Language extensions mapping
$LANGUAGE_MAPPING = @{
    "rs" = "Rust"
    "c" = "C"
    "h" = "C"
    "cpp" = "C++"
    "cxx" = "C++"
    "cc" = "C++"
    "hpp" = "C++"
    "hxx" = "C++"
    "hh" = "C++"
    "py" = "Python"
    "js" = "JavaScript"
    "mjs" = "JavaScript"
    "cjs" = "JavaScript"
    "ts" = "TypeScript"
    "tsx" = "TypeScript"
    "java" = "Java"
    "go" = "Go"
    "rb" = "Ruby"
    "php" = "PHP"
    "swift" = "Swift"
    "kt" = "Kotlin"
    "kts" = "Kotlin"
    "sh" = "Shell"
    "bash" = "Shell"
    "zsh" = "Shell"
    "fish" = "Shell"
    "html" = "HTML"
    "htm" = "HTML"
    "css" = "CSS"
    "sql" = "SQL"
    "json" = "JSON"
    "yaml" = "YAML"
    "yml" = "YAML"
    "xml" = "XML"
    "md" = "Markdown"
    "markdown" = "Markdown"
    "txt" = "Text"
    "text" = "Text"
    "cs" = "C#"
    "scala" = "Scala"
    "dart" = "Dart"
    "lua" = "Lua"
    "pl" = "Perl"
    "pm" = "Perl"
    "r" = "R"
    "m" = "Objective-C"
    "mm" = "Objective-C"
    "ex" = "Elixir"
    "exs" = "Elixir"
    "erl" = "Erlang"
    "hrl" = "Erlang"
    "hs" = "Haskell"
    "lhs" = "Haskell"
    "clj" = "Clojure"
    "cljs" = "Clojure"
    "cljc" = "Clojure"
    "scm" = "Scheme"
    "rkt" = "Racket"
    "d" = "D"
    "nim" = "Nim"
    "v" = "V"
    "zig" = "Zig"
    "fs" = "F#"
    "ml" = "OCaml"
    "mli" = "OCaml"
    "coffee" = "CoffeeScript"
    "vue" = "Vue"
    "svelte" = "Svelte"
    "astro" = "Astro"
    "solid" = "SolidJS"
    "qml" = "QML"
    "purs" = "PureScript"
    "res" = "ReScript"
    "toml" = "TOML"
    "ini" = "INI"
    "cfg" = "Config"
    "conf" = "Config"
    "makefile" = "Makefile"
    "dockerfile" = "Dockerfile"
}

# Function to get language for extension
function Get-Language($extension) {
    if ($LANGUAGE_MAPPING.ContainsKey($extension)) {
        return $LANGUAGE_MAPPING[$extension]
    }
    return "Other"
}

Write-Host "Scanning $TARGET_DIR..."

# Use hashtables for counting
$languageCounts = @{}
$languageLines = @{}
$totalFiles = 0
$totalLines = 0

# Get all files, excluding common directories
$files = Get-ChildItem -Path $TARGET_DIR -File -Recurse | 
    Where-Object {
        $_.FullName -notmatch '\\\.git\\' -and 
        $_.FullName -notmatch '\\node_modules\\' -and 
        $_.FullName -notmatch '\\target\\' -and 
        $_.FullName -notmatch '\\build\\' -and 
        $_.Name -notmatch '^\\.'
    }

foreach ($file in $files) {
    $filename = $file.Name
    $extension = if ($filename -match '\.(.+)$') { $matches[1] } else { "" }
    $language = Get-Language $extension
    
    # Count lines
    $lines = 0
    try {
        $content = Get-Content -Path $file.FullName -ErrorAction Stop
        $lines = $content.Length
    } catch {
        # Skip files that can't be read
        $lines = 0
    }
    
    $totalFiles++
    $totalLines += $lines
    
    # Update counts
    if ($languageCounts.ContainsKey($language)) {
        $languageCounts[$language]++
        $languageLines[$language] += $lines
    } else {
        $languageCounts[$language] = 1
        $languageLines[$language] = $lines
    }
}

Write-Host ""
Write-Host "Results:"
Write-Host "--------"

if ($totalFiles -eq 0) {
    Write-Host "No files found."
    exit 0
}

# Show top languages by lines of code
Write-Host "By lines of code:"
$languageLines.GetEnumerator() | 
    Sort-Object -Property Value -Descending | 
    Select-Object -First $TOP_LANGUAGES | 
    ForEach-Object {
        $language = $_.Key
        $lines = $_.Value
        $percentage = [math]::Round(($lines * 100) / $totalLines, 2)
        Write-Host ("  {0,-15} {1,5} lines ({2}%)" -f $language, $lines, $percentage)
    }

Write-Host ""
Write-Host "By file count:"
$languageCounts.GetEnumerator() | 
    Sort-Object -Property Value -Descending | 
    Select-Object -First $TOP_LANGUAGES | 
    ForEach-Object {
        $language = $_.Key
        $count = $_.Value
        $percentage = [math]::Round(($count * 100) / $totalFiles, 2)
        Write-Host ("  {0,-15} {1,5} files ({2}%)" -f $language, $count, $percentage)
    }

Write-Host ""
Write-Host ("Total: {0} files, {1} lines" -f $totalFiles, $totalLines)