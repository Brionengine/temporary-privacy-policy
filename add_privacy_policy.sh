#!/bin/bash

# Step 1: Check if you're in the correct directory
if [ ! -d ".git" ]; then
  echo "Git is not initialized in this directory. Initializing now..."
  git init || { echo "Failed to initialize Git. Exiting."; exit 1; }
fi

# Step 2: Check for existing remote
REMOTE_URL=$(git remote get-url origin 2>/dev/null)
if [ $? -ne 0 ]; then
  echo "No remote origin found. Please add the correct remote URL:"
  read -p "Enter the GitHub remote URL (e.g., https://github.com/your-user/your-repo.git): " REMOTE_URL
  git remote add origin "$REMOTE_URL" || { echo "Failed to add remote. Exiting."; exit 1; }
fi

# Step 3: Check if privacy_policy.html exists in the root directory
if [ ! -f "privacy_policy.html" ]; then
  echo "privacy_policy.html file not found in the root directory."
  echo "Please place the privacy_policy.html file in the repository's root folder and run this script again."
  exit 1
fi

# Step 4: Stage the privacy_policy.html file
echo "Staging privacy_policy.html file..."
git add privacy_policy.html || { echo "Failed to stage privacy_policy.html. Exiting."; exit 1; }

# Step 5: Commit the file (check if there are any commits)
if git rev-parse --verify HEAD >/dev/null 2>&1; then
  echo "Committing the privacy_policy.html file..."
  git commit -m "Add privacy policy HTML file" || { echo "Commit failed. Exiting."; exit 1; }
else
  echo "Creating the first commit and adding privacy policy HTML file..."
  git commit -m "Initial commit with privacy policy" || { echo "Initial commit failed. Exiting."; exit 1; }
fi

# Step 6: Check if the branch is 'main' and push
BRANCH=$(git branch --show-current)
if [ "$BRANCH" != "main" ]; then
  echo "Renaming branch to 'main'..."
  git branch -m main || { echo "Failed to rename branch. Exiting."; exit 1; }
fi

echo "Pushing the changes to GitHub..."
git push -u origin main || { echo "Failed to push to GitHub. Please check your remote URL and credentials."; exit 1; }

echo "The privacy_policy.html file has been successfully added and pushed to GitHub!"
