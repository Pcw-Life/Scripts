#!/bin/bash

# Set the base directory where all repositories are stored
BASE_DIR="/Users/pcwsecurity/Library/github"

# Loop through each directory in the base directory
for dir in "$BASE_DIR"/*; do
    if [ -d "$dir/.git" ]; then
        echo "Processing repository in $dir"
        cd "$dir"
        
        # Rebase onto the remote branch before force pushing
        git fetch origin
        git rebase origin/$(git rev-parse --abbrev-ref HEAD)

        # Stage all changes
        git add -A
        
        # Commit all changes with a generic message
        git commit -m "Bulk commit of all changes"
        
        # Force push to the remote repository on the current branch
        git push origin $(git rev-parse --abbrev-ref HEAD) --force
        
        echo "Rebased and force pushed $dir"
    else
        echo "$dir is not a Git repository, skipping."
    fi
done

echo "All repositories processed."