(in-package #:cl-github)

;;;
;;; Activity
;;;

;;;; Events

(define-api list-public-events () ()
            :get "/events"
         "We delay the public events feed by five minutes, which means the most recent event returned by the public events API actually occurred at least five minutes ago.")

(define-api list-repository-events (owner repo) ()
            :get "/repos/~A/~A/events"
            "")

(define-api list-repository-issue-events (owner repo) ()
            :get "/repos/~A/~A/issues/events"
            "")

(define-api list-repository-network-events (owner repo) ()
            :get "/networks/~A/~A/events"
            "")

(define-api list-public-org-events (org) ()
            :get "/orgs/~A/events")

(define-api list-user-received-events (username) ()
            :get "/users/~A/received_events"
            "")

(define-api list-user-received-public-events (username) ()
            :get "/users/~A/received_events/public"
            "")

(define-api list-user-performed-events (username) ()
            :get "/users/~A/events"
            "")

(define-api list-user-performed-public-events (username) ()
            :get "/users/~A/events/public"
            "")

(define-api list-events-for-org (username org) ()
            :get "/users/~A/events/orgs/~A"
            "")
;; TODO: parse event into class instance
;; cf. https://developer.github.com/v3/activity/events/types/
