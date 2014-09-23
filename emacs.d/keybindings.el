(keyboard-translate ?\C-h ?\C-?) ;backspace fix

(global-set-key (kbd "<f5>") 'save-and-run)
(global-set-key (kbd "C-<f5>") 'save-and-test)
(global-set-key (kbd "<f7>") 'save-and-make)
(global-set-key (kbd "C-<f7>") 'save-and-compile)
(global-set-key (kbd "S-<f5>") 'kill-compilation)

(global-set-key (kbd "C-.") 'trigger-kbd-macro)
(global-set-key (kbd "C-S-g") 'kmacro-end-and-call-macro)

(global-set-key (kbd "C-S-d") 'choose-project-file)
(global-set-key (kbd "C-S-e") 'ebrowse-project)
(global-set-key (kbd "C-S-c") 'cycle-linked-file)
(global-set-key (kbd "C-S-p") 'choose-project-and-file)

(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)

; jkli keys
;; (define-key input-decode-map (kbd "C-i") (kbd "H-i"))
;; (define-key input-decode-map (kbd "C-M-i") (kbd "H-M-i"))
;; (global-set-key (kbd "M-j") 'backward-char)
;; (global-set-key (kbd "M-l") 'forward-char)
;; (global-set-key (kbd "M-k") 'next-line)
;; (global-set-key (kbd "M-i") 'previous-line)
;; (global-set-key (kbd "C-j") 'smart-backward-to-word)
;; (global-set-key (kbd "C-l") 'smart-forward-to-word);
;; (global-set-key (kbd "C-k") 'next-line)
;; (global-set-key (kbd "H-i") 'previous-line)
;; (global-set-key (kbd "C-M-k") 'forward-paragraph)
;; (global-set-key (kbd "H-M-i") 'backward-paragraph)
;; (global-set-key (kbd "C-M-j") 'smart-backward-to-word)
;; (global-set-key (kbd "C-M-l") 'smart-forward-to-word)
;; (global-set-key (kbd "C-h") 'newline-and-indent)
;; (global-set-key (kbd "C-u") 'delete-backward-char)
;; (global-set-key (kbd "M-u") 'delete-backward-char)
;; (global-set-key (kbd "C-o") 'delete-forward-char)
;; (global-set-key (kbd "M-o") 'delete-forward-char)
;; (global-set-key (kbd "C-M-u") 'smart-delete-word-backward)
;; (global-set-key (kbd "C-M-o") 'smart-delete-word-forward)

; default keys
(global-set-key [home] 'smart-beginning-of-line)
(global-set-key (kbd "C-a") 'smart-beginning-of-line)
(global-set-key [end] 'smart-end-of-line)
(global-set-key (kbd "C-e") 'smart-end-of-line)
(global-set-key (kbd "M-f") 'smart-forward-to-word)
(global-set-key (kbd "M-b") 'smart-backward-to-word)
(global-set-key [C-right] 'smart-forward-to-word)
(global-set-key [C-left] 'smart-backward-to-word)

(global-set-key [C-next] 'cycle-buffers-next)
(global-set-key [C-prior] 'cycle-buffers-prev)
(global-set-key [C-S-next] 'buffer-menu)
(global-set-key [C-S-prior] 'buffer-menu-other-window)

(global-set-key (kbd "C-<f3>") 'fast-search-forward)
(global-set-key (kbd "C-S-<f3>") 'fast-search-backward)
(global-set-key (kbd "<f3>") 'fast-search-next)
(global-set-key (kbd "S-<f3>") 'fast-search-prev)

(global-set-key (kbd "C-S-f") 'search-in-project)
(global-set-key (kbd "C-x v p") 'vc-status-project)

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "<C-tab>") 'auto-complete)
