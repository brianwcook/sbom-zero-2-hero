#!/bin/bash -v
python3 spdx-cancel.py  5-sbom.json 7-sbom.json  | jq .
