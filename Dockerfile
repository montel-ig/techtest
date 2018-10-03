FROM python:3.6
MAINTAINER lauri@montel.fi

ENV PYTHONUNBUFFERED 1
ENV WORK_DIR /app
RUN mkdir -p ${WORK_DIR}

WORKDIR ${WORK_DIR}
EXPOSE 80

# install nginx, circus, chausetta, a more recent nodejs and build deps
RUN curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install -y --no-install-recommends nginx vim-tiny nodejs libpq-dev build-essential libjpeg-dev && \
    pip install "tornado<5" circus chaussette && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# install our app requirements
ADD requirements.txt ${WORK_DIR}
RUN pip install -r requirements.txt && \
    rm -rf ~/.cache/pip /tmp/pip-build-root

ADD frontend/yarn.lock frontend/package.json ${WORK_DIR}/frontend/
RUN cd frontend && \
    yarn

# clean up a bit
RUN apt-get -y purge libpq-dev build-essential libjpeg-dev && \
    apt-get -y autoremove && \
    apt-get -y clean

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY deployment/docker/nginx.conf /etc/nginx/nginx.conf

ENV DJANGO_SETTINGS_MODULE appz.settings.prod
ADD . ${WORK_DIR}
RUN cd frontend && yarn build
RUN python manage.py collectstatic --noinput
RUN DEBUG=0 COMPRESS_ENABLED=1 python manage.py compress --force

CMD ["/app/deployment/docker/entry.sh"]
