;;;; Package definitions for TRIVIAL-FEED.

(defpackage trivial-feed.struct
  (:use :cl)
  (:export :*date*
           :make-feed
           :make-feed-item))

(defpackage trivial-feed.xml
  (:use :cl :xmls :net.telent.date)
  (:export :node-by-name
           :node-text
           :parse-xsd-time
           :string-keyword))

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
        :trivial-feed.rss
        :trivial-feed.atom)
  (:shadow :null) ; Shadow IRONCLAD's NULL with CL's.
  (:export :parse-feed
           :feed-item-hash))
