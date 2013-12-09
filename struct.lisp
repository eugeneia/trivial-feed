;;;; TRIVIAL-FEED.STRUCT: Structure of feed items.

(in-package :trivial-feed.struct)

;;; TODO: Default dates to *date*.

(defvar *date* nil
  "Fallback date for feed.")

(defun make-feed (items &rest args
                  &key link date title description)
  (declare (ignore link date title description))
  (list* :items items
         args))

(defun make-feed-item (&rest args
                       &key link date author title description language)
  (declare (ignore link date author title description language))
  args)
