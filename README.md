# README

[![Build Status](https://travis-ci.org/pineapplethief/valucon-test-task.svg?branch=master)](https://travis-ci.org/pineapplethief/valucon-test-task)

Use `rake db:seed` to create users for different roles.

Use 'rake generate:fake_data' to generate bunch of random users with random tasks.

Run `rspec` to run tests.

Deploy via `cap production deploy`.

Application expects environment variable `SECRET_KEY_BASE` to be set in `.env` file. In production environment `DATABASE_URL` should be set as well, complete with user credentials and schema, something like that:

`DATABASE_URL=postgres://deploy:password@localhost/valucon`

where `valucon` is a database name. If database user has `CREATEDB` privilege, `rake db:create` should create database without having to resort to psql console.
