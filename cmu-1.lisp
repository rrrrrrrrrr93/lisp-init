(in-package "HTTP")

#+CL-HTTP-SSL
(defmethod ssl-ctx-initialize ((service https-service))
  (with-slots (address port version ctx certificate private-key password parameters ciphers
                       certificate-authorities client-certificates client-ca-list-ptr verify-mode verify-depth) service
    (flet ((get-password (password address port)
             (multiple-value-bind (pwd abort-p)
                 (case password
                   (:prompt (www-utils::get-ssl-server-private-key-password (or address "*") port))
                   (:none (values "" nil))
                   (t (values password nil)))
               (when abort-p
                 (error "SSL Launch Error: No server key password was supplied for https://~A:~D" address port))
               ;; make sure we have a base char string, unless LW is doing robustness.
               (values pwd))))
      (ssl-ctx-deinitialize service)
      ;; Make a new CTX and initialize from slots
      (setq ctx (comm:make-ssl-ctx :ssl-ctx version :ssl-side :both
				   #+XXX :server))
      (when parameters
	(comm:set-ssl-ctx-dh ctx :filename (ssl-filename parameters)))
      ;; Password must be set before calls to use private key file
      (comm:set-ssl-ctx-password-callback ctx :password (get-password password address port))
      (comm:ssl-ctx-use-certificate-chain-file ctx (ssl-filename certificate))
      (comm:ssl-ctx-use-rsaprivatekey-file ctx (ssl-filename private-key) comm:ssl_filetype_pem) ; XXX ONLY RSA!
      (comm:set-cipher-list ctx ciphers)

      ;; Set up client certificates
      (format t "certificate-authorities = ~A, client-certificates = ~A~%"
	      certificate-authorities client-certificates)

      (when (or certificate-authorities client-certificates)
        (when certificate-authorities
          ;; Load and returns a pointer to a stack of CA names extracted from a PEM (base64 encoded) file.
          ;; See: http://www.openssl.org/docs/ssl/SSL_load_client_CA_file.html
          (setq client-ca-list-ptr (comm:ssl-load-client-ca-file (ssl-filename certificate-authorities)))
          (cond ((sslfli-cmucl::null-pointer-p client-ca-list-ptr)
                 (error "SSL Launch Error: No client certificate authorities found when loading ~A." (ssl-filename certificate-authorities)))
                ;; Set the list of certificate authorities (CAs) that are acceptable from the client.
                (t (comm:ssl-ctx-set-client-ca-list ctx client-ca-list-ptr))))
        ;; Loads the certificates of the certificate authorities (CAs) that are trusted by this
        ;; application and that will be used to verify certificates that are received from remote
        ;; applications. Certificate revocation lists (CRLs) are also loaded if any exist.
        (comm:ssl-ctx-load-verify-locations ctx ;either certificate-authorities or client-certificates must be non-null
                                            (and certificate-authorities (ssl-filename certificate-authorities))
                                            (and client-certificates (ssl-directoryname client-certificates "http:pw;ssl;clientcerts;")))
        ;; Set the session ID context
        (comm::set-session-id-context ctx (ssl-session-id-context service))
        (comm::set-verification-mode ctx :server verify-mode)
        (comm::ssl-ctx-set-verify-depth ctx verify-depth))
      ;; Set kludge switches don't set unless we see some appreciable improvement -- JCMa 3/26/2006
      ;; (comm:set-ssl-ctx-options ctx :all t)
      ctx)))
