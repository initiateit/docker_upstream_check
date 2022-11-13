#!/bin/sh

#add your repos here, make sure to use format ie 'library/caddy' for upstream
up_repo=''
down_repo=''

#date generation
mdy=$(date +'%A, %d %B %Y')

#repo definitions

up_tag=${2:-latest}
up_token=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${up_repo}:pull" \
        | jq -r '.token')
up_digest=$(curl -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
              -H "Authorization: Bearer $up_token" \
              -s "https://registry-1.docker.io/v2/${up_repo}/manifests/${up_tag}" | jq -r .config.digest)

up_ver=$(curl -s -L -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
        -H "Authorization: Bearer $up_token" "https://registry-1.docker.io/v2/${up_repo}/blobs/${up_digest}" \
        | jq -r '.config.Labels."org.opencontainers.image.version"' \
        | sed 's/^.//')

down_tag=${2:-latest}
down_token=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${down_repo}:pull" \
        | jq -r '.token')
        down_digest=$(curl -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
              -H "Authorization: Bearer $down_token" \
              -s "https://registry-1.docker.io/v2/${down_repo}/manifests/${down_tag}" | jq -r .config.digest)

down_ver=$(curl -s -L -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
        -H "Authorization: Bearer $down_token" "https://registry-1.docker.io/v2/${down_repo}/blobs/${down_digest}" \
        | jq -r '.config.Labels."org.opencontainers.image.version"' \
        | sed 's/^.//')

echo 'upstream version is:' $up_ver
echo 'downstream version is:' $down_ver
# compare versions using dpkg

    if $(dpkg --compare-versions $up_ver "eq" $down_ver);
      then echo 'Versions equal, no update needed';
      else echo 'versions different, updating github repo'
          echo $mdy;

    fi
