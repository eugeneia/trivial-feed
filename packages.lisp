;;;; Package definitions for TRIVIAL-FEED.

(defpackage trivial-feed.struct
  (:use :cl)
  (:export :*date*
           :make-feed
           :make-feed-item))

(defpackage trivial-feed.xml
  (:use :cl :xmls)
  (:export :node-by-name
           :node-text))

(defpackage trivial-feed.rss
  (:use :cl
        :xmls
        :net.telent.date
        :trivial-feed.struct
        :trivial-feed.xml)
  (:export :rss-feed-p
           :parse-rss))

(defpackage trivial-feed.atom
  (:use :cl
        :xmls
        :net.telent.date
        :trivial-feed.struct
        :trivial-feed.xml)
  (:export :atom-feed-p
           :parse-atom))

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
