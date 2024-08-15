#!/bin/bash
syft --from registry scan quay.io/bcook/nubi:latest --output spdx-json | jq . > 3-prefetch-sbom.json

