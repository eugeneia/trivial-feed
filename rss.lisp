;;;; TRIVIAL-FEED.RSS: Parse all kinds of RSS feeds.

(in-package :trivial-feed.rss)

(defun rss-version (feed-tree)
  (case (string-keyword (node-name feed-tree))
    ;; RSS.
    (:rss (let ((version (assoc "version" (node-attrs feed-tree)
                                :test #'string-equal)))
            (when version
              (case (string-keyword (second version))
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

(defun parse-rdf-node (rdf-nodes)
  (let ((link-node
         (find-if (node-by-name "link") rdf-nodes))
        (title-node
         (find-if (node-by-name "title") rdf-nodes))
        (description-node
         (find-if (node-by-name "description") rdf-nodes)))
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

(defun parse-rss-channel (channel-nodes)
  (let ((link-node
         (find-if (node-by-name "link") channel-nodes))
        (date-node
         (or (find-if (node-by-name "lastBuildDate") channel-nodes)
             (find-if (node-by-name "pubDate") channel-nodes)))
        (author-node
         (or (find-if (node-by-name "managingEditor") channel-nodes)
             (find-if (node-by-name "webMaster") channel-nodes)))
        (title-node
         (find-if (node-by-name "title") channel-nodes))
        (description-node
         (find-if (node-by-name "description") channel-nodes))
        (language-node
         (find-if (node-by-name "language") channel-nodes)))
    (values
     (and link-node (node-text link-node))
     (and date-node (parse-time (node-text date-node)))
     (and author-node (node-text author-node))
     (and title-node (node-text title-node))
     (and description-node (node-text description-node))
     (and language-node (string-keyword (node-text language-node))))))

(defun parse-rss-item (item-nodes)
  (let ((link-node
         (find-if (node-by-name "link") item-nodes))
        (date-node
         (find-if (node-by-name "lastBuildDate") item-nodes))
        (author-node
         (find-if (node-by-name "author") item-nodes))
        (title-node
         (find-if (node-by-name "title") item-nodes))
        (description-node
         (find-if (node-by-name "description") item-nodes)))
    (values (and link-node (node-text link-node))
            (and date-node (parse-time (node-text date-node)))
            (and author-node (node-text author-node))
            (and title-node (node-text title-node))
            (and description-node (node-text description-node)))))

(defun parse-rss-feed (nodes)
  (let* ((channel-node (find-if (node-by-name "channel") nodes))
         (item-nodes (remove-if-not (node-by-name "item")
                                    (node-children channel-node))))
    (multiple-value-bind (link date author title description language)
        (parse-rss-channel (node-children channel-node))
      (make-feed
       (mapcar (lambda (item-node)
                 (multiple-value-bind
                       (link date* author* title description)
                     (parse-rss-item (node-children item-node))
                   (make-feed-item
                    :link link
                    :date (or date* date)
                    :author (or author* author)
                    :title title
                    :description description
                    :language language)))
               item-nodes)
       :link link
       :date date
       :title title
       :description description))))

(defun parse-rss (feed-tree)
  (let ((*version* (rss-version feed-tree)))
    (case *version*
      (:1.0
       (parse-rdf-feed (node-children feed-tree)))
      ((:2.0 :0.91 :0.92)
       (parse-rss-feed (node-children feed-tree))))))
