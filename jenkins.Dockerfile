FROM jenkins/jenkins:2.361.3
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli tzdata \
  && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo 'Asia/Shanghai' >/etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists
ENV JENKINS_USER=admin
ENV JENKINS_PASS=admin@123
COPY --chown=1000:1000 user.groovy /usr/share/jenkins/ref/init.groovy.d/user.groovy
USER jenkins
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Duser.timezone=Asia/Shanghai"
RUN jenkins-plugin-cli --jenkins-version 2.361.3  --plugins "build-timeout command-launcher configuration-as-code docker-workflow dynamic_extended_choice_parameter extended-choice-parameter extensible-choice-parameter git-parameter gitlab-oauth gitlab-branch-source kubernetes localization-zh-cn matrix-auth workflow-aggregator pipeline-github-lib pipeline-stage-view timestamper ws-cleanup scm-api"