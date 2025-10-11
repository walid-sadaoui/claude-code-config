#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Installation script for Claude Code configuration

.DESCRIPTION
    This script provides two installation modes:
    - Global: Installs the configuration for all projects (user-level)
    - Project: Creates a symlink in the current directory for project-specific config

.PARAMETER Mode
    Installation mode: 'global' or 'project'

.EXAMPLE
    .\install.ps1 -Mode global
    Installs configuration globally for all projects

.EXAMPLE
    .\install.ps1 -Mode project
    Creates a symlink in the current project directory
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('global', 'project')]
    [string]$Mode
)

$ErrorActionPreference = 'Stop'

# Colors for output
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Success($message) {
    Write-ColorOutput Green "[SUCCESS] $message"
}

function Write-Info($message) {
    Write-ColorOutput Cyan "[INFO] $message"
}

function Write-Error($message) {
    Write-ColorOutput Red "[ERROR] $message"
}

function Write-Warning($message) {
    Write-ColorOutput Yellow "[WARNING] $message"
}

# Get the script directory (where this repo is located)
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$CLAUDE_DIR = Join-Path $SCRIPT_DIR ".claude"
$SETTINGS_FILE = Join-Path $SCRIPT_DIR "settings.json"

# Check if running as administrator
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal $user
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-Global {
    Write-Info "Installing Claude Code configuration globally..."

    if (-not (Test-Administrator)) {
        Write-Error "Global installation requires administrator privileges."
        Write-Info "Please run PowerShell as Administrator and try again."
        exit 1
    }

    $userClaudeDir = Join-Path $env:USERPROFILE ".claude"

    # Check if .claude already exists
    if (Test-Path $userClaudeDir) {
        if ((Get-Item $userClaudeDir).LinkType -eq "SymbolicLink") {
            Write-Warning ".claude already exists as a symbolic link"
            $target = (Get-Item $userClaudeDir).Target
            Write-Info "Current target: $target"

            $response = Read-Host "Do you want to replace it? (y/N)"
            if ($response -ne 'y' -and $response -ne 'Y') {
                Write-Info "Installation cancelled."
                exit 0
            }

            Remove-Item $userClaudeDir -Force
        } else {
            Write-Warning ".claude directory already exists"
            Write-Info "Please backup and remove $userClaudeDir before installing globally"
            exit 1
        }
    }

    # Create symbolic link
    Write-Info "Creating symbolic link: $userClaudeDir -> $CLAUDE_DIR"
    New-Item -ItemType SymbolicLink -Path $userClaudeDir -Target $CLAUDE_DIR -Force | Out-Null

    Write-Success "Global configuration installed successfully!"
    Write-Info "Your Claude Code configuration is now available in all projects."
    Write-Info ""
    Write-Info "Configuration location: $userClaudeDir"
    Write-Info "Source: $CLAUDE_DIR"
}

function Install-Project {
    Write-Info "Installing Claude Code configuration for current project..."

    if (-not (Test-Administrator)) {
        Write-Error "Creating symbolic links on Windows requires administrator privileges."
        Write-Info "Please run PowerShell as Administrator and try again."
        exit 1
    }

    $currentDir = Get-Location
    $projectClaudeDir = Join-Path $currentDir ".claude"

    # Check if .claude already exists
    if (Test-Path $projectClaudeDir) {
        if ((Get-Item $projectClaudeDir).LinkType -eq "SymbolicLink") {
            Write-Warning ".claude already exists as a symbolic link in this project"
            $target = (Get-Item $projectClaudeDir).Target
            Write-Info "Current target: $target"

            $response = Read-Host "Do you want to replace it? (y/N)"
            if ($response -ne 'y' -and $response -ne 'Y') {
                Write-Info "Installation cancelled."
                exit 0
            }

            Remove-Item $projectClaudeDir -Force
        } else {
            Write-Warning ".claude directory already exists in this project"
            Write-Info "Please backup and remove $projectClaudeDir before installing"
            exit 1
        }
    }

    # Create symbolic link
    Write-Info "Creating symbolic link: $projectClaudeDir -> $CLAUDE_DIR"
    New-Item -ItemType SymbolicLink -Path $projectClaudeDir -Target $CLAUDE_DIR -Force | Out-Null

    Write-Success "Project configuration installed successfully!"
    Write-Info "Your Claude Code configuration is now available in this project."
    Write-Info ""
    Write-Info "Configuration location: $projectClaudeDir"
    Write-Info "Source: $CLAUDE_DIR"
    Write-Info ""
    Write-Warning "Don't forget to add .claude to your .gitignore file!"
}

function Show-Menu {
    Write-Host ""
    Write-Host "======================================"
    Write-Host "  Claude Code Configuration Installer"
    Write-Host "======================================"
    Write-Host ""
    Write-Host "Choose installation mode:"
    Write-Host ""
    Write-Host "  1) Global  - Install for all projects (user-level)"
    Write-Host "  2) Project - Install for current project only"
    Write-Host "  3) Exit"
    Write-Host ""

    $choice = Read-Host "Enter your choice (1-3)"

    switch ($choice) {
        "1" { Install-Global }
        "2" { Install-Project }
        "3" {
            Write-Info "Installation cancelled."
            exit 0
        }
        default {
            Write-Error "Invalid choice. Please run the script again."
            exit 1
        }
    }
}

# Main script logic
if (-not $Mode) {
    Show-Menu
} else {
    switch ($Mode) {
        "global" { Install-Global }
        "project" { Install-Project }
    }
}
