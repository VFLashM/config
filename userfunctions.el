(setq project-path "~/Programming/androidTest/")
(setq file-relative-paths '("./" "Src/" "../"))

;;general compile function call "make all"
(defun save-and-make-all ()
  "save and call compile as make all"
  (interactive)
  (save-buffer)
  (compile "scons -D")
  (message "builded!"))

(defun save-and-test-all ()
  "save and call compile as make all"
  (interactive)
  (save-buffer)
  (compile "scons -D test")
  (message "tested!"))

(defun save-and-compile ()
  "save and call compile as make all"
  (interactive)
  (save-buffer) 
 (compile (concat "scons -D "
                   (file-relative-name project-path (file-name-directory (buffer-file-name)))
                   ".linux-gcc/.debug/.qtSdl/"
                   (file-relative-name (file-name-sans-extension (buffer-file-name)) project-path)
                   ".o"))
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

(defun find-file-in-project () 
  (interactive)
  (shell-command 
   (concat "cd " project-path " && find * -iname '*.cpp' -or -iname '*.h' -or -iname '*.lua' -or -iname '*.pkg' | dmenu"))
  (set-buffer (get-buffer "*Shell Command Output*"))
  (if (> (length (buffer-string)) 0)
      (find-file (concat project-path (buffer-string)))))

(defun svnbrowse-project ()
  "browse svn tree of project"
  (interactive)
  (svn-status project-path))

(defun etag-project ()
  "browse project classes"
  (interactive)
;  (if (get-buffer "*Tree*") (kill-buffer (get-buffer "*Tree*")))
  (shell-command
   (concat "cd " project-path " && find * -iname '*.cpp' -or -iname '*.h' | etags -"))
  (setq tags-file-name (concat project-path "/TAGS"))
;  (tags-revert-without-query)
;  (and verify-tags-table-function
;       (funcall verify-tags-table-function))
;  (visit-tags-table tags-file-name)
;  (find-file-read-only 
;   (concat project-path "/BROWSE"))
  )

(defun c-mode-init ()
  (local-set-key (kbd "RET") 'newline-and-indent))

(defun setup-ide ()
  "setup ide functionality"
  (interactive)
  (etag-project)
  (add-hook 'c-mode-hook 'c-mode-init)
  (add-hook 'c++-mode-hook 'c-mode-init) 
;  (global-semantic-idle-completions-mode)
  )

(defun load-all-addons ()
  "loads all addons"
  (interactive)
;  (setq semantic-load-turn-everything-on t)
;  (require 'semantic-load)
;  (require 'semanticdb)
;  (require 'semantic-ia)	
;  (global-semanticdb-minor-mode 1)
;  (semanticdb-save-all-db)
;  (semantic-load-enable-code-helpers)
;  (setq semantic-load-turn-useful-things-on t)
;  (setq semanticdb-project-roots
;         (list project-path))
  (load-file "/usr/share/emacs/site-lisp/site-gentoo.el")
  (add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)
  (setup-ide))

;(set-language-environment 'UTF-8)
;
;(global-set-key (kbd "\C-\\") 'user-toggle-input-method)
;(global-set-key (kbd "\e(") 'user-to-cyr)
;(global-set-key (kbd "\e)") 'user-to-nil)


; (toggle-input-method)
; (user-to-cyr)
; (user-to-nil)

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
