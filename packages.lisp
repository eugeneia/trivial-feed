;;;; Package definitions for TRIVIAL-FEED.

(defpackage trivial-feed.struct
  (:use :cl)
  (:export :*date*
           :make-feed
           :make-feed-item))

(defpackage trivial-feed.xml
  (:use :cl
        :xmls)
  (:export :node-by-name
           :node-text
           :attribute))

(defpackage trivial-feed.rss
  (:use :cl
        :xmls
        :cl-date-time-parser
        :trivial-feed.struct
        :trivial-feed.xml)
  (:export :rss-feed-p
           :parse-rss))

(defpackage trivial-feed.atom
  (:use :cl
        :xmls
        :cl-date-time-parser
        :trivial-feed.struct
        :trivial-feed.xml)
  (:export :atom-feed-p
           :parse-atom))

(defpackage trivial-feed
  (:use :cl
        :xmls
        :xmls/octets
        :flexi-streams
        :trivial-feed.struct
        :trivial-feed.xml
        :trivial-feed.rss
        :trivial-feed.atom)
  (:export :parse-feed))
