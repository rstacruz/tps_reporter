Guide
=====

Advanced usage guide!

Sprint support
--------------

First, make a sprints block, preferrably at the top of your `tasks.yml` file.  
List down the sprints.

Then simply add the sprint ID to your tasks.

    # tasks.yml
    Sprints:
      s1: Sprint 1 (Nov 1-15)
      s2: Sprint 2 (Nov 16-30)
      s3: Sprint 3 (Dec 1-15)

    Beta release:
      Account:
        Login: [s1]
        Logout: [s1, done]
        Signup: [s2]

It's also recursive--you can put sprints in your parent tasks under `_`:

    Beta release:
      Blog:
        _: [s3]
        Create posts:
        Read posts:
        Delete posts:

Trello card linking support
---------------------------

Simply link the card shortcut under each item using `tr/XXXX`, where *XXXX* is 
the short URL ID for the Trello card. You can see the short ID in Trello by 
clicking "more..." inside the card popup.

    Beta release:
      Blog: [tr/Xh3pAGp1]
      Account management:

You can also link the card numbers, but you have to define the main Trello board 
URL. Simply add `Trello URL: ____` to the top of the file.


    Trello URL: https://trello.com/board/trello-resources/4f84a60f0cbdcb7e7d40e099

    Beta release:
      Blog: [tr/42]
      Account management: [tr/12, done]
