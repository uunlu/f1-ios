# GitHub Actions CI/CD for F1App

This repository includes automated CI/CD workflows for building and testing the F1App iOS application.

## Workflows

### 🔄 iOS CI/CD (`ios-ci.yml`)

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests targeting `main`

**Jobs:**

1. **Build & Test**
   - Runs on macOS 14 with Xcode 16.1
   - Installs SwiftLint and runs code analysis
   - Builds the app for iOS Simulator
   - Runs all unit tests with iPhone 16 Pro simulator
   - Uploads test results as artifacts

2. **Security & Code Quality**
   - Scans for hardcoded secrets in Swift files
   - Ensures no sensitive data is committed

3. **Archive** (main branch only)
   - Creates an app archive for distribution
   - Uploads archive as artifact

### 🚀 Release (`release.yml`)

**Triggers:**
- Push of tags matching `v*` (e.g., `v1.0.0`)

**Actions:**
- Runs full test suite
- Creates GitHub release
- Uploads app archive to release

## Usage

### Running CI on Pull Requests

1. Create a feature branch
2. Make your changes
3. Open a pull request to `main`
4. CI will automatically run and show results

### Creating a Release

1. Tag your commit:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. GitHub Actions will:
   - Run tests
   - Create a release
   - Upload the app archive

## Free Tier Limits

GitHub Actions free tier includes:
- **Public repos**: Unlimited minutes
- **Private repos**: 2,000 minutes/month

macOS runners use a 10x multiplier, so you get ~200 minutes of actual macOS build time for private repos.

## Local Development

To run the same checks locally:

```bash
# Install SwiftLint
brew install swiftlint

# Run linting
swiftlint lint

# Build the app
xcodebuild build -project F1App.xcodeproj -scheme F1App -destination 'platform=iOS Simulator,name=iPhone 16 Pro'

# Run tests
xcodebuild test -project F1App.xcodeproj -scheme F1App -destination 'platform=iOS Simulator,name=iPhone 16 Pro' -parallel-testing-enabled NO
```

## Customization

### Changing iOS Simulator

Update the `-destination` parameter in workflows:
```yaml
-destination 'platform=iOS Simulator,name=iPhone 14,OS=16.0'
```

### Adding Code Coverage

Add to the test step:
```yaml
-enableCodeCoverage YES
```

### Slack Notifications

Add this step to get notified:
```yaml
- name: Slack Notification
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    channel: '#ios-builds'
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
``` 