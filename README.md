# lisp-init
My cross-platform Common Lisp environment initialization script

## Usage

1. Clone the repository into any local directory (I prefer `$HOME/Lisp/init`)
2. Download and install Quicklisp from [https://beta.quicklisp.org/quicklisp.lisp]
3. Create soft link from `init.lisp` to the initialization files of your Common Lisp platforms

NOTE: on Windows, instead of creating soft links, I put a `(load "init.lisp")` with full pathname from initialization files of my CL platforms.

4. Clone latest ASDF from [https://gitlab.common-lisp.net/asdf/asdf.git], put at `$HOME/Lisp/asdf` and build the final `asdf.lisp`. For old CL platforms, call `(recompile-asdf)` and explicitly load it in `init.lisp`, before initialize Quicklisp.

## Local ASDF projects

There're two ways to make them ASDF-loadable:
* Put the projects into Quicklisp's `local-projects` folder
* Put them in `$HOME/Lisp` and modify `init.lisp` with an explicit list of them.

## Name of initialization files for various Common Lisp platforms

By default all files are in home directory, e.g. `$HOME/.lispworks`

* Allegro CL: `.clinit.cl`
* ArmedBear Common Lisp: `.abclrc`
* Clozure CL: `.ccl-init.lisp`
* CMU Common Lisp: `.cmucl-init.lisp`
* Embeddable Common-Lisp: `.eclrc`
* GNU CLISP: `.clisprc`
* LispWorks: `.lispworks`
* Macintosh Common Lisp: `init.lisp` in MCL folder
* SBCL: `.sbclrc`

## Other useful scripts:

* `save-lw.lisp` and `save-lw-motif.lisp`: LispWorks image building scripts
