# What is this ?

Abstraction layer on top of mruby-cfunc to mimic the standard ffi ruby gem and allow hybrid gems working on both MRI and mruby.

Check the specs if you want to see what is currently supported.


# Running tests

First you need a standard ruby installed and then:

You need a mruby build with mruby-cfunc, download a copy of the mruby repository:
```bash
$ git clone git://github.com/mruby/mruby.git
```
edit build_config.rb to add cfunc (see: https://github.com/mobiruby/mruby-cfunc for infos)
and then build mruby with:
```bash
$ rake
```

add the path to your mruby/bin folder to your path, and now you can set up the test sytem
and run it (inside the mruby-rubyffi-compat folder):

```bash
$ gem install bundler
$ bundle install
$ bundle exec guard -c
```

After this any changes to either a rb file of the libtest.c file will trigger a new test run.

To check that the api is compatible with the ruby fi gem the tests can also be
executed with a standard ruby with:

```bash
$ ruby specs/mri_runner.rb
```

# Supported platforms
The tests pass on:
- Mac OS X 10.8 64bits (my dev machine)
- BeagleBone (ARM 32bits cpu) running linux 3.2 kernel
- Kubuntu (linux) x86_64 3.5.0-17-generic

# Design / Goals

My main goal is not to provide 100% coverage for the ffi gem api but to provide a
useful subset of it allowing porting gem from ffi to mruby or hybryd gems running on both
You can check https://github.com/schmurfy/host-stats for an example of such gem.


