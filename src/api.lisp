(in-package #:todo-backend)

(defun json-response (data &key (status 200))
    (setf (hunchentoot:content-type*) "application/json")
    (setf (hunchentoot:return-code*) status)
    (with-output-to-string (s)
        (encode-json data s)))

(defun handle-error (code message)
    (json-response '((:error . ,message)) :status code))

(define-easy-handler (get-todos :uri "/todos" :default-request-type :get)
    ((page :parameter-type 'integer :init-form 1)
     (limit :parameter-type 'integer :init-form 10))
    (handler-case
        (json-response (get-todos page limit))
        (error (e)
            (handle-error 500 (format nil "Internal server error: ~A" e)))))

(define-easy-handler (create-todo :uri "/todos" :default-request-type :post)
    ()
    (handler-case
        (let* ((body (raw-post-data :force-text t))
              (data (decode-json-from-string body))
              (title (cdr (assoc :title data))))
            (if (and title (stringp title) (> (length title) 0))
                (json-response (create-todo title))
                (handle-error 400 "Invalid or missing title")))
        (error (e)
            (handle-error 500 (format nil "Internal server error: ~A" e)))))

(define-easy-handler (update-todo :uri "/todos/:id" :default-request-type :put)
    ((id :parameter-type 'integer))
    (handler-case
        (let* ((body (raw-post-data :force-text t))
               (data (decode-json-from-string body))
               (title (cdr (assoc :title data)))
               (completed (cdr (assoc :completed data))))
            (if (get-todo-by-id id)
                (json-response (update-todo id title completed))
                (handle-error 404 "Todo not found")))
        (error (e)
            (handle-error 500 (format nil "Internal server error: ~A" e)))))

(define-easy-handler (delete-todo :uri "/todos/:id" :default-request-type :delete)
    ((id :parameter-type 'integer))
    (handler-case
        (if (get-todo-by-id id)
            (progn
                (delete-todo id)
                (json-response '((:message . "Todo deleted"))))
        (handle-error 404 "Todo not found"))
    (error (e)
        (handle-error 500 (format nil "Internal server error: ~A" e)))))
