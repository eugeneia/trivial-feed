;;;; System definition for TRIVIAL-FEED.

(defsystem trivial-feed
  :description
"Parse syndication feeds such as RSS and ATOM to a canoical form and
provide a hashing method for feed items."
  :author "Max Rottenkolber <max@mr.gy>"
  :license "GNU AGPL"
  :components ((:file "packages")
               (:file "xml"
                      :depends-on ("packages"))
               (:file "struct"
                      :depends-on ("packages"))
               (:file "rss"
                      :depends-on ("packages"
                                   "struct"
                                   "xml"))
               (:file "atom"
                      :depends-on ("packages"
                                   "struct"
                                   "xml"))
               (:file "trivial-feed"
                      :depends-on ("packages"
                                   "rss"
                                   "atom")))
  :depends-on ("xmls" "net-telent-date" "ironclad" "trivial-utf-8"))
