(require 'cl-lib)
(require 'grep)
(require 'vc)
(require 'popup)
(require 'fs)
(require 'f)

;;; Code:

(defun choose-variant (list)
  (if (and list (> (length list) 0))
      (if (> (length list) 1)
          (popup-menu* list :isearch t)
        (car list))))

(defun permanent-projects ()
  (let ((path (substitute-in-file-name "$HOME/.emacs.projects")))
    (if (file-exists-p path)
        (with-temp-buffer
          (insert-file-contents path)
          (mapcar 'file-name-as-directory (mapcar 'expand-file-name (aux-flatten (mapcar 'f-glob (split-string (buffer-string) "\n" t))))))
      (write-region "" nil path))))

(defun find-matching-permanent-project-for-path (path projects)
  (if projects
      (if (fs-is-prefix path (car projects))
          (car projects)
        (find-matching-permanent-project-for-path path (cdr projects)))
    nil))

(defun is-project-root (path)
  (let ((dir-path (file-name-as-directory path)))
    (or
     ;(file-exists-p (concat dir-path ".ropeproject"))
     (file-exists-p (concat dir-path ".git"))
     (file-exists-p (concat dir-path "SConstruct")))))

(defun get-file-project-dir (path)
  (if (or (equal path nil) (equal path ""))
      nil
    (or (find-matching-permanent-project-for-path path (permanent-projects))
        (if (is-project-root path)
            (file-name-as-directory path)
          (get-file-project-dir (fs-dirname path))))))

(defun get-current-project-dir ()
  (get-file-project-dir (or (buffer-file-name (current-buffer)) default-directory)))

(defun choose-project ()
  (choose-variant
   (delete-dups
    (delq nil
          (append (permanent-projects)
                  (mapcar 'get-file-project-dir
                          (mapcar 'buffer-file-name
                                  (buffer-list))))))))

(defun get-or-choose-project-dir ()
  (or (get-current-project-dir) (choose-project)))

(defun choose-opened-file ()
  (interactive)
  (find-file
   (choose-variant
    (mapcar 'buffer-file-name
            (cl-remove-if-not 'buffer-file-name (buffer-list))))))

(defun choose-project-file (&optional project-dir)
  (interactive)
  (setq project-dir (or project-dir (get-or-choose-project-dir)))
  (if project-dir
      (let ((path (choose-variant (fs-list-files-recursively project-dir))))
        (if path
            (find-file (concat project-dir path))))))

(defun choose-project-and-file ()
  (interactive)
  (let ((project (choose-project)))
    (if project
        (choose-project-file project)
      (message "No project selected"))))

(defun search-in-project (project regexp files)
  (interactive
   (progn
     (grep-compute-defaults)
     (let*
         ((project (get-or-choose-project-dir))
          (regexp (and project (grep-read-regexp)))
          (files (and project (grep-read-files regexp))))
       (list project regexp files))))
  (if (and project regexp)
      (rgrep regexp files project nil)
    (message "No project selected")))

(defun vc-status-project ()
  (interactive)
  (let ((project (get-or-choose-project-dir)))
    (if project
        (vc-dir project)
      (call-interactively 'vc-dir))))

(defadvice vc-diff (around vc-diff-keep-window)
  (let ((window (get-buffer-window (current-buffer))))
    ad-do-it
    (select-window window)))
(ad-activate 'vc-diff)

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
  (if (eq major-mode 'rust-mode)
      (compile "cargo run")
    (compile "scons -D -j 4 run"))
  (message "builded!"))

(defun save-and-make ()
  "save and make"
  (interactive)
  (save-buffer)
  (if (eq major-mode 'rust-mode)
      (compile "cargo build")
    (compile "scons -D -j 4 "))
  (message "builded!"))

(defun save-and-test ()
  "save, make and test"
  (interactive)
  (save-buffer)
  (if (eq major-mode 'rust-mode)
      (compile "cargo test")
    (compile "scons -D -j 4 test"))
  (message "tested!"))

(defun save-and-compile ()
  "save and compile one file"
  (interactive)
  (save-buffer)
  (if (eq major-mode 'python-mode)
      (compile (concat "pylint --msg-template=\"{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}\" " (buffer-file-name)))
    (if (eq major-mode 'rust-mode)
        (compile "cargo build")
      (compile (concat "scons -D "
                       (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))
                       ".cpp"))))
  (message "compiled!"))

