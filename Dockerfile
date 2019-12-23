FROM debian:buster-slim

USER root
EXPOSE 8000
RUN apt-get update && apt-get install -y build-essential redis-server libpng-dev git python-minimal libvhdi-utils lvm2 cifs-utils git curl redis-server && \
   rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
   apt-get remove cmdtest -y && \
   curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
   echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
   apt-get update && apt-get -y install yarn && \
   rm -rf /var/lib/apt/lists/*
RUN cd /root/ && \
   git clone -b master http://github.com/vatesfr/xen-orchestra
RUN cd /root/xen-orchestra && \
   yarn && \
   yarn build
RUN cd /root/xen-orchestra/packages/xo-server && \
   mkdir -p /root/.config/xo-server && \
   cp sample.config.toml /root/.config/xo-server/config.toml
RUN sed -i 's/80/8000/g' /root/.config/xo-server/config.toml
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -yy nodejs npm && rm -rf /var/lib/apt/lists/*
RUN npm install -g forever && \
   npm install -g forever-service && \
   yarn global add forever && \
   yarn global add forever-service
RUN cd /root/xen-orchestra/packages/xo-server/bin/ && \
   forever-service install orchestra -r root -s xo-server
RUN sed -i 's/900/60/g' /etc/redis/redis.conf
COPY ./start.sh /
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
