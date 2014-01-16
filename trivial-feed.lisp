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

(defun feed-item-hash (feed-item)
  (digest-sequence
   :sha1
   (destructuring-bind (&key link date author title description language)
       feed-item
     (declare (ignore language date))
     (string-to-utf-8-bytes
      (format nil "~S~S~S~S" link author title description)))))
