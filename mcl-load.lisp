;;;; -*- Mode: Lisp; -*-

(in-package :cl-user)

#+lispworks
(defun start-acl2 (&key force)
  (cd #p"~/Lisp/acl2/v6-4/acl2-sources/")
  (load "init.lisp")
  (when force
    (funcall (intern "COMPILE-ACL2" "ACL2")))
  (funcall (intern "LOAD-ACL2" "ACL2"))
  (funcall (intern "INITIALIZE-ACL2" "ACL2")))

#+cmu
(setq ext:*gc-verbose* nil)

#+mcl ; for step
(setq ccl:*save-definitions* t
      ccl:*fasl-save-definitions* t)

;;; The following lines added by ql:add-to-init-file:
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(dolist (i '("/Users/binghe/Lisp/usocket-0.6.x/"
	     "/Users/binghe/Lisp/snmp-6/"
	     "/Users/binghe/Lisp/cl-sanskrit/"
	     #+lispworks
	     "/Users/binghe/Lisp/lispworks-udp/"))
  (pushnew #-mcl (pathname i) #+mcl (asdf::probe-posix i)
	   asdf:*central-registry* :test #'equal))

#+mcl
(let* ((defaults #p"Lion:Users:binghe:Lisp:")
       (system (make-pathname :name :wild
			      :type :wild
			      :directory (append (pathname-directory defaults)
						 (list "packages" :wild-inferiors))
			      :defaults defaults)))
  (setf (logical-pathname-translations "ASDF")
        `(("**;*.*.newest" ,system)
	  ("**;*.*" ,system))))

#+mcl
(let* ((defaults #p"Snow Leopard:Users:binghe:")
       (system (make-pathname :name :wild
			      :type :wild
			      :directory (append (pathname-directory defaults)
						 (list "quicklisp" "local-projects" :wild-inferiors))
			      :defaults defaults)))
  (setf (logical-pathname-translations "QL")
        `(("**;*.*.newest" ,system)
	  ("**;*.*" ,system))))

#+mcl
(pushnew :hunchentoot-no-ssl *features*)

#+mcl
(dolist (i '(#p"ASDF:ironclad;"
	     #p"ASDF:hunchentoot;"
	     #p"ASDF:trivial-backtrace;"
	     #p"ASDF:md5;"
	     #p"ASDF:flexi-streams;"
	     #p"ASDF:rfc2388;"
	     #p"ASDF:cl-fad;"
	     #p"ASDF:chunga;"
	     #p"ASDF:url-rewrite;"
	     #p"ASDF:bordeaux-threads;"
	     #p"ASDF:alexandria;"
	     #p"ASDF:cl-ppcre;"
	     #p"ASDF:drakma;"
	     #p"QL:trivial-gray-streams;"))
  (pushnew (translate-logical-pathname i) asdf:*central-registry* :test #'equal))

#+lispworks
(load #p"/Users/binghe/Lisp/init/lw.lisp")

#+(or sbcl clozure)
(defun load-cl-http ()
  (load #p"/Users/binghe/Lisp/cl-http/contrib/kpoeck/port-template/load.lisp")
  (funcall (intern "COMPILE-ALL" "CL-USER"))
  (funcall (intern "START-EXAMPLES" "HTTP")))

#+mcl
(defun load-cl-http ()
  (load #P"Snow Leopard:Users:binghe:Lisp:cl-http:mcl:start-server.lisp"))

#+cmu
(pushnew :cl-http-ssl *features*)

#+cmu
(defvar *cl-http-options*
  '(#+nil :ask-compile :compile 
    :cl-http-client	; Basic client substrate.
    :cl-http-proxy	; Requires the client.
    :w4-web-walker	; Requires the client.
    :lambda-ir		; Broken.
;    :html-parser	; Can also be compiled stand-alone.
    ;; May not want to load the examples when dumping a lisp core.
    :cl-http-examples
    :w4-web-walker-demo
    :ask-enable #+nil :enable))

#+cmu
(defun load-cl-http ()
  (ext:load-foreign "/usr/lib/libcrypto.dylib")
  (ext:load-foreign "/usr/lib/libssl.dylib")
  (load #p"/Users/binghe/Lisp/cl-http/cmucl/start.lisp"))

(setf *print-pretty* t
      *print-circle* t
      *compile-verbose* t
      *load-verbose* t)

#+cmu20b
(progn
  (pushnew #p"/Users/binghe/Lisp/cmucl/20b/patch-000/"
	   asdf:*central-registry* :test #'equal)
  (asdf:load-system :patch-000))
