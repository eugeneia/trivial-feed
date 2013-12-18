;;;; Package definitions for TRIVIAL-FEED.

(defpackage trivial-feed.struct
  (:use :cl)
  (:export :*date*
           :make-feed
           :make-feed-item))

(defpackage trivial-feed.patterns
  (:use :cl :xmls)
  (:export :compile-pattern
           :find-pattern
           :find-pattern*
           :node-by-name
           :node-text))

(defpackage trivial-feed.rss
  (:use :cl
        :xmls
        :net.telent.date
        :trivial-feed.struct
        :trivial-feed.patterns)
  (:export :rss-feed-p
           :parse-rss))

(defpackage trivial-feed
  (:use :ironclad
        :cl
        :xmls
        :trivial-utf-8
        :trivial-feed.struct
        :trivial-feed.rss)
  (:shadow :null) ; Shadow IRONCLAD's NULL with CL's.
  (:export :parse-feed
           :feed-item-hash))
