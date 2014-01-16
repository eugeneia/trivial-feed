;;;; TRIVIAL-FEED: Parse syndication feeds such as RSS and ATOM to a
;;;; canoical form and provide a hashing method for feed items.

(in-package :trivial-feed)

(defun parse-feed (stream &optional (fallback-date (get-universal-time)))
  (let ((*date* fallback-date)
        (feed-tree (parse stream :compress-whitespace t)))
    (cond ((rss-feed-p feed-tree) (parse-rss feed-tree))
          ((atom-feed-p feed-tree) (parse-atom feed-tree))
          ;; Unsupported format, fail.
          (t (error "Failed to find parser for feed from STREAM.")))))
