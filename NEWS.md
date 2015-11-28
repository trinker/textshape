NEWS
====

Versioning
----------

Releases will be numbered with the following semantic versioning format:

&lt;major&gt;.&lt;minor&gt;.&lt;patch&gt;

And constructed with the following guidelines:

* Breaking backward compatibility bumps the major (and resets the minor
  and patch)
* New additions without breaking backward compatibility bumps the minor
  (and resets the patch)
* Bug fixes and misc changes bumps the patch



textshape 0.1.0
----------------------------------------------------------------

**BUG FIXES**

**NEW FEATURES**

* `bind_list` added to `rbind` a `list` of named `data.frame`s or `vector`s

* `split_transcript` added to split a transcript style vector (e.g.,
  `c("greg: Who me", "sarah: yes you!")` into a name and dialogue vector that is
  coerced to a `data.table`.

**MINOR FEATURES**

IMPROVEMENTS

**CHANGES**


textshape 0.0.1
----------------------------------------------------------------

Tools that can be used to reshape text data.