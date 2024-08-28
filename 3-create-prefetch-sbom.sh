#!/bin/bash
syft scan nubi/cachi2-output/deps --output spdx-json | jq . > 3-prefetch-sbom.json

