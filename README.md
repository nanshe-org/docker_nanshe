[![](https://badge.imagelayers.io/jakirkham/nanshe:latest.svg)](https://imagelayers.io/?images=jakirkham/nanshe:latest 'Get your own badge on imagelayers.io')

# Purpose

Provides the latest release of `nanshe` and dependencies installed in a supported cluster environment.

# Building

## Automatic

This repo is part of an automated build, which is hosted on Docker Hub ( <https://registry.hub.docker.com/u/jakirkham/nanshe> ). Changes added to this trigger an automatic rebuild and deploy the resulting image to Docker Hub. To download an existing image, one simply needs to run `docker pull jakirkham/nanshe`.

## Manual

If one wishes to develop this repo, building will need to be performed manually. This container can be built simply by `cd`ing into the repo and using `docker build -t <NAME> .` where `<NAME>` is the name tagged to the image built. More information about building can be found in Docker's documentation ( <https://docs.docker.com/reference/builder> ). Please consider opening a pull request for changes that you make.

# Testing

Only releases of `nanshe` are installed in this repo. As `nanshe` is only released if it passes a build and is actively tested in this exact same environment, no further testing is performed. The container used by this container as a base, `jakirkham/centos_drmaa_conda`, is tested independently. As a result, this container does not have any test of its own.

# Usage

Once an image is acquired either from one of the provided builds or manually, the image is designed to provide a preconfigured shell environment. Simply run `docker run -it <NAME>`. This will configure Grid Engine and a number of environment variables useful for maintaining it and starts up `bash`. At that point, any `nanshe` command can be run. In the case of an automated build, `<NAME>` is `jakirkham/nanshe`.
