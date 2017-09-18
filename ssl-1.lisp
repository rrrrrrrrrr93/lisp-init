(in-package "SSLFLI-CMUCL-1-1")

(defun comm::set-session-id-context (ctx session-id)
  "SESSION-ID must be a string of length less/equal 32 (8-bits)
characters (SSL_MAX_SSL_SESSION_ID_LENGTH). It sets the session
ID of the SSL-POINTER or SSL-CTX-POINTER to the string."
  (let* ((session-id-string (coerce session-id 'simple-string)) ;XXX 8 bit string in LW
	 (size (length session-id-string)))
    (declare (dynamic-extent session-id-string))
    (format t "comm::set-session-id-context -> session-id = ~A~%" session-id)
    (alien:with-alien ((ptr c-call:c-string session-id-string)
		       (c-byte-count c-call:int size))
      (unless (> c-byte-count ssl_max_ssl_session_id_length)
	(format t "comm::set-session-id-context -> ptr = ~A~%" ptr)
	(when (eql 1 (comm::ssl-ctx-set-session-id-context ctx ptr c-byte-count)) ;XXX
	  (return-from comm::set-session-id-context t))))
    ;; Report lossage
    (error "SESSION-ID, ~S, is not less than ~D characters." session-id ssl_max_ssl_session_id_length)))
