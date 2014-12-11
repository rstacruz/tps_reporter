File format
===========

The tasks file, usually `tasks.taskpaper`, is in [TaskPaper] format. 

They're simply a hierarchy of projects and tasks. Projects are lines that end with `:`, and tasks are lines that begin with `- `, with indentation.

``` yaml
Edit users:
  - Register and signup
  - Login and logout
```

You can tag some projects or tasks using `@`. For projects, you may put the tags after the colon.

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

