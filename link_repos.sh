#!/bin/bash

# Set your GitHub username
GITHUB_USERNAME="your_username"

# 1Password details for retrieving GitHub PAT
VAULT_NAME="your_vault"
ITEM_NAME="your_item"
FIELD_NAME="your_field"

# Function to authenticate with GitHub using a token from 1Password
authenticate_with_1password() {
  echo "Authenticating with GitHub via 1Password..."

  # Check if 1Password CLI is logged in
  if ! op account list &>/dev/null; then
    echo "1Password CLI is not logged in. Please log in using 'op signin'."
    op signin
    if [ $? -ne 0 ]; then
      echo "1Password login failed. Exiting."
      exit 1
    fi
  fi

  # Retrieve GitHub PAT from 1Password
  GH_TOKEN=$(op item get "$ITEM_NAME" --vault "$VAULT_NAME" --field "$FIELD_NAME")

  if [ -z "$GH_TOKEN" ]; then
    echo "GitHub token not found in 1Password. Please ensure it is stored in vault '$VAULT_NAME' under item '$ITEM_NAME' and field '$FIELD_NAME'."
    exit 1
  fi

  # Export the GitHub token as an environment variable
  export GH_TOKEN
  echo "GitHub authentication token retrieved and set for GitHub CLI."

  # Test GitHub authentication
  if ! gh auth status &>/dev/null; then
    echo "GitHub authentication failed. Please ensure the token in 1Password has correct permissions."
    echo "Would you like to log in to GitHub CLI manually instead? (y/n)"
    read -r retry_auth
    if [ "$retry_auth" = "y" ]; then
      # Temporarily unset GH_TOKEN to allow manual login
      unset GH_TOKEN
      gh auth login
      if [ $? -ne 0 ]; then
        echo "GitHub login failed. Exiting."
        exit 1
      fi
      # Re-set GH_TOKEN after manual login if needed for later parts of the script
      export GH_TOKEN=$(op item get "$ITEM_NAME" --vault "$VAULT_NAME" --field "$FIELD_NAME")
    else
      echo "Exiting due to authentication failure."
      exit 1
    fi
  else
    echo "GitHub authentication successful."
  fi
}

# Authenticate using 1Password before starting GitHub operations
authenticate_with_1password

# Function to create a new repository
create_repository() {
  local repo_name="$1"
  echo "Creating repository '$repo_name' on GitHub..."
  gh repo create "$GITHUB_USERNAME/$repo_name" --public --yes
  if [ $? -eq 0 ]; then
    echo "Repository '$repo_name' created successfully."
  else
    echo "Failed to create repository '$repo_name'."
  fi
}

# Function to list repositories and select one
select_existing_repository() {
  echo "Fetching existing repositories for $GITHUB_USERNAME..."
  repos=$(gh repo list "$GITHUB_USERNAME" --limit 100 --json name -q '.[].name')
  
  if [ -z "$repos" ]; then
    echo "No existing repositories found for user $GITHUB_USERNAME."
    return 1
  fi

  echo "Select an existing repository or choose to create a new one:"
  select repo in $repos "Create New Repository"; do
    if [ "$repo" == "Create New Repository" ]; then
      echo "Selected: Create New Repository"
      return 1
    elif [ -n "$repo" ]; then
      echo "Selected existing repository: $repo"
      echo "Setting remote URL to https://github.com/$GITHUB_USERNAME/$repo.git"
      git remote set-url origin "https://github.com/$GITHUB_USERNAME/$repo.git"
      return 0
    else
      echo "Invalid selection. Please try again."
    fi
  done
}

