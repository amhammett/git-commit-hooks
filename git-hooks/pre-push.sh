#!/bin/bash

echo 'pre-push testing (blocking)'

make test
rc=$?

[ "${rc}" -eq "0" ] || echo "pre-push testing failed ($?)"

exit $rc
