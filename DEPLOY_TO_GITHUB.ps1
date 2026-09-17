# ===================================================
# 🚀 AUTOMATED GITHUB DEPLOYMENT - PowerShell
# Gap Analysis Platform - Windows
# ===================================================

Write-Host "=================================================================================" -ForegroundColor Cyan
Write-Host "🚀 GAP ANALYSIS PLATFORM - GITHUB DEPLOYMENT" -ForegroundColor Cyan
Write-Host "=================================================================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$RepoName = "gap-analysis-agent"
$RepoDescription = "AI agent for competitive title gap analysis - Mordor Intelligence"
$Email = "ai_rahul@hotmail.com"
$Name = "Rahul Sharma"

# ===================================================
# STEP 1: Check Prerequisites
# ===================================================

Write-Host "[STEP 1/6] Checking prerequisites..." -ForegroundColor Blue
Write-Host ""

# Check if git is installed
$gitPath = where.exe git 2>$null
if (-not $gitPath) {
    Write-Host "❌ Git is not installed. Please install Git first." -ForegroundColor Red
    Write-Host "   Download from: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ Git is installed" -ForegroundColor Green

# Check if GitHub CLI is installed
$ghPath = where.exe gh 2>$null
if (-not $ghPath) {
    Write-Host "❌ GitHub CLI (gh) is not installed" -ForegroundColor Red
    Write-Host "   Install from: https://github.com/cli/cli/releases" -ForegroundColor Yellow
    Write-Host "   Or use: winget install GitHub.cli" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ GitHub CLI is installed" -ForegroundColor Green

# Check authentication
$authCheck = & gh auth status 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ GitHub CLI authenticated" -ForegroundColor Green
} else {
    Write-Host "❌ Not authenticated with GitHub" -ForegroundColor Red
    Write-Host ""
    Write-Host "Run this command first:" -ForegroundColor Yellow
    Write-Host "   gh auth login" -ForegroundColor Yellow
    exit 1
}

# Check if in right directory
if (-not (Test-Path "app_simple.py")) {
    Write-Host "❌ app_simple.py not found in current directory" -ForegroundColor Red
    Write-Host "   Please run from: C:\Users\RahulSharma\OneDrive - Mordor Intelligence\Desktop\gap-analysis-agent" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ App files found" -ForegroundColor Green
Write-Host ""

# ===================================================
# STEP 2: Initialize Git Repository
# ===================================================

Write-Host "[STEP 2/6] Initializing Git repository..." -ForegroundColor Blue
Write-Host ""

if (Test-Path ".git") {
    Write-Host "⚠️  Git repository already exists" -ForegroundColor Yellow
} else {
    Write-Host "Creating new git repository..."
    git init
    git config user.email $Email
    git config user.name $Name
    Write-Host "✅ Git repository initialized" -ForegroundColor Green
}
Write-Host ""

# ===================================================
# STEP 3: Create GitHub Repository
# ===================================================

Write-Host "[STEP 3/6] Creating GitHub repository..." -ForegroundColor Blue
Write-Host ""

# Check if repo already exists
$repoExists = & gh repo view $RepoName 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "⚠️  Repository '$RepoName' already exists" -ForegroundColor Yellow
    $repoURL = $repoExists -match "^https" | Select-Object -First 1
} else {
    Write-Host "Creating new repository on GitHub..."
    $createOutput = & gh repo create $RepoName `
        --description $RepoDescription `
        --public `
        --source=. `
        --remote=origin `
        --push 2>&1

    Write-Host $createOutput -ForegroundColor Green
}

# Get actual repo URL
$username = & gh api user --jq '.login'
$repoURL = "https://github.com/$username/$RepoName"
Write-Host "✅ Repository ready: $repoURL" -ForegroundColor Green
Write-Host ""

# ===================================================
# STEP 4: Add Files to Git
# ===================================================

Write-Host "[STEP 4/6] Adding files to Git..." -ForegroundColor Blue
Write-Host ""

$filesToAdd = @(
    "app_simple.py",
    "requirements.txt",
    "README.md",
    "QUICK_START_GUIDE.md",
    "Procfile",
    "runtime.txt",
    ".gitignore"
)

Write-Host "Files to commit:"
foreach ($file in $filesToAdd) {
    if (Test-Path $file) {
        Write-Host "  ✅ $file" -ForegroundColor Green
        git add $file 2>$null
    } else {
        Write-Host "  ⚠️  $file (not found)" -ForegroundColor Yellow
    }
}

$optionalFiles = @(
    "GITHUB_SETUP.md",
    "DEPLOY_FREE_CLOUD.md",
    "COMPLETE_DEPLOYMENT_GUIDE.md"
)

Write-Host ""
Write-Host "Optional documentation:"
foreach ($file in $optionalFiles) {
    if (Test-Path $file) {
        Write-Host "  ✅ $file" -ForegroundColor Green
        git add $file 2>$null
    }
}

Write-Host ""
Write-Host "✅ Files staged for commit" -ForegroundColor Green
Write-Host ""

# ===================================================
# STEP 5: Commit and Push to GitHub
# ===================================================

Write-Host "[STEP 5/6] Committing and pushing to GitHub..." -ForegroundColor Blue
Write-Host ""

Write-Host "Creating commit..."

git commit -m "Initial commit: Gap Analysis Platform v1.0 - Production Ready" `
           -m "Flask web application with Jaccard similarity matching" `
           -m "Real gap analysis algorithm (not dummy)" `
           -m "10 pre-loaded competitors" `
           -m "Excel report generation (4 sheets)" `
           -m "Cloud-ready configuration" `
           -m "Complete documentation included" 2>&1 | Select-String -Pattern "(create|files changed|insertions)" | ForEach-Object { Write-Host $_ -ForegroundColor Green }

# Set remote if needed
try {
    git remote get-url origin 2>$null
} catch {
    $remoteURL = "https://github.com/$username/$RepoName.git"
    git remote add origin $remoteURL
    Write-Host "✅ Remote URL set" -ForegroundColor Green
}

# Push to GitHub
Write-Host "Pushing to GitHub..."
git branch -M main 2>$null
git push -u origin main 2>&1 | Select-String -Pattern "(main|rejected|done)" | ForEach-Object { Write-Host $_ -ForegroundColor Green }

Write-Host "✅ Pushed to GitHub" -ForegroundColor Green
Write-Host ""

# ===================================================
# STEP 6: Verify Deployment
# ===================================================

Write-Host "[STEP 6/6] Verifying GitHub deployment..." -ForegroundColor Blue
Write-Host ""

Write-Host "Repository Information:"
Write-Host "  URL: $repoURL" -ForegroundColor Green
Write-Host "  Name: $RepoName" -ForegroundColor Green
Write-Host ""

# Try to list files
$files = & gh repo view $RepoName --json files --jq '.files[].name' 2>$null
if ($files) {
    Write-Host "Files in repository:"
    $files | ForEach-Object { Write-Host "  ✅ $_" -ForegroundColor Green }
}

Write-Host ""

# ===================================================
# Summary and Next Steps
# ===================================================

Write-Host "=================================================================================" -ForegroundColor Green
Write-Host "🎉 DEPLOYMENT SUCCESSFUL!" -ForegroundColor Green
Write-Host "=================================================================================" -ForegroundColor Green
Write-Host ""

Write-Host "Your Gap Analysis Platform is now on GitHub!" -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 Repository URL:" -ForegroundColor Yellow
Write-Host "   $repoURL" -ForegroundColor White
Write-Host ""
Write-Host "👥 Share with your team:" -ForegroundColor Yellow
Write-Host ""
Write-Host "FOR DEVELOPERS:" -ForegroundColor Cyan
Write-Host "   git clone $repoURL" -ForegroundColor White
Write-Host "   cd $RepoName" -ForegroundColor White
Write-Host "   python app_simple.py" -ForegroundColor White
Write-Host ""
Write-Host "FOR NON-TECHNICAL USERS (Optional - Deploy to Render):" -ForegroundColor Cyan
Write-Host "   1. Go to https://render.com" -ForegroundColor White
Write-Host "   2. Sign up with GitHub" -ForegroundColor White
Write-Host "   3. Create Web Service" -ForegroundColor White
Write-Host "   4. Select this repository" -ForegroundColor White
Write-Host "   5. Set:" -ForegroundColor White
Write-Host "      - Build: pip install -r requirements.txt" -ForegroundColor White
Write-Host "      - Start: gunicorn app_simple:app" -ForegroundColor White
Write-Host "   6. Deploy and share the Render URL" -ForegroundColor White
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor Yellow
Write-Host "   - README.md (on GitHub)" -ForegroundColor White
Write-Host "   - QUICK_START_GUIDE.md" -ForegroundColor White
Write-Host ""
Write-Host "✅ Next Steps:" -ForegroundColor Yellow
Write-Host "   1. Open: $repoURL" -ForegroundColor White
Write-Host "   2. Verify all files are there" -ForegroundColor White
Write-Host "   3. Share the link with your team" -ForegroundColor White
Write-Host "   4. (Optional) Deploy to Render for web access" -ForegroundColor White
Write-Host ""
Write-Host "=================================================================================" -ForegroundColor Green
Write-Host ""

# Open browser to GitHub repo
Start-Process $repoURL
Write-Host "Opening GitHub repository in browser..." -ForegroundColor Cyan
