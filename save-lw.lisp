(in-package "CL-USER")

(load-all-patches)

#+:cocoa
(compile-file-if-needed
  (sys:example-file "configuration/macos-application-bundle")
  :load t)

#+(and cocoa lispworks6.0) ; needed in OS X 10.11+, now there're official patches
(remhash "NSGlyphStorage" objc::*interned-protocols*)

(let* ((name (format nil "LispWorks ~A~@[~A~]"
                     (lisp-implementation-version)
                     (when (sys:featurep :lispworks-64bit) " 64-bit")))
       (exe-name (string-downcase 
                  (substitute #\- #\. (substitute #\- #\Space name)))))
  #-:cocoa
  (save-image (merge-pathnames
	       (make-pathname :name (format nil "~A-console" exe-name))
	       (lisp-image-name))
              :console t
	      :remarks name
	      :environment nil
	      :multiprocessing nil)
  (save-image #+:cocoa
              (write-macos-application-bundle
               (make-pathname :name name
                              :directory
                              (butlast
                               (pathname-directory (lisp-image-name))
                               3 ; omit *.app/Contents/MacOS
                               ))
               :executable-name exe-name)
              #-:cocoa 
              (merge-pathnames
               (make-pathname :name exe-name)
               (lisp-image-name))
              :remarks name
	      :environment t))

;;; KnowledgeWorks
#+lispworks-64bit
(require "kw")

#+lispworks-64bit
(let* ((name (format nil "KnowledgeWorks ~A~@[~A~]"
                     (lisp-implementation-version)
                     (when (sys:featurep :lispworks-64bit) " 64-bit")))
       (exe-name (string-downcase 
                  (substitute #\- #\. (substitute #\- #\Space name)))))
  #-:cocoa
  (save-image (merge-pathnames
	       (make-pathname :name (format nil "~A-console" exe-name))
	       (lisp-image-name))
              :console t
	      :remarks name
	      :environment nil
	      :multiprocessing nil)
  (save-image #+:cocoa
              (write-macos-application-bundle
               (make-pathname :name name
                              :directory
                              (butlast
                               (pathname-directory (lisp-image-name))
                               3 ; omit *.app/Contents/MacOS
                               ))
               :executable-name exe-name)
              #-:cocoa 
              (merge-pathnames
               (make-pathname :name exe-name)
               (lisp-image-name))
              :remarks name
	      :environment t))
