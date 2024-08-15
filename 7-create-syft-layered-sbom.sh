#!/bin/bash
syft --from registry scan quay.io/bcook/hello-go:latest --output spdx-json | jq . > 7-sbom.json

