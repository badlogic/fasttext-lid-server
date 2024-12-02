#!/bin/sh
set -e

version=1.0.2
platforms="linux/amd64,linux/arm64"

if [ -n "$(git status --porcelain)" ]; then
    echo "Uncommitted changes exist"
    exit 1
fi

if git rev-parse "v${version}" >/dev/null 2>&1; then
    echo "Tag v${version} already exists"
    exit 1
fi

# Set up buildx builder
docker buildx create --use --name multi-arch-builder --platform ${platforms}

# Build and push multi-arch images
docker buildx build --platform ${platforms} \
    --tag mariozechner/fasttext-lid-server:latest \
    --tag mariozechner/fasttext-lid-server:${version} \
    --push .

git tag "v${version}"
git push origin "v${version}"