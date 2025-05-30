(in-package #:todo-backend)

(defstruct todo
    (id nil :type (or integer null))
    (title "" :type string)
    (completed nil :type boolean)
    ;; created-at: ISO8601 timestamp, example: "2025-05-30T12:34:56Z"
    (created-at nil :type (or string null)))

(defstruct todo-state
    ;; list of todo objects
    (todos '() :type (or null (list todo)))
    ;; filter can only be one of three values
    (filter :all :type (member :all :completed :pending))
    ;; sorting: asc or desc
    (sort :asc :type (member :asc :desc))
    (page 1 :type (integer 1 *)) ; only positive integers
    (page-size 10 :type (integer 1 100))) ; limit from 1 to 100
