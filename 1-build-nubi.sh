#!/bin/bash
output=$(podman build -t quay.io/bcook/nubi:latest ./nubi | tee /dev/tty )
podman push quay.io/bcook/nubi:latest
digest=$(echo $output | tail -n -1)
