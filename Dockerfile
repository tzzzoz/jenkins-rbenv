FROM jenkins/jenkins:lts
MAINTAINER tzzzoz <tzzzoz@gmail.com>

USER root
RUN apt-get update
RUN apt-get install -y build-essential libssl-dev libreadline-dev zlib1g-dev \
  && apt-get install -y vim && apt-get install -y ruby-all-dev \
  && apt-get install -y postgresql-client libpq5 libpq-dev


RUN git clone git://github.com/rbenv/rbenv.git /usr/local/rbenv \
&&  git clone git://github.com/rbenv/ruby-build.git /usr/local/rbenv/plugins/ruby-build \
&&  git clone git://github.com/jf/rbenv-gemset.git /usr/local/rbenv/plugins/rbenv-gemset \
&&  /usr/local/rbenv/plugins/ruby-build/install.sh
ENV PATH /usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh \
&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /etc/profile.d/rbenv.sh \
&&  echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /root/.bashrc \
&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /root/.bashrc \
&&  echo 'eval "$(rbenv init -)"' >> /root/.bashrc

ENV CONFIGURE_OPTS --disable-install-doc
ENV PATH /usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH

ENV RBENV_VERSION 2.4.3
ENV JENKINS_DISPLAYURL_PROVIDER org.jenkinsci.plugins.displayurlapi.ClassicDisplayURLProvider

RUN eval "$(rbenv init -)"; rbenv install $RBENV_VERSION \
&&  eval "$(rbenv init -)"; rbenv global $RBENV_VERSION \
&&  eval "$(rbenv init -)"; gem update --system \
&&  eval "$(rbenv init -)"; gem install bundler -f \
&&  rm -rf /tmp/*

COPY id_rsa /root/.ssh/id_rsa

USER jenkins

COPY plugins.txt /plugins.txt
RUN  install-plugins.sh < /plugins.txt

WORKDIR $JENKINS_HOME
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
