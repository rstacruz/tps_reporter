# Task progress sheet reporter

![TPS report](http://i.imgur.com/AA7LNTR.png)

We often need to make regular reports of things done for our projects at work. I
hate doing these by hand. This tool lets us build these reports from YAML files
[such as this][s].

Get started
-----------

Install TPS (Ruby):

    $ gem install tps_reporter

...then generate a sample file. (or create `tasks.yml` based on [this sample
file.][s])

    $ tps sample

Edit it, then generate the report:

    $ tps open

[s]: https://github.com/rstacruz/tps_reporter/blob/master/data/sample.yml

Format
------

The tasks file, usually `tasks.taskpaper`, is in Taskpaper format.

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

Old YAML syntax
---------------

The old (v0.3.0) YAML syntax is still supported, see the [v0.3.0 readme] for 
more info.

[v0.3.0 readme]: http://github.com/rstacruz/tps_reporter/blob/v0.3.0/README.md
