# Fulli

> Fulli helps you keep track of who can do what in your organisation

[![Circle CI](https://circleci.com/gh/samtgarson/fulli.svg?style=svg)](https://circleci.com/gh/samtgarson/fulli) [![Code Climate](https://codeclimate.com/github/samtgarson/fulli/badges/gpa.svg)](https://codeclimate.com/github/samtgarson/fulli) [![Coverage Status](https://coveralls.io/repos/github/samtgarson/fulli/badge.svg?branch=master)](https://coveralls.io/github/samtgarson/fulli?branch=master)

Fulli is a Ruby on Rails app built to help you collect, track and search your employees' experience, interests and skills.

Visit the production app at [fulli.io](https://fulli.io)

## Contribute

- **Database**
    - This app uses _postgres_. Homebrew is the suggested installation method on a Mac.

- **Environment**
    - This app uses _.env_ to load up environment variables in development. Run `cp .env.example .env`
    - `bundle install`
    - `bundle exec rake db:setup`

---

Copyright (c) 2016 Sam Garson. See `licence.md` for details.
