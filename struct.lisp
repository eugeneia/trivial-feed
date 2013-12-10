;;;; TRIVIAL-FEED.STRUCT: Structure of feed items.

(in-package :trivial-feed.struct)

(defvar *date* nil
  "Fallback date for feed.")

(defun fallback-date ()
  (or *date* (get-universal-time)))

(defun make-feed
    (items &key link (date (fallback-date)) title description)
  `(:items ,items
    :date ,date
    ,@(and link `(:link ,link))
    ,@(and title `(:title ,title))
    ,@(and description `(:description ,description))))

(defun make-feed-item
    (&key link (date (fallback-date)) author title description language)
  `(:date ,date
    ,@(and link `(:link ,link))
    ,@(and author `(:author ,author))
    ,@(and title `(:title ,title))
    ,@(and description `(:description ,description))
    ,@(and language `(:language ,language))))
