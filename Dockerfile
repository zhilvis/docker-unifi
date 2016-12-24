FROM mongo:3.2

# Install Java.

RUN \
 echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
 echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
 apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
 apt-get update && \
 echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
 echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
 DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java7-installer oracle-java7-set-default  && \
 rm -rf /var/cache/oracle-jdk7-installer  && \
 apt-get install -y --force-yes unzip && \
 apt-get install -y --force-yes curl && \
 apt-get clean  && \
 rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip && \
    unzip -oj -d /usr/lib/jvm/java-7-oracle/jre/lib/security UnlimitedJCEPolicyJDK7.zip \*/\*.jar && rm UnlimitedJCEPolicyJDK7.zip

ADD UniFi /opt/UniFi

CMD ["sh", "-c", "cd /opt/UniFi && java -jar lib/ace.jar start"]
