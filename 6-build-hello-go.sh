cd hello
podman build -t quay.io/bcook/hello-go:latest .
podman push quay.io/bcook/hello-go:latest
cd ..
