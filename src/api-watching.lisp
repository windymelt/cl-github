(in-package #:cl-github)

;;;
;;; Activity
;;;

;;; Watching

(define-api list-watchers (owner repo) () :get "/repos/~A/~A/subscribers"
  "")

(define-api list-watched-repos (username) () :get "/users/~A/subscriptions"
  "")

;; Returns 200 or 404
(define-api repo-subscription (owner repo) () :get "/repos/~A/~A/subscription"
  "")

(define-api set-repo-subscription (owner repo) (&key (subscribed nil) (ignored nil)) :put "/repos/~A/~A/subscription"
  "")

(define-api delete-repo-subscription (owner repo) () :delete "/repos/~A/~A/subscription"
  "")

;;; Legacy API is not supported
