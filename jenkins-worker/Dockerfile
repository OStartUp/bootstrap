#FROM jenkinsci/jnlp-slave AS jenkins-base
FROM jenkins/jnlp-slave AS jenkins-base

FROM python:3.7-stretch AS python-openjdk
RUN apt-get update --fix-missing
RUN apt install -y software-properties-common openjdk-8-jdk 

FROM python-openjdk
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG AGENT_WORKDIR=/home/${user}/agent
ENV HOME /home/${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN echo 'deb http://deb.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/stretch-backports.list
RUN apt-get update --fix-missing && apt-get install -t stretch-backports git-lfs sudo
COPY --from=jenkins-base /usr/local/bin/jenkins-slave /usr/local/bin/jenkins-slave 
RUN mkdir -p /usr/share/jenkins
COPY --from=jenkins-base /usr/share/jenkins/ /usr/share/jenkins/

RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d $HOME -u ${uid} -g ${gid} -m ${user}
LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="${VERSION}"

RUN chmod 755 /usr/share/jenkins
RUN chmod 644 /usr/share/jenkins/slave.jar


USER root

RUN apt-get clean
RUN adduser jenkins sudo
RUN passwd -d jenkins


USER ${user}
COPY --from=jenkins-base ${AGENT_WORKDIR} ${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}

WORKDIR /home/${user}

ENTRYPOINT ["jenkins-slave"]