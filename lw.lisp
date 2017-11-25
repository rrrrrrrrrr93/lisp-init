;;;; -*- Mode: Lisp; -*-
;;;; LispWorks-specific load script

(eval-when (:compile-toplevel)
  (error "do not compile this file!"))

(in-package :system)

;(setq *stack-overflow-behaviour* :warn)

#+mswindows
(defun latin-1-file-encoding (pathname ef-spec buffer length)
  (declare (ignore pathname buffer length))
  (merge-ef-specs ef-spec :latin-1))

#+mswindows
(setf *file-encoding-detection-algorithm*
      (substitute 'latin-1-file-encoding
                  'locale-file-encoding
                  *file-encoding-detection-algorithm*))

(in-package :cl-user)

#+ios-delivery
(setq *LISPWORKS-DIRECTORY*
      #P"/Applications/LispWorks 7.0 (64-bit)/lw70-ios")

#+(and (or :lispworks5 :lispworks6 :lispworks7) :win32)
(define-action "Initialize LispWorks Tools"
               "Dismiss Splash Screen Quickly"
  #'(lambda (screen)
      (declare (ignore screen))
      (win32:dismiss-splash-screen t)))

(setf *inspect-through-gui* t)

(set-default-character-element-type 'simple-char)

#+(and (not ios-delivery) asdf3 (not lispworks5))
(compile-file-if-needed
  (example-file "misc/asdf-integration.lisp") :load t)

#-ios-delivery
(in-package :editor)

#-iso-delivery
(progn
  (setup-indent "defgrammar" 1 2 4))

#-ios-delivery
(progn
  (setq *indent-with-tabs* t)
  
  #+(and lispworks5 lw-editor)
  (bind-key "Compile and Load Buffer File"
	    #(#\control-\c #\control-\k) :mode "Lisp")

  #+(and (or lispworks6 lispworks7) lw-editor)
  (bind-key "Compile and Load Buffer File"
	    #("Control-c" "Control-k") :mode "Lisp")

  #+(and lispworks5 lw-editor)
  (bind-key "Beginning of Line" #\Home)

  #+(and (or lispworks6 lispworks7) lw-editor)
  (bind-key "Beginning of Line" "Home" :global :emacs)

  #+(and lispworks5 lw-editor)
  (bind-key "End of Line" #\End)

  #+(and (or lispworks6 lispworks7) lw-editor)
  (bind-key "End of Line" "End" :global :emacs)

  #+lispworks5
  (defcommand "Insert Tab" (p)
    "Insert a Tab"
    (self-insert-command p #\Tab))

  #+lispworks5
  (bind-key "Insert Tab"
	    #\meta-\i :mode "Lisp"))

(in-package :cl-user)

;;; FileMaker Pro Plugin Tools
#+ignore
(pushnew #p"/Applications/FileMaker Pro 11/fm-plugin-tools-0.2.9/"
	 asdf:*central-registry* :test 'equal)

(defun load-acl2 (&key force)
  (cd #p"~/Lisp/acl2/v6-4/acl2-sources/")
  (load "init.lisp")
  (when force
    (funcall (intern "COMPILE-ACL2" "ACL2")))
  (funcall (intern "LOAD-ACL2" "ACL2"))
  (funcall (intern "INITIALIZE-ACL2" "ACL2")))

(defun load-opengl ()
  (load (example-file "opengl/load")))

(defun load-opengl-examples ()
  (load (example-file "opengl/examples/load"))
  (format t "(setf v (capi:display (make-instance 'icosahedron-viewer)))~%"))

(defun load-maxima ()
  (cd #p"~/Lisp/maxima/current/src/")
  (load "maxima-build.lisp")
  (maxima-load)
  (run))

#+lispworks7
(progn

(require "java-interface")

(defparameter *java-library-path*
  "/System/Library/Frameworks/JavaVM.framework/JavaVM")

(defun initialize-java (&optional class-paths)
  (let ((lispcalls (namestring (lispworks-file "etc/lispcalls.jar"))))
    (funcall
      (intern "INIT-JAVA-INTERFACE" "LW-JI")
      :jvm-library-path *java-library-path*
      :java-class-path (if class-paths
                           (format nil "~S:~S" lispcalls class-paths)
                         lispcalls))))

(defparameter *jdk8-library-path*
  "/Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home/jre/lib/server/libjvm.dylib")

(defun initialize-jdk8 (&optional class-paths)
  (let ((lispcalls (namestring (lispworks-file "etc/lispcalls.jar"))))
    (funcall
      (intern "INIT-JAVA-INTERFACE" "LW-JI")
      :jvm-library-path *jdk8-library-path*
      :java-class-path (if class-paths
                           (format nil "~S:~S" lispcalls class-paths)
                           lispcalls))))

) ; progn

(defun run-prolog (&optional file)
  (require "prolog")
  (format t "~%Welcome to Common Prolog, use halt/0 to quit.~%")
  (when file
    ;; TODO
    )
  (let ((*package* (find-package :cp-user)))
    (funcall (intern "ERQP" "COMMON-PROLOG"))))

;; Optionally load LW-ADD-ONS
#+ignore
(ql:quickload :lw-add-ons)
