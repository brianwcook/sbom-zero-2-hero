

sed -i -E 's/"referenceLocator":.*"?.*"/"referenceLocator": "cpe:\/o:redhat:enterprise_linux:9::baseos"/g' $SBOM_FILE
