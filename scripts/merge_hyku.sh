#!/bin/bash
# merge_hyku.sh - Script to merge Samvera Hyku codebase into ENACT Hyku

set -e

echo "========================================="
echo "ENACT Hyku - Merge Samvera Hyku Script"
echo "========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    echo "Please run this script from the root of the enact-hyku repository"
    exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}Warning: You have uncommitted changes${NC}"
    echo "Please commit or stash your changes before merging Hyku"
    echo ""
    echo "To stash your changes:"
    echo "  git stash"
    echo ""
    echo "To commit your changes:"
    echo "  git add ."
    echo "  git commit -m 'Your commit message'"
    exit 1
fi

echo "Step 1: Adding Hyku remote repository..."
if git remote | grep -q "^hyku$"; then
    echo "Hyku remote already exists"
else
    git remote add hyku https://github.com/samvera/hyku.git
    echo -e "${GREEN}Hyku remote added${NC}"
fi

echo ""
echo "Step 2: Fetching Hyku codebase..."
git fetch hyku

echo ""
echo "Step 3: Creating backup branch..."
BACKUP_BRANCH="enact-backup-$(date +%Y%m%d-%H%M%S)"
git branch $BACKUP_BRANCH
echo -e "${GREEN}Backup created: $BACKUP_BRANCH${NC}"

echo ""
echo "Step 4: Merging Hyku main branch..."
echo -e "${YELLOW}Note: Merge conflicts are expected and normal${NC}"
echo ""

# Attempt merge with allow-unrelated-histories
if git merge hyku/main --allow-unrelated-histories --no-edit -m "Merge Samvera Hyku codebase for ENACT customization"; then
    echo -e "${GREEN}Merge completed successfully!${NC}"
else
    echo -e "${YELLOW}Merge has conflicts (this is expected)${NC}"
    echo ""
    echo "Step 5: Resolving conflicts..."
    echo "Keeping ENACT documentation and taking Hyku application code..."

    # Keep our files
    if [ -f README.md ]; then
        git checkout --ours README.md
        git add README.md
    fi

    if [ -d docs ]; then
        git checkout --ours docs/
        git add docs/
    fi

    if [ -f LICENSE ]; then
        git checkout --ours LICENSE
        git add LICENSE
    fi

    if [ -f HEROKU_DEPLOYMENT.md ]; then
        git checkout --ours HEROKU_DEPLOYMENT.md
        git add HEROKU_DEPLOYMENT.md
    fi

    if [ -f Procfile ]; then
        git checkout --ours Procfile
        git add Procfile
    fi

    if [ -f app.json ]; then
        git checkout --ours app.json
        git add app.json
    fi

    if [ -f .env.heroku.sample ]; then
        git checkout --ours .env.heroku.sample
        git add .env.heroku.sample
    fi

    # Check if there are still conflicts
    if git status | grep -q "Unmerged paths"; then
        echo -e "${YELLOW}Manual conflict resolution required${NC}"
        echo ""
        echo "Files with conflicts:"
        git status --short | grep "^UU"
        echo ""
        echo "Please resolve conflicts manually:"
        echo "  1. Edit conflicted files"
        echo "  2. git add <resolved-files>"
        echo "  3. git commit"
        echo ""
        echo "To abort the merge:"
        echo "  git merge --abort"
        echo "  git checkout $BACKUP_BRANCH"
        exit 1
    fi

    # Complete the merge
    git commit --no-edit
    echo -e "${GREEN}Conflicts resolved and merge completed!${NC}"
fi

echo ""
echo "========================================="
echo -e "${GREEN}Merge completed successfully!${NC}"
echo "========================================="
echo ""
echo "Next steps:"
echo "  1. Review the merged code:"
echo "     git log --oneline -10"
echo "     git diff $BACKUP_BRANCH"
echo ""
echo "  2. Test the application locally:"
echo "     docker compose build"
echo "     docker compose up"
echo ""
echo "  3. Push to GitHub:"
echo "     git push origin main"
echo ""
echo "  4. Configure Heroku deployment (see HEROKU_DEPLOYMENT.md)"
echo ""
echo "If something went wrong, restore backup:"
echo "  git reset --hard $BACKUP_BRANCH"
echo ""
