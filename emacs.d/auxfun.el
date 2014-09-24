;; lists

(defun aux-flatten (list-of-lists)
  (if (cdr list-of-lists)
      (aux-flatten
       (cons
        (append
         (car list-of-lists)
         (car (cdr list-of-lists)))
        (cdr (cdr list-of-lists))))
    (car list-of-lists)))

;; cycles

(defun aux-cycle-shift (list)
  (append (cdr list) (cons (car list) '())))

(defun aux-next-cycle-element (list element)
  (if (equal (car list) element)
      (car (aux-cycle-shift list))
    (aux-next-cycle-element (aux-cycle-shift list) element)))

;; functions

(defun aux-apply-if-not-nil (fn val &optional default)
  (if val
      (funcall fn val)
    default))

(provide 'aux)
