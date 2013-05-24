
# What is this ?

Abstraction layer on top of mruby-cfunc to mimic the standard ffi ruby gem and allow hybrid gems working on both MRI and mruby.

Check the specs if you want to see what is currently supported.


# Running tests

you need a standrd ruby:

```bash
$ gem install bundler
$ bundle install
$ bundle exec guard -c
```

To check that the api is compatible with the ruby fi gem the tests can also be
executed with a standard ruby with:

```bash
$ ruby specs/mri_runner.rb
```

# Design / Goals

My main goal is not to provide 100% coverage for the ffi gem api but to provide a
useful subset of it allowing porting gem from ffi to mruby or hybryd gems running on both
You can check https://github.com/schmurfy/host-stats for an example of such gem.


