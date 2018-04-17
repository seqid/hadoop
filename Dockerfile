# Creates pseudo distributed hadoop 2.9.0

FROM ubuntu
LABEL maintainer="me.suiwenfeng.tk"

USER root

# install dev tools
RUN apt-get update -y; \
    apt-get upgrade -y; \
    apt-get install ssh curl rsync -y;

# java
RUN curl -LO 'http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
RUN tar xvzf jdk-8u161-linux-x64.tar.gz -C /usr/local/
RUN rm jdk-8u161-linux-x64.tar.gz

# hadoop
RUN curl -LO 'http://mirrors.shu.edu.cn/apache/hadoop/common/hadoop-2.9.0/hadoop-2.9.0.tar.gz'
RUN tar xvzf hadoop-2.9.0.tar.gz -C /usr/local/
RUN rm hadoop-2.9.0.tar.gz

# passwordless ssh
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys
RUN echo "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config

# env
RUN cd /usr/local && ln -s ./hadoop-2.9.0 hadoop && ln -s jdk1.8.0_161 jdk
ENV JAVA_HOME /usr/local/jdk
ENV PATH $PATH:$JAVA_HOME/bin

# copy /etc/hadoop
COPY ./hadoop-2.9.0 /usr/local/hadoop/etc/hadoop
COPY ./bootstrap.sh /etc/

CMD ["/etc/bootstrap.sh", "-d"]

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 10020 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE 49707 2122 22