#!/bin/bash

echo 'pre-commit testing (warning)'

make test
rc=$?

[ "${rc}" -eq "0" ] || echo "pre-commit testing failed ($?)"
