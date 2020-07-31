FROM node:current-alpine3.12

ENV APP_ROOT /src
RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}
ADD src ${APP_ROOT}

COPY npmrc /root/.npmrc

ENV HOST 0.0.0.0

CMD npm run dev
