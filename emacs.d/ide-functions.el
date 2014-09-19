(require 'cl-lib)
(setq project-path (car (car projects)))
(setq project-name (car (cdr (car projects))))

(defun choose-variant (list)
  (popup-menu* list))

(defun get-file-project-dir (path)
  (if (or (equal path nil) (equal path ""))
      nil
    (if (string-suffix-p "/" path)
        (get-file-project-path (substring path 0 -1))
      (if (file-exists-p (concat path "/.ropeproject"))
          (concat path "/")
        (get-file-project-path (file-name-directory path))
        ))))

(defun fix-slashes (fpath)
  (replace-regexp-in-string "\\\\" "/" fpath)
  )

(defun choose-buffer ()
  (interactive)
  (set-window-buffer (selected-window)
                     (choose-variant
                       (mapcar 'buffer-name (cl-remove-if-not 'buffer-file-name (buffer-list)))
                      )
                     ))

(setq file-relative-paths '("./" "Src/" "../"))
(setq qt-dir
      (if (file-exists-p "/usr/include/qt4/")
          "/usr/include/qt4/"
        (if (getenv "QTDIR")
            (fix-slashes (getenv "QTDIR"))
          ""
          )
        ))
(setq ide-setted-up nil)

(defun find-tag-under-cursor ()
  "finds tag under cursor"
  (interactive)
  (find-tag
   (funcall (or find-tag-default-function
		(get major-mode 'find-tag-default-function)
		'find-tag-default)))
  )

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

(defun find-corresponding-file ()
  "find corresponding header file"
  (interactive)
  (set 'ext (file-name-extension (buffer-file-name)))
  (if (equal ext "h")
      (find-corresponding-ext-file "cpp" file-relative-paths)
    (if (equal ext "cpp")
    (find-corresponding-ext-file "h" file-relative-paths)))
  )

(defun ebrowse-project ()
  "browse project classes"
  (interactive)
  (if (get-buffer "*Tree*") (kill-buffer (get-buffer "*Tree*")))
  (shell-command
   (concat "cd " project-path " && find * -iname '*.cpp' -or -iname '*.h' | ebrowse"))
  (find-file-read-only 
   (concat project-path "/BROWSE"))
  )

(defun change-project ()
  (interactive)
  (check-setup-ide)

  (shell-command 
   (concat "echo " (mapconcat 'identity (mapcar (lambda (x) (concat (car (cdr x)) " " (car x) "?" (car (cdr x)) " " (car x))) projects) " ") " | qmenu -i 3" )
   )

  (set-buffer (get-buffer "*Shell Command Output*"))
  (if (> (length (buffer-string)) 0)
      (let (
	    (project-pair (split-string (buffer-string) "?"))
	    )
	(setq project-path (car project-pair))
	(setq project-name (car (cdr project-pair)))
	)
    )
  )

(defun find-file-in-project () 
  (interactive)
  (check-setup-ide)
  (shell-command
   (concat "chooseFile " project-path " " project-path ".qmenu.cache " project-name))
  (set-buffer (get-buffer "*Shell Command Output*"))
  (if (> (length (buffer-string)) 0)
      (find-file (buffer-string)))
  )

(defun svnbrowse-project ()
  "browse svn tree of project"
  (interactive)
  (svn-status project-path))

(defun etag-project ()
  "browse project classes"
  (interactive)
  (shell-command
   (concat "etagProject " project-path))
  (setq tags-file-name (concat project-path "/TAGS"))
  )

(defun check-setup-ide ()
  "setup ide if not setted up"
  (interactive)
  (if 
      (not ide-setted-up)
      (setup-ide)
    )
  (setq ide-setted-up t)
  )

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
              ))
)

(defun cut-trailing-slash (fpath)
  (if (or
       (equal (substring fpath -1 (length fpath)) "/")
       (equal (substring fpath -1 (length fpath)) "\\"))
      (substring fpath 0 -1)
    fpath
    )
  )

(defun cut-extension (fpath)
  (if (equal (substring fpath -1 (length fpath)) ".")
      (substring fpath 0 -1)
    (cut-extension (substring fpath 0 -1))
    )
  )

(defun is-capital-char (string position)
  (if (< position 0)
      (is-capital-char string (+ position (length string)))
    (equal (upcase (substring string position (+ position 1))) (substring string position (+ position 1)))
    )
  )

(defun format-string-as-preprocessor-header-part-loop (pref suf)
  (if 
      (and (> (length pref) 0) (> (length suf) 0))
      (if (and (not (is-capital-char pref -1)) (is-capital-char suf 0))
      (concat "_" (upcase (substring suf 0 1)))
    (upcase (substring suf 0 1))
    
    )
    "")
  )

(defun format-string-as-preprocessor-header-part (string)
  (let (result)
    (dotimes (number (length string) result)
      (setq result (concat result 
               (format-string-as-preprocessor-header-part-loop
                (substring string 0 number) 
                (substring string number (length string)))
               )
        )
      )
    result)
  )

(defun format-string-as-preprocessor-header (string)
  (concat "__" (upcase (substring string 0 1)) (format-string-as-preprocessor-header-part (cut-extension string)) "__")
  )

(defun current-file-preprocessor-header ()
  (format-string-as-preprocessor-header (file-name-nondirectory (buffer-file-name)))
  )

(defun decorate-h-file ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (insert 
     (concat "#ifndef " (current-file-preprocessor-header) "\n#define " (current-file-preprocessor-header) "\n\n")
     )
    (goto-char (point-max))
    (insert 
     (concat "\n#endif // " (current-file-preprocessor-header) "\n")
     )
    )
  )
