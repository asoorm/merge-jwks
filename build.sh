#!/bin/bash

export VERSION=0.7
echo $VERSION

git tag ${VERSION}
git push -f --tags
docker build --no-cache -t mangomm/merge-jwks:${VERSION} --build-arg version=${VERSION} .
docker push mangomm/merge-jwks:${VERSION}
