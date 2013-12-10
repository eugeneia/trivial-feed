;;;; TRIVIAL-FEED.RSS: Parse all kinds of RSS feeds.

(in-package :trivial-feed.rss)

(defun rss-version (feed-tree)
  (case (intern (string-upcase (node-name feed-tree)) :keyword)
    ;; RSS.
    (:rss (let ((version (assoc "version" (node-attrs feed-tree))))
            (when version
              (case (intern version :keyword)
                (:2.0 :2.0)
                (:0.91 :0.91)
                (:0.92 :0.92)))))
    ;; RDF.
    (:rdf :1.0)))

(defun rss-feed-p (feed-tree)
  (not (null (rss-version feed-tree))))

(defvar *version* nil
  "Dynamically bound to RSS version during parsing.")


;;; RDF parser.

(defun parse-rdf-node (rdf-node)
  (let ((link-node
         (find-if (node-by-name "link") rdf-node))
        (title-node
         (find-if (node-by-name "title") rdf-node))
        (description-node
         (find-if (node-by-name "description") rdf-node)))
    (values
     (and link-node (node-text link-node))
     (and title-node (node-text title-node))
     (and description-node (node-text description-node)))))

(defun parse-rdf-feed (rdf-nodes)
  (let ((channel-node (find-if (node-by-name "channel") rdf-nodes))
        (item-nodes (remove-if-not (node-by-name "item") rdf-nodes)))
    (multiple-value-bind (link title description)
        (parse-rdf-node (node-children channel-node))
      (make-feed (mapcar (lambda (node)
                           (multiple-value-bind (link title description)
                               (parse-rdf-node (node-children node))
                             (make-feed-item :link link
                                             :title title
                                             :description description)))
                         item-nodes)
                 :link link
                 :title title
                 :description description))))

(defun parse-rss-feed (channels)
  (declare (ignore channels))
  (error "PARSE-RSS-FEED is unimplemented."))

(defun parse-rss (feed-tree)
  (let ((*version* (rss-version feed-tree)))
    (case *version*
      (:1.0
       (parse-rdf-feed (node-children feed-tree)))
      ((:2.0 :0.91 :0.92)
       (parse-rss-feed (node-children feed-tree))))))
