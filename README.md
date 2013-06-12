# Task progress sheet reporter

![TPS report](http://i.imgur.com/AA7LNTR.png)

We often need to make regular reports of things done for our projects at work. I
hate doing these by hand. This tool lets us build these reports from YAML files
[such as this][sample]:

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

The tasks file, usually `tasks.taskpaper`, is in [TaskPaper] format. 

They're simply a hierarchy of projects and tasks.

``` yaml
Edit users:
  - Register and signup
  - Login and logout
```

You can tag some projects or tasks.

``` yaml
Facebook connect:
  - Register via Facebook @done
  - Capture email

Manage employees: @done
  - Create user
  - Edit user
```

The following tags are recognized:

 - `@done`
 - `@in_progress`
 - `@pt/2839478` *(Pivotal tracker ID. Links to a Pivotal tracker story.)*
 - `@tr/LabxGP3` *(Trello card short name. Links to a Trello card.)*
 - `@0pt` *(points; influences percentage. needs to end in __pt__ or __pts__.)*
 - `@10%` *(task progress. implies __in progress__.)*

Example:

``` yaml
Employee management:
  - Creating employees @40%
  - Editing employees @done @2pts
```

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

[v0.3.0 readme]: http://github.com/rstacruz/tps_reporter/blob/v0.3.0/README.md
[TaskPaper]: http://www.hogbaysoftware.com/products/taskpaper
