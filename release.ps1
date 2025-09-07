# VoiceLog Release Script for Windows
# Builds Windows binaries (amd64, arm64) and creates release packages

param(
    [string]$Version = "",
    [switch]$SkipTag = $false
)

# Colors for output
$Red = "`e[31m"
$Green = "`e[32m"
$Yellow = "`e[33m"
$Blue = "`e[34m"
$Reset = "`e[0m"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = $Reset)
    Write-Host "${Color}${Message}${Reset}"
}

function Get-GitVersion {
    try {
        $tag = git describe --tags --exact-match HEAD 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $tag
        }
        
        $tag = git describe --tags --abbrev=0 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $tag
        }
        
        return "dev"
    }
    catch {
        return "dev"
    }
}

function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Main execution
try {
    Write-ColorOutput "=== VoiceLog Release Script ===" $Blue
    
    # Check prerequisites
    Write-ColorOutput "Checking prerequisites..." $Yellow
    
    if (-not (Test-Command "git")) {
        throw "Git is not installed or not in PATH"
    }
    
    if (-not (Test-Command "go")) {
        throw "Go is not installed or not in PATH"
    }
    
    # Get version
    if ([string]::IsNullOrEmpty($Version)) {
        $Version = Get-GitVersion
        if ($Version -eq "dev") {
            Write-ColorOutput "No git tag found, using 'dev' version" $Yellow
        }
    }
    
    Write-ColorOutput "Building version: $Version" $Green
    
    # Clean previous builds
    Write-ColorOutput "Cleaning previous builds..." $Yellow
    if (Test-Path "dist") {
        Remove-Item -Recurse -Force "dist"
    }
    New-Item -ItemType Directory -Path "dist" | Out-Null
    
    # Set environment variables for Windows builds
    $env:GOOS = "windows"
    $env:CGO_ENABLED = "1"
    
    # Build targets
    $targets = @(
        @{Arch = "amd64"; Name = "voicelog-windows-amd64.exe"},
        @{Arch = "arm64"; Name = "voicelog-windows-arm64.exe"}
    )
    
    foreach ($target in $targets) {
        Write-ColorOutput "Building $($target.Name)..." $Yellow
        
        $env:GOARCH = $target.Arch
        
        $buildCmd = "go build -ldflags=`"-X main.version=$Version`" -o `"dist/$($target.Name)`" main.go"
        
        Invoke-Expression $buildCmd
        if ($LASTEXITCODE -ne 0) {
            throw "Build failed for $($target.Name)"
        }
        
        # Verify binary was created
        if (-not (Test-Path "dist/$($target.Name)")) {
            throw "Binary not created: $($target.Name)"
        }
        
        $size = (Get-Item "dist/$($target.Name)").Length
        Write-ColorOutput "✓ Built $($target.Name) ($([math]::Round($size/1MB, 2)) MB)" $Green
    }
    
    # Create release packages
    Write-ColorOutput "Creating release packages..." $Yellow
    
    foreach ($target in $targets) {
        $binaryName = $target.Name
        $packageName = "voicelog-$Version-windows-$($target.Arch).zip"
        
        # Create temporary directory for package
        $tempDir = "dist/temp-$($target.Arch)"
        New-Item -ItemType Directory -Path $tempDir | Out-Null
        
        # Copy binary
        Copy-Item "dist/$binaryName" "$tempDir/voicelog.exe"
        
        # Copy README and LICENSE
        Copy-Item "README.md" $tempDir
        Copy-Item "LICENSE" $tempDir
        
        # Create zip package
        Compress-Archive -Path "$tempDir/*" -DestinationPath "dist/$packageName" -Force
        
        # Clean up temp directory
        Remove-Item -Recurse -Force $tempDir
        
        Write-ColorOutput "✓ Created $packageName" $Green
    }
    
    # Summary
    Write-ColorOutput "`n=== Build Summary ===" $Blue
    Write-ColorOutput "Version: $Version" $Green
    Write-ColorOutput "Targets: Windows (amd64, arm64)" $Green
    Write-ColorOutput "Output: dist/" $Green
    
    Get-ChildItem "dist" | ForEach-Object {
        $size = [math]::Round($_.Length/1MB, 2)
        Write-ColorOutput "  $($_.Name) ($size MB)" $Green
    }
    
    Write-ColorOutput "`nRelease build completed successfully!" $Green
    
    if (-not $SkipTag -and $Version -ne "dev") {
        Write-ColorOutput "`nTo create and push a git tag:" $Yellow
        Write-ColorOutput "  git tag -a v$Version -m `"Release v$Version`"" $Yellow
        Write-ColorOutput "  git push origin v$Version" $Yellow
    }
}
catch {
    Write-ColorOutput "`nError: $($_.Exception.Message)" $Red
    exit 1
}
