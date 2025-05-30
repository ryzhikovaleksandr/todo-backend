(in-package #:todo-backend)

(defstruct todo
    (id nil :type (or integer null))
    (title "" :type string)
    (completed nil :type boolean)
    ;; created-at: ISO8601 timestamp, example: "2025-05-30T12:34:56Z"
    (created-at nil :type (or string null)))
