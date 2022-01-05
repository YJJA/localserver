# Gitlab

```sh
export GITLAB_HOME=$HOME/localserver/gitlab

docker run --detach \
  --name gitlab \
  --network nginx-proxy \
  --publish 80:80 \
  --restart always \
  --volume $GITLAB_HOME/config:/etc/gitlab \
  --volume $GITLAB_HOME/logs:/var/log/gitlab \
  --volume $GITLAB_HOME/data:/var/opt/gitlab \
  yrzr/gitlab-ce-arm64v8:latest
```
