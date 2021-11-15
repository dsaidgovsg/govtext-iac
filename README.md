# `govtext-iac`

Repository to create the Docker image with environment for running IaC operations

## How to build

```bash
docker build . -t govtext-iac
```

## How to run

It is recommended that you mount a host directory that acts as a store to the home directory within
the container's home directory.

This guide assumes that your host user has `sudo` access to manipulate the owner of the created home
directory to provision for the container.

As an example:

```bash
# We use 1000:1000 because that is the default uid:gid used in created user for the container
sudo mkdir -p /home/.govtext-iac
sudo chown 1000:1000 /home/.govtext-iac
```

```bash
docker run --rm -it \
    -v /home/.govtext-iac:/home/iac \
    --name govtext-iac \
    govtext-iac
```

Note that all your `bash` history and other user states will remain within `/home/.govtext-iac`,
making it easy to get back into using the container to resume running further operations based on
the previously run commands.
