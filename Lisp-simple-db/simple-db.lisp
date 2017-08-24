;;;;Description: a simple database using common-lisp
;;;;Author: b2ns

(defpackage :b2ns.github.simple-db
  (:use :cl)
  (:export :insert-db :select-db :update-db :delete-db :remove-duplicates-db :clear-db :save-db :load-db :where))
(in-package :b2ns.github.simple-db)

;;;dynamic var
(defparameter *filename* "newdb.db")
(defun make-dynamic-array (&optional (size 100))
  (make-array size :fill-pointer 0 :adjustable t))
(defparameter *db* (make-dynamic-array))

;;;utils
;;substr test
(defun has (str substr)
  (search substr str :test #'string-equal))
;;selector
(defmacro where (&body body)
  `#'(lambda (item)
       (and
         ,@(loop for i in body for k = (pop i)
                 if (<= (length i) 1) collect
                   `(equal (getf item ,k) ,(pop i))
                 else collect
                   `(and
                      (getf item ,k)
                      ,@(loop while i collect
                     `(,(pop i) (getf item ,k) ,(pop i))))))))

;;;main
(defun insert-db (&rest body)
  (progn
     (vector-push-extend body *db*)
     "Done!"))

(defun select-db (&optional (selector-fn nil supplied-p))
  (let ((tmp *db*))
    (if supplied-p
        (setf tmp (remove-if-not selector-fn *db*)))
    (loop for i across tmp do
      (format t "~{~a:~a | ~}" i)
      (format t "~%"))))

(defun update-db (selector-fn &rest body)
  (progn
     (loop for i across *db*
           if (funcall selector-fn i) do
             (loop for j on body by #'cddr do
                   (setf (getf i (first j)) (second j))))
    "Done!"))

(defun delete-db (selector-fn)
  (setf *db* (delete-if selector-fn *db*))
  "Done!")

(defun remove-duplicates-db ()
  (setf *db* (delete-duplicates *db* :test #'equal))
  "Done!")

(defun clear-db ()
  (setf *db* (make-dynamic-array))
  "Done!")

(defun save-db (&optional (filename *filename*))
   (setf *filename* filename)
   (with-open-file (out *filename* :direction :output :if-exists :supersede)
    (print *db* out)
    "Done!"))

(defun load-db (filename)
  (setf *filename* filename)
  (setf *db* (make-dynamic-array)) 
   (with-open-file (in *filename*)
     (loop for i across (read in) do
           (apply #'insert-db i)))
   "Done!")
