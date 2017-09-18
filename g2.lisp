(in-package :cl-user)

(let ((license "/Users/binghe/Lisp/G2/src/license/g2sitev2011-ent.ok"))
  (declare (ignorable license))
  #+lispworks
  (setf (lw:environment-variable "G2_OK") license)
  #+clozure
  (ccl:setenv "G2_OK" license))

(defun cd-g2-lisp ()
  (let* ((directory
	  "/Users/binghe/Lisp/G2/src/lisp/")
	 (pathname (pathname directory)))
    #+lispworks
    (hcl:change-directory pathname)
    #-lispworks
    (setq *default-pathname-defaults* pathname)))

(defun cd-chestnut ()
  (let* ((directory "/Users/binghe/Lisp/G2/src/chestnut/src/trans/")
	 (pathname (pathname directory)))
    #+lispworks
    (hcl:change-directory pathname)
    #-lispworks
    (setq *default-pathname-defaults* pathname)))