# Loop through each directory in the current folder
for dir in */; do
  if [ ! -d "$dir/.git" ]; then
    echo "$dir is not a Git repository."
    read -p "Would you like to initialize it as a Git repository and link to GitHub? (y/n): " init_repo
    if [[ "$init_repo" == "y" ]]; then
      cd "$dir"
      git init
      repo_name="${dir%/}"
      repo_name=${repo_name// /-}  # Replace spaces with hyphens for URL
      git_url="https://github.com/$GITHUB_USERNAME/$repo_name.git"
      
      # Check if the repository already exists on GitHub
      if ! gh repo view "$GITHUB_USERNAME/$repo_name" &>/dev/null; then
        echo "Remote repository for $repo_name not found on GitHub."
        echo "Options:"
        echo "1) Retry with a corrected URL"
        echo "2) Select an existing repository"
        echo "3) Create a new repository"

        read -p "Choose an option (1/2/3): " choice
        case $choice in
          1)  # Retry
            echo "Retrying with current URL setup..."
            git remote add origin "$git_url"
            ;;
          2)  # Select an existing repository
            if ! select_existing_repository; then
              echo "Repository selection failed. Skipping $dir."
              cd ..
              continue
            fi
            ;;
          3)  # Create a new repository
            create_repository "$repo_name"
            git remote add origin "$git_url"
            ;;
          *)  # Invalid choice
            echo "Invalid option selected. Skipping $dir."
            cd ..
            continue
            ;;
        esac
      else
        git remote add origin "$git_url"
      fi
      cd ..
    else
      echo "Skipping $dir."
      continue
    fi
  fi

  # Now process directories that are Git repositories
  cd "$dir"
  echo "Processing $dir"
  
  # Set up remote URL for existing Git repository
  repo_name="${dir%/}"
  repo_name=${repo_name// /-}  # Replace spaces with hyphens for URL
  git_url="https://github.com/$GITHUB_USERNAME/$repo_name.git"

  # Check if remote origin already exists and update if necessary
  if git remote | grep -q "origin"; then
    echo "Updating remote origin for $dir"
    git remote set-url origin "$git_url"
  else
    # Add remote repository
    git remote add origin "$git_url"
  fi

  # Verify if the repository exists
  if ! git ls-remote origin &>/dev/null; then
    echo "Remote repository for $repo_name not found on GitHub."
    echo "Options:"
    echo "1) Retry with a corrected URL"
    echo "2) Select an existing repository"
    echo "3) Create a new repository"

    read -p "Choose an option (1/2/3): " choice
    case $choice in
      1)  # Retry
        echo "Retrying with current URL setup..."
        ;;
      2)  # Select an existing repository
        if ! select_existing_repository; then
          echo "Repository selection failed. Skipping $dir."
          cd ..
          continue
        fi
        ;;
      3)  # Create a new repository
        create_repository "$repo_name"
        git remote set-url origin "$git_url"
        ;;
      *)  # Invalid choice
        echo "Invalid option selected. Skipping $dir."
        cd ..
        continue
        ;;
    esac
  fi

  # Fetch and check for branch
  if git fetch origin; then
    branch=$(git rev-parse --abbrev-ref HEAD)
    echo "Using branch '$branch' for $dir"

    # Attempt to merge remote changes
    if ! git merge origin/"$branch"; then
      echo "Merge conflict detected in $dir."
      echo "Please resolve conflicts manually now."
      git status
      echo "Resolve the conflicts, add the files with 'git add <file>', and commit with 'git commit'."
      read -p "Press Enter to continue after resolving conflicts..."
    fi
  else
    echo "Fetch failed for $dir. Skipping."
    cd ..
    continue
  fi

  # Push local changes to remote
  if ! git push -u origin "$branch"; then
    echo "Push failed for $dir. Attempting to rebase..."
    if ! git pull origin "$branch" --rebase; then
      echo "Rebase failed due to unresolved conflicts in $dir."
      echo "Please resolve the conflicts manually."
      git status
      echo "Resolve the conflicts, add them with 'git add <file>', then continue the rebase with 'git rebase --continue'."
      read -p "Press Enter to continue after resolving rebase conflicts..."
      git push -u origin "$branch"
    fi
  fi

  cd ..
done