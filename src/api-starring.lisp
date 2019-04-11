(in-package #:cl-github)

;;;
;;; Activity
;;;

;;; Starring

(define-api list-stargazers (owner repo) ()
            :get "/repos/~A/~A/stargazers"
            "")

(define-api list-starred-repos (username) (sort direction)
            :get "/users/~A/starred"
            "")

(define-api list-user-starred-repos () (sort direction)
            :get "/user/starred"
            "")

;; returns 204 or 404
(define-api user-starred-repo-p (owner repo) ()
            :get "/user/starred/~A/~A"
            "")

(define-api star-repo (owner repo) ()
            :put "/user/starred/~A/~A"
            "")

(define-api unstar-repo (owner repo) ()
            :delete "/user/starred/~A/~A"
            "")
