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
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "cl-github"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "cl-github-test"))))
