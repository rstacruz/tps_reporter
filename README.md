# Task progress sheet reporter

![TPS report](http://i.imgur.com/AA7LNTR.png)

We often need to make regular reports of things done for our projects at work. I
hate doing these by hand. This tool lets us build these reports from [TaskPaper] 
files [such as this][sample]:

``` yaml
Version 1:

	This file is in TaskPaper format.
	Tabs are used to indent.
	Each task begins with a "- ".
	Projects end with a ":".
	Tags are in the format "@tag_name".
	All other lines (such as these) are considered as notes,
	and are to be ignored.

	- User signup
		- Register for an account
		- Log in @done
		- Forget password

	- Manage users
		- Create users @in_progress
		- Delete users
		- User profile page @40%

	- Blog
		- Creating new posts @done
		- Comments @done
		- Moderating comments @done
```

Requires Ruby 1.9+. No, 1.8.7 will not work.

Get started
-----------

Install TPS (Ruby):

    $ gem install tps_reporter

...then generate a sample file. (or create `tasks.taskpaper` based on [this sample
file.][sample])

    $ tps sample

Edit it, then generate the report:

    $ tps open

[sample]: https://github.com/rstacruz/tps_reporter/blob/master/data/sample.taskpaper

Format
------

See [docs/Format.md](docs/Format.md).

Exporting to PDF or image
-------------------------

If you're on a Mac, install [Paparazzi](http://derailer.org/paparazzi)
and use the `tps paparazzi` command. This will open the report in Paparazzi
where you can save or copy it as an image, or PDF.

Command line
------------

There's also a command line reporter that you can access via `tps print`. It
looks like this:

![Comamnd line reporter][cli]

[cli]: https://img.skitch.com/20120204-ccb2guerhrjmj3rht3e4ies4ur.png

Sprints
-------

You can define sprints to help you see the workload of each sprint. First, 
define your sprints on top of your file like so (this is a TaskPaper project 
with notes):

``` yaml
Sprints:
  s1: Sprint 1 (May 1)
  s2: Sprint 2 (May 8)
  s3: Sprint 3 (May 15)
```

The names are all arbitrary; `s1`..`s3` is just used here for convention; feel
free to use any string you like. (say, `week1`..`week7` works well for some
projects.)

Then use the names as tags (in this case, `@s1`, `@s2`):

``` yaml
Blog:
  - Writing articles @s1
  - Publishing @s2
```


Old YAML syntax
---------------

The old (v0.3.0) YAML syntax is still supported, see the [v0.3.0 readme] for 
more info.

License
-------

© 2013, Rico Sta. Cruz. Released under the [MIT License].

[My site](http://ricostacruz.com) (ricostacruz.com) -
[Twitter](http://twitter.com/rstacruz) (@rstacruz)

[v0.3.0 readme]: http://github.com/rstacruz/tps_reporter/blob/v0.3.0/README.md
[TaskPaper]: http://www.hogbaysoftware.com/products/taskpaper
[MIT License]: http://www.opensource.org/licenses/mit-license.php
