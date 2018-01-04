# Start from the official Ruby 2.3 image
FROM ruby:2.3

LABEL \
  Description="This image is used to run puppet-strings on a module and post the results back to a given URL" \
  Vendor="Puppet, Inc." \
  Version="1.0"

# Install system-level dependencies
RUN apt-get update && apt-get install -y \
  jq

# Install puppet
RUN gem install puppet \
  --version 5.3.3 \
  --no-document \
  --silent

# Install rgen
RUN gem install rgen \
  --version 0.8.2 \
  --no-document \
  --silent

# Install puppet-strings
RUN gem install puppet-strings \
  --version 1.1.1 \
  --no-document \
  --silent

# Set workdir and copy context into it
WORKDIR /opt/anubis
ADD . /opt/anubis

# Make a workspace folder
RUN mkdir workspace

# Set default command
CMD ["/opt/anubis/bin/entrypoint.sh"]
