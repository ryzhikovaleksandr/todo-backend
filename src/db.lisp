(in-package #:todo-backend)

(defun connect-db ()
    (connect-toplevel :todo-app :user "postgres" :password "" :host "localhost"))

(defun disconnect-db ()
    (disconnect-toplevel))

(defun create-todo (title)
    (with-connection (:todo-app :user "postgres" :password "" :host "localhost")
        (query (:insert-into 'todos :set 'title title :returning '*)
            :single
            :constructor #'make-todo)))

(defun get-todos (page limit)
    (with-connection (:todo-app :user "postgres" :password "" :host "localhost")
        (let ((offset (* (- page 1) limit)))
            (query (:select '* :from 'todos :limit limit :offset offset)
                :constructor #'make-todo))))

(defun get-todo-by-id (id)
    (with-connection (:todo-app :user "postgres" :password "" :host "localhost")
        (query (:select '* :from 'todos :where (:= 'id id))
            :single
            :constructor #'make-todo)))

(defun update-todo (id title completed)
    (with-connection (:todo-app :user "postgres" :password "" :host "localhost")
        (query (:update 'todos
                        :set 'title title 'completed completed
                        :where (:= 'id id)
                        :returning '*)
                :single
                :constructor #'make-todo)))

(defun delete-todo (id)
    (with-connection (:todo-app :user "postgres" :password "" :host "localhost")
        (query (:delete-from 'todos :where (:= 'id id)))))
