#!/bin/bash
# Python: full project lint.
ruff check . 2>&1
exit $?
