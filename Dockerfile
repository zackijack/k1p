# Build stage
FROM golang:1.13-buster as build

LABEL app="k1p"
LABEL REPO="https://github.com/zackijack/k1p"

ADD . /code/k1p

WORKDIR /code/k1p

RUN make build

# Final stage
FROM zackijack/debugger:latest

LABEL maintainer="m.zackky@gmail.com"

ARG GIT_COMMIT
ARG VERSION

LABEL app="k1p"
LABEL REPO="https://github.com/zackijack/k1p"
LABEL GIT_COMMIT=$GIT_COMMIT
LABEL VERSION=$VERSION

ENV PATH=$PATH:/opt/k1p/bin

WORKDIR /opt/k1p/bin

COPY --from=build /code/k1p/bin/k1p /opt/k1p/bin

RUN chmod +x /opt/k1p/bin/k1p

# Create appuser
RUN adduser --disabled-password --gecos '' k1p
USER k1p

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/opt/k1p/bin/k1p"]
