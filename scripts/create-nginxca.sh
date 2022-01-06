#!/bin/sh
# 创建 Nginx 证书

./scripts/create-rootca.sh

./scripts/create-domainca.sh -d nginx/certs
