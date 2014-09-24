(require 'aux)
(require 'cl-lib)

(defun fs-dirname (path)
  (let ((dirname (file-name-directory (substring (file-name-as-directory path) 0 -1))))
    (if (equal dirname path) ; windows drive root
        nil
      dirname)))

(defun fs-is-hidden (path)
  (if (string-match "^\\([#.].*\\)\\|\\(.*~\\)\\|\\(.*[.]pyc\\)$" path) t))

(defun fs-list-recursively (dir &optional filter)
  (setq dir (file-name-as-directory dir))
  (setq filter (or filter 'fs-is-hidden))
  (unless (file-directory-p dir)
    (error "Not a dir: %s" dir))

  (aux-flatten
   (mapcar
    (lambda (name)
      (if (file-directory-p (concat dir name))
          (cons (file-name-as-directory name)
                (mapcar (lambda (subname) (concat (file-name-as-directory name) subname)) (fs-list-recursively (concat dir name) filter)))
        (cons name ())))
    (cl-remove-if filter (directory-files dir)))))

(defun fs-list-dirs-recursively (dir &optional filter)
  (cl-remove-if-not (lambda (x) (equal (substring x -1) "/")) (fs-list-recursively dir filter)))

(defun fs-list-files-recursively (dir &optional filter)
  (cl-remove-if (lambda (x) (equal (substring x -1) "/")) (fs-list-recursively dir filter)))

(provide 'fs)
