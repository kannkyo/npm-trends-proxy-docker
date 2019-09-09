FROM alpine/git AS git_stage
WORKDIR /
RUN git clone https://github.com/johnmpotter/npm-trends-proxy.git

FROM node:10.16.3-alpine AS node_stage
COPY --from=git_stage /npm-trends-proxy /npm-trends-proxy
WORKDIR /npm-trends-proxy
RUN apk --no-cache add git && \
    npm install -g yarn && \
    yarn install

FROM redis:5.0.5-alpine
COPY --from=node_stage /npm-trends-proxy /npm-trends-proxy
WORKDIR /npm-trends-proxy
RUN apk --no-cache add npm
ENTRYPOINT ["docker-entrypoint.sh"]
