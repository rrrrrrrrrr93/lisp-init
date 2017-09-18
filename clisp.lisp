(in-package :cl-user)

;;; Obsolete in SCL 1.3.9
;;; #+(and scl linux amd64)
;;; (load #p"/opt/scl/lib/patch-udp1")

#+allegro
(setf excl:*fasl-default-type* "aclfasl")

#+clisp
(setf *load-paths* nil)

;; #+clisp
;; (setf custom:*DEFAULT-FILE-ENCODING* charset:ascii)

#-(or cormanlisp)
(let* ((defaults
	 #+(and (or clozure ecl abcl allegro sbcl lispworks cmu clisp)
		(or darwin macos macosx))
	 #p"/Users/binghe/Lisp/"

	 #+(and (or scl ecl abcl lispworks cmu clisp) linux)
	 #p"/home/binghe/Lisp/"

	 #+(and (or scl lispworks clozure) (or solaris solaris2))
	 #p"/export/home/binghe/Lisp/"

	 #+(and (or clozure ecl abcl lispworks cmu clisp) win32)
	 #p"Z:/"

	 #+mcl
	 #p"Snow Leopard:Users:binghe:Lisp:")
       (system (make-pathname :name :wild
			      :type :wild
			      :directory (append (pathname-directory defaults)
						 (list :wild-inferiors))
			      :defaults defaults)))
  (setf (logical-pathname-translations "LISP")
        `(("**;*.*" ,system))
        (logical-pathname-translations "PACKAGE")
        `(("**;*.*" "LISP:packages;**;*.*"))
        (logical-pathname-translations "BINGHE")
        `(("**;*.*" "LISP:binghe;**;*.*"))))
