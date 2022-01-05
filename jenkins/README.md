# Jenkins

```sh
export JENKINS_HOME=$HOME/localserver/jenkins

docker run \
    --name jenkins \
    --network nginx-proxy \
    -v $JENKINS_HOME/jenkins_home:/var/jenkins_home \
    -p 8020:8080 \
    -p 8021:50000 \
    -d jenkins/jenkins:lts-jdk11
```

## Official Jenkins Docker image

https://github.com/jenkinsci/docker/blob/master/README.md
