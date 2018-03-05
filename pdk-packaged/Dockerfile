FROM ubuntu:16.04

LABEL \
  Description="This image is used to run pdk commands on a module and post the results back to a given URL" \
  Vendor="Puppet, Inc." \
  Version="1.0"

# Install system level dependencies
RUN apt-get update && apt-get install -y \
  curl

# Add official repos
RUN curl -O https://apt.puppetlabs.com/puppet5-release-xenial.deb
RUN dpkg -i puppet5-release-xenial.deb

# Install pdk from package repo
RUN apt-get update && apt-get install -y pdk

# Add a non-root user to run things as
RUN useradd -ms /bin/bash anubis

USER anubis
WORKDIR /home/anubis

# Add build context and set workdir
ADD pdk-packaged /home/anubis
ADD shared/entrypoints /home/anubis/bin/shared

# Make a workspace folder
RUN mkdir workspace

# Set default entrypoint 
ENTRYPOINT ["/home/anubis/bin/entrypoint"]
