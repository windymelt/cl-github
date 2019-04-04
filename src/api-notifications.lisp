(in-package #:cl-github)

;;;
;;; Notifications
;;;

;; TODO: default params
(define-api list-notifications () (all participating since before)
            :get "/notifications"
            "")

(define-api list-owner-repository-notifications
    (owner repo)
    (all participating since before)
    :get "/repos/~A/~A/notifications"
    "")

(define-api mark-as-read () (last--read--at) :put "/notifications"
            "")

(define-api mark-as-read-repository (owner repo) (last--read--at) :put "/repos/~A/~A/notifications"
            "")

(define-api view-single-thread (thread-id) () :get "/notifications/threads/~A"
            "")

(define-api mark-thread-as-read (thread-id) () :patch "/notifications/threads/~A"
            "")

(define-api get-thread-subscription (thread-id) () :get "/notifications/threads/~A/subscription"
            "")

(define-api set-thread-subscription (thread-id) (ignored) :put "/notifications/threads/~A/subscription"
            "")

(define-api delete-thread-subscription (thread-id) () :delete "/notifications/threads/~A/subscription"
            "")
