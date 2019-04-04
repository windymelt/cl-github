(in-package #:cl-github)

(define-condition github-error (error)
  ((error :initform nil
          :initarg :error
          :reader github-error-error)
   (message :initform nil
            :initarg :message
            :reader github-error-message))
  (:report (lambda (e stream)
             (format stream
                     "Github error: ~A~:[~;~2&~:*~A~]"
                     (github-error-error e)
                     (github-error-message e))))
  (:documentation "Any github-related error."))

(defparameter *cmd-prefix* 'gh
  "Prefix for functions names that implement github commands.")

(defmacro define-api (cmd (&rest pathparams) (&rest args) method path docstring)
  "Define and export a function with the name <*CMD-REDIX*>-<CMD> for
processing a GitHub command CMD."
  (let ((cmd-name (intern (fmt "~:@(~A-~A~)" *cmd-prefix* cmd))))
    `(eval-always
       (defun ,cmd ,(concatenate 'list pathparams args)
         ,docstring
         (cl-json:decode-json
          (flet ((args-to-content (actual-args)
                   (with-output-to-string (s)
                     (cl-json:encode-json-alist (mapcar #'cons ',args actual-args) s))))
            (dex:request
             (quri:make-uri
              :scheme (if (conn-use-tls-p *connection*)
                          "https"
                          "http")
              :host (conn-host *connection*)
              :port (conn-port *connection*)
              :path ,(concatenate
                      'list
                      `(format nil (format nil "~A~A" (conn-root *connection*) ,path))
                      pathparams))
             :method ,method
             :headers `(("Content-Type" . "application/json")
                        ("Accept" . "application/vnd.github.v3+json")); todo Authorization header for OAuth2
             :content (args-to-content (list ,@args))
             :want-stream t
             :basic-auth (conn-basic-auth *connection*)
             :insecure (conn-insecure *connection*)
             :verbose nil)))) ; todo verbosity control
       (abbr ,cmd-name ,cmd)
       (export ',cmd-name '#:cl-github)
       (import ',cmd '#:gh)
       (export ',cmd '#:gh))))
