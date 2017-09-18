(in-package :http)

(define-https-service
  :port 8443
  :certificate #p"http:pw;ssl;localhost.crt"
  :private-key #p"http:pw;ssl;localhost.key"
  :password "localhost"
  :certificate-authorities #p"http:pw;ssl;ca.crt"
  :parameters #p"http:pw;ssl;dh2048.pem"
  :ciphers :all
  :ssl-version :ssl-default
  :enable-service-p t)

(export-url #u("/cl-http/" :port 8443 :protocol :https)
            :directory
            :recursive-p t
            :pathname #p"http:www;cl-http;"
            :expiration `(:interval ,(* 15. 60.))
            :public t
            :language :en
            :keywords '(:cl-http :documentation))

(export-url #u("favicon.ico" :port 8443 :protocol :https)
            :ico-image
            :pathname #p"http:www;cl-http;icons;lambda.ico"
            :public t
            :max-age #.(* 60 60 24) ;recache every day
            :keywords '(:cl-http :demo)
            :documentation "The Website URL icon.")
