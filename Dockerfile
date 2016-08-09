FROM ubuntu

MAINTAINER Alexander Alemayhu

RUN apt-get update
RUN apt-get install -y sudo git vim

ADD . /tmp/config-files
WORKDIR /tmp/config-files

RUN echo "postfix postfix/mailname string container.alemayhu.com" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
RUN /bin/bash run.bash
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*