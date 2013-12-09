;;;; System definition for TRIVIAL-FEED.

(defsystem trivial-feed
  :description
"Parse syndication feeds such as RSS and ATOM to a canoical form and
provide a hashing method for feed items."
  :author "Max Rottenkolber <max@mr.gy>"
  :license "GNU AGPL"
  :components ((:file "packages")
               (:file "patterns"
                      :depends-on ("packages"))
               (:file "struct"
                      :depends-on ("packages"))
               (:file "rss"
                      :depends-on ("packages"
                                   "struct"
                                   "patterns"))
               (:file "trivial-feed"
                      :depends-on ("packages"
                                   "rss")))
  :depends-on ("xmls" "ironclad" "trivial-utf-8"))
