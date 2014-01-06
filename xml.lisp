;;;; TRIVIAL-FEED.XML: XML processing functions.

(in-package :trivial-feed.xml)

(defun node-by-name (name)
  (lambda (node)
    (string-equal name (node-name node))))

(defun node-text (node)
  (with-output-to-string (out)
    (loop for child in (node-children node)
       do (write-string (etypecase child
                          (string child)
                          (cons (toxml child)))
                        out))))
