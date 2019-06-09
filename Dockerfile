FROM ruby:2.6.3-alpine3.9

RUN apk add g++ musl-dev make

COPY Gemfile /blog/Gemfile
WORKDIR /blog
RUN bundle install --path .vendor/bundle

COPY src .

CMD bundle exec jekyll serve
