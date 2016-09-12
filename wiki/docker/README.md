### docker command cheat sheet

```bash
docker ps
docker ps -a
docker images
docker rmi busybox
docker run -it ubuntu:14.04 /bin/bash
docker run -d -p 1230:1234 python:2.7 python -m SimpleHTTPServer 1234
docker exec -it 385f45c0bce3 /bin/bash
docker run --name fedora_bash -it fedora bash 
docker exec -d fedora_bash touch /tmp/exec_works
docker exec -it fedora_bash bash
docker kill
docker stop
docker restart
docker rm
docker build -t busybox2 .

```
