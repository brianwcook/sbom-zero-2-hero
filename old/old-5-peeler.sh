#!/bin/bash

# export $IMAGE to $OCI-DIR
IMAGE=registry.access.redhat.com/ubi9/python-39
OUT=python-39-oci
podman pull $IMAGE
podman save -o $OUT  --format=oci-dir $IMAGE

# what is the hash of the manifest blob?
MANIFEST=cat "$IMAGE/index.json" | jq .manifests[0].digest | tr -d '"' | cut -d: -f2
echo "Manifest: blobs/sha256/$MANIFEST"

# how many layers are there?
NUMLAYERS=cat $IMAGE/blobs/sha256/$MANIFEST | jq ".layers | length"
echo "Layers: $NUMLAYERS"

# create bom
syft scan python-39-oci

# What is the digest of the last layer?
LAYER=cat "$IMAGE/blobs/sha256/$MANIFEST" | jq .layers[3].digest | tr -d '"'

# peel
python3 ../layeremove/layeremove.py "$LAYER"

# peel



