;;;; TRIVIAL-FEED.PATTERNS: 

(in-package :trivial-feed.patterns)

(defun match (pattern list)
  "Match PATTERN against LIST."
  (let (wildcards) ; Values for wildcard fields.
    (labels ((r-match (pattern list) ; Match linear recursively.
               (let ((pcar (car pattern))
                     (lcar (car list)))
                 (cond ((eq '_ pcar)
                        (push lcar wildcards)) ; Collect wildcard.
                       ((and pcar (listp pcar)
                             lcar (listp lcar))
                        (r-match pcar lcar)) ; Recurse.
                       ((not (equal lcar pcar))
                        (return-from match nil)))) ; Fail.
               (when (and #1=(cdr pattern) #2=(cdr list))
                 (r-match  #1# #2#))))
      (r-match pattern list))
    ;; Matched successfully. If we got wildcards return the as a list (in
    ;; order of appearance). Otherwise return canonical T.
    (if wildcards
        (nreverse wildcards)
        t)))

(defun compile-pattern (pattern)
  "Compile PATTERN. _ (underscore) is used as a wildcard symbol."
  (compile nil (lambda (x) (match pattern x))))

(defun find-pattern (pattern tree)
  "Find first occurrence of PATTERN in TREE and return its wildcard
values."
  (loop for node in tree
     for match = (and (listp node)
                      (or (funcall pattern node)
                          (find-pattern pattern node)))
     when match return match))

(defun find-pattern* (PATTERN tree)
  "Find every occurrence of PATTERN in TREE and return their wildcard
values. "
  (loop for node in tree
     for match = (and (listp node)
                      (funcall pattern node))
     for other-matches = (and (listp node)
                              (not match)
                              (find-pattern* pattern node))
     append match
     append other-matches))

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
