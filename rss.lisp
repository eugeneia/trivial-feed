;;;; TRIVIAL-FEED.RSS: Parse all kinds of RSS feeds.

(in-package :trivial-feed.rss)

(defun rss-version (feed-tree)
  (case (intern (string-upcase (node-name feed-tree)))
    (:rss (case (intern (assoc "version" (node-attrs feed-tree)))
            (:0.91 :0.91)
            (:0.92 :0.92)
            (:2.0 :2.0)))
    (:rdf :1.0)))

(defun rss-feed-p (feed-tree)
  (not (null (rss-version feed-tree))))

(defvar *version* nil
  "Dynamically bound to RSS version during parsing.")

(defun parse-rdf-feed (rdf-nodes)
  (declare (ignore rdf-nodes))
  (error "PARSE-RDF-FEED is unimplemented."))

(defun parse-0.x-feed (channels)
  (declare (ignore channels))
  (error "PARSE-0.x-FEED is unimplemented."))

(defun parse-rss (feed-tree)
  (let ((*version* (rss-version feed-tree)))
    (case *version*
      (:1.0 (parse-rdf-feed (node-children feed-tree)))
      (otherwise (parse-0.x-feed (node-children feed-tree))))))
