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
(defun parse-xsd-time (date-string)
  (handler-case ; Don't throw errors.
      (if (string-equal "-" date-string :end2 1)
          (parse-xsd-time (subseq date-string 1))
          (parse-time
           (format nil "~a ~a~@[ ~a~]"
                   (subseq date-string 0 10)
                   (subseq date-string 11 16)
                   (when (> (length date-string) 19)
                     (let ((zone (subseq date-string 19)))
                       (unless (string-equal "Z" zone :end2 1)
                         (format nil "~a~a"
                                 (subseq zone 0 3)
                                 (subseq zone 4 6))))))))
    (error () nil))) ; Return NIL on failure.

(defun string-keyword (string)
  (intern (string-upcase string) :keyword))
