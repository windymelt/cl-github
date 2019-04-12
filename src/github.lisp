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

;; TODO: cl-json false handler

(eval-always
  (defun extract-arg-names (arglist
                            &aux
                              (first (first arglist))
                              (second (second arglist))
                              (rest (rest arglist))
                              (restrest (rest rest)))
    "Returns symbols list removing &key, &optional, &rest symbol and default value."
    (when (null arglist) (return-from extract-arg-names nil))
    (labels ((purify (x) (if (listp x) (first x) x)))
      (case first
        (&key (cons (purify second) (extract-arg-names restrest))) ;todo: default
        (&optional (cons (purify second) (extract-arg-names restrest)))
        (&rest (cons second (extract-arg-names restrest)))
        (t (cons (purify first) (extract-arg-names rest)))))))

(defmacro define-api (cmd (&rest pathparams) (&rest args) method path docstring)
  "Define and export a function with the name <*CMD-REDIX*>-<CMD> for
processing a GitHub command CMD."
  (let ((cmd-name (intern (fmt "~:@(~A-~A~)" *cmd-prefix* cmd))))
    `(eval-always
       (defun ,cmd ,(concatenate 'list pathparams args) ;; TODO: detect params provided or not
         ,docstring
         (cl-json:decode-json
          (labels ((args-to-query (actual-args)
                     (mapcar #'cons ',(mapcar #'string-downcase (mapcar #'symbol-name (extract-arg-names args))) actual-args))
                 (args-to-content (actual-args)
                   (cl-json:encode-json-alist-to-string (mapcar #'cons ',(extract-arg-names args) actual-args))))
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
                      pathparams)
              ,@(when (eq method :get) `(:query (args-to-query (list ,@(extract-arg-names args))))))
             :method ,method
             :headers `(("Content-Type" . "application/json")
                        ("Accept" . "application/vnd.github.v3+json")); todo Authorization header for OAuth2
             ,@(when (or (eq method :post)
                         (eq method :put))
                 `(:content (args-to-content (list ,@(extract-arg-names args)))))
             :want-stream t
             :basic-auth (conn-basic-auth *connection*)
             :insecure (conn-insecure *connection*)
             :verbose nil)))) ; todo verbosity control
       (abbr ,cmd-name ,cmd)
       (export ',cmd-name '#:cl-github)
       (import ',cmd '#:gh)
       (export ',cmd '#:gh))))
