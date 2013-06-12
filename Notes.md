Development notes
-----------------

Releasing the gem:

    $ vim lib/tps/version.rb   # Bump version
    $ git clog                 # Mini utility to write changelog
    $ vim HISTORY.md           # Fix up changelog
    $ git release v0.X.X       # github.com/visionmedia/git-extras
    $ rake test
  
    $ rm *.gem
    $ gem build *.gemspec
    $ gem push *.gem
