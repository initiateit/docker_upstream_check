#!/bin/sh

# Simple bash script to check upstream docker repos for any updates and compare to a user created repo.
# If versions are different then a git add will be pushed to a github repo.
# Using Github Actions you can have your docker image rebuilt whenever upstream chages are detected.

GIT_REPO=''
GITHUB_TOKEN='~/docker/gh_token'
REPO_DIR='~/docker/repos/'
UP=''
DOWN=''
mdy=$(date +'%A, %d %B %Y')

#Create a function to grab version information
repo_check(){

repo=${1}
tag=${2:-latest}

token=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${repo}:pull" \
| jq -r '.token')
digest=$(curl -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
-H "Authorization: Bearer $token" \
-s "https://registry-1.docker.io/v2/${repo}/manifests/${tag}" | jq -r .config.digest)

curl -s -L -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
-H "Authorization: Bearer $token" "https://registry-1.docker.io/v2/${repo}/blobs/${digest}" \
| jq -r '.config.Labels."org.opencontainers.image.version"' \
| sed 's/^.//'
}

# call the function
up_ver=$(repo_check {$UP})
down_ver=$(repo_check {$DOWN})

# check authenticate with github
# no need to logout of any sessions / cached credentials gh auth with token will take precedence

gh auth login --with-token < {$GITHUB_TOKEN}

# compare versions using dpkg and push to github

if $(dpkg --compare-versions $up_ver "eq" $down_ver);

then echo 'Versions equal, no update needed';
else echo 'versions different, updating github repo'

        echo $mdy >> update_log;
        echo "Adding and commiting files"
        message="Upstream update detected, auto-commit from $USER@$(hostname -s) on $(date)"

        cd ${REPO_DIR}
        ${GIT} add update_log .
        ${GIT} commit -m "$message"

        gitPush=$(${GIT} push -vvv {$GIT_REPO} master 2>&1)
        echo "$gitPush"
fi
