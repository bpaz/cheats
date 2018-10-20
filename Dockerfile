FROM ruby:2.5.1-alpine3.7  AS build-env

ENV NODE_ENV=development

RUN apk update && apk add --no-cache nodejs build-base
RUN apk add yarn --no-cache --repository http://dl-3.alpinelinux.org/alpine/v3.8/community/ --allow-untrusted
RUN mkdir -p /app
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install -j 4
COPY . ./
COPY package.json yarn.lock ./
RUN yarn install
RUN make _site

VOLUME /app

FROM nginx:1.13.0-alpine
WORKDIR /usr/share/nginx/html
COPY --from=build-env /app/_site ./

EXPOSE 80