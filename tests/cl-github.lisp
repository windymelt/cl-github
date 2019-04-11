(defpackage cl-github-test
  (:use :cl
        :cl-github
        :prove))
(in-package :cl-github-test)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-github)' in your Lisp.

(plan 1)

(subtest "extract-arg-names"
  (let ((f (function cl-github::extract-arg-names)))
    (is (funcall f '())
        '())
    (is (funcall f '(foo))
        '(foo))
    (is (funcall f '(foo bar))
        '(foo bar))
    (is (funcall f '(foo &key bar))
        '(foo bar))
    (is (funcall f '(foo &key (bar 1)))
        '(foo bar))
    (is (funcall f '(foo &key bar (buzz 1)))
        '(foo bar buzz))
    (is (funcall f '(foo &optional bar))
        '(foo bar))
    (is (funcall f '(foo &optional (bar 1)))
        '(foo bar))
    (is (funcall f '(foo &optional (bar 1) &key (buzz 2)))
        '(foo bar buzz))
    (is (funcall f '(foo &optional (bar 1) &rest rest &key (buzz 2)))
        '(foo bar rest buzz))))

(finalize)
