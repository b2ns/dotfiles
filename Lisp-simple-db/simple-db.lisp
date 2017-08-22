;;;;Description: simple database using common-lisp
;;;;Author: b2ns

(defpackage :b2ns.github.simple-db
  (:use :cl)
  (:export :where :get-fields :set-fileds :show-db :insert-db :select-db :update-db :delete-db :clear-db :save-db :load-db))
(in-package :b2ns.github.simple-db)

;;;dynamic var
(defparameter *fields* (list :name :age :sex))
(defparameter *db* (list *fields*))
(defparameter *filename* "newfile.db")

;;;utils
(defun my-push (obj place)
  (nconc place (list obj)))

(defun parse-string (x)
  (if (numberp x)
      x
      (format nil "~a" x)))

(defun get-fields ()
  *fields*)
(defun set-fileds (&rest body)
  (setf *fields* body)
  (setf (car *db*) *fields*))

(defmacro where (&body body)
  `#'(lambda (item)
       (and
         ,@(loop while body collect 
                 `(equal (getf item ,(pop body)) ,(parse-string (pop body)))))))

;;;main
(defmacro insert-db (&body body)
  `(if (some (where ,@(loop for k in *fields* for v in body with tmp do
                            (push k tmp)
                            (push (parse-string v) tmp)
                            finally (return (reverse tmp)))) *db*)
      "Already exist!"
      (progn
         (my-push (list ,@(loop for k in *fields* for v in body with tmp2 do 
                            (push k tmp2)
                            (push (parse-string v) tmp2)
                            finally (return (reverse tmp2)))) *db*)
         "Done!")))

(defun select-db (selector-fn)
  (remove-if-not selector-fn *db*))

(defmacro update-db (selector-fn &body body)
  `(progn
    (setf *db*
        (mapcar
          #'(lambda (item)
              (when (funcall ,selector-fn item)
                ,@(loop while body collect
                        `(setf (getf item ,(pop body)) ,(parse-string (pop body))))) item) *db*))
    "Done!"))

(defun delete-db (selector-fn)
  (setf *db* (remove-if selector-fn *db*))
  "Done!")

(defun clear-db ()
  (setf *db* (list *fields*)))

(defun show-db ()
  (dolist (item (cdr *db*))
    (format t "~{~a: ~a  ~}" item)
    (format t "~%")))

(defmacro save-db (&optional (filename *filename*))
  `(progn 
     (setf *filename* ,(parse-string filename))
     (with-open-file (out *filename* :direction :output :if-exists :supersede)
      (print *db* out)
      "Done!")))

(defmacro load-db (filename)
  `(progn 
     (setf *filename* ,(parse-string filename))
     (with-open-file (in *filename*)
      (setf *db* (read in))
      (setf *fields* (car *db*))
      "Done!")))

