# Task progress sheet reporter

![TPS report](https://img.skitch.com/20120203-nr24dn9u7euchmqa516718unpe.png)

We often need to make regular reports of things done for our projects at work. I
hate doing these by hand. This tool lets us build these reports from YAML files.

Get started
-----------

Install TPS (Ruby):

    $ gem install tps_reporter

  then generate a sample file.

    $ tps sample

Edit it, then generate the report:

    $ tps open

Format
------

The tasks file, usually `tasks.yml`, is in YAML format.

Tasks are always keys (ie, they all end in ':'). They can be nested as far
as you like.

    Edit users:
      Register and signup:
      Login and logout:

To define task metadata for *leaf* tasks, add it as an array inside the task:

    Manage employees: [done]

Or for *branch* tasks, add it under the "_" task:

    Manage employees:
      _: [done]
      Creating employees:
      Editing employees:

Allowed metadata are:

    - done
    - in progress
    - pt/2839478 (Pivotal tracker ID)

Exporting to PDF or image
-------------------------

If you're on a Mac, install [Paparazzi](http://derailer.org/paparazzi)
and use the `tps paparazzi` command. This will open the report in Paparazzi
where you can save or copy it as an image, or PDF.
