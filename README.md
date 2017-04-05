pdupes – Perl duplicate file finder and deduper
===============================================

abstract
--------

pdupes is a duplicate file detector that is inspired by
(jdupes)[https://github.com/jbruchon/jdupes], while having
different design goals:

* jdupes has many configuration options and operation modes.
  pdupes is designed to do exactly one thing: dedupe
  (rsnapshot)[http://rsnapshot.org/] backup archives.

* jdupes is designed to be extremely fast while using little memory.
  pdupes favors a small and simple codebase and more expensive higher
  language constructs over resource usage.

* pdupes functionality should be verified by automated tests


usage
-----

`pdupes <directory> [<directory> ...]`

pdupes will scan all files in the given directories and will then
hardlink duplicate files to each other to consume disk space.


#TODO
-----

* add dedupication: hardlink duplicate file, don't just print them

* add inode comparison: already hardlinked files can be skipped

* add tangled POD

* add test cases

* add TravisCI build
  
* add license/copyright

* add project URL and badges
