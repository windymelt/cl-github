(in-package #:cl-github)

(cl-annot:enable-annot-syntax)

@export
(defvar *connection* nil "The current github connection.")

@export-class
(defclass github-connection ()
  ((host
    :initarg :host
    :initform "api.github.com"
    :reader conn-host)
   (port
    :initarg :port
    :initform 443
    :reader conn-port)
   (root
    :initarg :root
    :initform ""
    :reader conn-root)
   (use-tls-p
    :initarg :use-tls-p
    :initform t
    :reader conn-use-tls-p)
   (oauth-token
    :initarg :oauth-token
    :initform nil
    :reader conn-oauth-token)
   (basic-auth
    :initarg :basic-auth
    :initform nil
    :reader conn-basic-auth)
   (insecure
    :initarg :insecure
    :initform nil
    :reader conn-insecure))
  (:documentation "Representation of a GitHub/GHE connection."))

@export
(defun connected-p ()
  "Is there a current connection?"
  *connection*)

@export
(defun connect (&key
                  (host "api.github.com")
                  (port 443)
                  (root "")
                  (use-tls t)
                  oauth-token
                  basic-auth
                  (insecure nil))
  "Connect to GitHub/GHE server."
  (when (connected-p)
    (restart-case (error 'github-error :error "A connection to GitHub/GHE server is already established.")
      (:leave ()
       :report "Leave it."
        (return-from connect))
      (:replace ()
       :report "Replace it with a nwe connection."
        (disconnect))))
  (setf *connection* (make-instance 'github-connection
                                    :host host
                                    :port port
                                    :root root
                                    :use-tls-p use-tls
                                    :oauth-token oauth-token
                                    :basic-auth basic-auth
                                    :insecure insecure)))

@export
(defun disconnect ()
  "Disconnect from GitHub/GHE server."
  (when *connection*
    (setf *connection* nil)))

@export
(defmacro with-connection ((&key
                              (host "api.github.com")
                              (port 443)
                              (root "")
                              (use-tls t)
                              oauth-token
                              basic-auth
                              (insecure nil))
                           &body body)
  "Evaluate BODY with the current connection bound to a new connection specified by the given HOST and PORT"
  `(let* ((*connection* (make-instance 'github-connection
                                       :host ,host
                                       :port ,port
                                       :root ,root
                                       :use-tls-p ,use-tls
                                       :oauth-token ,oauth-token
                                       :basic-auth ,basic-auth
                                       :insecure ,insecure)))
     (unwind-protect
          (progn ,@body)
       (disconnect))))
