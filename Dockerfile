FROM ubuntu:latest
MAINTAINER xjchengo

COPY sources.list /etc/apt/sources.list
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62

# install utils
RUN apt-get update && \
    apt-get install -y --force-yes ca-certificates \
        curl \
        openssh-server \
	supervisor \
        unzip \
        vim  \
	openssl \
	shellinabox && \
    rm -rf /var/lib/apt/lists/*


COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www
EXPOSE 80 22
ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord"]
