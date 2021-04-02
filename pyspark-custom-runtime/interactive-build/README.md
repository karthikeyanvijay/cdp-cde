# Experiment with CDE container interactively

You can use the following steps to create a temporary container & gain SSH access to the image. Perform steps interactively before automating it.

- Build the docker image locally 
```
docker build --network=host -t cde-rootaccess . -f interactive-build.Dockerfile
```
- Run the Docker image
```
docker run -d --name cde-rootaccess cde-rootaccess sleep 9999999999
docker container exec -it cde-rootaccess bash
```
- You can now interactively install packages & comeup with the right configuration.
- Once done remove the container
```
docker stop cde-rootaccess && docker rm cde-rootaccess
```
