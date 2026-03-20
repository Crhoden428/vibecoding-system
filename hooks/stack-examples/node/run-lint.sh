#!/bin/bash
# Node/JS/TS: full project lint.
npx eslint . 2>&1
exit $?
