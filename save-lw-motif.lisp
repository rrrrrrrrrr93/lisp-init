(in-package "CL-USER")

#+lispworks5
(error "no need to use this script in LispWorks 5")

(require "capi-motif")

(load-all-patches)

(let* ((name (format nil "LispWorks ~A~@[~A~]"
                     (lisp-implementation-version)
                     (when (sys:featurep :lispworks-64bit) " 64-bit")))
       (exe-name (string-downcase
                  (substitute #\- #\. (substitute #\- #\Space name)))))
  (save-image (merge-pathnames
	       (make-pathname :name (format nil "~A-motif-console" exe-name))
	       (lisp-image-name))
              :console t
	      :remarks name
	      :environment nil
	      :multiprocessing nil)
  (save-image (merge-pathnames
               (make-pathname :name (format nil "~A-motif" exe-name))
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
  (save-image (merge-pathnames
	       (make-pathname :name (format nil "~A-motif-console" exe-name))
	       (lisp-image-name))
              :console t
	      :remarks name
	      :environment nil
	      :multiprocessing nil)
  (save-image (merge-pathnames
               (make-pathname :name (format nil "~A-motif" exe-name))
               (lisp-image-name))
              :remarks name
	      :environment t))
