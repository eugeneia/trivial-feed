;;;; TRIVIAL-FEED.XML: XML processing functions.

(in-package :trivial-feed.xml)

(defun node-by-name (name)
  (lambda (node)
    (when (stringp #1=(node-name node))
      (string-equal name #1#))))

(defun node-text (node)
  (with-output-to-string (out)
    (loop for child in (node-children node)
       do (write-string (etypecase child
                          (string child)
                          (cons (toxml child)))
                        out))))

(defun attribute (string attributes)
  (second (assoc string attributes :test #'equalp)))
