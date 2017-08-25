;;;;Description: a simple database using common-lisp
;;;;Author: b2ns

(defpackage :b2ns.github.simple-db
  (:use :cl)
  (:export :insert-db :select-db :update-db :delete-db :remove-duplicates-db :clear-db :save-db :load-db
           :where :has :orderby
           :count-db :max-db :min-db :sum-db :avg-db))
(in-package :b2ns.github.simple-db)

;;;dynamic var
(defparameter *filename* "newDB.db")
(defun make-dynamic-array (&optional (size 100))
  (make-array size :fill-pointer 0 :adjustable t))
(defparameter *db* (make-dynamic-array))

;;;utils
;;substr test
(defun has (str substr)
  (search substr str :test #'string-equal))
;;selector
(defmacro where (&body body)
  (if (null body) (return-from where nil))
  (if (equal "all" (car body))
      `#'(lambda (item) item)
      `#'(lambda (item)
           (and
             ,@(loop for i in body for k = (pop i)
                     if (<= (length i) 1) collect
                       `(equal (getf item ,k) ,(pop i))
                     else collect
                       `(and
                          (getf item ,k)
                          ,@(loop while i collect
                         `(,(pop i) (getf item ,k) ,(pop i)))))))))
;;sort comparator
(defmacro orderby (key opt)
  `#'(lambda (x y)
       (let ((xv (getf x ,key)) (yv (getf y ,key)))
         (if (and xv yv)
             (,opt xv yv)
             nil))))

;;;main
(defun insert-db (&rest body)
  (progn
     (vector-push-extend body *db*)
     "Done!"))

(defun select-db (selector-fn &optional (orderby-fn nil supplied-p))
  (let ((tmp (remove-if-not selector-fn *db*)))
    (if supplied-p
        (sort tmp orderby-fn))
    (loop for i across tmp do
      (format t "~{~(~a~):~10s~}" i)
      (format t "~&"))))

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
     (loop for i across *db* do
       (print i out))
    "Done!"))

(defun load-db (filename)
  (setf *filename* filename)
  (setf *db* (make-dynamic-array)) 
   (with-open-file (in *filename*)
     (loop for i = (read in nil)
           while i do (vector-push-extend i *db*)))
   "Done!")

;;;math function
(defun count-db (selector-fn)
  (length (remove-if-not selector-fn *db*)))

(defmacro with-loop (action)
  `(loop for i across (remove-if-not selector-fn *db*)
         for num = (getf i key)
         when num
         ,action num into result
         count num into size
         finally (return (values result size))))

(defun max-db (selector-fn key)
  (with-loop maximize))

(defun min-db (selector-fn key)
  (with-loop minimize))

(defun sum-db (selector-fn key)
  (with-loop sum))

(defun avg-db (selector-fn key)
  (multiple-value-call #'/ (with-loop sum)))
