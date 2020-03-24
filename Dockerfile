FROM node:13.10 AS base
# the official node image provides an unprivileged user as a security best practice
# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#non-root-user
USER root
WORKDIR /opt/app
# you'll likely want the latest npm, regardless of node version, for speed and fixes
# but pin this version for the best stability
RUN npm i npm@latest -g


FROM base AS development
WORKDIR /opt/app
COPY package*.json ./
RUN npm install --no-optional --quiet --production && npm cache clean --force
RUN cp -R node_modules /tmp/node_modules
RUN npm install --no-optional --quiet && npm cache clean --force
COPY --chown=node:node . .


FROM development AS builder
USER root
WORKDIR /opt/app
ENV PATH /opt/app/node_modules/.bin:$PATH
RUN npm run build


FROM base AS release
WORKDIR /opt/app
USER node
# set our node environment, either development or production
# defaults to production, compose overrides this to development on build and run
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV
ENV NODE_BOILERPLATE_TEST true
ENV SOME_ENV false
COPY --from=builder --chown=node:node /tmp/node_modules ./node_modules
COPY --from=builder --chown=node:node /opt/app/build ./build
COPY --from=builder --chown=node:node /opt/app/package.json ./package.json
COPY --from=builder --chown=node:node /opt/app/scripts ./scripts
COPY --from=builder --chown=node:node /opt/app/config ./config
ENV PATH /opt/app/node_modules/.bin:$PATH
# use `docker run --init in production`
# so that signals are passed properly. Note the code in index.js is needed to catch Docker signals
# using node here is still more graceful stopping then npm with --init afaik
# I still can't come up with a good production way to run with npm and graceful shutdown
CMD [ "npm", "run", "start" ]