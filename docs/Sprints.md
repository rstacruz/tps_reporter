Sprint support
==============

First, make a sprints block, preferrably at the top of your `tasks.yml` file.  
List down the sprints.

Then simply add the sprint ID to your tasks.

    # tasks.taskpaper
    Sprints:
      s1: Sprint 1 (Nov 1-15)
      s2: Sprint 2 (Nov 16-30)
      s3: Sprint 3 (Dec 1-15)

    Beta release:
      - Account
        - Login @s1
        - Logout @s1 @done
        - Signup @s2

It's also recursive--you can put sprints in your parent tasks under `_`:

    Beta release:
      - Blog @s3
        - Create posts
        - Read posts
        - Delete posts
