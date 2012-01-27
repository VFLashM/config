(defun fix-slashes (fpath)
  (replace-regexp-in-string "\\\\" "/" fpath)
  )

;(setq project-path "~/Programming/androidTest/")
(setq project-path "C:/Programming/AndroidTest/")

(setq project-name "RTB")
(setq file-relative-paths '("./" "Src/" "../"))
(setq qt-dir 
      (if (file-exists-p "/usr/include/qt4/")
      "/usr/include/qt4/"
    (fix-slashes (getenv "QTDIR"))
    ))
(setq ide-setted-up nil)

(file-exists-p "/")

(setq system-include-paths '("C:/Program Files (x86)/Microsoft Visual Studio 10.0/VC/include"))

(defun save-and-run ()
  "save, make and run"
  (interactive)
  (save-buffer)
  (compile "scons -D run")
  (message "builded!"))

(defun save-and-make ()
  "save and make"
  (interactive)
  (save-buffer)
  (compile "scons -D")
  (message "builded!"))

(defun save-and-test ()
  "save, make and test"
  (interactive)
  (save-buffer)
  (compile "scons -D test")
  (message "tested!"))

(defun save-and-compile ()
  "save and compile one file"
  (interactive)
  (save-buffer) 
  (compile (concat "scons -D "
                   (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))
                   ".cpp"))
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
  (check-setup-ide)
  (shell-command 
                    ;(concat "cd " project-path " && find . -iname '*.cpp' -or -iname '*.h' -or -iname '*.lua' -or -iname '*.pkg' | qmenu"))
   (concat "cd " project-path " && find . -iname '*.cpp' -or -iname '*.h' -or -iname '*.lua' -or -iname '*.pkg' | sed -e s/[-0-9a-zA-Z_.]*$/\\\\0\\;\\\\0/g | qmenu -s \\;"))
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
   (concat "cd " project-path " && find . -iname '*.cpp' -or -iname '*.h' | etags -"))
  (setq tags-file-name (concat project-path "/TAGS"))
                    ;  (tags-revert-without-query)
                    ;  (and verify-tags-table-function
                    ;       (funcall verify-tags-table-function))
                    ;  (visit-tags-table tags-file-name)
                    ;  (find-file-read-only 
                    ;   (concat project-path "/BROWSE"))
  )

(defun c-mode-init ()
  (local-set-key (kbd "RET") 'newline-and-indent)
  (setq tab-width 4)

  (setq ac-sources '(ac-source-clang))

;  (setq ac-auto-start nil)
;  (setq ac-expand-on-auto-complete nil)
;  (setq ac-quick-help-delay 0.3)  

  (setq ac-auto-start nil)
  (define-key ac-mode-map (kbd "<C-tab>") 'auto-complete)
  (auto-complete-mode)
;  (local-set-key (kbd "<C-tab>") 'ac-complete-clang)
)

(defun check-setup-ide ()
  (if 
      (not ide-setted-up)
      (setup-ide)
    )
  (setq ide-setted-up t)
  )

(defun setup-ide ()

  ;(etag-project)

  (require 'auto-complete)
  (require 'auto-complete-clang)
  (if (not ac-clang-executable)
      (setq ac-clang-executable "C:/Programming/llvm/build/bin/RelWithDebInfo/clang.exe")
  )
  (add-to-list 'ac-clang-flags (concat "-I" project-path "Src"))
  (add-to-list 'ac-clang-flags (concat "-I" project-path "ThirdParty"))
  (add-to-list 'ac-clang-flags (concat "-I" project-path "ThirdParty/glew-1.7.0/include"))
  (add-to-list 'ac-clang-flags (concat "-I" project-path "ThirdParty/libpng-1.5.4"))
  (add-to-list 'ac-clang-flags (concat "-I" project-path "ThirdParty/zlib-1.2.5"))
  (add-to-list 'ac-clang-flags (concat "-I" project-path "ThirdParty/openal-1.1/include"))
  (add-to-list 'ac-clang-flags (concat "-I" project-path "ThirdParty/freealut-1.1.0-src/include"))
  (add-to-list 'ac-clang-flags (concat "-I" project-path "ThirdParty/Tremor"))

  (add-to-list 'ac-clang-flags "-DTARGET_PLATFORM_WINDOWS")
  (add-to-list 'ac-clang-flags "-DTARGET_PLATFORM_WINDOWS_MINGW")
  ;(add-to-list 'ac-clang-flags "-Dint64_t=long")
  ;(add-to-list 'ac-clang-flags "-Duint64_t=unsigned long")
  (add-to-list 'ac-clang-flags "-D_MSC_VER")
  ;(add-to-list 'ac-clang-flags "-D_W64=")
  ;(add-to-list 'ac-clang-flags "-D_WCHAR_T_DEFINED")
  ;(add-to-list 'ac-clang-flags "-D__int64=long")
  ;(add-to-list 'ac-clang-flags "-IC:/Program Files/Microsoft Visual Studio 10.0/VC/include")
  ;(add-to-list 'ac-clang-flags "-IC:/Program Files/Microsoft SDKs/Windows/v7.0A/Include")
  (add-to-list 'ac-clang-flags "-D__MSVCRT__")
  (add-to-list 'ac-clang-flags "-IC:/MinGW/include")
  (add-to-list 'ac-clang-flags "-IC:/MinGW/lib/gcc/mingw32/4.5.2/include")
  (add-to-list 'ac-clang-flags "-IC:/MinGW/lib/gcc/mingw32/4.5.2/include/c++")
  (add-to-list 'ac-clang-flags "-IC:/MinGW/lib/gcc/mingw32/4.5.2/include/c++/mingw32")
 

  (add-hook 'c-mode-hook 'c-mode-init)
  (add-hook 'c++-mode-hook 'c-mode-init)
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
