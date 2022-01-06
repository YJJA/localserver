
#!/bin/sh
# 创建根证书

# 根证书输出目录
CERTS_ROOT_DIST="certs"
# 根证书名称
CERTS_ROOT_NAME="RootCA"
# 重新生成根证书
CERTS_ROOT_REFRESH="false"

# 读取参数
while getopts 'rd:' o; do
  case "${o}" in
    r)
      CERTS_ROOT_REFRESH="true"
      ;;
    d)
      CERTS_ROOT_DIST=${OPTARG}
      ;;
    ?)
      echo "用法: $(basename $0) [-r 重新生成根证书] [-d 根证书存放目录]"
      echo ""
      echo "参数选项:"
      echo "  -r  重新生成根证书, 可选"
      echo "  -d  根证书存放目录, 可选, 默认值 'certs'"
      echo ""
      exit 1
      ;;
  esac
done

# 判断根证书存放目录是否存在，如果不存在就创建
if [[ ! -d "$CERTS_ROOT_DIST" ]]; then
  mkdir -p "$CERTS_ROOT_DIST"
fi

# 根证书
CERTS_ROOT_PATH="$CERTS_ROOT_DIST/$CERTS_ROOT_NAME"
# 根证书 key
CERTS_ROOT_KEY="$CERTS_ROOT_PATH.key"
# 根证书 pem
CERTS_ROOT_PEM="$CERTS_ROOT_PATH.pem"

# 判断是否重新生成证书
if test $CERTS_ROOT_REFRESH = "false"; then
  # 判断根证书是否已经存在
  if [ -f "$CERTS_ROOT_PEM" ]; then
    echo '根证书已经存在'
    exit 1;
  fi
else
  # 清除文件
  rm $CERTS_ROOT_KEY $CERTS_ROOT_PEM
fi

echo "开始生成根证书"

# 生成 key
openssl genrsa -des3 -out $CERTS_ROOT_KEY 2048 || exit

# 生成 pem
openssl req -x509 -new -nodes -key $CERTS_ROOT_KEY -sha256 -days 1825 -out $CERTS_ROOT_PEM \
  -subj "/C=CN/ST=SH/L=HP/O=Dev Inc./OU=IT/CN=Local Server Root CA" || exit

echo '生成根证书成功'
