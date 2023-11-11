FROM golang:1.21-alpine3.18 as build

ARG version

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    mkdir -p /go/src/github.com/asoorm && \
    cd /go/src/github.com/asoorm && ls -al && \
    git clone https://github.com/asoorm/merge-jwks.git && \
    ls -al && \
    pwd && \
    cd merge-jwks && ls -al

RUN cd /go/src/github.com/asoorm/merge-jwks && \
    git checkout --force $version && \
    export GIT_COMMIT=$(git rev-list -1 HEAD) && \
    echo "commit: $GIT_COMMIT" && \
    export GIT_TAG=$(git tag) && \
    echo "tag: $GIT_TAG" && \
    go build -ldflags="-X 'main.GitCommit=${GIT_COMMIT}' -X 'main.GitTag=${GIT_TAG}' -s -w" -a .

FROM alpine:3.18
RUN apk --no-cache add ca-certificates && \
    adduser -D -g merge_jwks merge_jwks
USER merge_jwks
WORKDIR /opt/merge_jwks
COPY --from=build /go/src/github.com/asoorm/merge-jwks/merge-jwks /opt/merge_jwks/merge-jwks
COPY config.yaml /opt/merge-jwks/config.yaml
USER merge_jwks

EXPOSE 9000

CMD ["./merge-jwks"]
