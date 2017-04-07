#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

TARGET_BRANCH="gh-pages"
OUT_DIR="gh-pages"

git config --global user.name "Travis CI"
git config --global user.email "$COMMIT_AUTHOR_EMAIL"

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

# Clone the existing gh-pages for this repo into out/
# Create a new empty branch if gh-pages doesn't exist yet (should only happen on first deply)
git clone ${REPO} ${OUT_DIR}

##echo "going in"
cd ${OUT_DIR}
##pwd

git checkout ${TARGET_BRANCH} || git checkout --orphan ${TARGET_BRANCH}

##echo "ls after checkout"
##ls

# Clean out existing contents
# rm -rf ./${OUT_DIR}/**/* || exit 0
rm -rf *
rm -f ./.gitattributes
rm -f ./.gitignore
rm -rf ./.idea/*

##echo "ls after rm -rf"
##ls

##git status

cd ..

cp build/* ${OUT_DIR}/
cp id_rsa.enc ${OUT_DIR}/id_rsa.enc

cd ${OUT_DIR}

echo "ls after doCompile"
ls

if [ -z `git diff --exit-code` ]; then
    echo "No changes to the output on this push; exiting."
    exit 0
fi

# Commit the "changes", i.e. the new version.
# The delta will show diffs between new and old versions.
git add -A

echo "git status:"
git status

git commit -m "Deploy to GitHub Pages: ${SHA}"

# Get the deploy key by using Travis's stored variables to decrypt id_ra.enc
ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
openssl aes-256-cbc -K ${ENCRYPTED_KEY} -iv ${ENCRYPTED_IV} -in id_rsa.enc -out id_rsa -d
chmod 600 id_rsa
eval `ssh-agent -s`
ssh-add id_rsa

# Now that we're all set up, we can push.
git push ${SSH_REPO} ${TARGET_BRANCH}