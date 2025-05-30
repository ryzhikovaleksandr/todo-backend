(asdf:defsystem #:todo-backend
    :serial t
    :depends-on (:hunchentoot :cl-json :postmodern)
    :components ((:file "package")
                 (:file "src/types")
                 (:file "src/db")
                 (:file "src/api")
                 (:file "src/main")))
