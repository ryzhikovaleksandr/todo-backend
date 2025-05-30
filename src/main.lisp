(in-package #:todo-backend)

(defvar *server* nil)

(defun start-server (&key (port 8080))
    (when *server*
        (stop-server))
    (setf *server* (make-instance 'easy-acceptor :port port))
    (connect-db)
    (start *server*)
    (format t "Server started on port ~A~%" port))

(defun stop-server ()
    (when *server*
        (stop *server*)
        (setf *server* nil)
        (disconnect-db)
        (format t "Server stopped ~%")))
