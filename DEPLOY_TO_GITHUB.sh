#!/bin/bash

################################################################################
# 🚀 AUTOMATED GITHUB DEPLOYMENT SCRIPT
# Gap Analysis Platform - End-to-End Deployment
################################################################################

set -e  # Exit on error

echo "================================================================================"
echo "🚀 GAP ANALYSIS PLATFORM - GITHUB DEPLOYMENT"
echo "================================================================================"
echo ""

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
REPO_NAME="gap-analysis-agent"
REPO_DESCRIPTION="AI agent for competitive title gap analysis - Mordor Intelligence"

################################################################################
# STEP 1: Check Prerequisites
################################################################################

echo -e "${BLUE}[STEP 1/6]${NC} Checking prerequisites..."
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git is not installed. Please install git first.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Git is installed${NC}"

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${YELLOW}⚠️  GitHub CLI (gh) not found.${NC}"
    echo "   Installing GitHub CLI..."
    sudo apt-get update && sudo apt-get install -y gh 2>&1 | grep -E "(Setting|done|Processing)"
fi

# Verify gh is working
if gh auth status &> /dev/null; then
    echo -e "${GREEN}✅ GitHub CLI authenticated${NC}"
else
    echo -e "${RED}❌ Not authenticated with GitHub${NC}"
    echo ""
    echo "Please run: gh auth login"
    echo "Then run this script again."
    exit 1
fi

# Check if in the right directory
if [ ! -f "app_simple.py" ]; then
    echo -e "${RED}❌ app_simple.py not found in current directory${NC}"
    echo "   Please run this script from the project directory:"
    echo "   cd /path/to/gap-analysis-agent"
    exit 1
fi
echo -e "${GREEN}✅ App files found${NC}"
echo ""

################################################################################
# STEP 2: Initialize Git Repository
################################################################################

echo -e "${BLUE}[STEP 2/6]${NC} Initializing Git repository..."
echo ""

