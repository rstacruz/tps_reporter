File format
===========

The tasks file, usually `tasks.taskpaper`, is loosely based off of the [TaskPaper] format. 

They're simply a hierarchy of projects and tasks. Projects are lines that end with `:`, and tasks are lines that begin with `- `, with indentation.

``` yaml
Edit users:
  - Register and signup
  - Login and logout
```

### Nesting

You can nest tasks as deep as you like.

``` yaml
Edit users:
  - Register and signup
  - Login and logout
    - Design for the pages
    - Responsive
    - Implement functionality
```

### Tagging

You can tag some projects or tasks using `@`. For projects, you may put the tags after the colon.

``` yaml
Facebook connect:
  - Register via Facebook @done
  - Capture email

Manage employees: @done
  - Create user
  - Edit user
```

### Done

Mark tasks as done by adding a `@done` tag.
  
You may also use `x` instead of `-` to mark a task as done. (This is not standard [TaskPaper] behavior.)

``` yaml
Manage user records:
  - Create user
  x Edit user
  x Delete user
  - Update user
```

### GitHub Flavored Markdown style

You can make your lists GitHub-compatible by using `- [ ]` and `- [x]` in your tasks. Projects in Markdown headings (`### heading`) are also supported.

``` yaml
### Manage user records

  - [ ] Create user
  - [x] Edit user
  - [x] Delete user
  - [ ] Update user
```

### Done

### Tags

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

