(global-set-key (kbd "\e\e e") 'ecb-activate) ;; ecb activation
(global-set-key (kbd "\e\e l") 'load-all-addons) ;; ecb activation
;(global-set-key (kbd "<f5>") 'compile)        ;; compile
;(global-set-key (kbd "\C-f") 'compile)      ;; find in files



;(global-set-key (kbd "A-c") 'grep-find)
(global-set-key (kbd "<f5>") 'save-and-make-all)
(global-set-key (kbd "C-<f5>") 'save-and-test-all)
(global-set-key (kbd "C-<f7>") 'save-and-compile)
;(global-set-key (kbd "<f5>") 'save-and-make-all)
(global-set-key (kbd "S-<f5>") 'kill-compilation)

(global-set-key (kbd "C-.") 'start-kbd-macro)
(global-set-key (kbd "C-,") 'end-kbd-macro)
(global-set-key (kbd "C-S-g") 'call-last-kbd-macro)


(global-set-key (kbd "C-S-d") 'find-file-in-project)
(global-set-key (kbd "C-S-e") 'ebrowse-project)
(global-set-key (kbd "C-S-c") 'find-corresponding-file)

(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)
(global-set-key (kbd "C-c v") 'svnbrowse-project)
;(global-set-key (kbd "C-c C-a") 'grep-find)

(global-set-key (kbd "C-y") 'yank-replace-region)
