# Npm Docker Commond

```sh
export VERDACCIO_HOME=$HOME/localserver/verdaccio

docker run \
  --name verdaccio \
  --network nginx-proxy \
  -p 4873:4873 \
  -v $VERDACCIO_HOME/conf:/verdaccio/conf \
  -v $VERDACCIO_HOME/storage:/verdaccio/storage \
  -v $VERDACCIO_HOME/plugins:/verdaccio/plugins \
  -d verdaccio/verdaccio
```
