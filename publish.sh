#!/bin/sh
set -e

version=1.0.0

if git rev-parse "v${version}" >/dev/null 2>&1; then
    echo "Tag v${version} already exists"
    exit 1
fi

docker build --no-cache -t fasttext-lid-server .

git tag "v${version}"
git push origin "v${version}"

docker tag fasttext-lid-server mariozechner/fasttext-lid-server:latest
docker push mariozechner/fasttext-lid-server:latest
docker tag fasttext-lid-server mariozechner/fasttext-lid-server:${version}
docker push mariozechner/fasttext-lid-server:${version}