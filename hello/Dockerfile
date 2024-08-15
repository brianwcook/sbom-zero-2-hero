FROM quay.io/bcook/nubi:latest as builder
# install go
RUN dnf -y install golang

COPY hello.go .
COPY go.mod .

# build
RUN go build
RUN pwd

# copy binary to clean image
FROM quay.io/bcook/nubi:latest
COPY --from=builder /hello /usr/bin/hello
