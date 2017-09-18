;;;; -*- Mode: Lisp; -*-
;;;; general load script for Common Lisp platforms

(eval-when (:compile-toplevel)
  (error "do not compile this file!"))

(in-package :cl-user)

(setf *print-pretty* t
      *print-circle* t
      *compile-verbose* t
      *load-verbose* t)

(defvar *system-homedir*
  (cond ((string= (machine-instance) "BINGHE-P70")	 #p"D:/")
	((string= (machine-instance) "BINGHE-WIN7X64")	 #p"C:/")
	(t
	 (user-homedir-pathname))))

(defun recompile-asdf ()
  (compile-file (merge-pathnames "Lisp/asdf/build/asdf.lisp" *system-homedir*)))

#+clisp
(delete "~/lisp/**/" custom:*load-paths* :test 'equal)

#+clisp
(load (merge-pathnames "Lisp/asdf/build/asdf.fas" *system-homedir*))

#+cmu
(setq ext:*gc-verbose* nil)

#+cmu
(load (merge-pathnames "Lisp/asdf/build/asdf.sse2f" *system-homedir*))

;;; The following lines added by ql:add-to-init-file:
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

;;; bootstrap newer ASDF
#+(or lispworks5 lispworks6)
(pushnew (merge-pathnames "Lisp/asdf/" *system-homedir*)
         asdf:*central-registry* :test #'equal)

#+(or lispworks5 lispworks6)
(asdf:load-system :asdf)

;;; Setup Quicklisp again
#+(or lispworks5 lispworks6)
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

;;; Local ASDF repositories
(dolist (i '("Lisp/usocket/"
	     "Lisp/cl-net-snmp/"
             "Lisp/SWCLOS/"
	     "Lisp/OSCAR/"
	     "Lisp/screamer/"
	     "Lisp/GBBopen/"
             "Lisp/iolib/"
             "Lisp/cffi/"
             "Lisp/named-readtables/"
             "Lisp/maxima/current/src/"
             "Lisp/closette/"
             "Lisp/pcl/"
             "Lisp/portable-threads/"
             #+cmu20b "Lisp/cmucl/20b/patch-000/"))
  (pushnew (merge-pathnames i *system-homedir*) asdf:*central-registry* :test #'equal))

#+cmu20b
(asdf:load-system :patch-000)

(defparameter *cl-http-options*
  '((:CONFIGURE-AND-START . T)
    (:LAMBDA-IR . T)
    (:MAIL-ARCHIVE . T)
    (:W4-EXAMPLES . T)
    (:EXAMPLES . T)
    (:W4 . T)
    (:PROXY . T)
    (:DEBUG-INFO . T)
    (:COLD-COMPILE . NIL)
    (:COMPILE . T)
    (:CONTROL-PANEL . T)
    (:UTF-8 . T)
    (:REMOTE-LISTENER . NIL)
    (:ENABLE . T)))

#+(or sbcl clozure)
(defun load-cl-http ()
  (load (merge-pathnames "Lisp/cl-http/contrib/kpoeck/port-template/load.lisp" *system-homedir*))
  (funcall (intern "COMPILE-ALL" "CL-USER"))
  (funcall (intern "START-EXAMPLES" "HTTP")))

#+lispworks
(defun load-cl-http ()
  ;; Compile CL-HTTP
  (load (merge-pathnames "Lisp/cl-http/lw/start.lisp" *system-homedir*))
  ;; Rainer Joswig's UTF-8 patch
  (when (sys:cdr-assoc :utf-8 *cl-http-options*)
    (compile-file "HTTP:CONTRIB;RJOSWIG;UNICODE;CL-HTTP-UTF-8.LISP" :load t))
  (when (sys:cdr-assoc :control-panel *cl-http-options*)
    (compile-file "HTTP:LW;CONTRIB;RJOSWIG;CL-HTTP-CAPI.LISP" :load t)
    (funcall (symbol-function (find-symbol "CONTROL-PANEL" :cl-http-capi))))
  (when (sys:cdr-assoc :remote-listener *cl-http-options*)
    (compile-file "HTTP:LW;CONTRIB;JCMA;REMOTE-LISTENER.LISP" :load t)
    (funcall (symbol-function (find-symbol "ENABLE-RREP-SERVICE" :rrep)))))

#+cmu
(pushnew :cl-http-ssl *features*)

#+cmu
(defvar *cl-http-options*
  '(:ask-compile
    :cl-http-client	; Basic client substrate.
    :cl-http-proxy	; Requires the client.
    :w4-web-walker	; Requires the client.
    :lambda-ir		; Broken.
    :html-parser	; Can also be compiled stand-alone.
    ;; May not want to load the examples when dumping a lisp core.
    :cl-http-examples
    :w4-web-walker-demo
    :ask-enable))

#+cmu
(defun load-cl-http ()
  (ext:load-foreign "/usr/lib/libcrypto.dylib")
  (ext:load-foreign "/usr/lib/libssl.dylib")
  (load (merge-pathnames "Lisp/cl-http/cmucl/start.lisp" *system-homedir*)))

#+lispworks
(load (make-pathname :name "lw" :type "lisp" :defaults *load-truename*))

#+ignore
(load (make-pathname :name "g2" :type "lisp" :defaults *load-truename*))
