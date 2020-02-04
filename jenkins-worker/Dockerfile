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
RUN apt-get update --fix-missing && apt-get install -y  -t stretch-backports git-lfs sudo apt-transport-https ca-certificates
COPY --from=jenkins-base /usr/local/bin/jenkins-slave /usr/local/bin/jenkins-slave 
RUN mkdir -p /usr/share/jenkins
COPY --from=jenkins-base /usr/share/jenkins/ /usr/share/jenkins/

RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d $HOME -u ${uid} -g ${gid} -m ${user}
LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="${VERSION}"

RUN chmod 755 /usr/share/jenkins
RUN chmod 644 /usr/share/jenkins/slave.jar


USER root
# Installing Graphviz and Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg -o key 
RUN apt-key add key
RUN echo "deb http://download.docker.com/linux/debian/ stretch stable" > /etc/apt/sources.list.d/stretch-docker.list
RUN adduser jenkins sudo
RUN passwd -d jenkins
RUN apt-get update --fix-missing
RUN apt-get install -y graphviz docker-ce
RUN apt-get clean

# Installing BAZEL
RUN curl -fsSL -o bazel-2.0.0-installer-linux-x86_64.sh https://releases.bazel.build/2.0.0/release/bazel-2.0.0-installer-linux-x86_64.sh
RUN chmod +x bazel-2.0.0-installer-linux-x86_64.sh
RUN ./bazel-2.0.0-installer-linux-x86_64.sh 

# Installing HELM3
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

# Installing container-structure-test 
RUN curl -LO https://storage.googleapis.com/container-structure-test/v1.8.0/container-structure-test-linux-amd64 
RUN mv container-structure-test-linux-amd64 container-structure-test 
RUN chmod +x container-structure-test 
RUN mv container-structure-test /usr/local/bin/

USER ${user}
COPY --from=jenkins-base ${AGENT_WORKDIR} ${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}

WORKDIR /home/${user}

ENTRYPOINT ["jenkins-slave"]