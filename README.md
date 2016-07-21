Buildbot slave
==============


This repository uses Git submodules, so clone it via this command:

```
  git clone --recursive <URL>
```


Requirements
------------

* Install docker: https://docs.docker.com/installation/


Installation
------------

* Run deploy script:

    ./deploy.sh

This script creates deploy/env.sh file to store settings and builds docker image (image name is buildslave_image).

* Edit deploy/env.sh and setup proper settings.

* Run:
    
    ./update_container.sh

* Start container again:

  docker start buildslave

* Start with attached console (for debug purpose, Ctrl+C will stop container):

  docker start -ai buildslave

* Stop container:

  docker stop buildslave

* Destroy container:

  docker rm buildslave
