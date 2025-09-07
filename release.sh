#!/bin/bash
# VoiceLog Release Script for Windows
# Builds Windows binary (amd64) and creates release package

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
VERSION=""
SKIP_TAG=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--version)
            VERSION="$2"
            shift 2
            ;;
        --skip-tag)
            SKIP_TAG=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -v, --version VERSION    Set version (default: auto-detect from git)"
            echo "  --skip-tag              Skip git tag creation"
            echo "  -h, --help              Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option $1"
            exit 1
            ;;
    esac
done

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to get version from git
get_git_version() {
    if git describe --tags --exact-match HEAD >/dev/null 2>&1; then
        git describe --tags --exact-match HEAD
    elif git describe --tags --abbrev=0 >/dev/null 2>&1; then
        git describe --tags --abbrev=0
    else
        echo "dev"
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main execution
main() {
    print_color "$BLUE" "=== VoiceLog Release Script ==="
    
    # Check prerequisites
    print_color "$YELLOW" "Checking prerequisites..."
    
    if ! command_exists git; then
        print_color "$RED" "Error: Git is not installed or not in PATH"
        exit 1
    fi
    
    if ! command_exists go; then
        print_color "$RED" "Error: Go is not installed or not in PATH"
        exit 1
    fi
    
    # Get version
    if [ -z "$VERSION" ]; then
        VERSION=$(get_git_version)
        if [ "$VERSION" = "dev" ]; then
            print_color "$YELLOW" "No git tag found, using 'dev' version"
        fi
    fi
    
    print_color "$GREEN" "Building version: $VERSION"
    
    # Clean previous builds
    print_color "$YELLOW" "Cleaning previous builds..."
    rm -rf dist
    mkdir -p dist
    
    # Set environment variables for Windows builds
    export GOOS=windows
    export CGO_ENABLED=1
    
    # Build targets
    declare -a targets=("amd64:voicelog-windows-amd64.exe")
    
    for target in "${targets[@]}"; do
        IFS=':' read -r arch binary_name <<< "$target"
        print_color "$YELLOW" "Building $binary_name..."
        
        export GOARCH="$arch"
        
        if go build -ldflags="-X main.version=$VERSION" -o "dist/$binary_name" main.go; then
            # Verify binary was created
            if [ -f "dist/$binary_name" ]; then
                size=$(du -h "dist/$binary_name" | cut -f1)
                print_color "$GREEN" "✓ Built $binary_name ($size)"
            else
                print_color "$RED" "Error: Binary not created: $binary_name"
                exit 1
            fi
        else
            print_color "$RED" "Error: Build failed for $binary_name"
            exit 1
        fi
    done
    
    # Create release packages
    print_color "$YELLOW" "Creating release packages..."
    
    for target in "${targets[@]}"; do
        IFS=':' read -r arch binary_name <<< "$target"
        package_name="voicelog-$VERSION-windows-$arch.zip"
        
        # Create temporary directory for package
        temp_dir="dist/temp-$arch"
        mkdir -p "$temp_dir"
        
        # Copy binary
        cp "dist/$binary_name" "$temp_dir/voicelog.exe"
        
        # Copy README and LICENSE
        cp README.md "$temp_dir/"
        cp LICENSE "$temp_dir/"
        
        # Create zip package
        (cd "$temp_dir" && zip -r "../$package_name" . >/dev/null)
        
        # Clean up temp directory
        rm -rf "$temp_dir"
        
        print_color "$GREEN" "✓ Created $package_name"
    done
    
    # Summary
    print_color "$BLUE" ""
    print_color "$BLUE" "=== Build Summary ==="
    print_color "$GREEN" "Version: $VERSION"
    print_color "$GREEN" "Targets: Windows (amd64)"
    print_color "$GREEN" "Output: dist/"
    
    for file in dist/*; do
        if [ -f "$file" ]; then
            size=$(du -h "$file" | cut -f1)
            print_color "$GREEN" "  $(basename "$file") ($size)"
        fi
    done
    
    print_color "$GREEN" ""
    print_color "$GREEN" "Release build completed successfully!"
    
    if [ "$SKIP_TAG" = false ] && [ "$VERSION" != "dev" ]; then
        print_color "$YELLOW" ""
        print_color "$YELLOW" "To create and push a git tag:"
        print_color "$YELLOW" "  git tag -a v$VERSION -m \"Release v$VERSION\""
        print_color "$YELLOW" "  git push origin v$VERSION"
    fi
}

# Run main function
main "$@"
