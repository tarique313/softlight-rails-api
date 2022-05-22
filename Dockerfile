FROM ruby:3.0.3-slim

RUN apt-get -y update && \
      apt-get install --fix-missing --no-install-recommends -qq -y \
        build-essential \
        wget gnupg \
        git-all \
        curl \
        ssh \
        postgresql-client-13 libpq5 libpq-dev -y && \
      wget -qO- https://deb.nodesource.com/setup_12.x  | bash - && \
      apt-get install -y nodejs && \
      wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update && \
      apt-get install yarn && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN mkdir /gems
WORKDIR /gems

# Copy Gemfile + Gemfile.lock
RUN gem install bundler -v 2.2.32

COPY Gemfile .
COPY Gemfile.lock .
## Preinstall gems. This will ensure that Gem Cache wont drop on code change
RUN (bundle check || bundle install)

ARG INSTALL_PATH=/opt/seedrs
ENV INSTALL_PATH $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY . .

EXPOSE 3000
CMD bash ./scripts/start_rails.sh
#CMD ["rails", "server", "-b", "0.0.0.0"]