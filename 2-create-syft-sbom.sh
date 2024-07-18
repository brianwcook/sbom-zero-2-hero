#!/bin/bash
syft --from registry scan quay.io/bcook/nubi:latest --output spdx-json=2.json

