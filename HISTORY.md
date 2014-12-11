v0.5.0 - unreleased
-------------------

 * Add support for spaces instead of tabs.

v0.4.2 - Dec 03, 2013
---------------------

 * MIT license.
 * Allow .tasks and .task extension.
 * Fix Trello link support.

v0.4.1 - Jul 22, 2013
---------------------

  * TaskPaper: allow `@done(...)` tags.
  * HTML: remove zebra stripes.
  * HTML: use default font (instead of PT Sans).

v0.4.0 - June 13, 2013
----------------------

  * TaskPaper support! Tasks are now stored in `tasks.taskpaper` by default.

v0.3.0 - June 13, 2013
----------------------

  * Sprint support

v0.2.2 - Dec 23, 2012
---------------------

### Fixes:

  * Fixed bug where a parent task is assigned to one sprint, and its children in 
  another, points for the sprints aren't reported properly.

### Internals:

  * Task: implement `Task#to_markdown` for testing.
  * Tests: move fixtures to `test/fixtures/`.
  * Tests: use `assert_equal`.

v0.2.0 - Nov 24, 2012
---------------------

### New features:

  * Added support for sprints! See `GUIDE.md` for info.
  * Trello card linking support! See `GUIDE.md` again.
  * Redesigned HTML output.
  * Added "Export mode" in the HTML output.

### Internals:

  * Implement @task['name'] lookup.
  * Implement Task#id.
  * Sprints: add a sprint model.
  * Task: implement #filter, #filter_by, #contains_sprint?

v0.0.3 - Nov 21, 2012
---------------------

  * Added support for linking tasks to Trello cards.
  * Fixed error when invoking 'tps' without arguments.
  * Fixed typo in message when invoked without a tasks.yml file.

v0.0.2 - Feb 04, 2012
---------------------

Initial.
