#!/bin/bash
s3cmd sync --recursive -P ./_site/ s3://blog.mihaya.com.0
