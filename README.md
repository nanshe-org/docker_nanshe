# Purpose

Provides the latest release of `nanshe` and dependencies installed in a supported cluster environment.

# Building

## Automatic

This repo is part of an automated build, which is hosted on Docker Hub ( <https://registry.hub.docker.com/u/jakirkham/nanshe> ). Changes added to this trigger an automatic rebuild and deploy the resulting image to Docker Hub. To download an existing image, one simply needs to run `docker pull jakirkham/nanshe`.

## Manual

If one wishes to develop this repo, building will need to be performed manually. This container can be built simply by `cd`ing into the repo and using `docker build -t <NAME> .` where `<NAME>` is the name tagged to the image built. More information about building can be found in Docker's documentation ( <https://docs.docker.com/reference/builder> ). Please consider opening a pull request for changes that you make.
