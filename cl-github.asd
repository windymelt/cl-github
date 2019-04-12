#|
  This file is a part of cl-github project.
  Copyright (c) 2019 Windymelt
|#

#|
  Author: Windymelt
|#

(defsystem "cl-github"
  :version "0.1.0"
  :author "Windymelt"
  :license "Apache License 2.0"
  :depends-on (:dexador :rutils :cl-json :cl-annot)
  :serial t
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "connection")
                 (:file "github")
                 (:file "api-events")
                 (:file "api-feeds")
                 (:file "api-notifications")
                 (:file "api-starring")
                 (:file "api-watching"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "cl-github-test"))))
