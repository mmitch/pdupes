pdupes – Perl duplicate file finder and deduper
===============================================

abstract
--------

pdupes is a duplicate file detector that is inspired by (jdupes)[],
while having slightly different design goals:

* jdupes has many configuration options and operation modes.
  pdupes is designed to do exactly one thing: dedupe (rsnapshot)[]
  backup archives.

* jdupes is designed to be extremely fast while using little memory.
  pdupes favors a small and simple codebase and more expensive higher
  language constructs over resource usage.

* pdupes functionality should be verified by automated tests


usage
-----

`pdupes <directory> [<directory> ...]`

pdupes will scan all files in the given directories and will then
hardlink duplicate files to each other to consume disk space.
