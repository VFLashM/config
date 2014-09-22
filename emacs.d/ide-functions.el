(require 'cl-lib)

;;; Code:

(defun choose-variant (list)
  (if (and list (> (length list) 0))
      (if (> (length list) 1)
          (popup-menu* list :isearch t)
        (car list))))

(defun get-file-project-dir (path)
  (if (or (equal path nil) (equal path ""))
      nil
    (let ((dir-path (file-name-as-directory path)))
      (if (or
           (file-exists-p (concat dir-path ".ropeproject"))
           (file-exists-p (concat dir-path ".git")))
          dir-path
        (get-file-project-dir (file-name-directory (substring dir-path 0 -1)))
        )
      )))

(defun get-current-project-dir ()
  (get-file-project-dir (buffer-file-name (current-buffer))))

(defun choose-buffer ()
  (interactive)
  (set-window-buffer (selected-window)
                     (choose-variant
                       (mapcar 'buffer-name (cl-remove-if-not 'buffer-file-name (buffer-list)))
                      )
                     ))

(defun choose-project-file (project-dir)
  (if project-dir
      (let ((path (choose-variant (fs-list-files-recursively project-dir))))
        (if path
            (find-file (concat project-dir path))))))

(defun choose-current-project-file ()
  (interactive)
  (choose-project-file (get-current-project-dir)))

(defun choose-project ()
  (interactive)
  (let ((project (choose-variant (delete-dups (delq nil (mapcar 'get-file-project-dir (mapcar 'buffer-file-name (buffer-list))))))))
        (if project
            (choose-project-file project))))

(defun vc-status-project ()
  (interactive)
  (let ((pdir (get-current-project-dir)))
    (if pdir
        (vc-dir pdir)
      (call-interactively 'vc-dir))))

(defun find-corresponding-ext-file (find-ext find-paths)
  "find corresponding header file"
  (set 'fname (concat 
           (concat (file-name-directory (buffer-file-name)) (car find-paths)) 
           (file-name-nondirectory (concat (file-name-sans-extension (buffer-file-name)) "." find-ext))))
  (if (file-exists-p fname) 
      (find-file fname)
    (if (> (length find-paths) 1) 
    (find-corresponding-ext-file find-ext (cdr find-paths))))
  )


(defun get-linked-extensions ()
  '("h" "cpp" "c" "mm" "m" "hpp" "cxx"))

(defun get-linked-paths ()
  '("" "../" "Src/"))

(defun get-linked-files (path)
  (setq path (file-truename path))
  (cl-remove-if-not
   'file-exists-p
   (mapcar
    (lambda (x) (file-truename x))
    (aux-flatten
     (mapcar
      (lambda (vpath)
        (mapcar
         (lambda (ext) (concat (file-name-sans-extension vpath) "." ext))
         (get-linked-extensions)))
      (mapcar
       (lambda (relpath)
         (concat (file-name-directory path) relpath (file-name-nondirectory path)))
       (get-linked-paths)))))))

(defun cycle-linked-file ()
  "find corresponding header file"
  (interactive)
  (if (member (file-name-extension (buffer-file-name)) (get-linked-extensions))
      (find-file
       (aux-next-cycle-element
        (get-linked-files (buffer-file-name))
        (file-truename (buffer-file-name))))))

;;; build system

(defun save-and-run ()
  "save, make and run"
  (interactive)
  (save-buffer)
  (compile "scons -D -j 4 run")
  (message "builded!"))

(defun save-and-make ()
  "save and make"
  (interactive)
  (save-buffer)
  (compile "scons -D -j 4 ")
  (message "builded!"))

(defun save-and-test ()
  "save, make and test"
  (interactive)
  (save-buffer)
  (compile "scons -D -j 4 test")
  (message "tested!"))

(defun save-and-compile ()
  "save and compile one file"
  (interactive)
  (save-buffer)
  (if (eq major-mode 'python-mode)
      (compile (concat "pylint --msg-template=\"{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}\" " (buffer-file-name)))
      (compile (concat "scons -D "
                   (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))
                   ".cpp")))
  (message "compiled!"))

;;; Entry point

(defun setup-ide ()
  (setq-default flycheck-disabled-checkers '(python-flake8))
  (global-flycheck-mode)
  (set-face-attribute 'flycheck-error nil :underline "red")
  (set-face-attribute 'flycheck-warning nil :underline "orange")
  (setq flycheck-highlighting-mode 'lines)
  (yas-global-mode 1)
  (pymacs-load "ropemacs" "rope-")
  (setq ropemacs-enable-autoimport t)
  (ac-config-default)
  ;(ac-ropemacs-initialize)
  (add-hook 'python-mode-hook
            (lambda ()
              (add-to-list 'ac-sources 'ac-source-ropemacs)
              (setq yas/indent-line 'fixed)
              (define-key yas-minor-mode-map (kbd "<tab>") nil)
              (define-key yas-minor-mode-map (kbd "TAB") nil)
              (define-key yas-minor-mode-map (kbd "C-`") 'yas-expand)
              (local-set-key (kbd "<C-return>") 'rope-goto-definition)
              )))
