#!/usr/bin/env bash

# Claude Code Configuration Installer
# Provides both global and project-level installation options

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Output functions
print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Get the script directory (where this repo is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$SCRIPT_DIR/.claude"
SETTINGS_FILE="$SCRIPT_DIR/settings.json"

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        *)          echo "unknown";;
    esac
}

OS=$(detect_os)

# Get user's .claude directory based on OS
get_user_claude_dir() {
    echo "$HOME/.claude"
}

# Global installation
install_global() {
    print_info "Installing Claude Code configuration globally..."

    local user_claude_dir=$(get_user_claude_dir)

    # Check if .claude already exists
    if [ -e "$user_claude_dir" ]; then
        if [ -L "$user_claude_dir" ]; then
            print_warning ".claude already exists as a symbolic link"
            local target=$(readlink "$user_claude_dir")
            print_info "Current target: $target"

            read -p "Do you want to replace it? (y/N) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_info "Installation cancelled."
                exit 0
            fi

            rm "$user_claude_dir"
        else
            print_warning ".claude directory already exists"
            print_info "Please backup and remove $user_claude_dir before installing globally"
            exit 1
        fi
    fi

    # Create symbolic link
    print_info "Creating symbolic link: $user_claude_dir -> $CLAUDE_DIR"
    ln -s "$CLAUDE_DIR" "$user_claude_dir"

    print_success "Global configuration installed successfully!"
    print_info "Your Claude Code configuration is now available in all projects."
    echo ""
    print_info "Configuration location: $user_claude_dir"
    print_info "Source: $CLAUDE_DIR"
}

# Project-level installation
install_project() {
    print_info "Installing Claude Code configuration for current project..."

    local current_dir=$(pwd)
    local project_claude_dir="$current_dir/.claude"

    # Check if .claude already exists
    if [ -e "$project_claude_dir" ]; then
        if [ -L "$project_claude_dir" ]; then
            print_warning ".claude already exists as a symbolic link in this project"
            local target=$(readlink "$project_claude_dir")
            print_info "Current target: $target"

            read -p "Do you want to replace it? (y/N) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_info "Installation cancelled."
                exit 0
            fi

            rm "$project_claude_dir"
        else
            print_warning ".claude directory already exists in this project"
            print_info "Please backup and remove $project_claude_dir before installing"
            exit 1
        fi
    fi

    # Create symbolic link
    print_info "Creating symbolic link: $project_claude_dir -> $CLAUDE_DIR"
    ln -s "$CLAUDE_DIR" "$project_claude_dir"

    print_success "Project configuration installed successfully!"
    print_info "Your Claude Code configuration is now available in this project."
    echo ""
    print_info "Configuration location: $project_claude_dir"
    print_info "Source: $CLAUDE_DIR"
    echo ""
    print_warning "Don't forget to add .claude to your .gitignore file!"
}

# Show interactive menu
show_menu() {
    echo ""
    echo "======================================"
    echo "  Claude Code Configuration Installer"
    echo "======================================"
    echo ""
    echo "Choose installation mode:"
    echo ""
    echo "  1) Global  - Install for all projects (user-level)"
    echo "  2) Project - Install for current project only"
    echo "  3) Exit"
    echo ""

    read -p "Enter your choice (1-3): " choice

    case $choice in
        1) install_global ;;
        2) install_project ;;
        3)
            print_info "Installation cancelled."
            exit 0
            ;;
        *)
            print_error "Invalid choice. Please run the script again."
            exit 1
            ;;
    esac
}

# Display usage information
usage() {
    cat << EOF
Usage: $0 [MODE]

Installation script for Claude Code configuration

MODES:
    global      Install configuration globally for all projects
    project     Install configuration for current project only
    (no args)   Show interactive menu

EXAMPLES:
    $0 global       Install globally
    $0 project      Install for current project
    $0              Show interactive menu

EOF
    exit 1
}

# Main script logic
main() {
    if [ $# -eq 0 ]; then
        show_menu
    elif [ $# -eq 1 ]; then
        case "$1" in
            global)
                install_global
                ;;
            project)
                install_project
                ;;
            -h|--help)
                usage
                ;;
            *)
                print_error "Invalid mode: $1"
                usage
                ;;
        esac
    else
        print_error "Too many arguments"
        usage
    fi
}

main "$@"
