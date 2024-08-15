#!/bin/bash
syft --from registry scan quay.io/bcook/nubi:latest --output spdx-json | jq . > 5-sbom.json

