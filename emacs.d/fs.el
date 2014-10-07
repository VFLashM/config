(require 'aux)
(require 'cl-lib)

(setq list-script (concat (file-name-directory load-file-name) "lstree.py"))

(defun fs-dirname (path)
  (let ((dirname (file-name-directory (substring (file-name-as-directory path) 0 -1))))
    (if (equal dirname path) ; windows drive root
        nil
      dirname)))

(defun fs-is-hidden (path)
  (if (string-match "^\\([#.].*\\)\\|\\(.*~\\)\\|\\(.*[.]pyc\\)$" path) t))

(defun fs-list-recursively (dir)
  (split-string (substring (shell-command-to-string (concat "python " list-script " \"" dir "\"")) 0 -1) "\n"))

(defun fs-list-dirs-recursively (dir)
  (cl-remove-if-not (lambda (x) (equal (substring x -1) "/")) (fs-list-recursively dir)))

(defun fs-list-files-recursively (dir)
  (cl-remove-if (lambda (x) (equal (substring x -1) "/")) (fs-list-recursively dir)))

(defun fs-is-prefix (path prefix)
  (aux-starts-with path (file-name-as-directory prefix)))

(provide 'fs)
