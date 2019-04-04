#|
  This file is a part of cl-github project.
  Copyright (c) 2019 Windymelt
|#

(defsystem "cl-github-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Windymelt"
  :license "Apache License 2.0"
  :depends-on ("cl-github"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "cl-github"))))
  :description "Test system for cl-github"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