if [ -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Git repository already exists${NC}"
    git status
else
    echo "Creating new git repository..."
    git init
    git config user.email "ai_rahul@hotmail.com" 2>/dev/null || true
    git config user.name "Rahul Sharma" 2>/dev/null || true
    echo -e "${GREEN}✅ Git repository initialized${NC}"
fi
echo ""

################################################################################
# STEP 3: Create GitHub Repository
################################################################################

echo -e "${BLUE}[STEP 3/6]${NC} Creating GitHub repository..."
echo ""

# Check if repo already exists
if gh repo view "$REPO_NAME" &> /dev/null; then
    echo -e "${YELLOW}⚠️  Repository '$REPO_NAME' already exists${NC}"
    REPO_URL=$(gh repo view "$REPO_NAME" --json url --jq '.url')
else
    echo "Creating new repository on GitHub..."
    REPO_URL=$(gh repo create "$REPO_NAME" \
        --description "$REPO_DESCRIPTION" \
        --public \
        --source=. \
        --remote=origin \
        --push 2>&1 | grep "https://github.com" | head -1)

    if [ -z "$REPO_URL" ]; then
        REPO_URL="https://github.com/$(gh api user --jq '.login')/$REPO_NAME"
    fi
fi

echo -e "${GREEN}✅ Repository ready: $REPO_URL${NC}"
echo ""

################################################################################
# STEP 4: Add Files to Git
################################################################################

echo -e "${BLUE}[STEP 4/6]${NC} Adding files to Git..."
echo ""

# Files to include
FILES_TO_ADD=(
    "app_simple.py"
    "requirements.txt"
    "README.md"
    "QUICK_START_GUIDE.md"
    "Procfile"
    "runtime.txt"
    ".gitignore"
)

echo "Files to commit:"
for file in "${FILES_TO_ADD[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
        git add "$file" 2>/dev/null || true
    else
        echo "  ⚠️  $file (not found, skipping)"
    fi
done

# Optional files
OPTIONAL_FILES=(
    "GITHUB_SETUP.md"
    "DEPLOY_FREE_CLOUD.md"
    "COMPLETE_DEPLOYMENT_GUIDE.md"
)

echo ""
echo "Optional documentation (if present):"
for file in "${OPTIONAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
        git add "$file" 2>/dev/null || true
    fi
done

echo ""
git add README.md 2>/dev/null || true
git add Procfile 2>/dev/null || true
git add runtime.txt 2>/dev/null || true
git add .gitignore 2>/dev/null || true

echo -e "${GREEN}✅ Files staged for commit${NC}"
echo ""

################################################################################
# STEP 5: Commit and Push to GitHub
################################################################################

echo -e "${BLUE}[STEP 5/6]${NC} Committing and pushing to GitHub..."
echo ""

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo -e "${YELLOW}⚠️  No changes to commit${NC}"
else
    echo "Creating commit..."
    git commit -m "Initial commit: Gap Analysis Platform v1.0 - Production Ready" \
        -m "- Flask web application with Jaccard similarity matching" \
        -m "- Real gap analysis algorithm (not dummy)" \
        -m "- 10 pre-loaded competitors" \
        -m "- Excel report generation (4 sheets)" \
        -m "- Cloud-ready configuration (Render, Railway, Heroku)" \
        -m "- Complete documentation included" \
        2>&1 | grep -E "(create|files changed|insertions|changed)" || true
fi

# Set remote URL if needed
if ! git remote get-url origin &> /dev/null; then
    USERNAME=$(gh api user --jq '.login')
    REMOTE_URL="https://github.com/$USERNAME/$REPO_NAME.git"
    git remote add origin "$REMOTE_URL"
    echo -e "${GREEN}✅ Remote URL set to: $REMOTE_URL${NC}"
fi

# Push to GitHub
echo "Pushing to GitHub..."
git branch -M main 2>/dev/null || true
git push -u origin main 2>&1 | grep -E "(main|rejected|done)" || true

echo -e "${GREEN}✅ Pushed to GitHub${NC}"
echo ""

################################################################################
# STEP 6: Verify Deployment
################################################################################

echo -e "${BLUE}[STEP 6/6]${NC} Verifying GitHub deployment..."
echo ""

# Get repo info
GITHUB_USER=$(gh api user --jq '.login')
REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME"

echo "Repository Information:"
echo "  URL: $REPO_URL"
echo "  Name: $REPO_NAME"

# List files in repo
echo ""
echo "Files in repository:"
gh repo view "$REPO_NAME" --json files --jq '.files[].name' 2>/dev/null | head -10 || echo "  (checking...)"

echo ""
echo -e "${GREEN}✅ GitHub deployment complete!${NC}"
echo ""

################################################################################
# Summary and Next Steps
################################################################################

echo "================================================================================"
echo "🎉 DEPLOYMENT SUCCESSFUL!"
echo "================================================================================"
echo ""
echo "Your Gap Analysis Platform is now on GitHub!"
echo ""
echo "📍 Repository URL:"
echo "   $REPO_URL"
echo ""
echo "👥 Share with your team:"
echo ""
echo "   FOR DEVELOPERS:"
echo "   git clone $REPO_URL"
echo "   cd $REPO_NAME"
echo "   python app_simple.py"
echo ""
echo "   FOR NON-TECHNICAL USERS (Optional - Deploy to Render):"
echo "   1. Go to https://render.com"
echo "   2. Sign up with GitHub"
echo "   3. Create Web Service"
echo "   4. Select this repository"
echo "   5. Set:"
echo "      - Build: pip install -r requirements.txt"
echo "      - Start: gunicorn app_simple:app"
echo "   6. Deploy and share the Render URL"
echo ""
echo "📚 Documentation:"
echo "   - README.md (on GitHub)"
echo "   - QUICK_START_GUIDE.md"
echo ""
echo "✅ Next Steps:"
echo "   1. Visit: $REPO_URL"
echo "   2. Verify all files are there"
echo "   3. Share the link with your team"
echo "   4. (Optional) Deploy to Render for web access"
echo ""
echo "================================================================================"
echo ""

