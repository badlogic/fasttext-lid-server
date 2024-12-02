#!/bin/sh
set -e

version=1.0.3
image_name="mariozechner/fasttext-lid-server"

# Check git status
if [ -n "$(git status --porcelain)" ]; then
    echo "Uncommitted changes exist"
    exit 1
fi

if git rev-parse "v${version}" >/dev/null 2>&1; then
    echo "Tag v${version} already exists"
    exit 1
fi

# Build AMD64
docker build --platform linux/amd64 -t ${image_name}:${version}-amd64 .
docker push ${image_name}:${version}-amd64

# Build ARM64
docker build --platform linux/arm64 -t ${image_name}:${version}-arm64 .
docker push ${image_name}:${version}-arm64

# Create and push manifest
docker manifest create ${image_name}:${version} \
    ${image_name}:${version}-amd64 \
    ${image_name}:${version}-arm64

docker manifest create ${image_name}:latest \
    ${image_name}:${version}-amd64 \
    ${image_name}:${version}-arm64

docker manifest push ${image_name}:${version}
docker manifest push ${image_name}:latest

# Tag git release
git tag "v${version}"
git push origin "v${version}"