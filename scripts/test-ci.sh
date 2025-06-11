#!/bin/bash

# Local CI Test Script
# This script mimics the GitHub Actions workflow for local testing

set -e

echo "🧪 F1App Local CI Test"
echo "======================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if we're in the right directory
if [[ ! -f "F1App.xcodeproj/project.pbxproj" ]]; then
    print_error "Not in F1App project directory"
    exit 1
fi

print_status "Starting local CI test..."

# Check Xcode version
echo ""
echo "📱 Xcode Information:"
xcodebuild -version

# Check available simulators
echo ""
echo "📱 Available iOS Simulators:"
xcrun simctl list devices available | grep "iPhone"

# Install SwiftLint if not present
if ! command -v swiftlint &> /dev/null; then
    print_warning "SwiftLint not found. Installing..."
    brew install swiftlint
fi

# Run SwiftLint
echo ""
echo "🔍 Running SwiftLint..."
if swiftlint lint; then
    print_status "SwiftLint passed"
else
    print_error "SwiftLint failed"
    exit 1
fi

# Check for hardcoded secrets
echo ""
echo "🔐 Checking for hardcoded secrets..."
if grep -r "password\|secret\|key\|token" --include="*.swift" F1App/ | grep -v "// " | grep -v "/*"; then
    print_error "Potential hardcoded secrets found"
    exit 1
else
    print_status "No hardcoded secrets detected"
fi

# Clean build
echo ""
echo "🧹 Cleaning build folder..."
xcodebuild clean -project F1App.xcodeproj -scheme F1App
print_status "Clean complete"

# Build app
echo ""
echo "🔨 Building app..."
if xcodebuild build \
    -project F1App.xcodeproj \
    -scheme F1App \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.1' \
    -allowProvisioningUpdates \
    CODE_SIGNING_ALLOWED=NO; then
    print_status "Build successful"
else
    print_error "Build failed"
    exit 1
fi

# Run tests
echo ""
echo "🧪 Running tests..."
if xcodebuild test \
    -project F1App.xcodeproj \
    -scheme F1App \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.1' \
    -parallel-testing-enabled NO \
    CODE_SIGNING_ALLOWED=NO; then
    print_status "All tests passed"
else
    print_error "Tests failed"
    exit 1
fi

echo ""
print_status "🎉 All CI checks passed! Ready for GitHub Actions."

echo ""
echo "Next steps:"
echo "1. Commit your changes"
echo "2. Push to GitHub"
echo "3. Create a pull request"
echo "4. Watch the CI run automatically!" 