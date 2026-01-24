<#
    kats - Fast Language Analyzer v1.2 (Windows)
    Quickly see what programming languages make up your project
#>

# Show help information
function Show-Help {
    Write-Host "Usage: kats.ps1 [directory]"
    Write-Host ""
    Write-Host "Analyzes a project directory and shows percentage of different programming languages."
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -h, --help    Show this help message"
    Write-Host "  -v, --version Show version information"
    Write-Host "  --top N       Show top N languages (default: 10)"
    Write-Host ""
    Write-Host "If no directory is specified, the current directory is analyzed."
    Write-Host "If the directory is a git repository, .gitignore patterns are respected."
}

# Show version information
function Show-Version {
    Write-Host "kats v1.2 (Windows)"
    Write-Host "Fast language analyzer with gitignore support"
}

# Default settings
$TOP_LANGUAGES = 10
$TARGET_DIR = $null

# Parse command line arguments
for ($i = 0; $i -lt $args.Length; $i++) {
    $arg = $args[$i]
    
    switch -Regex ($arg) {
        "^(-h|--help)$" {
            Show-Help
            exit 0
        }
        "^(-v|--version)$" {
            Show-Version
            exit 0
        }
        "^--top$" {
            $i++
            if ($i -lt $args.Length -and $args[$i] -match "^\d+$") {
                $TOP_LANGUAGES = [int]$args[$i]
            }
            else {
                Write-Host "Error: --top requires a number" -ForegroundColor Red
                Show-Help
                exit 1
            }
        }
        "^-.*" {
            Write-Host "Unknown option: $arg" -ForegroundColor Red
            Show-Help
            exit 1
        }
        default {
            if ($null -eq $TARGET_DIR) {
                $TARGET_DIR = $arg
            }
            else {
                Write-Host "Error: Only one directory can be specified" -ForegroundColor Red
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
    Write-Host "Error: Directory '$TARGET_DIR' does not exist" -ForegroundColor Red
    exit 1
}

# Language extensions mapping
$LANGUAGE_MAPPING = @{
    "rs"         = "Rust"
    "c"          = "C"
    "h"          = "C"
    "cpp"        = "C++"
    "cxx"        = "C++"
    "cc"         = "C++"
    "hpp"        = "C++"
    "hxx"        = "C++"
    "hh"         = "C++"
    "py"         = "Python"
    "js"         = "JavaScript"
    "mjs"        = "JavaScript"
    "cjs"        = "JavaScript"
    "ts"         = "TypeScript"
    "tsx"        = "TypeScript"
    "java"       = "Java"
    "go"         = "Go"
    "rb"         = "Ruby"
    "php"        = "PHP"
    "swift"      = "Swift"
    "kt"         = "Kotlin"
    "kts"        = "Kotlin"
    "sh"         = "Shell"
    "bash"       = "Shell"
    "zsh"        = "Shell"
    "fish"       = "Shell"
    "html"       = "HTML"
    "htm"        = "HTML"
    "css"        = "CSS"
    "sql"        = "SQL"
    "json"       = "JSON"
    "yaml"       = "YAML"
    "yml"        = "YAML"
    "xml"        = "XML"
    "md"         = "Markdown"
    "markdown"   = "Markdown"
    "txt"        = "Text"
    "text"       = "Text"
    "cs"         = "C#"
    "cshtml"     = "C#"
    "razor"      = "C#"
    "scala"      = "Scala"
    "dart"       = "Dart"
    "lua"        = "Lua"
    "pl"         = "Perl"
    "pm"         = "Perl"
    "r"          = "R"
    "m"          = "Objective-C"
    "mm"         = "Objective-C"
    "ex"         = "Elixir"
    "exs"        = "Elixir"
    "erl"        = "Erlang"
    "hrl"        = "Erlang"
    "hs"         = "Haskell"
    "lhs"        = "Haskell"
    "clj"        = "Clojure"
    "cljs"       = "Clojure"
    "cljc"       = "Clojure"
    "scm"        = "Scheme"
    "rkt"        = "Racket"
    "d"          = "D"
    "nim"        = "Nim"
    "v"          = "V"
    "zig"        = "Zig"
    "fs"         = "F#"
    "ml"         = "OCaml"
    "mli"        = "OCaml"
    "coffee"     = "CoffeeScript"
    "vue"        = "Vue"
    "svelte"     = "Svelte"
    "astro"      = "Astro"
    "solid"      = "SolidJS"
    "qml"        = "QML"
    "purs"       = "PureScript"
    "res"        = "ReScript"
    "toml"       = "TOML"
    "ini"        = "INI"
    "cfg"        = "Config"
    "conf"       = "Config"
    "makefile"   = "Makefile"
    "dockerfile" = "Dockerfile"
    "sln"        = "Solution"
    "csproj"     = "C# Project"
    "vb"         = "Visual Basic"
    "vbs"        = "VBScript"
    "ps1"        = "PowerShell"
    "psm1"       = "PowerShell"
    "psd1"       = "PowerShell"
    "bat"        = "Batch"
    "cmd"        = "Batch"
    "asm"        = "Assembly"
    "s"          = "Assembly"
    "xaml"       = "XAML"
    "axaml"      = "XAML"
    "gradle"     = "Gradle"
    "groovy"     = "Groovy"
    "gvy"        = "Groovy"
    "gy"         = "Groovy"
    "gsp"        = "Groovy"
}

# Get the language name for a file extension
function Get-Language($extension) {
    if ($LANGUAGE_MAPPING.ContainsKey($extension)) {
        return $LANGUAGE_MAPPING[$extension]
    }
    return "Other"
}

Write-Host "Scanning $TARGET_DIR..." -ForegroundColor Cyan

# Use hashtables for counting
$languageCounts = @{}
$languageLines = @{}
$totalFiles = 0
$totalLines = 0

# Check if this is a git repository
$isGitRepo = $false
if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitCheck = git -C "$TARGET_DIR" rev-parse --is-inside-work-tree 2>$null
    if ($gitCheck -eq "true") {
        $isGitRepo = $true
    }
}

$files = @()

if ($isGitRepo) {
    # Use git to respect .gitignore files
    # We get relative paths, need to join with TARGET_DIR
    $gitFiles = git -C "$TARGET_DIR" ls-files --cached --others --exclude-standard
    foreach ($gFile in $gitFiles) {
        $files += Join-Path -Path $TARGET_DIR -ChildPath $gFile
    }
}
else {
    # Use Get-ChildItem with common exclusions
    $files = Get-ChildItem -Path $TARGET_DIR -File -Recurse |
    Where-Object {
        $_.FullName -notmatch '\\.git\\'
        $_.FullName -notmatch '\\node_modules\\'
        $_.FullName -notmatch '\\target\\'
        $_.FullName -notmatch '\\build\\'
        $_.Name -notmatch '^.'
    } | Select-Object -ExpandProperty FullName
}

foreach ($filePath in $files) {
    # Get the filename from the path
    $filename = Split-Path $filePath -Leaf
    
    # Get extension
    $extension = if ($filename -match '\.(.+)$') { $matches[1] } else { "" }
    $language = Get-Language $extension
    
    # Count lines in the file
    $lines = 0
    try {
        # Read file and count lines
        $lines = (Get-Content -Path $filePath -ErrorAction Stop).Count
        # Get-Content returns array for multiple lines, or single object/null for 0-1
        if ($null -eq $lines) { 
            # Check if file is empty
            if ((Get-Item $filePath).Length -gt 0) { $lines = 1 } else { $lines = 0 }
        }
    }
    catch {
        # Skip files we can't read
        $lines = 0
    }
    
    $totalFiles++
    $totalLines += $lines
    
    # Update counts
    if ($languageCounts.ContainsKey($language)) {
        $languageCounts[$language]++
        $languageLines[$language] += $lines
    }
    else {
        $languageCounts[$language] = 1
        $languageLines[$language] = $lines
    }
}

Write-Host ""
Write-Host "Results:" -ForegroundColor Blue
Write-Host "--------" -ForegroundColor Blue

if ($totalFiles -eq 0) {
    Write-Host "No files found."
    exit 0
}

# Function to determine color based on percentage
function Get-PercentColor($percent) {
    if ($percent -gt 50) { return "Yellow" }
    if ($percent -gt 20) { return "Green" }
    return "White"
}

# Show top languages by lines of code
Write-Host "By lines of code:" -ForegroundColor Gray -NoNewline; Write-Host ""
$languageLines.GetEnumerator() |
Sort-Object -Property Value -Descending |
Select-Object -First $TOP_LANGUAGES |
ForEach-Object {
    $language = $_.Key
    $lines = $_.Value
    $percentage = 0
    if ($totalLines -gt 0) {
        $percentage = [math]::Round(($lines * 100) / $totalLines, 2)
    }
    $pColor = Get-PercentColor $percentage
        
    Write-Host "  " -NoNewline
    Write-Host ("{0,-15}" -f $language) -ForegroundColor Cyan -NoNewline
    Write-Host (" {0,5} lines (" -f $lines) -NoNewline
    Write-Host ("{0}%" -f $percentage) -ForegroundColor $pColor -NoNewline
    Write-Host ")"
}

Write-Host ""
Write-Host "By file count:" -ForegroundColor Gray -NoNewline; Write-Host ""
$languageCounts.GetEnumerator() |
Sort-Object -Property Value -Descending |
Select-Object -First $TOP_LANGUAGES |
ForEach-Object {
    $language = $_.Key
    $count = $_.Value
    $percentage = 0
    if ($totalFiles -gt 0) {
        $percentage = [math]::Round(($count * 100) / $totalFiles, 2)
    }
    $pColor = Get-PercentColor $percentage

    Write-Host "  " -NoNewline
    Write-Host ("{0,-15}" -f $language) -ForegroundColor Cyan -NoNewline
    Write-Host (" {0,5} files (" -f $count) -NoNewline
    Write-Host ("{0}%" -f $percentage) -ForegroundColor $pColor -NoNewline
    Write-Host ")"
}

Write-Host ""
Write-Host "Total: " -NoNewline
Write-Host "$totalFiles" -ForegroundColor White -NoNewline
Write-Host " files, " -NoNewline
Write-Host "$totalLines" -ForegroundColor White -NoNewline
Write-Host " lines"