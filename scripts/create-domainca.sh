
#!/bin/sh
# 创建域名证书

# 根证书存放目录
CERTS_ROOT_DIST="certs"
# 根证书名称
CERTS_ROOT_NAME="RootCA"

# 域名证书存放目录
CERTS_DOMAIN_DIST="certs"
# 域名证书名称
CERTS_DOMAIN_NAME="example.com"
# 重新生成域名证书
CERTS_DOMAIN_REFRESH="false"

# 读取参数
while getopts 'rd:n:' o; do
  case "${o}" in
    r)
      CERTS_DOMAIN_REFRESH="true"
      ;;
    d)
      CERTS_DOMAIN_DIST=${OPTARG}
      ;;
    d)
      CERTS_DOMAIN_NAME=${OPTARG}
      ;;
    ?)
      echo "用法: $(basename $0) [-r 重新生成域名证书] [-d 域名证书存放目录] [-n 证书域名]"
      echo ""
      echo "参数选项:"
      echo "  -r  重新生成域名证书, 可选"
      echo "  -d  域名证书存放目录, 可选, 默认值 'certs'"
      echo "  -n  证书域名, 可选, 默认值 'example.com'"
      echo ""
      exit 1
      ;;
  esac
done

# 根证书
CERTS_ROOT_PATH="$CERTS_ROOT_DIST/$CERTS_ROOT_NAME"
# 根证书 key
CERTS_ROOT_KEY="$CERTS_ROOT_PATH.key"
# 根证书 pem
CERTS_ROOT_PEM="$CERTS_ROOT_PATH.pem"

# 判断根证书是否已经存在
if [ ! -f "$CERTS_ROOT_PEM" ]; then
  echo '根证书不存在'
  exit 1;
fi

# 判断域名证书存放目录是否存在，如果不存在就创建
if [[ ! -d "$CERTS_DOMAIN_DIST" ]]; then
  mkdir -p "$CERTS_DOMAIN_DIST"
fi

# 域名证书
CERTS_DOMAIN_PATH="$CERTS_DOMAIN_DIST/$CERTS_DOMAIN_NAME"
# 域名证书 key
CERTS_DOMAIN_KEY="$CERTS_DOMAIN_PATH.key"
# 域名证书 csr
CERTS_DOMAIN_CSR="$CERTS_DOMAIN_PATH.csr"
# 域名证书 ext
CERTS_DOMAIN_EXT="$CERTS_DOMAIN_PATH.ext"
# 域名证书 crt
CERTS_DOMAIN_CRT="$CERTS_DOMAIN_PATH.crt"

# 判断是否重新生成证书
if test $CERTS_DOMAIN_REFRESH = "false"; then
  # 判断证书是否已经存在
  if [ -f "$CERTS_DOMAIN_CRT" ]; then
    echo '域名证书已经存在'
    exit 1;
  fi
else
  # 清除文件
  rm $CERTS_DOMAIN_KEY $CERTS_DOMAIN_CSR $CERTS_DOMAIN_EXT $CERTS_DOMAIN_CRT
fi

echo "开始域名证书"

# 生成 key
openssl genrsa -out $CERTS_DOMAIN_KEY 2048 || exit;

# 生成 csr
openssl req -new -key $CERTS_DOMAIN_KEY -out $CERTS_DOMAIN_CSR \
  -subj "/C=CN/ST=SH/L=HP/O=Dev Inc./OU=IT/CN=Local Server Dev Domain CSR"  || exit;

# 生成 ext
cat > $CERTS_DOMAIN_EXT << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.$CERTS_DOMAIN_NAME
EOF

# 生成 crt
openssl x509 -req -in $CERTS_DOMAIN_CSR -CA $CERTS_ROOT_PEM -CAkey $CERTS_ROOT_KEY \
  -CAcreateserial -out $CERTS_DOMAIN_CRT -days 825 -sha256 -extfile $CERTS_DOMAIN_EXT  || exit;

echo '生成域名证书成功'
