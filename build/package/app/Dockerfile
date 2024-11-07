FROM ruby:3.3.0

WORKDIR /workspace/cqrs-example-ruby

RUN gem install bundler rerun

COPY Gemfile Gemfile.lock ./

RUN bundle install

EXPOSE 3000

CMD ["rerun", "cmd/app/main.rb"]
