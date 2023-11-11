#!/bin/bash

export VERSION=0.7
echo $VERSION

git tag ${VERSION}
git push -f --tags
docker buildx build --no-cache --push -t mangomm/merge-jwks:${VERSION} --platform=linux/amd64 --build-arg version=${VERSION} .
docker scout cves local://mangomm/merge-jwks:${VERSION}
